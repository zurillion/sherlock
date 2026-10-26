// Offline recovery: run the supplied commands in the autonomous JS engine.
// Never import a native machine snapshot or change the random state by hand.
import {readFile,writeFile} from 'node:fs/promises';
import assert from 'node:assert/strict';
import {ClientSession} from '../src/session.mjs';
import {SpectrumTerminal} from '../src/spectrum.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url))),session=new ClientSession(data,{npc_profile:'world-v5',seed:1});
const input=await readFile(new URL('../results/fact-boundary/user-natural-inputs.txt',import.meta.url),'utf8'),commands=input.split('\n').filter(s=>s&&!s.startsWith('#')).slice(0,98),transcript=[];
for(const command of commands){const out=session.request('command',{command});assert.equal(out.state.analysis.outcome,'ok',command+' '+out.state.prototype_notice);transcript.push({kind:'command',text:command},...out.messages);}
const g=session.game,s=g.world.display;assert.equal(g.world.clock().label,'Mon 11:54am');assert.equal(g.world.roomOf(),67);g.history.origin='rebuilt-user-history-before-stall';
const terminal={model:{columns:36,rows:18,lines:[...s.upper],counter:s.counter,scrolls:s.scrolls,cursor:s.cursor,remaining:s.remaining,started:s.started,capitalize:true,lastSpacePrinted:s.lastSpacePrinted??false},lowerHistory:s.lower.slice(0,-1).filter(Boolean).map(x=>x.replace(/^> /,'').slice(0,34)),lowerLine:'',draft:'',clockVisible:true,promptVisible:true,startupPending:false,picture:null,pictureTop:0,pictureNarrow:false,pictureMode:'svg',pictures:false};
SpectrumTerminal.validateSnapshot(terminal);
const presentation={version:1,compatibility:true,spectrum:terminal,transcript:transcript.slice(-200),history:commands,view:[-15,-15,805,675]},result=await session.request('save',{presentation});
const url=new URL('../results/fact-boundary/sherlock-seed1-ripresa-1154.json',import.meta.url);await writeFile(url,JSON.stringify(result.save,null,2)+'\n');console.log(url.pathname,g.world.clock().label,'room',g.world.roomOf());
