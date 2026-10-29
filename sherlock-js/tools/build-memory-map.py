"""Build a conservative, source-backed atlas. No execution of Z80 instructions.

Every listed byte is checked against the original payload. Unclassified gaps
remain unknown; the entropy-only disassembly is deliberately NOT evidence.
"""
import json,re,sys,hashlib,collections
from pathlib import Path
sys.dont_write_bytecode=True
ROOT=Path(__file__).resolve().parents[1];PROJECT=ROOT.parent;ANALYSIS=PROJECT/'sherlock-analisi'
sys.path[:0]=[str(ANALYSIS/'decoder'),str(ANALYSIS/'grafica')]
from sherlock_text import Decoder
from sherlock_graphics import catalog as pictures
sys.path.insert(0,str(PROJECT/'skoolkit-10.1'))
from skoolkit.z80 import Assembler
assembler=Assembler()
BASE=0x5D80;END=0x10000;payload=(ANALYSIS/'block-10.bin').read_bytes();digest=hashlib.sha256(payload).hexdigest()
game=json.loads((ROOT/'data/game.json').read_text());assert digest==game['source_sha256'] and len(payload)==END-BASE
mem=bytes(BASE)+payload;decoder=Decoder(mem);candidates=[];sources=[];all_rows=[];checks=0
hex4=lambda n:f'{n:04X}'
def raw(a,b):return mem[a:b].hex(' ').upper()
def row(a,b,op,comment=''):return {'a':a,'n':b-a,'op':op,'c':comment}
def db(a,b,comment=''):return row(a,b,'DEFB '+','.join('$'+f'{v:02X}'for v in mem[a:b]),comment)
def add(a,b,title,kind,description,rows=None,source=None,status='documented',priority=90,fields=None):
 assert 0x5B00<=a<b<=END,(hex(a),hex(b),title)
 item=dict(id=len(candidates),start=a,end=b,title=title,kind=kind,status=status,description=description,rows=rows or [],sources=[source]if source is not None else [],priority=priority)
 if fields:item['fields']=fields
 candidates.append(item);return item

def source(path,title):
 path=path.resolve();relative=str(path.relative_to(PROJECT))
 for entry in sources:
  if entry['path']==relative:return entry['id']
 entry={'id':len(sources),'path':relative,'title':title,'sha256':hashlib.sha256(path.read_bytes()).hexdigest()};sources.append(entry);return entry['id']

# These are curated analysis dossiers, not a broad code sweep. Their own
# comments identify scope and known limitations. Overlap is resolved per byte.
inputs=[
('testo/text.asm','Dizionario e stampa del testo','Testo compresso e convenzioni dei suoi interpreti.'),
('parser/parser.asm','Input, lessico e sintassi','Editor, lexer, parser e rifiuti sintattici. Il riuso dei nodi con predicati differenti è ricostruito in parser-rule-lifetimes; altri casi mantengono i limiti documentati.'),
('parser/parser-special.asm','Citazioni e continuazioni','Modalità speciali, riferimenti impliciti e continuazioni.'),
('main-loop/results/main-loop.asm','Ciclo principale e tempo','Scansione delle righe attore, costi, calendario e servizi.'),
('entita/results/entities-semantics.asm','Entità e risoluzione','Modelli delle azioni, oggetti, personaggi e risoluzione dei riferimenti.'),
('locazioni/results/locations.asm','Locazioni e percezione','Descrizioni, grafo, luce e contenuti visibili.'),
('regole/results/rules.asm','Regole e azioni','Intestazioni delle regole e loro contratti.'),
('scrolling/results/scrolling.asm','Stampa, scorrimento e MORE','Formatter, contatore cumulativo delle righe e pausa di paginazione.'),
('cab/results/cab.asm','Cab, percorsi e denaro','Viaggi, tariffa, pagamento e resto.'),
('ai/results/npc-ai.asm','AI e linguaggio DOMAIN','Programmi degli attori, richieste, segnali e contesti sospesi.'),
('grafica/graphics.asm','Grafica vettoriale e riempimento','Interprete delle immagini, tracciamento delle linee, fill e colori.'),
]
for path in sorted((ROOT/'results').glob('**/*.asm')):
 if path.name!='random-input-code.asm':inputs.append((path,str(path.parent.relative_to(ROOT/'results')).replace('/',' · '),'Estratto tematico verificato; ruolo specificato dalle annotazioni e dal rapporto associato.'))
line_re=re.compile(r'^\s*(.+?)\s*;\s*\$([0-9A-Fa-f]{4})\s+((?:[0-9A-Fa-f]{2}(?:\s+|$))+)')
for path,title,description in inputs:
 path=Path(path);path=path if path.is_absolute()else ANALYSIS/path
 if not path.exists():continue
 sid=source(path,title);rows=[];pending=[];domain=False
 for line_no,line in enumerate(path.read_text().splitlines(),1):
  if line.lstrip().startswith(';'):
   text=line.lstrip()[1:].strip()
   if text:pending.append(text)
   if text.startswith(('BYTECODE:','HEADER:','DATA:')):domain=text.startswith('BYTECODE:')
   continue
  match=line_re.match(line)
  if not match:continue
  op=match[1].strip();a=int(match[2],16);bs=bytes.fromhex(match[3]);b=a+len(bs)
  if a<BASE:pending=[];continue
  assert mem[a:b]==bs,(str(path),line_no,hex4(a),'listing differs from payload')
  assert bytes(assembler.assemble(op,a))==bs,(str(path),line_no,hex4(a),'operation does not reassemble')
  checks+=len(bs);inline=line.split('|',1)[1].strip()if'|'in line else ''
  rr=row(a,b,op,' '.join(pending+[inline]).strip());rr.update(line=line_no,source=sid,kind='domain'if domain and op.startswith('DEF')else 'data'if op.startswith('DEF')else 'code');pending=[];rows.append(rr)
 all_rows.extend(rows)
 # Reports with explicit typed boundaries take priority over coarse chunks.
 report=path.parent/'listing-verification.json'
 if path.name=='parser-special.asm':report=path.parent/'listing-special-verification.json'
 regions=json.loads(report.read_text()).get('regions',[])if report.exists()else []
 if regions:
  for region in regions:
   a=int(region['start'],16);b=int(region['end_exclusive'],16)
   selected=[r for r in rows if r['a']<b and r['a']+r['n']>a]
   if not selected or a<BASE:continue
   # An explicit region is not permission to colour unlisted holes.
   covered=set(i for r in selected for i in range(max(a,r['a']),min(b,r['a']+r['n'])))
   if len(covered)!=b-a:continue
   notes=[r['c']for r in selected if r['c'] and not re.match(r'^(?:DATA|CODE)(?: fino| \$|:)',r['c'])]
   label=region.get('label')or(notes[0]if notes else title)
   kind='code'if region['kind']=='code'else'data'
   add(a,b,label,kind,description,selected,sid,status='documented'if notes or region.get('label')else'partial',priority=region.get('atlas_priority',75 if region.get('label') else 70),fields=region.get('fields'))
 # Exact contiguous sequences also recover sources without region reports.
 chunks=[]
 for rr in rows:
  if not chunks or chunks[-1][-1]['a']+chunks[-1][-1]['n']!=rr['a']or chunks[-1][-1]['kind']!=rr['kind'] or (rr['c'] and not rr['c'].startswith(('Sherlock','CODE fino','DATA fino'))):chunks.append([])
  chunks[-1].append(rr)
 for chunk in chunks:
  a=chunk[0]['a'];b=chunk[-1]['a']+chunk[-1]['n'];notes=[r['c']for r in chunk if r['c']]
  label=next((n for n in notes if not n.startswith(('Sherlock','CODE fino','DATA fino'))),title)
  label=re.sub(r'^(Z80|CODE|BYTECODE|HEADER|DATA):\s*','',label)
  add(a,b,label[:160],chunk[0]['kind'],description,chunk,sid,status='documented'if notes else'partial',priority=75 if notes else 50)

# Structurally decoded banks. Structured data coverage is explicitly distinct
# from understanding every state-dependent response or gameplay path.
sid=source(ANALYSIS/'parser/results/dictionary.json','Dizionario: 592 record lessicali decodificati')
add(0x5D80,0x5DC0,'Indice alfabetico del dizionario','data','32 word little-endian; le entrate a–z sono offset relativi a $5DBF.',[row(a,a+2,f'DEFW ${int.from_bytes(mem[a:a+2],"little"):04X}','Offset relativo alla base $5DBF')for a in range(0x5D80,0x5DC0,2)],sid,priority=100)
words=json.loads((ANALYSIS/'parser/results/dictionary.json').read_text());groups=[]
for w in words:
 a=int(w['address'],16);bs=bytes.fromhex(w['raw_bytes']);assert mem[a:a+len(bs)]==bs
 letter=w['stem'][:1].upper()
 if not groups or groups[-1][0]!=letter:groups.append([letter,[]])
 groups[-1][1].append((w,a,a+len(bs)))
for letter,ww in groups:
 rows=[db(a,b,f'{w["stem"]} → {w["output_inflected"]}; offset ${w["offset"]}; classe ${w["class"]}; suffisso ${w["suffix_code"]}; prefisso {w["prefix_length_excluding_initial"]}'+(f'; alias ${w["alias_direct"]}'if w['alias_direct']else''))for w,a,b in ww]
 add(ww[0][1],ww[-1][2],f'Dizionario · {letter} · {len(ww)} voci','text','Record compressi con prefisso condiviso, lettere a 5 bit, classe grammaticale, suffisso ed eventuale alias. La decodifica del formato non certifica ogni frase del parser.',rows,sid,priority=100)
sid=source(ANALYSIS/'decoder/sherlock_text.py','Decoder dei token testuali')
add(0x67B7,0x67F7,'Tabella delle 32 parole frequenti','data','I token $60–$7F selezionano un offset lessicale in questa tabella.',[row(a,a+2,f'DEFW ${int.from_bytes(mem[a:a+2],"little"):04X}',f'Token ${0x60+(a-0x67B7)//2:02X}')for a in range(0x67B7,0x67F7,2)],sid,priority=100)
fragments=decoder.bank()
# Modest groups keep the overview legible; the detailed listing preserves
# fragment and token boundaries, with symbolic dynamic alternatives.
commands=['nome da argomento','parola da argomento','salto relativo','parola del soggetto','nome da argomento','relazione dell’affermazione','nome referente A036','nome referente A034','backspace','nome referente A035','scelta casuale','richiamo relativo','possessivo di A036','ritorno a capo','possessivo di A034','condizione temporale','nome A036 + is/are','nome A034 + is/are','ripetizione DE: contratto parziale','nome da argomento + is/are','condizione temporale','condizione temporale','condizione temporale','condizione temporale','composizione di un’azione','testo da argomento stack','salto a testo da argomento stack','alterna maiuscole','nessuna operazione','fine con ritorno a capo','fine con punto e ritorno a capo','fine frammento']
def token_note(t):
 if t.kind=='word':return f"parola {decoder.words[t.value].stem if t.value in decoder.words else hex4(t.value)!r}; offset ${t.value:03X}, contesto ${t.context:02X}"
 if t.kind=='command':return commands[t.value]
 if t.kind in ['call','jump']:return t.kind+' $'+hex4(t.value)
 if t.kind=='choice':return 'scelta casuale: '+' | '.join(token_note(x)for x in t.value)
 if t.kind=='conditional':return f"se classe temporale {t.value['time_class']}: "+token_note(t.value['token'])
 return t.kind+': '+repr(t.value)
for i in range(0,len(fragments),24):
 batch=fragments[i:i+24];rows=[]
 for a,b,tokens in batch:
  for j,t in enumerate(tokens):
   comment=token_note(t)
   if j==0:comment=f'Frammento ${a:04X}. '+comment
   rows.append(db(t.address,t.end,comment))
 add(batch[0][0],batch[-1][1],f'Testi compressi · ${batch[0][0]:04X} · {len(batch)} frammenti','text','Frammenti decodificati sequenzialmente. Nomi, tempo, richiami e scelte rimangono simbolici: non si inventa una frase dipendente da uno stato inesistente.',rows,sid,priority=100)

locations=json.loads((ANALYSIS/'locazioni/results/locations.json').read_text());assert locations['source_sha256']==digest;sid=source(ANALYSIS/'locazioni/results/locations.json','Struttura delle locazioni e delle entità')
add(0x840B,0x84E1,'Indice delle 106 locazioni','data','106 word puntano ai record; lo slot $6A finale è il ponte all’indice delle entità, non una locazione.',[row(a,a+2,f'DEFW ${int.from_bytes(mem[a:a+2],"little"):04X}',f'ID {(a-0x840B)//2:03d}'if a<0x84DF else'Slot $6A: indice delle entità')for a in range(0x840B,0x84E1,2)],sid,priority=100)
for r in locations['rooms']:
 a=int(r['record'],16);b=a+r['size'];fields=[['+0','1','Flag: visita, luce e relazione grammaticale'],['+1','6','Nome lessicale e due qualificatori (3 word)'],['+7','2','Puntatore alla descrizione; zero = descrizione generica'],['+9','variabile','Triplette direzione, destinazione, porta; terminatore FF']]
 rr=[db(a,a+1,'Flag della locazione'),row(a+1,a+7,'DEFW '+','.join(f'${int.from_bytes(mem[x:x+2],"little"):04X}'for x in range(a+1,a+7,2)),'Nome e qualificatori'),row(a+7,a+9,f'DEFW ${int.from_bytes(mem[a+7:a+9],"little"):04X}','Descrizione compressa')]
 for edge in r['exits']:rr.append(db(a+9+3*len(rr[3:]),a+12+3*len(rr[3:]),f'{edge["direction"]}: locazione {edge["target"]}; porta {edge["gate"]}'))
 if a+9<b:rr.append(db(b-1,b,'Terminatore delle uscite FF'))
 add(a,b,f'Locazione {r["id"]:03d} · {r["name_hint"]or"fuori scena"}','data','Record della locazione e archi diretti del grafo. I nomi sono quelli del catalogo di analisi; il renderer può applicare flessioni e articoli.',rr,sid,priority=100,fields=fields)
add(0x8B6F,0x8CBA,'Indice delle 110 entità','data','Triplette ID + puntatore word; FF termina la tabella.',[db(a,min(a+3,0x8CBA),'ID e puntatore al record'if a<0x8CB9 else'Terminatore FF')for a in range(0x8B6F,0x8CBA,3)],sid,priority=100)
for e in locations['entities']:
 a=int(e['record'],16);b=a+e['size'];fields=[['+0','1','Numero di collocazioni'],['+1','1','Contenitore/padre, FF = nessuno'],['+2','1','Dimensione'],['+3','1','Capacità/peso'],['+4','1','Relazione di contenimento e proprietà'],['+5','1','Attributi: persona, stato fisico, ecc.'],['+6','1','Flag di esame e visibilità'],['+7','6','Nome e qualificatori'],['+13','2','Puntatore descrizione'],['+15','variabile','Collocazioni, poi coppie azione/regola']]
 rr=[db(a,a+7,'Conteggio, contenitore, dimensione, capacità, proprietà e flag'),row(a+7,a+13,'DEFW '+','.join(f'${int.from_bytes(mem[x:x+2],"little"):04X}'for x in range(a+7,a+13,2)),'Nome lessicale e qualificatori'),row(a+13,a+15,f'DEFW ${int.from_bytes(mem[a+13:a+15],"little"):04X}','Descrizione')]
 for x in range(a+15,b,8):rr.append(db(x,min(x+8,b),'Collocazioni e tabella delle regole (coppie ID azione / word regola)'))
 add(a,b,f'Entità {e["id"]:03d} · {e["name"]}','data','Oggetti e personaggi usano lo stesso formato. I valori qui sono quelli del nastro prima dell’inizializzazione, non lo stato di una partita.',rr,sid,priority=100,fields=fields)

# DOMAIN instructions are DATA interpreted by the game, never Z80 code.
sid=source(ROOT/'data/game.json','Catalogo semantico delle istruzioni DOMAIN e delle regole')
ops=sorted(game['npcPrograms']['instructions'].values(),key=lambda o:int(o['source'],16));roots={int(x['entry'],16):game['entities'][x['id']]['name']for x in game['npcPrograms']['actors']};runs=[]
for op in ops:
 a=int(op['source'],16)
 if not runs or int(runs[-1][-1]['source'],16)+runs[-1][-1]['size']!=a or a in roots:runs.append([])
 runs[-1].append(op)
for run in runs:
 a=int(run[0]['source'],16);b=int(run[-1]['source'],16)+run[-1]['size'];rr=[]
 for op in run:
  x=int(op['source'],16);value=op.get('rule',op.get('text',op.get('action','')));value=('$'+value.split('.')[-1]+' (identificatore storico del catalogo)'if isinstance(value,str)and value.startswith('unimplemented.')else '$'+value if op['op']in ['say','print']else value);label=op['op']+' '+str(value)
  if 'args'in op:label+=' argomenti='+str(op['args'])
  if op.get('success')is not None:label+='; successo $'+op['success']
  if op.get('failure')is not None:label+='; fallimento $'+op['failure']
  rr.append(db(x,x+op['size'],'DOMAIN: '+label))
 add(a,b,'Programma DOMAIN · '+roots.get(a,('Holmes / input'if a==0x9923 else f'sequenza condivisa ${a:04X}')),'domain','Bytecode interpretato dal gioco. Flag, rami, argomenti e richiami alle regole sono dati, non istruzioni Z80. La comprensione del formato non certifica ogni futuro percorso NPC.',rr,sid,priority=110)
for name,r in game['npcPrograms']['rules'].items():
 a=int(r['source'],16);b=a+2+(2 if mem[a]&64 else 0)+(5 if mem[a]&16 else 0);assert [mem[a]&15,mem[a+1]&15]==r['classes'] and mem[a+1]>>4==r['cost']
 if not BASE<=a<b<=END:continue
 add(a,b,f'Intestazione regola · {name.replace("unimplemented.","$")}','data',f'Classi argomenti {r["classes"]}; costo {r["cost"]}; luce richiesta: {r["requiresLight"]}. '+('Corpo DOMAIN.'if r.get('program')else'Il corpo è Z80; questa zona contiene soltanto i metadati.'),[db(a,b,'Header: classi, flag, costo, eventuale predicato e maschere')],sid,priority=115)

sid=source(ANALYSIS/'grafica/sherlock_graphics.py','Decoder delle istruzioni grafiche')
pp=pictures(decoder);table_end=0xF60C+3*len(pp)+1
add(0xF60C,table_end,'Indice delle immagini delle locazioni','graphics','Triplette ID locazione / puntatore allo stream, terminate da FF.',[db(a,min(a+3,table_end),'Locazione e puntatore grafica')for a in range(0xF60C,table_end,3)],sid,priority=100)
for pic in pp:
 rr=[]
 for c in pic['commands']:
  desc=c['kind'].upper()+' '+', '.join(f'{k}={v}'for k,v in c.items()if k not in ['address','end','raw','kind','opcode','runs'])
  if c.get('runs'):desc+='; passi attributi='+str(c['runs'])
  rr.append(db(c['address'],c['end'],desc))
 add(pic['start'],pic['end'],f'Immagine {pic["location"]:03d} · {pic["name"]}','graphics','Stream MOVE / LINE / FILL / PAPER / END. Sono istruzioni grafiche, non una bitmap. Coordinate e colori sono quelli del formato originale.',rr,sid,priority=100)

sid=source(ANALYSIS/'main-loop/results/main-loop.asm','Stato globale e avvio della sessione')
def listed(a,b):
 result={}
 for rr in all_rows:
  if rr['a']<b and rr['a']+rr['n']>a:result[rr['a']]=rr
 return [result[x]for x in sorted(result)]
add(0x9FDD,0xA040,'Stato globale · clock, liste, parser e casualità','data','Area mutabile condivisa. Le fonti annotano il calendario, le teste delle liste, il costo restituito, i riferimenti correnti e il seed. Non tutti i byte temporanei hanno un proprietario ricostruito.',listed(0x9FDD,0xA040),sid,status='partial',priority=100,fields=[['9FDD','2','Tick globale'],['9FDF–9FE2','4','Minuto, ora, giorno, am/pm'],['9FE3','2','Testa della lista dei blocchi liberi'],['A00B','1','Fase regole: 0 verifica/enumerazione; 1 esecuzione, anche dopo predicato falso con argomenti espliciti (C5F4)'],['A013–A016','4','Due puntatori argomento: record di locazione o entità, conservati per FE/FF'],['A01A','1','Stato ALL/BUT: 0 nessuno, 1 ALL, 2 BUT; reset AAB3 e transizioni B03F/B026. Persistenza su errore, ingressi delle citazioni e continuazioni verificati'],['A01B','1','Offset del referente da completare:0,08,12 esadecimali. Reset al ritorno D793, scrittura alla domanda B5B6; distinto da puntatore pendente e ordine semantico'],['A01C','1','Modo del resolver:0 normale,128 continuazione ALL; quattro writer e contesti distinti D6B8/record richiesta+2'],['A01F','2','Costo temporaneo condiviso: reset CC74, intestazioni CA09, cab9B07, controlli B0BD/B0CC, yield CD85/CD8E, basso DDC5 e word WAIT UNTIL DE42; ingressi casuali verificati'],['A021','1','Residuo dei controlli: C655=0, C6BA=1; rifiuti del secondo ruolo possono conservarlo. Non è il risultato generale della regola'],['A036','1','Attore corrente'],['A037','1','Accumulatore casuale'],['A039','2','Cursore del generatore casuale'],['A03B','2','Contatore di inattività della tastiera']])
add(0xA040,0xA068,'Avvio · schermo, scelta grafica e seed','code','Prepara la sessione, imposta lo stack a $5D80, legge la scelta grafica e inizializza l’accumulatore casuale dal registro R.',listed(0xA040,0xA068),sid,priority=100)
sid=source(ANALYSIS/'entita/results/entities-semantics.asm','Formato dei modelli delle azioni')
add(0x8259,0x840B,'54 modelli lessicali delle azioni','data','Record da 8 byte: quattro word lessicali con metadati nei nibble alti. Una word zero chiude la tabella. I nibble non fanno parte degli offset del dizionario.',listed(0x8259,0x840B),sid,priority=100)
sid=source(ROOT/'src/random.mjs','Algoritmo del generatore casuale condiviso')
add(0xD29D,0xD2ED,'Generatore casuale · seed, cursore e memoria','code','Algoritmo condiviso per contatori, dialoghi e decisioni. Mescola lo stato corrente con byte della memoria. La formula è ricostruita; alcuni ingressi mutabili rimangono sconosciuti, quindi questo non certifica ogni sequenza futura.',listed(0xD29D,0xD2ED),sid,priority=100)

sid=source(ROOT/'src/record-arena.mjs','Arena dei record dinamici')
add(0x9570,0x9860,'Arena dei record dinamici · 752 byte','data','Blocco di allocazione delle liste di contesti, richieste, sintassi, segnali e fatti. Il layout varia durante la partita. I byte mostrati sono soltanto l’inizializzazione del nastro.',[db(a,min(a+16,0x9860),'Area dinamica, non istruzioni CPU')for a in range(0x9570,0x9860,16)],sid,priority=100,fields=[['Blocco allocato','3 + N','Dimensione totale (1), link di lista (2), payload N'],['Blocco libero','4 + …','Dimensione word, puntatore word al prossimo blocco libero'],['Liste','variabile','Contesti 7 B, richieste 8 B, sintassi 30 B, contatori e segnali 2 B'],['Sintassi +00','2','Verbo: AB7C/AC17 sovrascrivono anche il nodo intermedio prima della nuova allocazione'],['Record liberati','variabile','Il payload non viene azzerato dalla liberazione; i residui restano ingressi del generatore casuale']])
sid=source(ANALYSIS/'cab/results/cab-data.json','Rete statica dei percorsi dei cab')
routes=game['cab']['routes'];route_bytes=bytes([v for r in routes for v in [r['source'],r['target'],r['duration']]]+[255]);assert mem[0x9B7F:0x9B7F+len(route_bytes)]==route_bytes
add(0x9B7F,0x9B7F+len(route_bytes),'Percorsi dei cab · sorgente, destinazione, durata','data','Triplette di ID locazione e costo del tragitto. Le modalità rapide applicano la propria regola; non si deduce una nuova rete da coordinate grafiche.',[db(0x9B7F+i*3,0x9B82+i*3,f"Da {r['source']} a {r['target']}: durata {r['duration']}")for i,r in enumerate(routes)]+[db(0x9B7F+len(route_bytes)-1,0x9B7F+len(route_bytes),'Terminatore FF')],sid,priority=100)

sid=source(ROOT/'src/random-display.mjs','Proiezione dei buffer e dei campi temporanei')
for a,b,title,note in [(0x5B00,0x5B81,'Buffer del comando','Editor: caratteri ASCII normalizzati e CR; la coda riusa i byte del loader.'),(0x5B81,0x5C00,'Buffer dei token','Tipi e valori lessicali, citazioni e puntatori; alcuni ingressi possono sovrapporre i buffer.'),(0x5C0B,0x5C8B,'Buffer della parola in uscita','Buffer riutilizzato: svuotarlo non cancella tutti i byte. I letterali delle conversazioni fuori scena scrivono ancora nel buffer, a differenza delle parole di dizionario. A 5C10–5C1D la ROM copia inizialmente quattordici byte della mappa dei canali: sono conservati solo fino alla prima sovrascrittura del gioco.'),(0x5CEC,0x5D80,'Stack e area temporanea del gioco','Layout dipendente dai chiamanti; soltanto alcuni residui AF/BC e frame della stampa sono ricostruiti. Nessuna immagine RAM completa è certificata. La stampa C388 lascia indirizzo video, shift, ultima scansione e campi del chiamante; i nuovi dossier distinguono campi ricostruiti e revocati, senza una copia RAM di riserva.')]:
 add(a,b,title,'workspace',note,[],sid,status='partial',priority=100,fields=([['5D1A / 5D1B','F / A, provenienza condizionata','Con frame glifo5D26: flag e ottava riga non allineata del font. Il nuovo dossier verifica il chiamante della pulizia del prefisso qualificato'],['5D1B','altri frame','Con frame5D24 conserva B=1; le stampe prive di contratto revocano la proprietà. Nessun valore iniziale mostrato come stato corrente'],['5D1C','C dello shift nel frame verificato','Con frame5D26: (2+7*colonna)&7. C39C/C3B7 conservano C. Con altri frame può essere indirizzo o F; vecchi save restano sconosciuti e i chiamanti non proiettati revocano. Non comprende5D1D/5D1E'],['5D22','L del video nel frame verificato','Con frame5D2A: (5020+floor((2+7*colonna)/8))&FF. Il prefisso del nome dell’attore nell’ordine682A salva HL a C38B/C398; gli altri chiamanti revocano, vecchi LOAD rimangono sconosciuti. Non comprende5D23–5D27']]if a==0x5CEC else None))

# Resolve overlap once, deterministically. Smaller typed intervals win within
# a source priority. Grey is not inferred as code or data from its byte values.
owners=[None]*END
for c in candidates:
 rank=(c['priority'],-(c['end']-c['start']),c['id'])
 for a in range(c['start'],c['end']):
  old=owners[a]
  if old is None or rank>(old['priority'],-(old['end']-old['start']),old['id']):owners[a]=c
segments=[];a=0x5B00
while a<END:
 c=owners[a];b=a+1
 while b<END and owners[b]is c:b+=1
 if c is None:segment=dict(start=a,end=b,title='Area non analizzata',kind='unknown',status='unknown',description='Non è stata selezionata alcuna fonte che classifichi questi byte. Non si tenta di disassemblarli come Z80.',rows=[],sources=[])
 else:
  segment={k:v for k,v in c.items()if k not in ['id','priority']};segment.update(start=a,end=b)
  segment['rows']=[r for r in c['rows']if r['a']<b and r['a']+r['n']>a]
  # Include other dossiers that independently document the selected bytes.
  segment['sources']=sorted(set(c['sources']+[r['source']for r in all_rows if r['a']<b and r['a']+r['n']>a]))
 segment['id']=len(segments);segments.append(segment);a=b
assert segments[0]['start']==0x5B00 and segments[-1]['end']==END
for x,y in zip(segments,segments[1:]):assert x['end']==y['start']
for s in segments:
 for r in s['rows']:assert r['n']>0 and r['a']<s['end']and r['a']+r['n']>s['start']
counts=collections.Counter()
for s in segments:
 n=max(0,s['end']-max(BASE,s['start']));counts[s['status']]+=n
assert sum(counts.values())==len(payload)
result=dict(version=1,base=BASE,end=END,workspaceBase=0x5B00,payload_sha256=digest,payload_hex=payload.hex(),scope='Payload statico del TAP, prima dell’inizializzazione. ROM e memoria video escluse. Buffer e stack opzionali, senza valori RAM inventati.',method='Unione degli intervalli sostenuti dai dossier selezionati. Ogni byte dei listati è confrontato con il payload. Gli intervalli tipizzati più specifici prevalgono su quelli generali; le sovrapposizioni non aumentano le percentuali. Un ruolo documentato non certifica tutti i comportamenti del gioco.',sources=sources,segments=segments,counts=dict(counts),listed_bytes_checked_with_duplicates=checks,excluded_source='ai/results/random-input-code.asm: disassemblato usato per gli ingressi casuali, non prova di comprensione funzionale')
out=ROOT/'src';(out/'memory-map-data.json').write_text(json.dumps(result,ensure_ascii=False,separators=(',',':'))+'\n')
report=dict(payload_sha256=digest,atlas_sha256=hashlib.sha256((out/'memory-map-data.json').read_bytes()).hexdigest(),payload_bytes=len(payload),unique_counts=dict(counts),segments=len(segments),sources=len(sources),all_listing_bytes_match=True,all_listing_operations_reassemble=True,checked_bytes_with_duplicates=checks,partition_has_no_gaps_or_overlaps=True,video_and_rom_excluded=True,not_gameplay_equivalence=True)
(ROOT/'results/memory-map-verification.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(dict(segments=len(segments),payload_bytes=len(payload),unique_bytes=counts,sources=len(sources),checked_listing_bytes=checks),indent=2))
