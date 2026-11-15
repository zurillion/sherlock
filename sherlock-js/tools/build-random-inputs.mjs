// Offline extraction of immutable VALUES consulted by the original generator.
// These values are entropy data, never dispatched as instructions by the game.
import {readFile,readdir} from 'node:fs/promises';
import {join} from 'node:path';
import {createHash} from 'node:crypto';
export async function buildRandomInputs(project,payload,npcPrograms){
 const base=0x5D80,byte=a=>payload[a-base],hash=b=>createHash('sha256').update(b).digest('hex');
 const firmware=await readFile(join(project,'skoolkit-10.1/skoolkit/resources/48.rom'));
 if(firmware.length!==16384||hash(firmware)!=='d55daa439b673b0e3f5897f99ac37ecb45f974d1862b4dadb85dec34af99cb42')throw Error('Unexpected immutable random-input firmware');
 const code=new Map(),written=new Set(),sources=[];
 async function visit(dir){for(const e of await readdir(dir,{withFileTypes:true})){const path=join(dir,e.name);if(e.isDirectory())await visit(path);else if(e.name.endsWith('.asm'))sources.push(path);}}
 await visit(join(project,'sherlock-analisi'));
 for(const path of sources){const text=await readFile(path,'utf8');for(const line of text.split('\n')){
  const match=line.match(/^\s*([^;]+?)\s*;\s*\$([\dA-F]{4})\s+(?:(?:Z80|CODE|DATA|HEADER|BYTECODE)\s+)?([\dA-F]{2}(?:\s+[\dA-F]{2})*)/i);
  if(!match)continue;const op=match[1].trim().toUpperCase(),at=parseInt(match[2],16),bytes=match[3].trim().split(/\s+/).map(v=>parseInt(v,16));
  if(/^(?:DEFB|DEFW|DEFM|DB\b|DW\b|ORG\b)/.test(op))continue;
  if(bytes.some((b,i)=>b!==byte(at+i)))throw Error('Source listing differs from payload: '+path+' '+match[2]);
  for(const [i,b] of bytes.entries())code.set(at+i,b);
  const store=op.match(/^LD \(\$([\dA-F]{4})\),(.+)$/);
  if(store){const target=parseInt(store[1],16),size=/^(?:BC|DE|HL|SP|IX|IY)$/.test(store[2])?2:1;for(let i=0;i<size;i++)written.add(target+i);}
 }}
 // Never freeze a known directly written inline value. Unknown data regions
 // are absent, not filled from an initial RAM image.
 for(const at of written)code.delete(at);
 const ranges=[{start:0,kind:'immutable-firmware-entropy',values:[...firmware]},
  {start:base,kind:'immutable-lexicon-and-prose',values:[...payload.subarray(0,0x8258-base)]},
  {start:0xF60C,kind:'immutable-vector-picture-data',values:[...payload.subarray(0xF60C-base)]}];
 // These three loaded bytes precede the entry at A040. There is no
 // decoded game writer or command using them; only the entropy resolver
 // observes them in the passive trace.
 if([0xA03D,0xA03E,0xA03F].some(address=>written.has(address)))throw Error('The pre-entry data are no longer immutable');
 ranges.push({start:0xA03D,kind:'immutable-pre-entry-data',values:[byte(0xA03D),byte(0xA03E),byte(0xA03F)]});
 // A7EB selects one of two four-word article tables. Article lookup
 // never modifies these dictionary references.
 if(Array.from({length:16},(_,i)=>0xA24D+i).some(address=>written.has(address)))throw Error('The article tables are no longer immutable');
 ranges.push({start:0xA24D,kind:'immutable-article-references',values:[...payload.subarray(0xA24D-base,0xA25D-base)]});
 // BFC6 copies three characters per day into the mutable clock buffer.
 if(Array.from({length:21},(_,i)=>0xBF59+i).some(address=>written.has(address)))throw Error('The weekday names are no longer immutable');
 ranges.push({start:0xBF59,kind:'immutable-weekday-names',values:[...payload.subarray(0xBF59-base,0xBF6E-base)]});
 // D0F2 uses the first references for the room's locative phrases.
 // The back half supplies direction words. Both are immutable.
 if(Array.from({length:30},(_,i)=>0xD05A+i).some(address=>written.has(address)))throw Error('The location vocabulary references are no longer immutable');
 ranges.push({start:0xD05A,kind:'immutable-location-vocabulary',values:[...payload.subarray(0xD05A-base,0xD078-base)]});
 // The formatter copies up to four bytes per inflection; its suffix table is read-only.
 if(Array.from({length:36},(_,i)=>0xA85C+i).some(address=>written.has(address)))throw Error('The suffix table is no longer immutable');
 ranges.push({start:0xA85C,kind:'immutable-text-suffixes',values:[...payload.subarray(0xA85C-base,0xA880-base)]});
 // Two instructions between the normal F059 jump and the signal entry F062.
 // Neither has the erase bit. Reading the bytes does not dispatch the branch.
 if(Array.from({length:6},(_,i)=>0xF05C+i).some(address=>written.has(address)))throw Error('The spare policeman instructions are no longer immutable');
 ranges.push({start:0xF05C,kind:'immutable-policeman-wait-branch',values:[...payload.subarray(0xF05C-base,0xF062-base)]});
 // A621 indexes the 32 two-byte formatter handlers. The entries are
 // read-only even though the interpreted text around them is stateful.
 if(Array.from({length:64},(_,i)=>0xA55D+i).some(address=>written.has(address)))throw Error('The formatter dispatch table is no longer immutable');
 ranges.push({start:0xA55D,kind:'immutable-text-dispatch',values:[...payload.subarray(0xA55D-base,0xA59D-base)]});
 const constants=[...code].filter(([at])=>at>=0x9921).sort((a,b)=>a[0]-b[0]);
 const npcBytes=[];for(const op of Object.values(npcPrograms.instructions)){const start=parseInt(op.source,16);for(let i=0;i<op.size;i++)if(!written.has(start+i))npcBytes.push([start+i,byte(start+i)]);}
 const catalog=JSON.parse(await readFile(join(project,'sherlock-analisi/locazioni/results/locations.json'),'utf8')),
  actions=JSON.parse(await readFile(join(project,'sherlock-analisi/locazioni/results/gameplay-action-inventory.json'),'utf8'));
 const headers=new Set([...catalog.entities.flatMap(e=>e.rules.map(r=>r.rule_pointer)),...actions.models.map(a=>a.general_rule),...Object.values(npcPrograms.rules).map(r=>r.source)].filter(Boolean));
 // The six conditional rule operations in the player's DOMAIN program
 // reference the editor/lexer/parser/semantic headers just like NPC rules.
 // D7FA/D7FB is the two-byte semantic-rule header, not mutable scratch.
 for(let p=0x9923;p<=0x993C;p+=5){if(byte(p)!==0x13)throw Error('Unexpected player rule operation');headers.add((byte(p+1)|byte(p+2)<<8).toString(16).toUpperCase());}
 const ruleBytes=[];for(const h of headers){const at=parseInt(h,16),flags=byte(at),size=2+(flags&64?2:0)+(flags&16?5:0);for(let i=0;i<size;i++)if(!written.has(at+i))ruleBytes.push([at+i,byte(at+i)]);}
 const worldLayout={rooms:catalog.rooms.map(r=>({id:r.id,start:parseInt(r.record,16),size:r.size})),entities:catalog.entities.map(e=>({id:e.id,start:parseInt(e.record,16),size:e.size,rulePairs:e.rules.map(r=>[r.action_id,r.value])})),tables:[{start:0x8B6F,values:[...catalog.entities.flatMap(e=>[e.id,parseInt(e.record,16)&255,parseInt(e.record,16)>>>8]),255]},{start:0x8258,values:[...payload.subarray(0x8258-base,Math.min(...catalog.rooms.map(r=>parseInt(r.record,16)))-base)]}]};
 // C972 searches this immutable id/pointer table; it is DATA, not code.
 const generalActions=[];for(let at=0x9F38;;at+=3){const id=byte(at);generalActions.push(id);if(id===255)break;const pointer=byte(at+1)|(byte(at+2)<<8),model=actions.models.find(a=>a.id===id);if(!model||parseInt(model.general_rule,16)!==pointer)throw Error('Unexpected global action table');generalActions.push(pointer&255,pointer>>>8);}
 worldLayout.tables.push({start:0x9F38,values:generalActions});
 // Immutable player DOMAIN operations (9921..994C), with no erase flags.
 worldLayout.tables.push({start:0x9921,values:[...payload.subarray(0x9921-base,0x994D-base)]});
 // A702 reads this dormant default text-word reference. No understood writer
 // targets it; unlike neighbouring action-class fields, it is immutable DATA.
 if(written.has(0xA00D)||written.has(0xA00E)||byte(0xA702)!==0xED||byte(0xA703)!==0x5B||byte(0xA704)!==0x0D||byte(0xA705)!==0xA0)throw Error('Default text reference contract changed');
 worldLayout.tables.push({start:0xA00D,values:[byte(0xA00D),byte(0xA00E)]});
 // Unreferenced padding between the live failure and request bytes.
 if(written.has(0xCC0C))throw Error('DOMAIN padding has a writer');
 worldLayout.tables.push({start:0xCC0C,values:[byte(0xCC0C)]});
 // The editor reuses the relocated tape loader. Unwritten input suffixes
 // therefore retain loader VALUES, including its last CODE header and status.
 // Reconstruct the copy/header operations, rather than reading a RAM snapshot.
 const loader=await readFile(join(project,'sherlock-analisi/block-04.bin'));
 if(loader.length!==256||hash(loader)!=='189679d90ca23d74b07181fa809f428c7076be66f81f54cf06fc78699aaa2b1c')throw Error('Unexpected loader data');
 const inventory=JSON.parse(await readFile(join(project,'sherlock-analisi/inventory.json'),'utf8')),header=inventory.blocks.at(-1),editorInitial=[...loader],headerBytes=[header.type,...Buffer.from(header.name),header.declared_length&255,header.declared_length>>>8,header.parameter1&255,header.parameter1>>>8,header.parameter2&255,header.parameter2>>>8];
 editorInitial.splice(30,17,...headerBytes);editorInitial[47]=1;
 // ROM 127C–1285 copies fourteen stream-map bytes to 5C10. These are
 // startup data reused by the game's word workspace, not a RAM fallback.
 if(Buffer.from(firmware.subarray(0x127C,0x1287)).toString('hex')!=='21c61511105c010e00edb0')throw Error('Unexpected ROM stream initialization');
 // The ROM seeds CHANS and copies the default channel records before
 // publishing PROG. Match the writer, including both destinations.
 if(firmware.subarray(0x1235,0x124D).toString('hex')!=='21b65c224f5c11af15011500ebedb0eb2b22575c2322535c')throw Error('Unexpected ROM BASIC channel initialization');
 const basicChannels={start:firmware.readUInt16LE(0x1236),length:firmware.readUInt16LE(0x123F)};
 const basic=await readFile(join(project,'sherlock-analisi/block-02.bin'));
 if(hash(basic)!=='fcd8b87a6c41db725a5af0694ffc04423d824993d6f7eb7ce7edfda360e680b0')throw Error('Unexpected BASIC bootstrap');
 basicChannels.lineSize=4+basic.readUInt16LE(2);
 // 0878 stores the header reference at X-PTR. MAKE-ROOM moves it
 // by the program length, then a second LOAD reserves two headers at 061F.
 if(firmware[0x061F]!==0x0E||firmware[0x0620]!==2*17)throw Error('Unexpected ROM tape header allocation');
 basicChannels.loadHeaderWorkspace=firmware[0x0620];
 if(basicChannels.lineSize!==basic.length)throw Error('The BASIC bootstrap no longer has one line');
 // BASIC token USR becomes (token - AF + DC) & 3F; RST 28
 // publishes the operation number as BREG before entering the loader.
 const usr=basic[basic.indexOf(0xF5,4)+1];
 if(usr!==0xC0||firmware[0x26ED]!==0xD6||firmware[0x26FE]!==0xC6||firmware[0x2753]!==0xE6)throw Error('Unexpected BASIC USR dispatch');
 basicChannels.calculatorEntry=(usr-firmware[0x26EE]+firmware[0x26FF])&firmware[0x2754];
 if(firmware.subarray(0x16CC,0x16D2).toString('hex')!=='21925c22685c')throw Error('Unexpected calculator memory reset');
 basicChannels.calculatorMemory=firmware.readUInt16LE(0x16CD);
 const cab=JSON.parse(await readFile(join(project,'sherlock-analisi/cab/results/cab-data.json'),'utf8'));worldLayout.tables.push({start:0x9B7F,values:[...cab.routes.flatMap(r=>[r.source,r.target,r.duration]),255]});
 // Native tape IO is an explicitly unavailable command; the typed CODE
 // header remains its source value. Browser JSON save/load never modifies it.
 worldLayout.tables.push({start:0xC0FE,values:[...payload.subarray(0xC0FE-base,0xC10F-base)]});
 // AF6B/AF9B: immutable word/handler pairs for the two parser modes.
 // The parser reads these tables; no handler writes their entries.
 worldLayout.tables.push({start:0xAF6B,values:[...payload.subarray(0xAF6B-base,0xAFB3-base)]});
 // Fact records have a six-byte subject/predicate/object/flags/handler prefix,
 // followed by source reference terms. Boundaries are established by the
 // evaluator's referenced entries, not by disassembling this data as code.
 const factStarts=[0x9965,0x9973,0x9981,0x9997,0x99A9,0x99BB,0x99C5,0x99CF,0x99D9,0x99E3,0x99F1,0x99FB];
 // BC4E/BC7A/BCA2 scan until the FF subject at 99FB. This byte is a
 // table terminator, not another mutable fact or an instruction at 99FC.
 const terminator=factStarts.at(-1);if(byte(terminator)!==255)throw Error('Invalid fact table terminator');
 worldLayout.tables.push({start:terminator,values:[255],kind:'fact-table-terminator'});
 worldLayout.facts=factStarts.slice(0,-1).map((start,i)=>({start,subject:byte(start),predicate:byte(start+1),object:byte(start+2),flags:byte(start+3),handler:byte(start+4)|byte(start+5)<<8,terms:Array.from({length:(factStarts[i+1]-start-6)/2},(_,j)=>byte(start+6+2*j)|byte(start+7+2*j)<<8)}));
 return {version:1,worldLayout,editorInitial,basicProgramLength:basic.length,bootOptions:{basicChannels,initialParserAll:byte(0xA01A),initialEditorTokenFlag:byte(0xD714),initialParserCount:byte(0xA012),initialStreams:[...firmware.subarray(0x15C6,0x15D4)],initialFillColor:byte(0xF60B),printerEnabled:Boolean(byte(0xA008)),keyboard:{rawKey:13,decodedKey:13,releaseScans:2,releaseWindow:firmware[0x02F5],repeatDelay:35,repeatPeriod:5}},source_sha256:hash(payload),firmware_sha256:hash(firmware),
  scope:'Immutable inputs only. Unmapped display, buffers, records and mutable fields must be generated or rejected; no RAM image fallback.',
  ranges,constants,npcBytes,ruleBytes,excludedWrites:[...written].sort((a,b)=>a-b),
  historicalPrompt:{profile:'historical-prompt-watson-v4',seed:77,cursor:512,encounters:[30,0,0]}};
}
