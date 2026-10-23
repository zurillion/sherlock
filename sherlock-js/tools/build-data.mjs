// Offline asset extraction only. No simulator, Z80 execution or save snapshot.
import {readFile,writeFile,mkdir,copyFile,readdir} from 'node:fs/promises';
import {resolve,dirname,join} from 'node:path';
import {fileURLToPath} from 'node:url';
import {createHash} from 'node:crypto';
const target=resolve(dirname(fileURLToPath(import.meta.url)),'..');
const project=process.argv.includes('--project')?resolve(process.argv[process.argv.indexOf('--project')+1]):resolve(target,'..');
const analysis=join(project,'sherlock-analisi'),read=async path=>JSON.parse(await readFile(join(analysis,path),'utf8'));
const payload=await readFile(join(analysis,'block-10.bin'));
const sha=createHash('sha256').update(payload).digest('hex');
if(sha!=='c5d48285c0cee5c25cf4734dff0ac8296c0ec0194135e3a72267e49724ac8407')throw Error('Unrecognized source data version');
const byte=p=>payload[p-0x5d80],word=p=>byte(p)|(byte(p+1)<<8);
const dictionary=(await read('parser/results/dictionary.json')).map(w=>({id:parseInt(w.offset,16),stem:w.stem,form:w.output_inflected,type:parseInt(w.class,16),alias:w.alias_direct?parseInt(w.alias_direct,16):null}));
const catalog=await read('locazioni/results/locations.json');
const ruleNames={E40A:'enterContainer',E432:'leaveContainer',DE9D:'openOrdinary',DEAF:'closeOrdinary',DF7E:'takeBurningNote',DFA7:'openSafe'};
const entities=catalog.entities.map(e=>({id:e.id,name:e.name,noun:parseInt(e.name_words_raw[0],16),qualifiers:[e.money_flag?0:parseInt(e.name_words_raw[1],16),parseInt(e.name_words_raw[2],16)],parent:e.parent_id,rooms:e.locations.map(r=>r.id),size:e.field_02,weight:e.field_03,properties:e.field_04,attributes:parseInt(e.flags_05,16),status:parseInt(e.flags_06,16),person:e.person_flag,money:e.money_flag,pence:e.money_pence,description:e.description_pointer==='0000'?null:e.description_pointer,rules:e.rules.filter(r=>r.action_id).map(r=>({action:r.action_id,rule:ruleNames[r.rule_pointer]||'untranslated:'+r.rule_pointer}))}));
const rooms=catalog.rooms.map(r=>({id:r.id,name:r.name_hint,flags:r.flags,nameWords:[word(parseInt(r.record,16)+1),word(parseInt(r.record,16)+3),word(parseInt(r.record,16)+5)],description:r.description,coordinates:r.coordinates,exits:r.exits.map(e=>({source:e.source,target:e.target,direction:e.direction,direction_id:e.direction_id,gate:e.gate,gate_name:e.gate_name}))}));
const actions=(await read('locazioni/results/gameplay-action-inventory.json')).models.map(a=>({id:a.id,words:a.words,rule:a.general_rule}));
// Decode the *data language* used for compressed prose into a semantic AST.
// The packaged game contains this JSON, never the original binary or CPU code.
const frequent=Array.from({length:32},(_,i)=>word(0x67b7+2*i));
function packed(p,count){let bits='';for(let n=0;n<Math.ceil(count*5/8);n++)bits+=byte(p+n).toString(2).padStart(8,'0');return Array.from({length:count},(_,i)=>String.fromCharCode(96+parseInt(bits.slice(i*5,i*5+5),2))).join('');}
const commands=['nameArgument','wordArgument','jump','wordSubject','nameArgument','relationArgument','actorName','objectName','backspace','otherName','choice','call','actorPossessive','newline','objectPossessive','time','actorIs','objectIs','repeat','argumentIs','time','time','time','time','compose','textArgument','jumpArgument','toggleUpper','noop','endLine','endSentence','end'];
function token(p){
 const b=byte(p);if(b>=128){const context=b&112,id=((b&15)<<8)|byte(p+1);return [{op:'word',id,form:context===80?'stem':context===64?'inflected':context===16?'object':'actor',capitalized:context===112,end:context===32?'end':context===48?'sentence':context===96?'line':null},p+2,[32,48,96].includes(context)];}
 if(b>=96)return [{op:'word',id:frequent[b-96],form:'stem'},p+1,false];
 if(b>=64)return [{op:'literal',text:packed(p+1,(b&31)+1)},p+1+Math.ceil(((b&31)+1)*5/8),false];
 if(b>=32)return [{op:'literal',text:String.fromCharCode(b)},p+1,false];
 if(b===2||b===11)return [{op:b===2?'jump':'call',text:((p+word(p+1))&65535).toString(16).toUpperCase()},p+3,b===2];
 if(b===10){const options=[];let q=p+2;for(let n=0;n<byte(p+1);n++){const [t,end]=token(q);options.push(t);q=end;}return [{op:'choice',options},q,false];}
 if([15,20,21,22,23].includes(b)){const [t,end]=token(p+1);return [{op:'time',value:({15:5,20:4,21:3,22:2,23:1})[b],token:t},end,false];}
 return [{op:commands[b]},p+1,[26,29,30,31].includes(b)];
}
const texts={};let p=0x67f7;
while(p<0x8258){const start=p,events=[];for(let n=0;n<4096;n++){const [t,end,terminal]=token(p);events.push(t);p=end;if(terminal)break;}if(p<=start||p>0x8258)throw Error('Invalid compressed data boundary');texts[start.toString(16).toUpperCase()]=events;}
// Calls may enter a suffix of a fragment. Materialize only referenced entries.
function ensure(id){if(texts[id])return;let p=parseInt(id,16),events=[];if(p<0x67f7||p>=0x8258)throw Error('Text reference out of range');for(let n=0;n<4096;n++){const [t,end,last]=token(p);events.push(t);p=end;if(last)break;}texts[id]=events;}
for(let pass=0;pass<8;pass++)for(const events of Object.values(texts))for(const t of events)if(t.op==='call'||t.op==='jump')ensure(t.text);
for(const r of rooms)if(r.description)ensure(r.description);
for(const e of entities)if(e.description)ensure(e.description);
const assets=await read('locazioni/spectrum-assets.json');
const data={version:1,source_sha256:sha,dictionary,rooms,entities,actions,texts,spectrum:assets,pictures:{}};
await mkdir(join(target,'data'),{recursive:true});await mkdir(join(target,'images'),{recursive:true});
for(const name of await readdir(join(analysis,'grafica/immagini')))if(/^\d{3}.*-straight\.svg$/.test(name)){const id=Number(name.slice(0,3)),route=`images/${String(id).padStart(3,'0')}.svg`;await copyFile(join(analysis,'grafica/immagini',name),join(target,route));data.pictures[id]=route;}
await writeFile(join(target,'data/game.json'),JSON.stringify(data)+'\n');
await mkdir(join(target,'test/fixtures'),{recursive:true});
for(const [source,name] of [['parser/results/commands.json','parser.json'],['parser/results/lookup-checks.json','lookup.json'],['parser/results/literals-and-boundary.json','literals.json'],['parser/results-special/special-cases.json','special.json']])await writeFile(join(target,'test/fixtures',name),JSON.stringify(await read(source))+'\n');
console.log(`Extracted data: ${dictionary.length} words, ${rooms.length} rooms, ${entities.length} entities, ${Object.keys(texts).length} text entries. No Z80 executable packaged.`);
