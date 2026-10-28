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
 let text='',quoted=false,capacity=128;
 const period=()=>{if(!text.endsWith('.')){text+='.';capacity=(capacity-1)&255;}};
 for(const c of raw.toUpperCase().replaceAll('£','`')){
  if(c.charCodeAt(0)<64&&!/[ ".,\/\-:0-9]/.test(c))continue;
  if(c==='"'){quoted=!quoted;if(!quoted)period();}
  if(capacity){text+=c;capacity=(capacity-1)&255;}
 }
 if(quoted){period();text+='"';}period();return text;
}

const rotate=value=>((value<<1)|(value>>>7))&255;
// This reproduces the unusual 8-bit decimal accumulation, including overflow.
export function decimalByte(text){let n=0;for(const c of text){const twice=rotate(n);n=(twice+rotate(rotate(twice))+Number(c))&255;}return n;}
// DAEF–DC12: value and cursor are separate results. The pound separator
// is skipped only when another decimal field follows it; it need not be '/'.
export function scanNumeric(text,start=0){
 let at=start,pounds=0,shillings=0,pence=0;
 const digit=c=>c!==undefined&&c>='0'&&c<='9';
 const decimal=()=>{const begin=at;while(digit(text[at]))at++;return decimalByte(text.slice(begin,at));};
 const money=()=>{const total=((pounds*20+shillings)*12+pence)&65535;if(total>=16384)return null;while(text[at]==='.')at++;if(text[at]==='\r'||text[at]==='"')at--;else if(![' ',','].includes(text[at]))return null;return {type:240,value:32768|((total>>>7)<<8)|128|(total&127),word:null,literal:{kind:'money',pence:total},next:at};};
 let amount;
 if(text[at]==='`'){at++;pounds=decimal();if(!digit(text[at+1]))return money();at++;amount=decimal();}
 else{
  if(!digit(text[at]))return null;amount=decimal();
  if([':', 'A','P','.',',',' '].includes(text[at])){
   if(amount>=60)return null;const hour=amount;let minute=0,period=null;
   if(text[at]===':'){at++;minute=decimal();if(minute>=60)return null;}
   if(!['.',',',' '].includes(text[at])){period=text[at];if(!['A','P'].includes(period)||text[++at]!=='M')return null;at++;while(text[at]==='.')at++;if(text[at]==='\r'||text[at]==='"')at--;else if(![' ',','].includes(text[at]))return null;}
   return {type:240,value:((128|hour|(period==='A'?64:0))<<8)|minute|(period==='P'?64:0),word:null,literal:{kind:'time',hour,minute,period:period?period+'M':null},next:at};
  }
 }
 if(text[at]==='S'){shillings=amount;at++;}
 else if(text[at]==='D'){pence=amount;at++;}
 else if(text[at]==='/'){shillings=amount;at++;if(text[at]==='-')at++;else{if(!digit(text[at]))return null;pence=decimal();}}
 else return null;
 return money();
}
export function numericLiteral(text){const result=scanNumeric(text+' .\r');if(!result)return null;const {next,...token}=result;return token;}

export class Lexer {
 constructor(dictionary){this.dictionary=dictionary;}
 scan(raw){
  const normalized=normalizeInput(raw),tokens=[],workspaceCopies=[];if(normalized.length>128)throw new InputError('tool_limit','Sovrapposizione originale fra buffer editor e token non ancora ricostruita: comando non applicato.');let pos=0,lookupState=null;
  while(pos<normalized.length){const start=pos,c=normalized[pos];if(c===' '){pos++;continue;}
   const special={'.':176,',':160,'"':144}[c];if(special!==undefined){tokens.push({type:special,value:0,word:null,start,end:++pos,source:c});continue;}
   let result;
   if(/[0-9`]/.test(c)){
    result=scanNumeric(normalized+'\r',pos);if(result)pos=result.next;else{while(pos<normalized.length&&!/[ .,\"]/.test(normalized[pos]))pos++;}

   }
   else{while(pos<normalized.length&&normalized.charCodeAt(pos)>=64)pos++;if(pos===start)pos++;result=this.dictionary.lookup(normalized.slice(start,pos));const word=normalized.slice(start,pos);if(this.dictionary.groups.has(word[0]?.toLowerCase())){workspaceCopies.push([...word.slice(1)].map(c=>c.charCodeAt(0)|32).concat(0));lookupState=/^[A-Y][A-Z]*$/.test(word)?[word.length,result.matched_prefix]:[null,null];}}
   if(!result||result.type===208){const source=normalized.slice(start).split(/[ .]/)[0];throw new InputError('lexical_error',`I DO NOT KNOW THE WORD"${source} "`,{word:normalized.slice(start,pos),start,normalized,lookupState,workspaceCopies});}
   tokens.push({...result,start,end:pos,source:normalized.slice(start,pos)});
  }
  tokens.push({type:192,value:0,word:null,start:pos,end:pos,source:''});
  return {normalized,tokens,lookupState,workspaceCopies};
 }
}
