// Offline original ABI comparison; the browser imports neither this report nor the snapshots.
import {readFile,writeFile} from 'node:fs/promises';
import assert from 'node:assert/strict';
import {Game} from '../src/game.mjs';
const read=async p=>JSON.parse(await readFile(new URL('../'+p,import.meta.url)));
const data=await read('data/game.json'),abi=await read('results/full-arrival-exits/formatter-abi.json');
const g=new Game(data,{npc_profile:'world-v5',seed:1,native_graphics:true}),p=g.sourceDisplay;
const counts={scanC:0,clearF:0,unknown:0},shifts=new Set();
for(const row of abi.cases){
 g.world.move(0,row.room);const roles=[],whole=g.text.scene({source:'arrival',full:true,mark:false,trace:roles});
 const start=whole.indexOf('Visible exits are '),end=start<0?-1:whole.indexOf('.',start)+1;
 const text=start<0?'':' '+whole.slice(start,end);
 const trace=start<0?[]:roles.filter(e=>e.start>=start&&e.end<=end).map(e=>({...e,start:e.start-start+1,end:e.end-start+1}));
 assert.equal(row.text.trim(),text.trim());
 Object.assign(p.state,{scratch:{},cursor:row.column,remaining:36-row.column,counter:row.counter,windowMode:0,pending:'',spacingFlag:row.column?1:0,started:row.column>0,upper:Array(18).fill('')});
 p.scene(text,trace);p.feed('\n');
 for(const at of [0x5D1E,0x5D24]){
  const value=p.read(at);if(value===null){counts.unknown++;continue;}
  assert.equal(value,row.cells[at],JSON.stringify({room:row.room,column:row.column,counter:row.counter,at}));
  if(at===0x5D1E){counts.scanC++;shifts.add(value);}else counts.clearF++;
 }
}
const report={setups:abi.cases.length,known_fields_compared:counts,observed_scan_shifts:[...shifts].sort(),mismatches:0,scope:'D68C/SP5D5E plus final CR A9B7/SP5D5C; ordinary player0, root, full arrival, no listed room contents, one/two ungated exits. Wide native picture window, counter+6<15 at each owned glyph. Other fields and excluded geometries remain unknown.'};
await writeFile(new URL('../results/full-arrival-exits/verification.json',import.meta.url),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify(report));
