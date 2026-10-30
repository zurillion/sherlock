import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Transcript} from '../src/transcript.mjs';
import {ClientSession} from '../src/session.mjs';
import {capturePresentation} from '../src/tab-session.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url)));
test('Text transcript includes only executed player inputs, optionally and uppercase',()=>{
 const session=new ClientSession(data,{npc_profile:'world-v5',seed:1}),log=new Transcript();
 log.message({kind:'narrative',text:session.game.opening});
 for(const command of ['nonsense','OPEN DOOR','YOUR','i']){
  const entry=log.begin(command),out=session.request('command',{command});
  for(const message of out.messages)log.message(message);
  log.finish(entry,out.state.analysis);
 }
 const text=log.text({includeCommands:true});
 assert(!text.includes('> NONSENSE'));assert(!text.includes('> OPEN DOOR'));
 assert(text.includes('> YOUR\n'));assert(text.includes('> I\n'));assert(text.includes('You open your door.'));
 assert(!log.text().includes('> '));assert(log.text().includes('Good morning Holmes.'));
});
test('Rollback and NPC-only activity cannot qualify an input',()=>{
 const log=new Transcript(),a=log.begin('north');log.finish(a,{outcome:'not_translated',actions:[{actor:0}]});
 const b=log.begin('hello');log.finish(b,{outcome:'ok',actions:[{actor:3}]});
 assert.equal(log.text({includeCommands:true}),'');
});
test('Full text survives presentation capture and JSON roundtrip past 200 entries',()=>{
 const log=new Transcript();for(let i=0;i<650;i++)log.message({kind:'narrative',text:'Line '+i});
 const terminal={active:false,snapshot:()=>({})};
 const p=capturePresentation(terminal,{transcript:[],history:[],view:[0,0,1,1],textTranscript:log.dump()});
 const restored=Transcript.fromPresentation(JSON.parse(JSON.stringify(p)));
 assert.equal(restored.text(),log.text());assert(restored.text().includes('Line 0\n'));assert(restored.text().includes('Line 649\n'));
});
test('Legacy presentations recover available output without inventing accepted commands',()=>{
 const log=Transcript.fromPresentation({transcript:[{kind:'command',text:'LOOK'},{kind:'narrative',text:'Your room.'}]});
 assert.equal(log.text({includeCommands:true}),'Your room.\n');
 assert.throws(()=>new Transcript([{kind:'command',text:'I'}]),/Trascrizione/);
});
