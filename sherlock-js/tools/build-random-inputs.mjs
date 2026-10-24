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
 const constants=[...code].filter(([at])=>at>=0x9A7F).sort((a,b)=>a[0]-b[0]);
 const npcBytes=[];for(const op of Object.values(npcPrograms.instructions))if(!op.erase){const start=parseInt(op.source,16);for(let i=0;i<op.size;i++)if(!written.has(start+i))npcBytes.push([start+i,byte(start+i)]);}
 const catalog=JSON.parse(await readFile(join(project,'sherlock-analisi/locazioni/results/locations.json'),'utf8')),
  actions=JSON.parse(await readFile(join(project,'sherlock-analisi/locazioni/results/gameplay-action-inventory.json'),'utf8'));
 const headers=new Set([...catalog.entities.flatMap(e=>e.rules.map(r=>r.rule_pointer)),...actions.models.map(a=>a.general_rule),...Object.values(npcPrograms.rules).map(r=>r.source)].filter(Boolean));
 const ruleBytes=[];for(const h of headers){const at=parseInt(h,16),flags=byte(at),size=2+(flags&64?2:0)+(flags&16?5:0);for(let i=0;i<size;i++)if(!written.has(at+i))ruleBytes.push([at+i,byte(at+i)]);}
 return {version:1,source_sha256:hash(payload),firmware_sha256:hash(firmware),
  scope:'Immutable inputs only. Unmapped display, buffers, records and mutable fields must be generated or rejected; no RAM image fallback.',
  ranges,constants,npcBytes,ruleBytes,excludedWrites:[...written].sort((a,b)=>a-b),
  historicalPrompt:{profile:'historical-prompt-watson-v4',seed:77,cursor:512,encounters:[30,0,0]}};
}
