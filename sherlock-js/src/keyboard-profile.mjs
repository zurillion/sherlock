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
export function bootstrapWordWorkspace(){const bytes=Array(128).fill(null);bytes[0x5C76-0x5C0B]=0;bytes[0x5C77-0x5C0B]=0;return {bytes,index:0};}
