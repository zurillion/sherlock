import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Game} from '../src/game.mjs';
import {World} from '../src/world.mjs';
import {Dictionary,Lexer,InputError} from '../src/lexer.mjs';
import {Text} from '../src/text.mjs';
import {Conversation} from '../src/conversation.mjs';
import {OriginalRandom} from '../src/random.mjs';
import {encodeMoney,formatMoney} from '../src/cab-economy.mjs';
const read=async path=>JSON.parse(await readFile(new URL(path,import.meta.url),'utf8'));
const data=await read('../data/game.json'),reference=await read('./fixtures/conversation-reference.json');
const periods=await read('./fixtures/number-periods-reference.json');
const norm=s=>s.replace(/\s*"\s*/g,'"').replace(/\s+/g,' ').trim().toUpperCase();
const prose=s=>s.replace(/\s*"\s*/g,'"').replace(/\s+/g,' ').trim();
test('Native numeric suffix/delimiter boundaries, including consumed periods (16 cases)',()=>{
 const lexer=new Lexer(new Dictionary(data.dictionary));
 for(const row of periods.cases){assert.equal(row.status,'returned');
  if(row.type==='D0')assert.throws(()=>lexer.scan(row.input),e=>e instanceof InputError&&e.kind==='lexical_error',row.input);
  else{const token=lexer.scan(row.input).tokens[0];assert.equal(token.type,parseInt(row.type,16),row.input);assert.equal(token.value,parseInt(row.offset,16),row.input);assert.equal(token.end,parseInt(row.next_input,16)-0x5B00,row.input);}
 }
});

test('Original TELL actor/topic table, generated selector context and supplied native random inputs (90 bodies)',()=>{
 for(const row of reference.bodies){
  const world=new World(data);let index=0;
  const text=new Text(data,new Dictionary(data.dictionary),world,{chooseIndex:(count,ctx)=>{
   const c=row.random[index++];assert(c);assert.equal(count-1,c.width);assert.equal(ctx.mixOffset,c.mixOffset);
   const random=new OriginalRandom({seed:c.seed,cursor:c.cursor});let read=0;
   const result=random.chooseIndex(count,{mixOffset:ctx.mixOffset,inputs:({cursor,mixOffset})=>{
    const first=c.reads[read++],second=c.reads[read++];assert.equal(first.address,cursor);assert.equal(second.address,(cursor+mixOffset+1)&65535);return {first:first.value,second:second.value};
   }});
   assert.deepEqual(random.dump(),{seed:c.next_seed,cursor:c.next_cursor});assert.equal(read,c.reads.length);return result;
  }});
  const actual=new Conversation(data,text).tell(row.actor,row.recipient,row.topic);
  assert.equal(prose(actual),prose(row.text),JSON.stringify({actor:row.actor,topic:row.topic}));assert.equal(index,row.random.length);
 }
 // Supplied native inputs certify the selector context and question body.
 // They do not certify a generated entropy source or whole-game sequences.
});
for(const label of ['payments','payment_literals','payment_funds'])test('Native player and delayed Watson PAY: '+label,()=>{
 const g=new Game(data);
 for(const row of reference.requests.find(r=>r.label===label).commands){
  const actual=g.submit(row.input);assert.equal(actual.state.analysis.outcome==='not_translated',false);
  for(const kind of ['narrative','error'])assert.equal(norm(actual.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),norm(row.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),row.input);
  assert.deepEqual(g.world.clock(),row.clock);assert.equal(g.world.scheduler.actor(3).due,row.watson_due);
  for(const [id,bytes] of Object.entries(row.money)){const value=encodeMoney(g.world.entity(Number(id)).pence);assert.deepEqual([value&255,value>>>8],bytes);}
 }
});
test('Original cab account payments, driver turns disabled in both compared profiles',()=>{
 const g=new Game(data,{npcs:false});g.teleport(5);
 for(const row of reference.requests.find(r=>r.label==='cab_player_payments_no_driver_turns').commands){const out=g.submit(row.input);
  for(const kind of ['narrative','error'])assert.equal(prose(out.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),prose(row.messages.filter(m=>m.kind===kind).map(m=>m.text).join(' ')),row.input);
  assert.deepEqual(g.world.clock(),row.clock);for(const [id,bytes] of Object.entries(row.money)){const value=encodeMoney(g.world.entity(Number(id)).pence);assert.deepEqual([value&255,value>>>8],bytes);}
 }
});
test('PAY validates currency and person classes without spending time',()=>{
 const g=new Game(data),before=g.world.dump();
 for(const command of ['PAY TO WATSON','PAY LAMP TO WATSON','PAY 1/- TO LAMP','PAY 8:30 TO WATSON']){
  const out=g.submit(command);assert.equal(out.messages[0].text,"DON'T BE SILLY.");assert.deepEqual(g.world.dump(),before);
 }
});
test('A payment and a pending quoted payment survive a logical save/load',()=>{
 const a=new Game(data);a.teleport(5);a.submit('HAIL CAB');a.submit('PAY 1/- TO CABBIE');
 assert.equal(a.world.entity(32).pence,12);assert.equal(a.world.entity(27).pence,1236);
 const b=Game.load(data,JSON.parse(JSON.stringify(a.dump())));
 for(const c of ['PAY 2/6 TO CABBIE','COUNT MONEY']){assert.deepEqual(a.submit(c),b.submit(c));assert.deepEqual(a.dump(),b.dump());}
 const c=new Game(data);c.submit('SAY TO WATSON "WAIT"');c.submit('SAY TO WATSON "PAY 1/- TO ME"');const d=Game.load(data,JSON.parse(JSON.stringify(c.dump())));assert.deepEqual(c.submit('WAIT'),d.submit('WAIT'));
});
test('Money display preserves period and whole-pound conventions',()=>{
 for(const [pence,text] of [[0,'0d.'],[1,'1d.'],[6,'6d.'],[12,'1/-'],[240,'£1'],[246,'£1 6d.'],[252,'£1 1/-'],[16383,'£68 5/3']])assert.equal(formatMoney(pence),text);
});
test('TELL never chooses a substitute says/remarks prefix in the playable engine',()=>{
 const g=new Game(data),before=g.world.dump();for(const input of ['TELL WATSON ABOUT LESTRADE','SAY TO WATSON "TELL ME ABOUT LESTRADE"']){
  const out=g.submit(input);assert.equal(out.state.analysis.outcome,'not_translated');assert(out.messages.every(m=>m.kind==='system'));assert.deepEqual(g.world.dump(),before);
 }
});
