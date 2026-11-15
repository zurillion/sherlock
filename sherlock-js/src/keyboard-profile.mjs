// ROM 02BF..031D under the declared injected-key oracle protocol. The boot
// RETURN occupies the last empty KSTATE slot (02E2..02EB); game commands
// bypass this scanner. releaseScans is an INPUT-protocol initial condition,
// not a random-state repair and not a model of arbitrary physical timings.
export function bootstrapKeyboard({rawKey=13,decodedKey=13,releaseScans=2,releaseWindow=5,repeatDelay=35,repeatPeriod=5}={}){
 const groups=[[255,0,0,0],[255,0,0,0]],slot=groups.findLast(g=>g[0]&128);slot.splice(0,4,rawKey,releaseWindow,repeatDelay,decodedKey);
 for(let scan=0;scan<releaseScans;scan++)for(const group of groups)if(!(group[0]&128)&&--group[1]===0)group[0]=255;
 return [...groups.flat(),decodedKey,repeatDelay,repeatPeriod];
}

// The declared cold-start/LOAD-USR protocol leaves the ROM RND seed at zero.
// The game uses A037 instead. This ROM field lies in its reused word workspace;
// later character writes may overwrite it, so it is initialized only at boot.
// ROM 127C–1285 also copies the fourteen-byte stream map to 5C10;
// those source-derived bytes survive until the game writes over them.
// Cold-start ROM 11DA–11EF clears tested RAM; streams 4..15 (5C1E–5C35)
// stay zero because this loader never opens another stream. Boot only.
export function bootstrapWordWorkspace({initialStreams=[],basicChannels=null}={}){
 const bytes=Array(128).fill(null);
 const store=(address,values)=>values.forEach((value,i)=>{bytes[address-0x5C0B+i]=value;});
 for(let at=0x5C1E;at<0x5C36;at++)bytes[at-0x5C0B]=0;
 store(0x5C10,initialStreams);
 // The 48K cold start sets CHARS=3C00 and RASP/PIP=0040.
 // The BASIC command loop clears ERR-NR to FF before running the loader.
 store(0x5C36,[0,0x3C,0x40,0,0xFF]);
 // LOAD "" begins with the editor flags 0C. Run mode (12F4),
 // the active output channel (0B74) and USR's numeric path (26C3)
 // set bits 7, 0 and 6 respectively before entry to the game.
 store(0x5C3B,[0x0C|0x80|1|0x40]);
 // ROM 122B sets ERR-SP three bytes below the 48K RAMTOP FF57.
 // LIST-SP remains zero from RAM testing: the loader never lists BASIC.
 const errorStack=0xFF57-3;
 store(0x5C3D,[errorStack&255,errorStack>>>8,0,0,0]);
 // The loader's last ROM output is on stream 2. ROM 1601 leaves its
 // selected channel at CHANS plus the one-based stream offset minus one.
 if(initialStreams.length>=12){
  const streamOffset=initialStreams[10]|initialStreams[11]<<8;
  const channel=(basicChannels?.start??0x5CB6)+streamOffset-1;
  store(0x5C51,[channel&255,channel>>>8]);
 }
 // ROM 1235–124D copies its channel records and terminator, then
 // puts PROG at the next address. Only the boot protocol owns this.
 if(basicChannels){
  const program=basicChannels.start+basicChannels.length;
  store(0x5C53,[program&255,program>>>8]);
  // 1BD1 stores the end of the current BASIC line, which runs LOAD
  // and USR in one line. No subsequent BASIC statement runs in-game.
  if(Number.isInteger(basicChannels.lineSize)){
   const storeWord=(address,value)=>store(address,[value&255,value>>>8]);
   const nextLine=program+basicChannels.lineSize;
   const editLine=nextLine+1; // Variables terminator $80.
   const cursor=editLine+3; // LOAD token plus two quotation marks.
   const work=editLine+5; // LOAD "" followed by CR and $80.
   storeWord(0x5C55,nextLine);
   storeWord(0x5C57,program-1); // 1246: the loader has no DATA.
   storeWord(0x5C59,editLine); // 167C moves the editor after the inserted program.
   storeWord(0x5C5B,cursor);
   storeWord(0x5C5D,nextLine-1); // 26C0 advances after USR's numeric literal.
   if(Number.isInteger(basicChannels.loadHeaderWorkspace))storeWord(0x5C5F,nextLine+basicChannels.lineSize+basicChannels.loadHeaderWorkspace);
   for(const address of [0x5C61,0x5C63,0x5C65])storeWord(address,work);
   if(Number.isInteger(basicChannels.calculatorEntry))store(0x5C67,[basicChannels.calculatorEntry]);
   if(Number.isInteger(basicChannels.calculatorMemory))storeWord(0x5C68,basicChannels.calculatorMemory);
  }
 }
 store(0x5C76,[0,0]);
 return {bytes,index:0};
}
