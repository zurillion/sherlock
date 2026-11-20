import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
const read=async p=>JSON.parse(await readFile(new URL('../'+p,import.meta.url)));
const data=await read('data/game.json');
const make=()=>new Game(data,{npc_profile:'world-v5',seed:1,native_graphics:true});

test('Original last direction descriptor comes from SW, before the cook reads A022',async()=>{
 const proof=await read('results/direction-rejection-reference/natural-writer.json');
 assert.deepEqual(proof.unclassified_transitions,[]);
 assert.equal(proof.handover.original_checkpoint,2004);
 const r=proof.read,w=r.writer;
 assert.deepEqual([r.tick,r.actor,r.value,r.descriptor],[2930,9,39,0x0827]);
 assert.deepEqual([w.tick,w.command,w.pc,w.channel,w.enabled,w.value],[2293,'SW',0xA8B5,1,1,0x0827]);
 assert.equal(make().text.directionRejectionReference(8),r.descriptor);
});

test('Ninety complete native direction refusals select the model word for all playable identities',async()=>{
 const abi=await read('results/direction-rejection-reference/command-abi.json');assert.equal(abi.cases.length,90);
 for(const row of abi.cases){
  const g=make(),w=g.world;w.player=row.player;w.move(row.player,45);
  const node=g.parser.parse(row.command).nodes[0],action=g.action(node);assert.equal(action,row.action,row.command);
  const out=g.executeNode(node),message=out.messages.find(m=>m.kind==='error');
  assert.equal(message.text.trim(),row.text.trim(),row.command);
  assert.equal(message.dictionary_reference,row.descriptor);assert.equal(row.final_descriptor,row.descriptor);
  assert.equal(g.text.directionRejectionReference(action),row.descriptor);
  g.sourceDisplay.error([message]);assert.equal(g.npcRuntime.read(0xA022),row.descriptor&255);assert.equal(g.npcRuntime.read(0xA023),row.descriptor>>8);
 }
});

test('The descriptor is selected from available no-argument model data, never from a captured constant',()=>{
 const g=make(),copy=structuredClone(data);g.text.data=copy;
 const model=copy.actions.find(a=>a.id===8);model.wordReferences[0]=0xF123;
 assert.equal(g.text.directionRejectionReference(8),0x0123);
 model.wordReferences[0]=0;assert.equal(g.text.directionRejectionReference(8),0);
 delete model.wordReferences;assert.equal(g.text.directionRejectionReference(8),null);
 model.wordReferences=[0x0827];model.modelFlags[0]|=4;assert.equal(g.text.directionRejectionReference(8),null);
 for(const id of [0,11,35,undefined])assert.equal(g.text.directionRejectionReference(id),null);
});

test('NPC movement does not borrow the ordinary direction descriptor',()=>{
 const g=make();g.world.move(3,45);g.actingActor=3;
 const node=g.parser.parse('SW').nodes[0],out=g.executeNode(node);
 assert.equal(out.messages[0].dictionary_reference,undefined);
});

test('WEAR scan B has an independent original last writer and is not a default one',async()=>{
 const proof=await read('results/direction-rejection-reference/wear-count-writer.json');
 assert.deepEqual(proof.unclassified_transitions,[]);assert(proof.handover.clock_room_video_counter_and_mode_match);
 const r=proof.reads.at(-1),w=r.writer;
 assert.deepEqual([r.address,r.tick,r.actor,r.value],['5D23',2998,31,1]);
 assert.deepEqual([w.pc,w.tick,w.glyph.frame,w.glyph.character,w.registers[2]],[0xC3B7,2286,0x5D2C,115,1]);
});
