import test from 'node:test';import assert from 'node:assert/strict';import {readFile} from 'node:fs/promises';import {RecordArena,RecordLists} from '../src/record-arena.mjs';
const ref=JSON.parse(await readFile(new URL('./fixtures/record-arena.json',import.meta.url),'utf8'));
test('All bytes, allocation pointers and free heads match 140 original operations',()=>{
 let a=new RecordArena({base:ref.base,length:ref.length});const records=new Map();
 for(const [i,r] of ref.operations.entries()){
  if(r.op==='allocate'){const p=a.allocate(r.size);assert.equal(p,r.pointer,'allocation '+i);records.set(r.id,p);r.values.forEach((v,n)=>a.putByte(p+n,v));}else a.release(records.get(r.id));
  assert.equal(a.freeHead,r.free_head,'free head '+i);assert.deepEqual([...a.bytes],r.bytes,'bytes '+i);
  if(i===70)a=RecordArena.load(JSON.parse(JSON.stringify(a.dump())));
 }
});
for(const [i,r] of ref.context_returns.entries())test('Original context-return metadata and record release: '+i,()=>{
 const store=new RecordLists(new RecordArena({base:ref.base,length:ref.length}));
 for(const op of r.insertions)assert.equal(store.prepend(op.list,op.values),op.pointer);
 const record=store.records('contexts').find(p=>store.arena.byte(p)===3),prev=store.remove('contexts',record),outer=store.records('contexts').find(p=>store.arena.byte(p)===3);
 const saved=outer?[store.arena.byte(outer+6),store.arena.byte(outer+3),store.arena.byte(outer+4)]:store.returnSaved(prev);
 assert.deepEqual(saved,r.saved);assert.equal(store.heads.contexts,r.remaining_context_head);assert.deepEqual([...store.arena.bytes],r.bytes);
 const restored=RecordLists.load(JSON.parse(JSON.stringify(store.dump())));assert.deepEqual(restored.dump(),store.dump());
});
