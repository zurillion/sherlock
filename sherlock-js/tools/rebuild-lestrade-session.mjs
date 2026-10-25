// Reconstruct the submitted playthrough using only the autonomous engine.
// The save stops BEFORE the three originally cancelled I commands at 11:42.
import {readFile,writeFile} from 'node:fs/promises';
import assert from 'node:assert/strict';
import {ClientSession} from '../src/session.mjs';
import {SpectrumBuffer,SpectrumTerminal,spectrumWrap} from '../src/spectrum.mjs';
const root=new URL('../',import.meta.url),data=JSON.parse(await readFile(new URL('data/game.json',root))),s=new ClientSession(data,{npc_profile:'world-v5',seed:1});
const screen=new SpectrumBuffer(),transcript=[],commands=[],lowerHistory=[];
function deliver(events){for(const e of events||[]){if(e.op==='counter')screen.counter=e.value;else if(e.op==='wide')screen.setColumns(36);else if(e.op==='word')for(const op of screen.packet(e))if(op==='line')while(!screen.newline())screen.more();}}
deliver(s.state().opening_screen);let count=0;
for(const line of(await readFile(new URL('results/lestrade/user-history.txt',root),'utf8')).split('\n')){
 if(!line||line.startsWith('#')&&!line.startsWith('# Teletrasporto'))continue;
 let out;if(line.startsWith('#'))out=s.request('teleport',{room:Number(line.match(/\d+/)[0])});
 else{commands.push(line);transcript.push({kind:'command',text:line});lowerHistory.push(...spectrumWrap(line.toUpperCase(),34));out=s.request('command',{command:line});}
 assert.notEqual(out.state.analysis?.outcome,'not_translated',line+' '+out.state.prototype_notice);
 for(const m of out.messages){transcript.push(m);deliver(m.screen_events);if(m.kind==='error')lowerHistory.push(...spectrumWrap(m.text.toUpperCase(),34));}
 if(++count===138)break;
}
assert.equal(s.state().clock.label,'Mon 11:42am');assert.equal(s.state().room,63);
const model={};for(const key of ['columns','rows','lines','counter','scrolls','cursor','remaining','started','capitalize','lastSpacePrinted'])model[key]=structuredClone(screen[key]);
const spectrum={model,lowerHistory:lowerHistory.slice(-40),lowerLine:'',draft:'',clockVisible:true,promptVisible:true,startupPending:false,picture:null,pictureTop:0,pictureNarrow:false,pictureMode:'svg',pictures:true};SpectrumTerminal.validateSnapshot(spectrum);
s.game.history.origin='reconstructed-from-submitted-history';
const presentation={version:1,compatibility:true,transcript:transcript.slice(-200),history:commands.slice(-200),view:[-15,-15,805,675],spectrum};
const save=(await s.request('save',{presentation})).save,path=new URL('results/lestrade/sherlock-seed1-1142-restored.json',root);await writeFile(path,JSON.stringify(save,null,2)+'\n');
const loaded=new ClientSession(data);await loaded.request('load',{save:JSON.parse(JSON.stringify(save))});
for(const command of ['I','I','I']){assert.deepEqual(loaded.request('command',{command}),s.request('command',{command}));assert.equal(s.state().analysis.outcome,'ok');}
assert.equal(s.state().clock.label,'Mon 11:45am');
console.log('Rebuilt 138 submitted events; save at Mon 11:42am, room 63. The next three I commands succeed identically after load.');
