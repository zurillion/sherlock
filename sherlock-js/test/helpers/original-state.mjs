import assert from 'node:assert/strict';
import {createHash} from 'node:crypto';
import {RecordLists} from '../../src/record-arena.mjs';
import {encodeMoney} from '../../src/cab-economy.mjs';
function bytes(g,from,to){const b=[];for(let y=from;y<to;y++)for(let x=0;x<32;x++)b.push(g.sourceDisplay.read(0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x));return b;}
export function assertOriginalState(g,e,label){const w=g.world,r=RecordLists.load(w.npcs.records);
 if(e.mutable?.A019!==undefined)assert.equal(w.display.counter,e.mutable.A019,label+' cumulative MORE counter');
 assert.equal(w.player,e.player,label+' identity');assert.deepEqual(w.clock(),e.clock,label+' clock');assert.equal(w.npcs.playerFailures,e.player_failures,label+' failure budget');
 for(const row of e.actors){const a=w.scheduler.actor(row.id),state=a===w.scheduler.actors[0]?{pc:w.npcs.playerProgramCounter,saved:w.npcs.playerRootSaved}:w.npcs.program.states[row.id];assert.equal(a.due,row.due,label+' due '+row.id);assert.equal(state.pc,row.pc,label+' PC '+row.id);assert.deepEqual(state.saved,row.saved,label+' arguments '+row.id);}
 for(const e0 of e.entities)for(const k of ['parent','rooms','attributes','status','properties','noun','qualifiers','description']){if(k==='qualifiers'&&w.entity(e0.id).money){assert.deepEqual([encodeMoney(w.entity(e0.id).pence),w.entity(e0.id).qualifiers[1]],e0.qualifiers,label+' money '+e0.id);continue;}assert.deepEqual(w.entity(e0.id)[k],k==='description'&&e0[k]==='0000'?null:e0[k],label+' entity '+e0.id+' '+k);}
 assert.deepEqual(w.rooms.map(r=>r.flags),e.rooms,label+' room flags');assert.deepEqual([...r.arena.bytes],e.arena,label+' complete arena');assert.equal(r.arena.freeHead,e.free_head,label+' free head');
 for(const[name,size]of Object.entries({counters:2,signals:2,contexts:7,requests:8,syntax:30,parsed:30}))assert.deepEqual(r.records(name).map(p=>({pointer:p,values:Array.from({length:size},(_,i)=>r.arena.byte(p+i))})),e.records[name],label+' '+name);
 assert.deepEqual(w.npcs.facts.map(f=>[f.subject,f.predicate,f.object,f.flags,f.handler&255,f.handler>>>8,...f.terms.flatMap(n=>[n&255,n>>>8])]),e.facts,label+' facts');
 assert.deepEqual({seed:w.random.seed,cursor:w.random.cursor},e.random_state,label+' RNG successor');assert.deepEqual(w.display.input,e.input,label+' editor');assert.deepEqual(w.display.tokens,e.tokens,label+' tokens');assert.deepEqual(bytes(g,152,192),e.lower_bitmap,label+' lower bitmap');assert.equal(createHash('sha256').update(Uint8Array.from(bytes(g,0,144))).digest('hex'),e.upper_sha256,label+' upper bitmap');
 for(const[at,v]of Object.entries(e.working_cells)){const a=parseInt(at,16);if(a in w.display.scratch)assert.equal(g.sourceDisplay.read(a),v,label+' owned field '+at);}
}
