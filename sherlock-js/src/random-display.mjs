import {RandomInputsUnavailable} from './random.mjs';
// Canonical text-screen projection for random input, independent of the DOM,
// display speed and SVG preference. It is rebuilt from output operations; no
// original screen image or machine snapshot is installed here.
export class RandomDisplay {
 constructor(data,world){this.data=data;this.world=world;}
 initialize(opening){this.world.display={version:1,profile:'historical-text-only',upper:Array(18).fill(''),cursor:0,remaining:36,started:false,counter:0,scrolls:0,pending:'',lower:Array(5).fill(''),lowerKnown:Array(5).fill(true),input:[],inputKnown:[]};this.write(opening,{leading:true});this.prompt();}
 get state(){return this.world.display;}
 newline(){const s=this.state;if(s.counter===15)s.counter=255;s.counter=(s.counter+1)&255;s.upper.shift();s.upper.push('');s.cursor=0;s.remaining=36;s.started=false;s.scrolls++;}
 put(c){const s=this.state,row=s.upper[17].padEnd(36,' ');s.upper[17]=(row.slice(0,s.cursor)+c+row.slice(s.cursor+1)).trimEnd();s.cursor++;s.remaining--;s.started=true;if(!s.remaining)this.newline();}
 flush(){const s=this.state,word=s.pending;if(!word.length)return;if(s.remaining<word.length)this.newline();const exact=s.remaining===word.length;for(const c of word)this.put(c);s.pending='';if(exact)s.started=false;}
 feed(c){const s=this.state;if(!s)return;if(c==='\b'){s.pending=s.pending.slice(0,-1);return;}if(![' ','\n','\r','"'].includes(c)){s.pending+=c;return;}this.flush();if(c==='\n'||c==='\r')this.newline();else if(c!==' '||s.started)this.put(c);}
 write(text,{leading=false}={}){if(!this.state)return;if(leading)this.feed('\n');for(const c of text)this.feed(c);if(!text.endsWith('\n'))this.feed('\n');}
 prompt(){const s=this.state;if(!s)return;s.lower[4]='> +';s.lowerKnown[4]=true;}
 command(normalized){const s=this.state;if(!s)return;
  // The active prompt is overwritten by the typed, normalized command.
  const line='> '+normalized.toUpperCase();s.lower[4]=line.slice(0,36);s.lowerKnown[4]=true;
  for(let at=36;at<line.length;at+=36){s.lower.shift();s.lowerKnown.shift();s.lower.push(line.slice(at,at+36));s.lowerKnown.push(true);}
  // ENTER has already scrolled the completed command before NPC execution;
  // the channel leaves its cursor at x=2. The next editor adds "> " later.
  s.lower.shift();s.lowerKnown.shift();s.lower.push('+');s.lowerKnown.push(true);
  for(let i=0;i<normalized.length;i++){s.input[i]=normalized.charCodeAt(i)===163?96:normalized.charCodeAt(i);s.inputKnown[i]=true;}s.input[normalized.length]=13;s.inputKnown[normalized.length]=true;
  s.counter=0;s.cursor=0;s.remaining=36; // D719/C142, following lexical preflight.
 }
 error(){const s=this.state;if(s)s.lowerKnown=s.lowerKnown.map(()=>false);}
 rowByte(text,row,byteX){
  let result=0;for(let column=0;column<36;column++){
   const c=text[column]||' ',code=c==='£'?96:c.charCodeAt(0),glyph=this.data.spectrum.glyphs[code-this.data.spectrum.first];
   if(!glyph)throw new RandomInputsUnavailable('Glifo della proiezione video non ricostruito.');
   const start=2+column*7;
   for(let pixel=0;pixel<8;pixel++){const x=start+pixel;if(x<byteX||x>=byteX+8)continue;const mask=128>>(x-byteX);result=(result&~mask)|((glyph[row]&(128>>pixel))?mask:0);}
  }return result;
 }
 read(address){
  const s=this.state;if(!s)throw new RandomInputsUnavailable('Proiezione video assente nel salvataggio.');
  if(address>=0x5800&&address<0x5B00)return 56; // canonical INK 0 / PAPER 7, no graphics
  if(address>=0x5B00&&address<0x5B80){const i=address-0x5B00;if(s.inputKnown[i])return s.input[i];}
  if(address<0x4000||address>=0x5800)return null;
  const offset=address-0x4000,y=((offset>>>11)&3)*64+((offset>>>5)&7)*8+((offset>>>8)&7),x=(offset&31)*8;
  if(y<144)return this.rowByte(s.upper[Math.floor(y/8)],y&7,x);
  if(y>=152){const row=Math.floor((y-152)/8);if(!s.lowerKnown[row])throw new RandomInputsUnavailable('Cronologia video degli errori non ancora ricostruita: comando non applicato.');return this.rowByte(s.lower[row],y&7,x);}
  // The status pattern is an asset; clock text uses the same ROM glyphs.
  const scan=y-144,clock=this.world.clock().label;let result=scan>=1&&scan<=6?this.data.spectrum.divider[(scan-1)*4+((x/8)%4)]:0;
  if(x>=8&&x<clock.length*7+24){result=0;for(let col=0;col<clock.length;col++){const c=clock[col],glyph=this.data.spectrum.glyphs[c.charCodeAt(0)-32];for(let bit=0;bit<8;bit++){const px=16+col*7+bit;if(px>=x&&px<x+8)result=(result&~(128>>(px-x)))|((glyph[scan]&(128>>bit))?(128>>(px-x)):0);}}}
  return result;
 }
 static validate(s){if(s===null||s===undefined)return;if(s.version!==1||s.profile!=='historical-text-only'||!Array.isArray(s.upper)||s.upper.length!==18||!s.upper.every(v=>typeof v==='string'&&v.length<=36)||!Array.isArray(s.lower)||s.lower.length!==5||!s.lower.every(v=>typeof v==='string'&&v.length<=36)||!Array.isArray(s.lowerKnown)||s.lowerKnown.length!==5||!s.lowerKnown.every(v=>typeof v==='boolean')||typeof s.pending!=='string'||s.pending.length>128||!Array.isArray(s.input)||!s.input.every(v=>Number.isInteger(v)&&v>=0&&v<=255)||!Array.isArray(s.inputKnown)||s.inputKnown.length!==s.input.length||!s.inputKnown.every(v=>typeof v==='boolean')||!Number.isInteger(s.cursor)||s.cursor<0||s.cursor>36||s.remaining!==36-s.cursor||!Number.isInteger(s.counter)||s.counter<0||s.counter>255||!Number.isSafeInteger(s.scrolls)||s.scrolls<0||typeof s.started!=='boolean')throw Error('Proiezione video casuale non valida.');}
}
