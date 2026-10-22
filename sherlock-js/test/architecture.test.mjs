import test from 'node:test';
import assert from 'node:assert/strict';
import {readdir,readFile} from 'node:fs/promises';

test('The playable bundle has no CPU, original binary or backend dependency',async()=>{
 const root=new URL('../',import.meta.url),runtime=await readdir(new URL('src/',root));
 for(const name of runtime){const source=await readFile(new URL('src/'+name,root),'utf8');
  assert(!/\b(?:child_process|skoolkit|NativeWorld|SherlockParser|WebAssembly|new\s+Worker)\b/.test(source),name);
  assert(!/fetch\([^)]*(?:api\/|\.bin|\.z80|\.tap|\.tzx)/i.test(source),name);
  const imports=[...source.matchAll(/(?:from\s+|import\s*)['"]([^'"]+)['"]/g)].map(m=>m[1]);assert(imports.every(p=>p.startsWith('./')),name+' runtime imports');
 }
 const assets=await readdir(new URL('data/',root));assert.deepEqual(assets,['game.json']);
 const data=JSON.parse(await readFile(new URL('data/game.json',root),'utf8'));assert(!('memory' in data)&&!('registers' in data)&&!('rom' in data));
 assert.equal(data.entities.length,110);assert.equal(data.rooms.length,106);assert.equal(data.dictionary.length,592);
});
