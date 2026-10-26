export class InputError extends Error {
 constructor(kind,text,detail={}){super(text);this.kind=kind;this.detail=detail;}
}

export class Dictionary {
 constructor(words){this.words=new Map(words.map(w=>[w.id,w]));this.groups=new Map();for(const w of words){const key=w.stem[0];if(!this.groups.has(key))this.groups.set(key,[]);this.groups.get(key).push(w);}}
 word(id){return this.words.get(id&4095);}
 canonical(word){const seen=new Set();while(word.alias){if(seen.has(word.id))throw Error('Dictionary alias cycle');seen.add(word.id);word=this.words.get(word.alias);if(!word)throw Error('Invalid dictionary alias');}return word;}
 lookup(value){
  const input=value.toLowerCase();let score=0,selected=null;
  if(!/^[a-y][a-z]*$/.test(input))return {type:208,value:0,word:null,matched_prefix:0};
  for(const candidate of this.groups.get(input[0])||[]){
   if(candidate.type===208)continue;if(score>=input.length)break;
   let matched=1;while(matched<input.length&&matched<candidate.stem.length&&input[matched]===candidate.stem[matched])matched++;
   if(matched<score)break;score=matched;selected=this.canonical(candidate);
  }
  const accepted=selected&&(score>=4||score===input.length);
  return {type:accepted?selected.type:208,value:accepted?selected.id:0,word:accepted?selected.stem:null,matched_prefix:score};
 }
}

export function normalizeInput(raw){
 if(typeof raw!=='string'||/[^\x20-\x7e£]/.test(raw))throw new InputError('tool_limit','Only printable ASCII characters and £ are supported.');
 if(raw.length>128)throw new InputError('tool_limit','The reconstructed editor accepts at most 128 characters.');
 let text='',quoted=false;
 for(const c of raw.toUpperCase().replaceAll('£','`')){
  if(c==='"'){if(quoted&&!text.endsWith('.'))text+='.';quoted=!quoted;}
  text+=c;
 }
 if(quoted){if(!text.endsWith('.'))text+='.';text+='"';}
 if(!text.endsWith('.'))text+='.';
 return text;
}

const rotate=value=>((value<<1)|(value>>>7))&255;
// This reproduces the unusual 8-bit decimal accumulation, including overflow.
export function decimalByte(text){let n=0;for(const c of text){const twice=rotate(n);n=(twice+rotate(rotate(twice))+Number(c))&255;}return n;}
export function numericLiteral(text){
 const money=text.match(/^(?:`(\d+)(?:\/(\d+)\/(\d+|-))?|(\d+)(S|D)|(?:(\d+)\/(\d+|-)))$/);
 if(money){const pound=money[1]?decimalByte(money[1]):0,shilling=money[2]?decimalByte(money[2]):money[5]==='S'?decimalByte(money[4]):money[6]?decimalByte(money[6]):0,pence=money[3]&&money[3]!=='-'?decimalByte(money[3]):money[5]==='D'?decimalByte(money[4]):money[7]&&money[7]!=='-'?decimalByte(money[7]):0;
  const total=((pound*20+shilling)*12+pence)&65535;if(total>=16384)return null;
  return {type:240,value:32768|((total>>>7)<<8)|128|(total&127),word:null,literal:{kind:'money',pence:total}};
 }
 const time=text.match(/^(\d+)(?::(\d*))?(AM|PM)?$/);
 if(!time)return null;const hour=decimalByte(time[1]),minute=decimalByte(time[2]||'0');if(hour>=60||minute>=60)return null;
 return {type:240,value:((128|hour|(time[3]==='AM'?64:0))<<8)|minute|(time[3]==='PM'?64:0),word:null,literal:{kind:'time',hour,minute,period:time[3]||null}};
}

export class Lexer {
 constructor(dictionary){this.dictionary=dictionary;}
 scan(raw){
  const normalized=normalizeInput(raw),tokens=[];let pos=0;
  while(pos<normalized.length){const start=pos,c=normalized[pos];if(c===' '){pos++;continue;}
   const special={'.':176,',':160,'"':144}[c];if(special!==undefined){tokens.push({type:special,value:0,word:null,start,end:++pos,source:c});continue;}
   let result;
   if(/[0-9`]/.test(c)){
    while(pos<normalized.length&&!/[ .,\"]/.test(normalized[pos]))pos++;result=numericLiteral(normalized.slice(start,pos));
    // DB3D consumes periods following money or an explicit AM/PM suffix.
    // In particular the dot in 6D. is not a command terminator.
    if(result&&(result.literal.kind==='money'||result.literal.period)){
     while(normalized[pos]==='.')pos++;
     if(pos<normalized.length&&!/[ ,\"]/.test(normalized[pos]))result=null;
     else if(normalized[pos]==='"'||pos===normalized.length)pos--; // DB5F returns before quote/CR; the last period is scanned again.
    }
   }
   else{while(pos<normalized.length&&normalized.charCodeAt(pos)>=64)pos++;if(pos===start)pos++;result=this.dictionary.lookup(normalized.slice(start,pos));}
   if(!result||result.type===208){const source=normalized.slice(start).split(/[ .]/)[0];throw new InputError('lexical_error',`I DO NOT KNOW THE WORD"${source} "`,{word:normalized.slice(start,pos),start,normalized});}
   tokens.push({...result,start,end:pos,source:normalized.slice(start,pos)});
  }
  tokens.push({type:192,value:0,word:null,start:pos,end:pos,source:''});
  return {normalized,tokens};
 }
}
