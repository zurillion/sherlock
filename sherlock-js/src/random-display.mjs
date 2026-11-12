import {capitalKind,normalizedCapital,moneyClearsCapital} from './output-capitalization.mjs';
import {textWindowControl} from './text-window.mjs';
import {RandomInputsUnavailable} from './random.mjs';
import {bootstrapKeyboard,bootstrapWordWorkspace} from './keyboard-profile.mjs';

function incrementFlags(before,carry=0){
 const after=(before+1)&255;
 return (after&0xA8)|(after===0?64:0)|((before&15)===15?16:0)|(before===127?4:0)|carry;
}
// Canonical text-screen projection for random input, independent of the DOM,
// display speed and SVG preference. It is rebuilt from output operations; no
// original screen image or machine snapshot is installed here.
export class RandomDisplay {
 constructor(data,world){this.data=data;this.world=world;}
 initialize(opening,{sceneTrace=[],deferPrompt=false}={}){this.world.display={version:1,profile:'historical-text-only',capitalizationFlag:this.data.argumentChecks?.initialCapitalization??null,spacingFlag:this.data.argumentChecks?.initialOutputSpacing??null,wordBuffer:bootstrapWordWorkspace(this.data.randomInputs.bootOptions),upper:Array(18).fill(''),cursor:0,remaining:36,started:false,counter:0,scrolls:0,pending:'',lower:Array(5).fill(''),lowerKnown:Array(5).fill(true),input:[],inputKnown:[],scratch:{}};
  if(this.data.randomInputs.editorInitial){this.state.input=this.data.randomInputs.editorInitial.slice(0,129);this.state.inputKnown=this.state.input.map(()=>true);this.state.tokens=this.data.randomInputs.editorInitial.slice(129);this.state.tokenKnown=this.state.tokens.map(()=>true);}
  // ROM 0616–062B allocates a LOAD header after the BASIC program, its
  // variable terminator and the five-byte LOAD "" editor line. It fills
  // eleven bytes with spaces. The USR calculator replaces the first five;
  // the untouched filename tail remains until a deeper renderer owns it.
  if(this.data.randomInputs.basicProgramLength){const workspace=0x5CCB+this.data.randomInputs.basicProgramLength+6;for(let i=5;i<11;i++)this.state.scratch[workspace+i]=32;}
  this.wideWindow(); // C14A/C15D initializes the source window through C142.
  this.feed('\n');this.scene(opening,sceneTrace);if(!opening.endsWith('\n'))this.feed('\n');if(!deferPrompt)this.prompt();}
 wideWindow(){const s=this.state;if(!s)return;const next=textWindowControl(false,s.counter);s.windowMode=next.mode;s.cursor=next.cursor;s.remaining=next.remaining;s.started=false;}
 setChannel(value){if(this.world.npcs)this.world.npcs.outputChannel=value;}
 scene(text,sceneTrace=[]){this.invalidateGlyphExtras();const previousFlags=this.glyphFlagsKnown;const previousUpper=this.upperGlyphKnown,previousVideoHigh=this.glyphVideoHighKnown,previousVideoLow=this.glyphVideoLowKnown,previousCallerB=this.glyphCallerBKnown,previousCallerC=this.glyphCallerCKnown,previousCallerFlags=this.glyphCallerFlagsKnown,previousCallerA=this.glyphCallerAKnown,previousDescriptorLow=this.glyphDescriptorLowKnown,previousSpaceScan=this.glyphSpaceScanKnown,previousDescriptorHigh=this.glyphDescriptorHighKnown,previousSpaceByte=this.glyphSpaceByteKnown,previousSpaceShift=this.glyphSpaceShiftKnown,previousSpaceCount=this.glyphSpaceCountKnown,previousSpaceVideoLow=this.glyphSpaceVideoLowKnown,previousSpaceVideoHigh=this.glyphSpaceVideoHighKnown;this.upperGlyphKnown=false;try{for(let i=0;i<=text.length;i++){
   // D5C4 renders the last word of the carrying person's name and the
   // copula via the actor-is text argument. Its glyph frame differs from
   // the literal name in the preceding contents list. A wrapped word also
   // clears a row (C316/C374), publishing the final space's scan state.
   const role=sceneTrace.findLast(e=>e.start<=i&&i<e.end&&Number.isInteger(e.frame));
   this.glyphFrame=role?.kind==='passage-direction'?null:role?.frame??null;this.glyphFlagsKnown=role?.flagsKnown===true;this.glyphVideoHighKnown=role?.videoHighKnown===true;this.glyphVideoLowKnown=role?.videoLowKnown===true;this.glyphCallerBKnown=role?.callerBKnown===true;this.glyphCallerCKnown=role?.callerCKnown===true;this.glyphCallerFlagsKnown=role?.callerFlagsKnown===true;this.glyphCallerAKnown=role?.callerAKnown===true;this.glyphDescriptorLowKnown=role?.descriptorLowKnown===true;this.glyphDescriptorHighKnown=role?.descriptorHighKnown===true;this.glyphSpaceScanKnown=false;this.glyphSpaceByteKnown=false;this.glyphSpaceShiftKnown=false;this.glyphSpaceCountKnown=false;this.glyphSpaceVideoLowKnown=false;this.glyphSpaceVideoHighKnown=false;
   this.glyphSpaceDescriptor=null;
   if(role&&['carrying-name','literal-person-name'].includes(role.kind)&&i<role.end-this.world.name(role.parent).split(' ').at(-1).length-(role.kind==='literal-person-name'?1:0))this.glyphFrame+=role.kind==='literal-person-name'?30:-20;
   // A887 inserts a space before the next dictionary reference. That space
   // flushes the previous name word, with DE already naming the next word.
   if(role&&['carrying-name','literal-person-name','container-name','root-object-prefix','carried-object-prefix','passage-name-prefix'].includes(role.kind)&&text[i]===' '){const entity=this.world.entity(role.parent),words=[...entity.qualifiers.filter(v=>v&&!(v&32768)),entity.noun],index=text.slice(role.start,i).trim().split(/\s+/).length-(['container-name','root-object-prefix','carried-object-prefix','passage-name-prefix'].includes(role.kind)&&!(entity.noun&32768)?1:0);if(words[index])this.glyphSpaceDescriptor=(index===words.length-1?0x5000:0x4000)|(words[index]&4095);}
   const rawText=sceneTrace.find(e=>e.kind==='raw-text-buffer'&&e.start<=i&&i<e.end);
   // A later name/prose caller has its own unprojected register saves.
   // The noun of this same passage shares the raw span with its prefix.
   if(rawText&&rawText.affectsStack!==false&&i===rawText.start){if(!this.glyphCallerBKnown)delete this.state.scratch[0x5D23];if(!this.glyphCallerCKnown)delete this.state.scratch[0x5D22];if(!this.glyphVideoLowKnown)delete this.state.scratch[0x5D1E];if(!this.glyphCallerFlagsKnown)delete this.state.scratch[0x5D24];if(!this.glyphCallerAKnown)delete this.state.scratch[0x5D25];if(!this.glyphDescriptorLowKnown)delete this.state.scratch[0x5D20];delete this.state.scratch[0x5D26];if(!this.glyphDescriptorHighKnown)delete this.state.scratch[0x5D21];delete this.state.scratch[0x5D27];delete this.state.scratch[0x5D28];delete this.state.scratch[0x5D29];delete this.state.scratch[0x5D2A];delete this.state.scratch[0x5D2B];}
   if(i<text.length)this.feed(text[i],{buffer:!rawText});
   if(rawText&&i+1===rawText.end)for(const {c,...options}of rawText.events)this.bufferFeed(c,options);
   // A word is flushed by the following delimiter, within the same owner.
   // After a carried-name prefix, A887 emits the separating space from
   // its caller. Filling column 35 clears the next row at that caller depth.
   if(role&&i+1===role.end){this.flush(role.kind==='passage-direction'?role.frame:null);if(role.spaceClearFrame&&this.state.cursor===35)this.glyphResidue(' ',role.spaceClearFrame,35,0x5A20);if(this.state.started&&(role.kind==='literal-person-name'&&role.end<text.length||role.spaceAfter)){this.glyphSpaceScanKnown=role.spaceScanKnown===true;this.glyphSpaceByteKnown=role.spaceByteKnown===true;this.glyphSpaceShiftKnown=role.spaceShiftKnown===true;this.glyphSpaceCountKnown=role.spaceCountKnown===true;this.glyphSpaceVideoLowKnown=role.spaceVideoLowKnown===true;this.glyphSpaceVideoHighKnown=role.spaceVideoHighKnown===true;this.glyphResidue(' ',role.frame+12,this.state.cursor,0x5000|(this.world.entity(role.parent).noun&4095));this.glyphSpaceScanKnown=false;this.glyphSpaceByteKnown=false;this.glyphSpaceShiftKnown=false;this.glyphSpaceCountKnown=false;this.glyphSpaceVideoLowKnown=false;this.glyphSpaceVideoHighKnown=false;}this.glyphFrame=null;}
  }
   // The last noun can remain buffered until the caller emits CR after
   // scene(). A wrap there is outside the proved passage-prefix frame.
   if(this.state.pending.length>=this.state.remaining){delete this.state.scratch[0x5D22];delete this.state.scratch[0x5D23];delete this.state.scratch[0x5D1E];delete this.state.scratch[0x5D24];delete this.state.scratch[0x5D25];delete this.state.scratch[0x5D20];delete this.state.scratch[0x5D26];delete this.state.scratch[0x5D21];delete this.state.scratch[0x5D27];delete this.state.scratch[0x5D28];delete this.state.scratch[0x5D29];delete this.state.scratch[0x5D2A];delete this.state.scratch[0x5D2B];}
   // Reserve the final CR and action separator below the MORE threshold.
   if(this.state.counter+2>=15){delete this.state.scratch[0x5D26];delete this.state.scratch[0x5D27];delete this.state.scratch[0x5D28];delete this.state.scratch[0x5D29];delete this.state.scratch[0x5D2A];delete this.state.scratch[0x5D2B];}
  }finally{this.glyphFrame=null;this.glyphSpaceDescriptor=null;this.upperGlyphKnown=previousUpper;this.glyphVideoHighKnown=previousVideoHigh;this.glyphVideoLowKnown=previousVideoLow;this.glyphCallerBKnown=previousCallerB;this.glyphCallerCKnown=previousCallerC;this.glyphCallerFlagsKnown=previousCallerFlags;this.glyphCallerAKnown=previousCallerA;this.glyphDescriptorLowKnown=previousDescriptorLow;this.glyphSpaceScanKnown=previousSpaceScan;this.glyphDescriptorHighKnown=previousDescriptorHigh;this.glyphSpaceByteKnown=previousSpaceByte;this.glyphSpaceShiftKnown=previousSpaceShift;this.glyphSpaceCountKnown=previousSpaceCount;this.glyphSpaceVideoLowKnown=previousSpaceVideoLow;this.glyphSpaceVideoHighKnown=previousSpaceVideoHigh;this.glyphFlagsKnown=previousFlags;}}
 glyphResidue(c,frame,column,descriptor=0x5C0B,callerCount=null){
  if(!frame)return;
  const x=2+column*7,address=0x5020+Math.floor(x/8),shift=x&7,glyph=this.data.spectrum.glyphs[c.charCodeAt(0)-this.data.spectrum.first],s=this.state.scratch;
  // C38B/C398 retain the screen address at frame-8. The verified
  // literal actor-name prefix uses frame5D2A and publishes its low byte
  // at5D22 and high byte at5D23. C38A separately saves E of the text
  // descriptor at5D24; this is not derived from either video-address byte. Other callers revoke ownership rather than guessing an address.
  // C38B retains the screen address at frame-8. In the cab-name path
  // frame=5D1A, so its high byte owns 5D13 until another known writer.
  // C388 ABI tests distinguish eight frames and both caller counts. The extra 5D1F byte is owned only
  // in a verified caller scope. The passage qualifier independently owns
  // video H; other scene and unprojected statement callers remain unowned.
  // D658 passage prefix, C388/SP5D26: C38B/C398 save video H at1F.
  // The low byte1E has its own proved caller contract; knowing1F alone
  // never supplies it. Both values are derived from the glyph column.
  // The same verified passage frame independently saves caller B at23.
  // A9F5 supplies remaining word length; an unknown count revokes the byte.
  const put=(at,value)=>{
   const passagePrefix=frame===0x5D26&&(
    at===0x5D20&&this.glyphDescriptorLowKnown===true||
    at===0x5D21&&this.glyphDescriptorHighKnown===true||
    at===0x5D22&&this.glyphCallerCKnown===true||
    at===0x5D23&&this.glyphCallerBKnown===true||
    at===0x5D24&&this.glyphCallerFlagsKnown===true||
    at===0x5D25&&this.glyphCallerAKnown===true
   );
   const passageSpace=frame===0x5D32&&c===' '&&(
    at===0x5D26&&this.glyphSpaceScanKnown===true||
    at===0x5D27&&this.glyphSpaceByteKnown===true||
    at===0x5D28&&this.glyphSpaceShiftKnown===true||
    at===0x5D29&&this.glyphSpaceCountKnown===true||
    at===0x5D2A&&this.glyphSpaceVideoLowKnown===true||
    at===0x5D2B&&this.glyphSpaceVideoHighKnown===true
   );
   const usesUpperContext=at>=0x5D20&&at<=0x5D2B||at===0x5D30;
   if((at===0x5D2B&&!passageSpace)||
    (at>=0x5D1A&&at<=0x5D1D&&this.glyphFlagsKnown!==true)||
    (usesUpperContext&&this.upperGlyphKnown!==true&&!passagePrefix&&!passageSpace)||
    (at===0x5D1E&&this.upperGlyphKnown!==true&&!(this.glyphVideoLowKnown===true&&frame===0x5D26))||
    (at===0x5D1F&&this.upperGlyphKnown===false&&!(this.glyphVideoHighKnown===true&&frame===0x5D26))){
    delete s[at];
    return;
   }
   if(at>=0x5CEC&&(at<=0x5D2B||at===0x5D30))s[at]=value;
  };
  // C389 saves caller C at frame-4: 5D22 for a verified passage prefix.
  // The value is the pixel offset in the current video byte.
  // This is supplied by the pixel-column calculation, not a global shift2.
  // The later proper room prefix uses frame5D32: saved scan F supersedes
  // that caller C at5D26. Its final noun flushes after the name returns.
  // C39D/C3B8 save A alongside F: frame5D32 owns5D27 as the raw
  // eighth font row, before rotation. C39C/C3B7 retain C at5D28 in
  // the same frame: (2+7*column)&7, before either pixel rotation.
  // The high byte of that saved BC owns5D29 for frame5D32: the
  // final scan count before DJNZ is1. Other frames retain caller A/B,
  // descriptor D, video H or raw glyph A; no global byte1 is installed.
  // In frame5D32, C38B/C398 also retains video L at5D2A.
  // Its value follows the glyph column, independently of saved BC at28/29.
  // Other entry frames retain caller F/C, descriptor E, scan C or scan F.
  // 5D25 follows the independently saved high byte for six caller frames:
  // caller A/B, descriptor D, video H, scan B, or raw glyph A.
  // Unknown caller BC revokes it.
  // C374's CALL leaves its return link at the glyph-entry stack position.
  // A deep wrap can overwrite previously owned cells with that link.
  // C316 also saves its caller registers above the C374/C388 frame.
  // A deep clear can overwrite23 without any C388 PUSH landing there.
  // Those outer registers are not owned by the passage-prefix contract.
  if(descriptor===0x5A20&&this.glyphDescriptorLowKnown===true&&frame===0x5D1E)delete s[0x5D20];
  if(descriptor===0x5A20&&this.glyphDescriptorHighKnown===true&&frame===0x5D1E)delete s[0x5D21];
  if(descriptor===0x5A20&&this.glyphCallerCKnown===true&&[0x5D1E,0x5D20].includes(frame))delete s[0x5D22];
  if(descriptor===0x5A20&&this.glyphCallerBKnown===true&&[0x5D1E,0x5D20].includes(frame))delete s[0x5D23];
  // C316's outer BC/HL/DE saves can also replace the caller F at24.
  if(descriptor===0x5A20&&this.glyphCallerFlagsKnown===true&&[0x5D1E,0x5D20,0x5D22].includes(frame))delete s[0x5D24];
  // The high bytes of those same outer BC/HL/DE saves can replace A at25.
  if(descriptor===0x5A20&&this.glyphCallerAKnown===true&&[0x5D1E,0x5D20,0x5D22].includes(frame))delete s[0x5D25];
  if(descriptor===0x5A20&&this.upperGlyphKnown!==true&&frame>=0x5D20&&frame<=0x5D28){
   delete s[0x5D28];
   delete s[0x5D29];
  }
  if(descriptor===0x5A20&&this.upperGlyphKnown!==true&&frame>=0x5D22&&frame<=0x5D2A){
   delete s[0x5D2A];
   delete s[0x5D2B];
  }
  if(descriptor===0x5A20){put(frame,0x77);put(frame+1,0xC3);}
  else if(frame===0x5D22)delete s[0x5D22]; // Unprojected return link.
  else if(frame===0x5D24)delete s[0x5D25]; // An unprojected return link cannot preserve an old high byte.
  if(descriptor!==0x5A20&&frame===0x5D26){delete s[0x5D26];delete s[0x5D27];} // Unknown C2EE return link, superseded only by a proved later writer.
  if(descriptor!==0x5A20&&frame===0x5D28){delete s[0x5D28];delete s[0x5D29];} // Unprojected return link.
  if(descriptor!==0x5A20&&frame===0x5D2A){delete s[0x5D2A];delete s[0x5D2B];}
  if(descriptor!==0x5A20&&frame===0x5D30)delete s[0x5D30]; // Unknown return link, not an AF save.
  // 5D30 is projected independently: AF/BC/DE/HL/scan fields depend on entry depth.
  // Cells2C–2F and31 remain unowned.
  // The verified caller owns both bytes of the saved scan AF: F at
  // frame-12 and raw font row A at frame-11 (5D1A/5D1B for frame5D26).
  // With frame5D26, frame-10/-9 retain C and B at5D1C/5D1D. B is the
  // scan countdown saved before DJNZ: its final saved value is1.
  // Other callers revoke ownership; this is not an unconditional stack value.
  // C388 preserves the caller's AF. Upper output reaches it after CP 0D;
  // Z80 CP takes undocumented X/Y from the operand. A row-clear reaches it
  // after AND 0. A9F5 supplies the remaining word length as the caller's B.
  for(let at=frame-4;at<frame;at++)if(at>=0x5CEC&&(at<=0x5D2B||at===0x5D30))delete s[at];
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
  // On the last scan, C39D retains flags from INC H at the end of
  // scan seven. A split byte restores them, then DEC/INC C before C3B8.
  // Derive those flags from the row address and shift, not a boot zero.
  const lastRowFlags=incrementFlags(((address>>>8)+6)&255,0);
  const savedScanFlags=shift?incrementFlags((shift-1)&255,lastRowFlags&1):lastRowFlags;
  put(frame-10,shift);put(frame-9,1);put(frame-12,savedScanFlags);put(frame-11,glyph[7]);
 }
 // The verified GO TO announcement never reaches saved scan AF or BC.
 // Unprojected callers revoke the owned upper fields; each register has its own role.
 invalidateGlyphExtras({preserve1A=false,preserveFlags=false,preserveLow=false,preserve1F=false,preserve23=false,preserve22=false,preserve1E=false,preserve24=false,preserve25=false,preserve20=false,preserve26=false,preserve21=false,preserve27=false,preserve28=false,preserve29=false,preserve2A=false,preserve2B=false,preserveLowerClear=false}={}){const except=[];if(preserve1A)except.push(0x5D1A);if(preserve1F)except.push(0x5D1F);if(preserve23)except.push(0x5D23);if(preserve22)except.push(0x5D22);if(preserve1E)except.push(0x5D1E);if(preserve24)except.push(0x5D24);if(preserve25)except.push(0x5D25);if(preserve20)except.push(0x5D20);if(preserve26)except.push(0x5D26);if(preserve21)except.push(0x5D21);if(preserve27)except.push(0x5D27);if(preserve28)except.push(0x5D28);if(preserve29)except.push(0x5D29);if(preserve2A)except.push(0x5D2A);if(preserve2B)except.push(0x5D2B);if(preserveLowerClear)except.push(0x5D2C,0x5D2D,0x5D2E,0x5D2F,0x5D30,0x5D31);this.invalidateScratch(preserveFlags?0x5D1F:preserveLow?0x5D1E:0x5D1A,0x5D31,except);}
 get state(){return this.world.display;}
 invalidateScratch(from=0x5CEC,to=0x5D31,except=[]){if(this.state)for(const at of Object.keys(this.state.scratch))if(Number(at)>=from&&Number(at)<=to&&!except.includes(Number(at)))delete this.state.scratch[at];}
 newline(){const s=this.state;if(this.world.npcs?.printerEnabled){const paper=s.printerPaper??(s.printerPaper=[]);paper.push(Array.from({length:256},(_,i)=>this.rowByte(s.upper[0],Math.floor(i/32),(i%32)*8)));}if(s.counter===15){this.wideWindow();s.counter=255;}s.counter=(s.counter+1)&255;s.upper.shift();s.upper.push('');s.cursor=0;s.remaining=36;s.started=false;s.scrolls++;}
 put(c,glyphFrame=this.glyphFrame){const s=this.state,row=s.upper[17].padEnd(36,' ');s.upper[17]=(row.slice(0,s.cursor)+c+row.slice(s.cursor+1)).trimEnd();s.cursor++;s.remaining--;s.started=true;if(!s.remaining){if(glyphFrame)this.glyphResidue(' ',glyphFrame-8,35,0x5A20);else if(this.upperGlyphKnown===false){delete s.scratch[0x5D22];delete s.scratch[0x5D23];delete s.scratch[0x5D1E];delete s.scratch[0x5D24];delete s.scratch[0x5D25];delete s.scratch[0x5D20];delete s.scratch[0x5D26];delete s.scratch[0x5D21];delete s.scratch[0x5D27];delete s.scratch[0x5D28];delete s.scratch[0x5D29];delete s.scratch[0x5D2A];delete s.scratch[0x5D2B];}this.newline();}}
 // A025 belongs to AA14 normalization, not the physical cursor. Raw margin
 // wraps and C142 do not reset it. Only normalized CR and an exact-fit
 // buffered word clear it; a non-suppressed character sets it to1.
 normalizeCapital(c){this.state.capitalizationFlag=normalizedCapital(this.state.capitalizationFlag,c);}
 moneyCapital(pence){if(moneyClearsCapital(pence))this.state.capitalizationFlag=0;}
 normalizeSpacing(c){const s=this.state;if(!s)return;this.normalizeCapital(c);if(c==='\n'||c==='\r')s.spacingFlag=0;else if(c!==' '||s.spacingFlag!=null&&s.spacingFlag!==0)s.spacingFlag=1;}
 flush(wrapFrame=null){const s=this.state,word=s.pending;if(!word.length)return;const exactSpacing=s.remaining===word.length;if(s.remaining<word.length){if(wrapFrame||this.glyphFrame)this.glyphResidue(' ',wrapFrame??this.glyphFrame-6,35,0x5A20);else if(this.upperGlyphKnown===false){delete s.scratch[0x5D22];delete s.scratch[0x5D23];delete s.scratch[0x5D1E];delete s.scratch[0x5D24];delete s.scratch[0x5D25];delete s.scratch[0x5D20];delete s.scratch[0x5D26];delete s.scratch[0x5D21];delete s.scratch[0x5D27];delete s.scratch[0x5D28];delete s.scratch[0x5D29];delete s.scratch[0x5D2A];delete s.scratch[0x5D2B];}this.normalizeSpacing('\r');this.newline();}const exact=s.remaining===word.length;for(const [i,c]of [...word].entries()){this.normalizeSpacing(c);this.glyphResidue(c,this.glyphFrame,s.cursor,0x5C0B,word.length-i);this.put(c);}s.pending='';if(exactSpacing)s.spacingFlag=0;if(exact)s.started=false;}
 // A9B7 owns a reused word workspace. Flushing resets its pointer, not bytes.
 lexicalWorkspace(copies=[]){const b=this.state?.wordBuffer;if(!b)return;for(const values of copies)for(let i=0;i<values.length&&i<128;i++){
  // DA6D/DA75 write after the first letter, without touching A9B5.
  // At 5C42 the dictionary decoder reuses this same area: do not publish
  // the input copy as its final value beyond that overlap.
  b.bytes[i]=i<0x5C42-0x5C0B?values[i]:null;if(b.capitalClasses)b.capitalClasses[i]=b.bytes[i]==null?null:capitalKind(String.fromCharCode(b.bytes[i]));
 }}
 // Literal output still runs A9B7/AA14 when C1E1 discards pixels.
 // Dictionary/name emission is suppressed earlier at A887. Hidden output
 // uses the shared word pointer but never advances the screen cursor.
 hiddenSpacing(c,length){if(this.world.npcs?.outputChannel==null){this.state.spacingFlag=null;return;}if(this.world.npcs.outputChannel!==0)return;if(![' ','\n','\r','"'].includes(c))return;if(length){for(let i=0;i<length;i++){const kind=this.state.wordBuffer.capitalClasses?.[i]??(this.state.wordBuffer.bytes[i]==null?null:capitalKind(String.fromCharCode(this.state.wordBuffer.bytes[i])));if(kind===null)this.state.capitalizationFlag=null;else if(kind>=0)this.state.capitalizationFlag=kind;}if(this.state.remaining<length)this.normalizeSpacing('\r');this.state.spacingFlag=1;/* A nonempty buffered word emits non-space characters. */if(this.state.remaining===length)this.state.spacingFlag=0;}this.normalizeSpacing(c);}
 bufferFeed(c,{known=true,hidden=false}={}){const s=this.state;if(!s)return;const b=s.wordBuffer??(s.wordBuffer={bytes:Array(128).fill(null),index:0});if(hidden)this.hiddenSpacing(c,b.index);if(!b.capitalClasses)b.capitalClasses=b.bytes.map(v=>v==null?null:capitalKind(String.fromCharCode(v)));if([' ','\n','\r','"'].includes(c)){b.index=0;return;}if(c==='\b'){b.index=Math.max(0,b.index-1);return;}if(b.index>=128)throw new RandomInputsUnavailable('Buffer parola oltre il confine ricostruito');b.capitalClasses[b.index]=capitalKind(c);b.bytes[b.index++]=known?(c==='£'?96:c.charCodeAt(0)):null;}
 feed(c,{buffer=true}={}){
  const s=this.state;if(!s)return;if(buffer)this.bufferFeed(c,{known:!/[A-Za-z]/.test(c)});
  if(c==='\b'){s.pending=s.pending.slice(0,-1);return;}
  if(![' ','\n','\r','"'].includes(c)){s.lastSpacePrinted=false;s.pending+=c;return;}
  this.flush();this.normalizeSpacing(c);
  if(c==='\n'||c==='\r'){this.newline();s.lastSpacePrinted=false;}
  else if(c===' '){const printed=s.started;if(printed){const frame=this.glyphFrame&&this.glyphSpaceDescriptor!==null&&this.glyphSpaceDescriptor!==undefined?this.glyphFrame+12:this.glyphFrame;if(frame&&this.glyphSpaceDescriptor!==null&&this.glyphSpaceDescriptor!==undefined)this.glyphResidue(' ',frame,s.cursor,this.glyphSpaceDescriptor);this.put(c,frame);}s.lastSpacePrinted=printed;}
  // AA2A sets A025 before emitting a quote; a raw margin wrap does not
  // clear it. Only the word-buffer exact-fit path or CR resets that flag.
  else{if(!s.started&&!s.lastSpacePrinted)this.put(' ');this.put(c);s.started=true;s.lastSpacePrinted=false;}
 }
 // Fresh-row cab payment and exit announcements leave the saved C at 5D1A.
 // A longer announcement or a pending MORE can reach a deeper clear.
 write(text,{cabAction=false,leading=false,sceneTrace=null,moneyEnds=[],preserveLow=false,preserve1F=false,preserve23=false,preserve22=false,preserve1E=false,preserve24=false,preserve25=false,preserve20=false,preserve26=false,preserve21=false,preserve27=false,preserve28=false,preserve29=false,preserve2A=false,preserve2B=false,preserveLowerClear=false}={}){if(!this.state)return;if(!sceneTrace)this.invalidateGlyphExtras({preserve1A:cabAction&&this.state.cursor===0&&!this.state.pending&&this.state.counter+2<15&&text.length<=36,preserveLow,preserve1F,preserve23,preserve22,preserve1E,preserve24,preserve25,preserve20,preserve26,preserve21,preserve27,preserve28,preserve29,preserve2A,preserve2B});if(leading)this.feed('\n');if(sceneTrace)this.scene(text,sceneTrace);else for(const[i,c]of[...text].entries()){this.feed(c);for(const end of moneyEnds)if(end.end===i+1)this.moneyCapital(end.pence);}if(!text.endsWith('\n'))this.feed('\n');}
 lowerText(text){const s=this.state;let column=((s.lowerCursor??2)-2)/7;for(const c of text){if(c==='\r'||c==='\n'){s.lower.shift();s.lowerKnown.shift();s.lower.push('');s.lowerKnown.push(true);column=0;continue;}s.lower[4]=s.lower[4].slice(0,column).padEnd(column,' ')+c;if(++column===36){s.lower.shift();s.lowerKnown.shift();s.lower.push('');s.lowerKnown.push(true);column=0;}}s.lowerCursor=2+column*7;s.lower[4]=s.lower[4].slice(0,column).padEnd(column,' ')+'+';}
 prompt(){this.setChannel(1);const s=this.state;if(!s)return;const column=((s.lowerCursor??2)-2)/7;if(s.lower[4][column]==='+'&&s.lower[4].slice(Math.max(0,column-2),column)==='> ')return;this.lowerText('> ');s.lowerKnown[4]=true;}
 repeat(){this.setChannel(0);const s=this.state,column=((s.lowerCursor??16)-2)/7;s.lower[4]=s.lower[4].slice(0,Math.max(0,column-2));s.lowerCursor=Math.max(2,(s.lowerCursor??16)-14);}
 command(normalized){this.setChannel(0);const s=this.state;if(!s)return;
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
 // Lower-channel rejection preserves low stack only for callers separately proved
 // by the complete original pipeline. Clarifications and other errors revoke it.
 error(messages,{inline=false}={}){this.setChannel(1);const s=this.state;if(!s)return;this.invalidateGlyphExtras({preserveLow:messages.length>0&&messages.every(m=>m.preserve_renderer_low===true),preserve1F:messages.length>0&&messages.every(m=>m.preserve_renderer_1f===true),preserve23:messages.length>0&&messages.every(m=>m.preserve_renderer_23===true),preserve22:messages.length>0&&messages.every(m=>m.preserve_renderer_22===true),preserve1E:messages.length>0&&messages.every(m=>m.preserve_renderer_1e===true),preserve24:messages.length>0&&messages.every(m=>m.preserve_renderer_24===true),preserve25:messages.length>0&&messages.every(m=>m.preserve_renderer_25===true),preserve20:messages.length>0&&messages.every(m=>m.preserve_renderer_20===true),preserve26:messages.length>0&&messages.every(m=>m.preserve_renderer_26===true),preserve21:messages.length>0&&messages.every(m=>m.preserve_renderer_21===true),preserve27:messages.length>0&&messages.every(m=>m.preserve_renderer_27===true),preserve28:messages.length>0&&messages.every(m=>m.preserve_renderer_28===true),preserve29:messages.length>0&&messages.every(m=>m.preserve_renderer_29===true),preserve2A:messages.length>0&&messages.every(m=>m.preserve_renderer_2a===true),preserve2B:messages.length>0&&messages.every(m=>m.preserve_renderer_2b===true),preserveLowerClear:messages.length>0&&messages.every(m=>m.lower_scenery_clear===true)});if(this.world.npcs)this.world.npcs.dictionaryReference=null;
  // A027 selects the unbuffered lower channel. C1FD wraps at 36 characters,
  // including the dictionary's initial space; CR scrolls before the prompt.
  // Proven flat6894 errors publish the selected model descriptor after
  // formatting. Zero is an emitted empty argument, not a missing value.
  // Unprojected messages still revoke it, in their actual output order.
  for(const[i,message]of messages.entries()){
   const text=' '+message.text.toUpperCase();
   const column=((s.lowerCursor??2)-2)/7;
   if(message.lower_scenery_clear&&column===0&&text.length>=36){
    // C271 clears 36 seven-pixel cells from x=1 on the bottom row.
    // The last space is rendered at frame 5D38 in this rejection caller.
    const lastPixel=1+35*7;
    const address=0x50E0+Math.floor(lastPixel/8);
    const shift=lastPixel&7;
    const priorScanHigh=(address>>>8)+6;
    const blank=this.data.spectrum.glyphs[32-this.data.spectrum.first];
    s.scratch[0x5D2C]=shift?incrementFlags(shift-1):incrementFlags(priorScanHigh);
    s.scratch[0x5D2D]=blank[7];
    s.scratch[0x5D2E]=shift;
    s.scratch[0x5D2F]=1;
    s.scratch[0x5D30]=address&255;
    s.scratch[0x5D31]=address>>>8;
   }
   this.lowerText(text+(inline&&i===messages.length-1?'':'\r'));if(this.world.npcs)this.world.npcs.dictionaryReference=Number.isInteger(message.dictionary_reference)&&message.dictionary_reference>=0&&message.dictionary_reference<=65535?message.dictionary_reference:null;}
  this.setChannel(0); // D710/D7CA/CB74 write zero, rather than restoring the incoming channel.
 }
 lexed(tokens){const s=this.state;if(!s)return;s.counter=0;this.wideWindow();s.pending='';if(!s.tokens)return; // D719/C142 reset the formatter and word-buffer pointer.
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
  if(address===0xA025)return s.spacingFlag??null;
  if(address===0xA026)return s.capitalizationFlag??null;
  if(address===0xC128)return s.windowMode??null;
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
 static validate(s){if(s===null||s===undefined)return;if(s.capitalizationFlag!==undefined&&s.capitalizationFlag!==null&&(!Number.isInteger(s.capitalizationFlag)||s.capitalizationFlag<0||s.capitalizationFlag>255))throw Error('Stato delle maiuscole non valido');if(s.wordBuffer?.capitalClasses!==undefined&&(!Array.isArray(s.wordBuffer.capitalClasses)||s.wordBuffer.capitalClasses.length!==128||s.wordBuffer.capitalClasses.some(v=>v!==null&&![-1,0,1].includes(v))))throw Error('Classi del buffer delle maiuscole non valide');if(s.spacingFlag!==undefined&&s.spacingFlag!==null&&(!Number.isInteger(s.spacingFlag)||s.spacingFlag<0||s.spacingFlag>255))throw Error('Stato degli spazi non valido');if(s.windowMode!==undefined&&s.windowMode!==null&&s.windowMode!==0)throw Error('Modo finestra nativo non supportato dal profilo di testo.');if(s.wordBuffer!==undefined&&(!s.wordBuffer||!Number.isInteger(s.wordBuffer.index)||s.wordBuffer.index<0||s.wordBuffer.index>128||!Array.isArray(s.wordBuffer.bytes)||s.wordBuffer.bytes.length!==128||s.wordBuffer.bytes.some(v=>v!==null&&(!Number.isInteger(v)||v<0||v>255))))throw Error('Buffer parola non valido');if(s.printerPaper!==undefined&&(!Array.isArray(s.printerPaper)||s.printerPaper.length>100000||s.printerPaper.some(r=>!Array.isArray(r)||r.length!==256||r.some(v=>!Number.isInteger(v)||v<0||v>255))))throw Error('Carta della stampante non valida');if(s.version!==1||s.profile!=='historical-text-only'||!Array.isArray(s.upper)||s.upper.length!==18||!s.upper.every(v=>typeof v==='string'&&v.length<=36)||!Array.isArray(s.lower)||s.lower.length!==5||!s.lower.every(v=>typeof v==='string'&&v.length<=36)||!Array.isArray(s.lowerKnown)||s.lowerKnown.length!==5||!s.lowerKnown.every(v=>typeof v==='boolean')||typeof s.pending!=='string'||s.pending.length>128||!Array.isArray(s.input)||!s.input.every(v=>Number.isInteger(v)&&v>=0&&v<=255)||!Array.isArray(s.inputKnown)||s.inputKnown.length!==s.input.length||!s.inputKnown.every(v=>typeof v==='boolean')||!Number.isInteger(s.cursor)||s.cursor<0||s.cursor>36||s.remaining!==36-s.cursor||!Number.isInteger(s.counter)||s.counter<0||s.counter>255||!Number.isSafeInteger(s.scrolls)||s.scrolls<0||typeof s.started!=='boolean'||s.lastSpacePrinted!==undefined&&typeof s.lastSpacePrinted!=='boolean'||s.lowerCursor!==undefined&&(!Number.isInteger(s.lowerCursor)||s.lowerCursor<2||s.lowerCursor>254||(s.lowerCursor-2)%7))throw Error('Proiezione video casuale non valida.');}
}
