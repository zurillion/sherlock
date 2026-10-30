import {RandomInputsUnavailable} from './random.mjs';
import {bootstrapKeyboard,bootstrapWordWorkspace} from './keyboard-profile.mjs';
// Canonical text-screen projection for random input, independent of the DOM,
// display speed and SVG preference. It is rebuilt from output operations; no
// original screen image or machine snapshot is installed here.
export class RandomDisplay {
 constructor(data,world){this.data=data;this.world=world;}
 initialize(opening,{sceneTrace=[]}={}){this.world.display={version:1,profile:'historical-text-only',wordBuffer:bootstrapWordWorkspace(this.data.randomInputs.bootOptions),upper:Array(18).fill(''),cursor:0,remaining:36,started:false,counter:0,scrolls:0,pending:'',lower:Array(5).fill(''),lowerKnown:Array(5).fill(true),input:[],inputKnown:[],scratch:{}};
  if(this.data.randomInputs.editorInitial){this.state.input=this.data.randomInputs.editorInitial.slice(0,129);this.state.inputKnown=this.state.input.map(()=>true);this.state.tokens=this.data.randomInputs.editorInitial.slice(129);this.state.tokenKnown=this.state.tokens.map(()=>true);}
  // ROM 0616–062B allocates a LOAD header after the BASIC program, its
  // variable terminator and the five-byte LOAD "" editor line. It fills
  // eleven bytes with spaces. The USR calculator replaces the first five;
  // the untouched filename tail remains until a deeper renderer owns it.
  if(this.data.randomInputs.basicProgramLength){const workspace=0x5CCB+this.data.randomInputs.basicProgramLength+6;for(let i=5;i<11;i++)this.state.scratch[workspace+i]=32;}
  this.feed('\n');this.scene(opening,sceneTrace);if(!opening.endsWith('\n'))this.feed('\n');this.prompt();}
 scene(text,sceneTrace=[]){this.invalidateGlyphExtras();const previousFlags=this.glyphFlagsKnown;const previousUpper=this.upperGlyphKnown;this.upperGlyphKnown=false;try{for(let i=0;i<=text.length;i++){
   // D5C4 renders the last word of the carrying person's name and the
   // copula via the actor-is text argument. Its glyph frame differs from
   // the literal name in the preceding contents list. A wrapped word also
   // clears a row (C316/C374), publishing the final space's scan state.
   const role=sceneTrace.findLast(e=>e.start<=i&&i<e.end&&Number.isInteger(e.frame));
   this.glyphFrame=role?.frame??null;this.glyphFlagsKnown=role?.flagsKnown===true;
   this.glyphSpaceDescriptor=null;
   if(role&&['carrying-name','literal-person-name'].includes(role.kind)&&i<role.end-this.world.name(role.parent).split(' ').at(-1).length-(role.kind==='literal-person-name'?1:0))this.glyphFrame+=role.kind==='literal-person-name'?30:-20;
   // A887 inserts a space before the next dictionary reference. That space
   // flushes the previous name word, with DE already naming the next word.
   if(role&&['carrying-name','literal-person-name','container-name'].includes(role.kind)&&text[i]===' '){const entity=this.world.entity(role.parent),words=[...entity.qualifiers.filter(v=>v&&!(v&32768)),entity.noun],index=text.slice(role.start,i).trim().split(/\s+/).length-(role.kind==='container-name'?1:0);if(words[index])this.glyphSpaceDescriptor=(index===words.length-1?0x5000:0x4000)|(words[index]&4095);}
   if(i<text.length)this.feed(text[i]);
   // A word is flushed by the following delimiter, within the same owner.
   // After a carried-name prefix, A887 emits the separating space from
   // its caller. Filling column 35 clears the next row at that caller depth.
   if(role&&i+1===role.end){this.flush();if(role.spaceClearFrame&&this.state.cursor===35)this.glyphResidue(' ',role.spaceClearFrame,35,0x5A20);if(this.state.started&&(role.kind==='literal-person-name'&&role.end<text.length||role.spaceAfter))this.glyphResidue(' ',role.frame+12,this.state.cursor,0x5000|(this.world.entity(role.parent).noun&4095));this.glyphFrame=null;}
  }}finally{this.glyphFrame=null;this.glyphSpaceDescriptor=null;this.upperGlyphKnown=previousUpper;this.glyphFlagsKnown=previousFlags;}}
 glyphResidue(c,frame,column,descriptor=0x5C0B,callerCount=null){
  if(!frame)return;
  const x=2+column*7,address=0x5020+Math.floor(x/8),shift=x&7,glyph=this.data.spectrum.glyphs[c.charCodeAt(0)-this.data.spectrum.first],s=this.state.scratch;
  // C38B/C398 retain the screen address at frame-8. The verified
  // literal actor-name prefix uses frame5D2A and publishes its low byte
  // at5D22 and high byte at5D23. Other callers revoke ownership rather than guessing an address.
  // C38B retains the screen address at frame-8. In the cab-name path
  // frame=5D1A, so its high byte owns 5D13 until another known writer.
  // C388 ABI tests distinguish eight frames and both caller counts. The extra 5D1F byte is owned only
  // in a verified caller scope; scene frames retain their old low-byte
  // contract and unprojected EXAMINE/statement output revokes ownership.
  const put=(at,v)=>{if((at>=0x5D1A&&at<=0x5D1D)&&this.glyphFlagsKnown!==true){delete s[at];return;}if((at>=0x5D20&&at<=0x5D23)&&this.upperGlyphKnown!==true){delete s[at];return;}if(at===0x5D1F&&this.upperGlyphKnown===false){delete s[at];return;}if(at>=0x5CEC&&(at<=0x5D1D||at>=0x5D1F&&at<=0x5D23))s[at]=v;};
  // C374's CALL leaves its return link at the glyph-entry stack position.
  // A deep wrap can overwrite previously owned cells with that link.
  if(descriptor===0x5A20){put(frame,0x77);put(frame+1,0xC3);}
  // The verified caller owns both bytes of the saved scan AF: F at
  // frame-12 and raw font row A at frame-11 (5D1A/5D1B for frame5D26).
  // With frame5D26, frame-10/-9 retain C and B at5D1C/5D1D. B is the
  // scan countdown saved before DJNZ: its final saved value is1.
  // Other callers revoke ownership; this is not an unconditional stack value.
  // C388 preserves the caller's AF. Upper output reaches it after CP 0D;
  // Z80 CP takes undocumented X/Y from the operand. A row-clear reaches it
  // after AND 0. A9F5 supplies the remaining word length as the caller's B.
  for(let at=frame-4;at<frame;at++)if(at>=0x5CEC&&(at<=0x5D1D||at>=0x5D1F&&at<=0x5D23))delete s[at];
  const code=c.charCodeAt(0),difference=(code-13)&255,flags=2|8|(difference&128)|(difference===0?64:0)|((code&15)<13?16:0)|(((code^13)&(code^difference)&128)?4:0)|(code<13?1:0);
  put(frame-2,descriptor===0x5A20?84:flags);put(frame-1,code);
  if(callerCount!==null||descriptor===0x5A20){put(frame-4,shift);put(frame-3,descriptor===0x5A20?1:callerCount);}
  // C38B retains the glyph address; C39C the last scan and bit shift;
  // C39D/C3B8 the unshifted final scan. Only established fields are owned.
  put(frame-8,address&255);put(frame-7,address>>>8);
  // C38A saves the current text descriptor. While A9DF flushes a word it
  // points at the word buffer; the following delimiter restores the caller's
  // descriptor (A815/D438: $5000 | noun). C374's row clear uses $5A20.
  put(frame-6,descriptor&255);put(frame-5,descriptor>>>8);
  put(frame-10,shift);put(frame-9,1);put(frame-12,0);put(frame-11,glyph[7]);
 }
 // The verified GO TO announcement never reaches saved scan AF or BC.
 // Unprojected callers revoke all four bytes; each register has its own role.
 invalidateGlyphExtras({preserveFlags=false}={}){this.invalidateScratch(preserveFlags?0x5D1E:0x5D1A,0x5D23);}
 get state(){return this.world.display;}
 invalidateScratch(from=0x5CEC,to=0x5D23){if(this.state)for(const at of Object.keys(this.state.scratch))if(Number(at)>=from&&Number(at)<=to)delete this.state.scratch[at];}
 newline(){const s=this.state;if(this.world.npcs?.printerEnabled){const paper=s.printerPaper??(s.printerPaper=[]);paper.push(Array.from({length:256},(_,i)=>this.rowByte(s.upper[0],Math.floor(i/32),(i%32)*8)));}if(s.counter===15)s.counter=255;s.counter=(s.counter+1)&255;s.upper.shift();s.upper.push('');s.cursor=0;s.remaining=36;s.started=false;s.scrolls++;}
 put(c){const s=this.state,row=s.upper[17].padEnd(36,' ');s.upper[17]=(row.slice(0,s.cursor)+c+row.slice(s.cursor+1)).trimEnd();s.cursor++;s.remaining--;s.started=true;if(!s.remaining){if(this.glyphFrame)this.glyphResidue(' ',this.glyphFrame-8,35,0x5A20);this.newline();}}
 flush(){const s=this.state,word=s.pending;if(!word.length)return;if(s.remaining<word.length){if(this.glyphFrame)this.glyphResidue(' ',this.glyphFrame-6,35,0x5A20);this.newline();}const exact=s.remaining===word.length;for(const [i,c]of [...word].entries()){this.glyphResidue(c,this.glyphFrame,s.cursor,0x5C0B,word.length-i);this.put(c);}s.pending='';if(exact)s.started=false;}
 // A9B7 owns a reused word workspace. Flushing resets its pointer, not bytes.
 lexicalWorkspace(copies=[]){const b=this.state?.wordBuffer;if(!b)return;for(const values of copies)for(let i=0;i<values.length&&i<128;i++){
  // DA6D/DA75 write after the first letter, without touching A9B5.
  // At 5C42 the dictionary decoder reuses this same area: do not publish
  // the input copy as its final value beyond that overlap.
  b.bytes[i]=i<0x5C42-0x5C0B?values[i]:null;
 }}
 bufferFeed(c,{known=true}={}){const s=this.state;if(!s)return;const b=s.wordBuffer??(s.wordBuffer={bytes:Array(128).fill(null),index:0});if([' ','\n','\r','"'].includes(c)){b.index=0;return;}if(c==='\b'){b.index=Math.max(0,b.index-1);return;}if(b.index>=128)throw new RandomInputsUnavailable('Buffer parola oltre il confine ricostruito');b.bytes[b.index++]=known?(c==='£'?96:c.charCodeAt(0)):null;}
 feed(c,{buffer=true}={}){
  const s=this.state;if(!s)return;if(buffer)this.bufferFeed(c,{known:!/[A-Za-z]/.test(c)});
  if(c==='\b'){s.pending=s.pending.slice(0,-1);return;}
  if(![' ','\n','\r','"'].includes(c)){s.lastSpacePrinted=false;s.pending+=c;return;}
  this.flush();
  if(c==='\n'||c==='\r'){this.newline();s.lastSpacePrinted=false;}
  else if(c===' '){const printed=s.started;if(printed){if(this.glyphFrame&&this.glyphSpaceDescriptor!==null&&this.glyphSpaceDescriptor!==undefined)this.glyphResidue(' ',this.glyphFrame+12,s.cursor,this.glyphSpaceDescriptor);this.put(c);}s.lastSpacePrinted=printed;}
  // AA2A sets A025 before emitting a quote; a raw margin wrap does not
  // clear it. Only the word-buffer exact-fit path or CR resets that flag.
  else{if(!s.started&&!s.lastSpacePrinted)this.put(' ');this.put(c);s.started=true;s.lastSpacePrinted=false;}
 }
 write(text,{leading=false,sceneTrace=null}={}){if(!this.state)return;if(!sceneTrace)this.invalidateGlyphExtras();if(leading)this.feed('\n');if(sceneTrace)this.scene(text,sceneTrace);else for(const c of text)this.feed(c);if(!text.endsWith('\n'))this.feed('\n');}
 lowerText(text){const s=this.state;let column=((s.lowerCursor??2)-2)/7;for(const c of text){if(c==='\r'||c==='\n'){s.lower.shift();s.lowerKnown.shift();s.lower.push('');s.lowerKnown.push(true);column=0;continue;}s.lower[4]=s.lower[4].slice(0,column).padEnd(column,' ')+c;if(++column===36){s.lower.shift();s.lowerKnown.shift();s.lower.push('');s.lowerKnown.push(true);column=0;}}s.lowerCursor=2+column*7;s.lower[4]=s.lower[4].slice(0,column).padEnd(column,' ')+'+';}
 prompt(){const s=this.state;if(!s)return;const column=((s.lowerCursor??2)-2)/7;if(s.lower[4][column]==='+'&&s.lower[4].slice(Math.max(0,column-2),column)==='> ')return;this.lowerText('> ');s.lowerKnown[4]=true;}
 repeat(){const s=this.state,column=((s.lowerCursor??16)-2)/7;s.lower[4]=s.lower[4].slice(0,Math.max(0,column-2));s.lowerCursor=Math.max(2,(s.lowerCursor??16)-14);}
 command(normalized){const s=this.state;if(!s)return;
  // The active prompt is overwritten by the typed, normalized command.
  const column=((s.lowerCursor??16)-2)/7,line=s.lower[4].slice(0,column)+normalized.toUpperCase();s.lower[4]=line.slice(0,36);s.lowerKnown[4]=true;
  // Filling the final column scrolls immediately; ENTER then scrolls again.
  for(let at=36;at<=line.length;at+=36){s.lower.shift();s.lowerKnown.shift();s.lower.push(line.slice(at,at+36));s.lowerKnown.push(true);}
  // ENTER has already scrolled the completed command before NPC execution;
  // the channel leaves its cursor at x=2. The next editor adds "> " later.
  s.lower.shift();s.lowerKnown.shift();s.lower.push('+');s.lowerKnown.push(true);
  s.lowerCursor=2;
  for(let i=0;i<Math.min(129,normalized.length);i++){s.input[i]=normalized.charCodeAt(i)===163?96:normalized.charCodeAt(i);s.inputKnown[i]=true;}if(normalized.length<129){s.input[normalized.length]=13;s.inputKnown[normalized.length]=true;}
 }
 error(messages,{inline=false}={}){const s=this.state;if(!s)return;this.invalidateGlyphExtras();if(this.world.npcs)this.world.npcs.dictionaryReference=null;
  // A027 selects the unbuffered lower channel. C1FD wraps at 36 characters,
  // including the dictionary's initial space; CR scrolls before the prompt.
  for(const[i,message]of messages.entries())this.lowerText(' '+message.text.toUpperCase()+(inline&&i===messages.length-1?'':'\r'));
 }
 lexed(tokens){const s=this.state;if(!s?.tokens)return;s.counter=0;s.cursor=0;s.remaining=36;s.pending=''; // D719/C142 reset the formatter and word-buffer pointer.
  for(let i=0;i<96;i++){s.tokens[i]=0;s.tokenKnown[i]=true;}const bytes=tokens.flatMap(t=>[t.type,...([128,160,176,192].includes(t.type)?[]:[t.value>>>8,t.value&255])]);for(const [i,v]of bytes.entries()){s.tokens[i]=v;s.tokenKnown[i]=true;}}
 quoted(quote,{consumed=false}={}){const s=this.state;if(!s?.tokens)return;const size=quote.tokens.slice(0,-1).reduce((n,t)=>n+([128,160,176,192].includes(t.type)?1:3),0),at=quote.tokenPointer-0x5B81+size;if(at>=0&&at<s.tokens.length){s.tokens[at]=consumed?144:192;s.tokenKnown[at]=true;}}
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
  if(address>=0xC1F4&&address<=0xC1FB){
   // C1F4..FB are the two formatter channels' width, bitmap pointer and
   // pixel shift. ENTER resets the lower channel to x=2 on its last row;
   // the subsequent prompt advances it by two seven-pixel characters.
   const lower=s.lowerCursor??(s.lower[4]==='> +'?16:2),upper=2+s.cursor*7,lp=0x50E0+Math.floor(lower/8),up=0x5020+Math.floor(upper/8);
   return [36-Math.floor((lower-2)/7),s.remaining,lp&255,lp>>>8,up&255,up>>>8,upper&7,lower&7][address-0xC1F4];
  }
  if(address>=0x5800&&address<0x5B00)return 56; // canonical INK 0 / PAPER 7, no graphics
  // Declared oracle protocol: the tape was started with RETURN, it has been
  // released with two empty scans, and game keys are injected above the
  // ROM scanner. Its second KSTATE slot has not yet expired. This is NOT a model of
  // arbitrary physical-key timing on a real Spectrum.
  if(address>=0x5C00&&address<0x5C0B)return bootstrapKeyboard(this.data.randomInputs.bootOptions.keyboard)[address-0x5C00];
  if(address>=0x5C0B&&address<0x5C8B)return s.wordBuffer?.bytes[address-0x5C0B]??null;
  if(address>=0x5B00&&address<0x5B80){const i=address-0x5B00;if(s.inputKnown[i])return s.input[i];}
  if(address>=0x5B81&&address<0x5C00){const i=address-0x5B81;if(s.tokenKnown?.[i])return s.tokens[i];}
  if(address in (s.scratch||{}))return s.scratch[address];
  if(address<0x4000||address>=0x5800)return null;
  const offset=address-0x4000,y=((offset>>>11)&3)*64+((offset>>>5)&7)*8+((offset>>>8)&7),x=(offset&31)*8;
  if(y<144)return this.rowByte(s.upper[Math.floor(y/8)],y&7,x);
  if(y>=152){const row=Math.floor((y-152)/8);if(!s.lowerKnown[row])throw new RandomInputsUnavailable('Cronologia video degli errori non ancora ricostruita: comando non applicato.');return this.rowByte(s.lower[row],y&7,x);}
  // The status pattern is an asset; clock text uses the same ROM glyphs.
  const scan=y-144,clock=this.world.clock().label;let result=scan>=1&&scan<=6?this.data.spectrum.divider[(scan-1)*4+((x/8)%4)]:0;
  if(x>=8&&x<clock.length*7+24){result=0;for(let col=0;col<clock.length;col++){const c=clock[col],glyph=this.data.spectrum.glyphs[c.charCodeAt(0)-32];for(let bit=0;bit<8;bit++){const px=16+col*7+bit;if(px>=x&&px<x+8)result=(result&~(128>>(px-x)))|((glyph[scan]&(128>>bit))?(128>>(px-x)):0);}}}
  return result;
 }
 static validate(s){if(s===null||s===undefined)return;if(s.wordBuffer!==undefined&&(!s.wordBuffer||!Number.isInteger(s.wordBuffer.index)||s.wordBuffer.index<0||s.wordBuffer.index>128||!Array.isArray(s.wordBuffer.bytes)||s.wordBuffer.bytes.length!==128||s.wordBuffer.bytes.some(v=>v!==null&&(!Number.isInteger(v)||v<0||v>255))))throw Error('Buffer parola non valido');if(s.printerPaper!==undefined&&(!Array.isArray(s.printerPaper)||s.printerPaper.length>100000||s.printerPaper.some(r=>!Array.isArray(r)||r.length!==256||r.some(v=>!Number.isInteger(v)||v<0||v>255))))throw Error('Carta della stampante non valida');if(s.version!==1||s.profile!=='historical-text-only'||!Array.isArray(s.upper)||s.upper.length!==18||!s.upper.every(v=>typeof v==='string'&&v.length<=36)||!Array.isArray(s.lower)||s.lower.length!==5||!s.lower.every(v=>typeof v==='string'&&v.length<=36)||!Array.isArray(s.lowerKnown)||s.lowerKnown.length!==5||!s.lowerKnown.every(v=>typeof v==='boolean')||typeof s.pending!=='string'||s.pending.length>128||!Array.isArray(s.input)||!s.input.every(v=>Number.isInteger(v)&&v>=0&&v<=255)||!Array.isArray(s.inputKnown)||s.inputKnown.length!==s.input.length||!s.inputKnown.every(v=>typeof v==='boolean')||!Number.isInteger(s.cursor)||s.cursor<0||s.cursor>36||s.remaining!==36-s.cursor||!Number.isInteger(s.counter)||s.counter<0||s.counter>255||!Number.isSafeInteger(s.scrolls)||s.scrolls<0||typeof s.started!=='boolean'||s.lastSpacePrinted!==undefined&&typeof s.lastSpacePrinted!=='boolean'||s.lowerCursor!==undefined&&(!Number.isInteger(s.lowerCursor)||s.lowerCursor<2||s.lowerCursor>254||(s.lowerCursor-2)%7))throw Error('Proiezione video casuale non valida.');}
}
