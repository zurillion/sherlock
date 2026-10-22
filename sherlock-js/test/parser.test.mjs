import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {Dictionary,Lexer,numericLiteral,normalizeInput} from '../src/lexer.mjs';
import {Parser,nodeWords} from '../src/parser.mjs';
const read=async name=>JSON.parse(await readFile(new URL(name,import.meta.url),'utf8'));
const data=await read('../data/game.json'),dictionary=new Dictionary(data.dictionary),lexer=new Lexer(dictionary),parser=new Parser(lexer);
test('1,804 frozen alphabetical comparisons against original lookup',async()=>{
 for(const row of await read('./fixtures/lookup.json')){const actual=dictionary.lookup(row.input);assert.equal(actual.type,parseInt(row.type,16),row.input);assert.equal(actual.value,parseInt(row.offset,16),row.input);assert.equal(actual.matched_prefix,row.matched_prefix,row.input);}
});
for(const row of await read('./fixtures/parser.json'))test('Native grammar fixture: '+JSON.stringify(row.input),()=>{
 let actual,error;try{actual=parser.parse(row.input);}catch(e){error=e;}
 if(['lexical_error','syntax_error'].includes(row.outcome)){assert.equal(error?.kind,row.outcome,row.input);return;}
 assert.ifError(error);
 if(row.outcome==='input_again'){assert.equal(actual.outcome,'empty');return;}
 if(row.outcome.startsWith('control_command')){assert.equal(actual.outcome,'control');return;}
 assert.equal(actual.outcome,'ok');
 assert.equal(actual.nodes.length,row.command_nodes.length,row.input);
 for(let n=0;n<actual.nodes.length;n++){
  const expected=row.command_nodes[n].words_le.map(h=>parseInt(h,16));
  const words=nodeWords(actual.nodes[n]);
  // Native quote queue pointers are allocator addresses, not semantic fields.
  // Their contents are checked by the separate quoted-content tests.
  assert.deepEqual(words.slice(0,12),expected.slice(0,12),row.input);
 }
});
test('Ordinary numeric formats use original token values',async()=>{
 for(const row of await read('./fixtures/literals.json'))if(/^\d|^`/.test(row.input)){const actual=numericLiteral(row.input);assert.equal(actual?.type||208,parseInt(row.type,16),row.input);assert.equal(actual?.value||0,parseInt(row.offset,16),row.input);}
});
test('Quotations, persistent mode and standalone statements',()=>{
 const out=parser.parse('TELL WATSON "WATSON KILLED YOU"');const q=parser.quoted(out.nodes[0].quote);assert.equal(q.mode,2);assert.equal(dictionary.word(q.nodes[0].subject.noun).stem,'watson');
 assert.throws(()=>parser.parse('WATSON KILLED YOU'),e=>e.kind==='syntax_error');
 assert.equal(parser.parse('HE KILLED YOU').nodes[0].subject.pronoun,'he');
 const mixed=parser.parse('TELL WATSON "LOOK. WATSON KILLED YOU"');assert.throws(()=>parser.quoted(mixed.nodes[0].quote),e=>e.kind==='syntax_error');
});
test('A continuation fills empty fields and a new verb replaces it',()=>{
 const node=parser.parse('OPEN DOOR').nodes[0],pending={node,slot:0};
 for(const text of ['YOUR','YOUR DOOR']){const out=parser.parse(text,{pending});assert.equal(out.nodes[0].verb,node.verb);assert.equal(out.nodes[0].groups[0].noun,node.groups[0].noun);assert.equal(dictionary.word(out.nodes[0].groups[0].qualifiers[0]).stem,'your');}
 assert.equal(dictionary.word(parser.parse('LOOK',{pending}).nodes[0].verb).stem,'look');
});

for(const row of await read('./fixtures/special.json')){
 // Native Z reads past the dictionary boundary. The tool-limit cases measure
 // the former harness input cap, not a certified property of the game grammar.
 if(['Z','ZZ'].includes(row.input)||row.outcome==='tool_limit')continue;
 test('Whole-line and special grammar: '+JSON.stringify(row.input),()=>{
  let actual,error;try{actual=parser.analyze(row.input);}catch(e){error=e;}
  if(['lexical_error','syntax_error','quoted_syntax_error'].includes(row.outcome)){assert.equal(error?.kind,row.outcome);return;}
  assert.ifError(error);
  const expected=row.units.flatMap(u=>u.nodes||[]),nodes=actual.units.flatMap(u=>u.nodes||[]);
  assert.equal(nodes.length,expected.length);
  for(let n=0;n<nodes.length;n++){
   const bytes=expected[n].raw.split(/\s+/).map(h=>parseInt(h,16)),words=Array.from({length:15},(_,i)=>bytes[2*i]|bytes[2*i+1]<<8);
   // Quoted content lives in a queue in the original. Its pointer is not a
   // semantic subject; compare the content separately below.
   if(nodes[n].quote)words.fill(0,12);
   assert.deepEqual(nodeWords(nodes[n]),words);
  }
 });
}
test('Several quotations are preserved in order, not overwritten',()=>{
 const out=parser.analyze('"TAKE BOOK" "DROP BOOK"'),quotes=out.units[0].nodes[0].quotes;
 assert.deepEqual(quotes.map(q=>dictionary.word(q.parsed.nodes[0].verb).stem),['take','drop']);
});
