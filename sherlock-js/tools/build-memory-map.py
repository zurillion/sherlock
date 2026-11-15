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
   kind=region['kind'] if region['kind'] in ('code','domain') else 'data'
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
victory_trace=source(ROOT/'PERCORSO-VITTORIA.md','Percorso di vittoria e tracciamento delle citazioni residue')
graphics_profile=source(ROOT/'results/seed-and-saves/native-graphics-first-rooms.json','Confronto Spectrum con grafica attiva e disattivata')
graphics_first_read=source(ROOT/'results/seed-and-saves/native-graphics-first-read.json','Prima lettura casuale diversa con grafica attiva')
add(0xA296,0xA2AA,'Grafica · svuotamento della finestra prima del disegno','code','Diciotto ritorni a capo, con A019 azzerato a ogni giro. Dopo D nella sequenza per Victoria, 4500 e 4506 sono già zero all’ingresso di C129, prima dell’interprete grafico.',listed(0xA296,0xA2AA),graphics_first_read,priority=113)
add(0xC329,0xC33E,'Schermo · larghezza dello scorrimento e copia dei pixel','code','C33C copia 32 byte per riga pixel con testo largo e 16 con testo stretto. Nella prima divergenza grafica osservata durante D, solo questa copia cambia i byte 4500 e 4506.',listed(0xC329,0xC33E),graphics_first_read,priority=210)
add(0xD2CB,0xD2DB,'Casualità · miscelazione dei due byte di memoria','code','D2CB somma il primo byte all’accumulatore. D2D0 applica XOR al secondo e D2D9 ripete se l’accumulatore non cambia. Per Strachan al tick 24, 4500/4506 vale 00/00 con grafica e 11/04 senza grafica.',listed(0xD2CB,0xD2DB),graphics_first_read,priority=210)
add(0xF19A,0xF1A8,'DOMAIN · verifica percentuale con la soglia','code','D29D estrae da 1 a 100 e conserva IX/IY della regola. F1A1 confronta la soglia in A034 con il risultato. Nella prima divergenza grafica, Strachan trova 81 oppure 3 contro la stessa soglia 10.',listed(0xF19A,0xF1A8),graphics_first_read,priority=210)
add(0xA25D,0xA277,'Grafica · disponibilità dell’immagine della stanza','code','A011 governa la ricerca. Nel corridoio 007 la chiamata avviene ma non attiva il riquadro. Nell’ingresso 006 e a Baker Street 005 trova la voce e chiama l’interprete.',listed(0xA25D,0xA277),graphics_profile,priority=102)
add(0xA277,0xA296,'Grafica · avvio dell’interprete della stanza','code','Con immagine disponibile, A281 pulisce l’area superiore, A284 passa al testo stretto e A28D richiama F3C2. Verificato con D, S e LOOK nelle prime stanze.',listed(0xA277,0xA296),graphics_profile,priority=102)
add(0xC129,0xC142,'Schermo · attivazione delle 18 colonne','code','C12A azzera il contatore di pagina e C12E imposta C128. La prima descrizione dell’ingresso lascia C128=1 e il contatore a 6 contro 5 nel profilo senza grafica.',listed(0xC129,0xC142),graphics_profile,priority=102)
add(0xC142,0xC15D,'Schermo · ripristino delle 36 colonne','code','C142 disattiva C128. OPEN DOOR dopo l’ingresso torna alle 36 colonne anche se l’hash della bitmap resta diverso tra i due profili.',listed(0xC142,0xC15D),graphics_profile,priority=102)
add(0xC4D1,0xC4E8,'DOMAIN · caricamento del modello dell’azione','code','L’ID già selezionato in A033 punta al modello tramite A2B1. Il percorso ordinario non riesegue l’analisi lessicale del comando del giocatore. In SIT IN il modello mantiene il riferimento a IN 450, che il lexer può altrimenti interpretare come VISIT 956.',listed(0xC4D1,0xC4E8),victory_trace,priority=101)
add(0xF053,0xF05C,'Strachan · sedersi o alzarsi','domain','Con l’argomento FF il gioco cerca un posto adatto o il contenitore attuale. Con il seed 255 Strachan si siede sul divano dei Brown alle 15:01 e si alza alle 15:03. Entrambe le azioni costano due minuti.',[db(0xF053,0xF057,'SIT IN con argomento implicito. Se riesce, riprende da F029.'),db(0xF057,0xF059,'GET OUT OF con argomento implicito. Alla ripresa prosegue da F059.'),db(0xF059,0xF05C,'Salto a F029 per il prossimo giro.')],victory_trace,priority=116)
add(0x681A,0x682A,'Testo · rifiuto di un ordine','data','Frammento compresso «Sorry, I cannot do that now». I delimitatori scaricano cannot/that dal buffer: la pulizia della riga e la scansione del glifo alimentano 5D23 e 5D29.',listed(0x681A,0x682A),victory_trace,priority=101)
add(0x7E45,0x7E65,'Testo · viaggio in treno attraverso la campagna','data','La parola English può andare a capo. Il descrittore di count (51F7) resta in A022/A023 durante la coda letterale di countryside, e Lestrade lo legge alle 18:47.',listed(0x7E45,0x7E65),victory_trace,priority=101)
add(0x7DE1,0x7E0B,'Testo · viaggio in cab per le strade di Londra','data','La variante serale salta al testo dei lampioni. Nella corsa diurna la pulizia della riga nel frame 5D2C lascia il byte video a 5D24; your lo lascia a 5D2A nel frame 5D32.',listed(0x7DE1,0x7E0B),victory_trace,priority=101)
add(0xB049,0xB09A,'Citazione implicita e ripristino del delimitatore','code','Apre un TALK implicito se manca il verbo, accoda il puntatore in 9FEC e cerca un token 90 con valore zero. Sul treno, dopo una citazione residua, la ricerca rilegge il terminatore appena convertito da B8D1.',listed(0xB049,0xB09A),victory_trace,priority=100,fields=[['B05E–B07C','Puntatore alla citazione','Accoda l’indirizzo del token successivo alla virgoletta.'],['B085–B097','Chiusura','La scansione originale può proseguire oltre il buffer. Nel caso osservato torna a 5B8B e B095 ripristina C0.']])
add(0xB8AA,0xB90E,'Parser della citazione e creazione della richiesta','code','Analizza la citazione in una lista temporanea. Accetta anche l’unità vuota restituita con stato 2. Converte C0 in 90 e accoda la richiesta; sugli altri errori libera la lista temporanea.',listed(0xB8AA,0xB90E),victory_trace,priority=100,fields=[['B8C1–B8D1','Unità vuota','Se il puntatore residuo precede un terminatore di riga, il terminatore diventa una virgoletta visibile al parser esterno.'],['B904–B90D','Rifiuto interno','Libera i nodi temporanei della citazione e ripristina la lista precedente. Il TALK esterno può ancora consumare un minuto.']])
add(0xAAEA,0xAB47,'Citazioni · soggetto e unità vuota','code','Quando il puntatore residuo cade su ME seguito da un punto, AAEA seleziona il modo 2. AB43 restituisce stato 2 e il nodo conserva il soggetto nello slot a offset 24.',listed(0xAAEA,0xAB47),victory_trace,priority=100)
add(0xB224,0xB259,'Resolver · arresto al primo candidato','code','Il flag B190 controllato da B238 arresta la ricerca al primo candidato ammesso. Con CLIMB INTO CAB di Mrs Jones, il cursore è 8BC9, riga del cab 30.',listed(0xB224,0xB259),victory_trace,priority=100)
add(0xB96B,0xB97F,'Richieste · cursore dell’argomento','code','B973 e B976 copiano B17E nel record della richiesta. Il valore può essere l’indice del candidato selezionato oppure il terminatore.',listed(0xB96B,0xB97F),victory_trace,priority=100)
add(0xB9AC,0xB9FA,'Richieste rifiutate · rilascio dei nodi','code','B9AC avanza la lista sintattica anche dopo rifiuto. B9D4 scrive il nuovo puntatore prima del rilascio. Nel caso FOLLOW ME di Mrs Jones il record liberato conserva una word zero.',listed(0xB9AC,0xB9FA),victory_trace,priority=100)
add(0xCBA7,0xCBBB,'Rifiuto dell’ordine e canale di stampa','code','Il bit 6 del contesto DOMAIN impedisce alcune azioni richieste. CBAF seleziona il canale superiore e CBB5 stampa 681A. La proiezione del renderer revoca il residuo a partire da 5D06.',listed(0xCBA7,0xCBBB),victory_trace,priority=100)
add(0xBA20,0xBA3E,'Destinatari delle affermazioni','code','BA28 e BA2F selezionano Watson e Lestrade. Per un altro attore il ritorno con carry lascia la richiesta in lista. Verificato con Mrs Jones durante il suo turno ordinario.',listed(0xBA20,0xBA3E),victory_trace,priority=100)
add(0xD026,0xD03B,'DOMAIN · ripristino degli argomenti di lavoro','code','D031 ripristina il cliente già selezionato dopo il predicato E6EA. Nella traccia delle 12:31 la scrittura temporanea identifica Holmes, quella finale Lestrade.',listed(0xD026,0xD03B),victory_trace,priority=100)
add(0xCA76,0xCA7F,'Movimento · annuncio di partenza da una regola','code','Il corpo di ricollocazione usa la notifica ordinaria. Il nome qualificato di Lestrade passa dai frame 5D2A e 5D38 e aggiorna il buffer delle parole.',listed(0xCA76,0xCA7F),victory_trace,priority=101)
add(0xCBEA,0xCC0B,'Movimento · notifica di arrivo da una regola','code','Se il destinatario è percepibile, CC07 stampa la notifica con l’attore ripristinato. Il ritorno a Scotland Yard da EA21 usa 5D28 per il prefisso Inspector.',listed(0xCBEA,0xCC0B),victory_trace,priority=101)
add(0xCB12,0xCB28,'Movimento · annuncio di arrivo','code','CB22 seleziona il testo 68ED. Il qualificatore Inspector usa il frame 5D2C. Lo shift di colonna resta a 5D22 e 5D28: gli annunci successivi di Watson e della partenza del treno non li sovrascrivono.',listed(0xCB12,0xCB28),victory_trace,priority=101)
add(0xDD07,0xDD35,'Movimento · ritorno del record dell’attore','code','D237 lascia IX sul record dell’attore. D249 conserva entrambi gli indici: la cuoca alle 17:32 legge in CB28 il byte basso del record del giardiniere, dopo il suo movimento.',listed(0xDD07,0xDD35),victory_trace,priority=101)
add(0xDEE4,0xDF02,'Contenitori · capacità residua','code','Sottrae dalla capacità sia la dimensione del candidato sia il carico del contenitore, calcolato da D2ED. Un residuo nullo non è sufficiente.',listed(0xDEE4,0xDF02),victory_trace,priority=101)
add(0xE3B8,0xE3EA,'Veicoli · controllo di salita','code','E3B8 chiama E3F5 prima di verificare il contesto del conducente. Straker non sale sul cab pieno durante la corsa a Old Mill Road.',listed(0xE3B8,0xE3EA),victory_trace,priority=101)
add(0xE3F5,0xE40A,'Veicoli · preparazione del controllo di capacità','code','Recupera i record del candidato e del veicolo, poi usa la verifica comune DEE4.',listed(0xE3F5,0xE40A),victory_trace,priority=101)
add(0xEAC6,0xEACC,'Lestrade · passi vincolati durante l’inseguimento','domain','Tre operazioni di movimento verso nord con rifiuto degli ordini incompatibili. Il cursore riparte dal passo successivo dopo il rifiuto osservato sulla via del ritorno a Leatherhead.',listed(0xEAC6,0xEACC),victory_trace,priority=101)
add(0xE6BE,0xE6E6,'Cab · richiesta di pagamento e stampa della tariffa','code','E6CF stampa il frammento 6BB7. Il testo conserva E del buffer a 5D1E; quando guv’nor non entra nella riga, C374 usa il frame 5D30 e la scansione dello spazio salva F a 5D24.',listed(0xE6BE,0xE6E6),victory_trace,priority=100)
add(0xE6EA,0xE6F6,'Cab · presenza del passeggero','code','Verifica che il passeggero sia a bordo. E6F0 scrive il passeggero enumerato; D031 ripristina il cliente già legato al turno del cabbie.',listed(0xE6EA,0xE6F6),victory_trace,priority=100)
add(0xE710,0xE72F,'Cab · avvertimento per il debito','code','E725 stampa sotto un AF supplementare. Nella traccia a Portman Street il renderer C39D/C3B8 raggiunge 5D0E; il modello revoca il residuo temporaneo fin dove la provenienza non è proiettata.',listed(0xE710,0xE72F),victory_trace,priority=100)
add(0xD16B,0xD1B2,'Arrivo · descrizione generica del veicolo','code','D187 usa il veicolo come soggetto temporaneo. A Camden Street il nome del cab va a capo e C374 raggiunge 5D0E dal frame 5D1A.',listed(0xD16B,0xD1B2),victory_trace,priority=100)
add(0xD1B2,0xD1DA,'Arrivo breve · luce e nome della stanza','code','D187 stampa il qualificatore del personaggio travestito nel frame 5D22. Il nome della stanza usa D1C6; il ritorno a capo successivo conserva i byte 5D1A–5D21. Lo spazio di separazione usa il frame 5D2E.',listed(0xD1B2,0xD1DA),victory_trace,priority=100)
add(0xD53C,0xD562,'LOOK · contenitori e nome del cab','code','Lo spazio fra il qualificatore e il nome del cab entra nel renderer a 5D26. AF e BC dell’ultima scansione restano a 5D1A–5D1D anche dopo il congedo 6BF6 su una riga libera. La cuoca e il giardiniere leggono 5D1A e 5D1C.',listed(0xD53C,0xD562),victory_trace,priority=100)
add(0xD68C,0xD6B8,'Uscite visibili · direzioni e stampa','code','Il frammento 68FE fa scaricare la parola exits. Durante l’arrivo in cab a Camden l’ultimo glifo s resta nel frame 5D24. La cuoca legge i flag della scansione a 5D18 nove minuti più tardi.',listed(0xD68C,0xD6B8),victory_trace,priority=100)
add(0xE18A,0xE1A3,'Mrs Jones · registrazione della testimonianza','code','Con il tema 16, 17 o 67, E19D imposta il bit 1 di 9996. Nel percorso originale con entrambe le deduzioni, la testimonianza segue la confessione alle 13:19 e precede l’accettazione di Lestrade alle 13:53.',listed(0xE18A,0xE1A3),victory_trace,priority=100)
add(0x9981,0x9997,'Prova dell’omicidio di Tricia Fender','data','Albero della deduzione su Mrs Jones. Nel percorso originale i due bit delle premesse si attivano durante i dialoghi delle 13:19 e 13:21. Lestrade conferma la conclusione alle 13:53.',listed(0x9981,0x9997),victory_trace,priority=100,fields=[['9984','Conclusione','Bit 1 impostato dall’accettazione di Lestrade.'],['9992','Confessione','E1CF imposta il bit 1 durante il cambio d’identità.'],['9996','Testimonianza','E19D imposta il bit 1 quando viene raccontato un tema ammesso.']])
add(0x9E4A,0x9E6A,'Victoria · scelta del finale','code','Il selettore controlla la stanza di Holmes contro le stanze di Watson e Lestrade. Nel percorso originale di mercoledì alle 20:12, con entrambi presenti al binario 1, stampa 6AF3. Nella diramazione con Lestrade già uscito stampa 6B79.',listed(0x9E4A,0x9E6A),victory_trace,priority=100)
add(0x994D,0x9965,'Informazioni · parole dei predicati','data','Undici riferimenti little endian a parole del dizionario seguiti da una word zero. Il parser e il sistema delle affermazioni usano la stessa tabella immutabile; il generatore legge 994E sabato alle 09:15.',listed(0x994D,0x9965),source(ROOT/'results/information/information.asm','Predicati delle affermazioni'),priority=155)
add(0xA851,0xA852,'Testo · maiuscole forzate','data','Flag persistente. Il token 1B lo inverte anche nel testo fuori scena. AA59 lo legge prima del flag di inizio frase A026.',listed(0xA851,0xA852),source(ANALYSIS/'testo/text.asm','Disassemblato del testo originale'),priority=155)
add(0xA852,0xA85C,'Testo · inversione delle maiuscole forzate','code','Il dispatcher A593 invoca questa routine per il token 1B. XOR 01 cambia il flag; XOR A restituisce Z al dispatcher senza emettere testo.',listed(0xA852,0xA85C),source(ANALYSIS/'testo/text.asm','Disassemblato del testo originale'),priority=155)
add(0xA85C,0xA880,'Testo · suffissi delle parole','data','Nove record da quattro byte. Il byte 08 arretra nel buffer prima di aggiungere il suffisso. Gli zeri di riempimento fanno parte dei record letti dal generatore.',listed(0xA85C,0xA880),source(ANALYSIS/'testo/text.asm','Disassemblato del testo originale'),priority=155)
add(0xA24D,0xA25D,'Dizionario · due tabelle degli articoli','data','Due serie da quattro riferimenti little endian. A7EB sceglie la tabella secondo il canale e il tipo di annuncio. Il generatore legge A24E direttamente sabato alle 09:19.',listed(0xA24D,0xA25D),source(ANALYSIS/'testo/text.asm','Tabelle degli articoli del testo'),priority=155)
add(0xDA32,0xDA34,'Lexer · limite del gruppo alfabetico','data','DA54 scrive la word little endian 5DBF più l’offset del successivo gruppo non vuoto nell’indice 5D80. La punteggiatura e i numeri validi restano nel percorso DAC6. Dopo UNTIL il limite del gruppo U è 670A; il giardiniere legge 0A giovedì alle 10:16.',listed(0xDA32,0xDA34),source(ANALYSIS/'parser/parser.asm','Disassemblato del parser originale'),priority=155)
add(0xA033,0xA036,'DOMAIN · operandi della visita in corso','data','CE3B–CE62 risolve i due parametri di una regola; FF indica un argomento assente. F19A può leggere questi byte durante la propria estrazione. 9CF3 aggiorna separatamente il destinatario A034 prima di un incontro.',listed(0xA033,0xA036),source(ROOT/'results/brown-to-ending/brown-to-ending.asm','Analisi del ramo passivo Brown'),priority=155)
add(0xA02B,0xA02D,'Parser · cursore del prossimo token','data','Word little endian. AEA4 la avanza oltre il token appena letto. Per WAIT UNTIL 11PM resta 5B8B mentre A029 punta al punto B0 in 5B8A. Watson legge il byte basso giovedì alle 09:32. Il valore è restituito dal parser prima della gestione dell’attesa, sia in una chiamata sincrona sia con ripresa a ogni minuto.',listed(0xA02B,0xA02D),victory_trace,status='partial',priority=101)
add(0xAE7F,0xAEA9,'Parser · lettura del token e avanzamento','code','AE82 salva l’inizio in A029. AEA4 salva il prossimo token in A02B. Il punto B0 usa un solo byte.',listed(0xAE7F,0xAEA9),victory_trace,priority=101)
add(0xD780,0xD79D,'Parser · ingresso e restituzione del cursore','code','D78B inizializza A02B dal cursore di riga. D797 lo rilegge al ritorno del parser e D79A aggiorna il cursore di riga.',listed(0xD780,0xD79D),victory_trace,priority=101)
add(0x9A59,0x9A74,'Deduzione Tricia · allontanamento e risposta','code','Sposta Mrs Jones fuori scena, conferma il bit 1 a 9984 e stampa 6FCA. La risposta singola osservata conserva BC del precedente elenco a 5D12–5D13.',listed(0x9A59,0x9A74),victory_trace,priority=101)
add(0xD526,0xD53C,'Elenco visibile · nome dell’entità','code','D531 marca l’entità come vista e D539 richiama il formatter del nome. Nel denaro di Lestrade, l’ultima lettera di some lascia C e B del chiamante in 5D12 e 5D13.',listed(0xD526,0xD53C),victory_trace,priority=101)
add(0x9EA2,0x9EA4,'Vendita dei piani · intestazione DOMAIN','data','Intestazione della regola invocata da EAB3. Il corpo inizia in 9EA4.',listed(0x9EA2,0x9EA4),victory_trace,priority=101)
add(0x9EA4,0x9EC0,'Vendita dei piani · scelta del finale','code','Controlla il bit 1 dei record 9973 e 9981. Se entrambi sono confermati sceglie 6ABD. Negli altri casi 9E74 riceve 6A33.',listed(0x9EA4,0x9EC0),victory_trace,priority=101)
add(0xEAA9,0xEAB6,'Lestrade · innesco del finale della vendita','domain','Lestrade viene spostato fuori scena. EAAD aspetta le 10 e EAB3 chiama la regola 9EA2.',listed(0xEAA9,0xEAB6),victory_trace,priority=101)
add(0xEA25,0xEA5F,'Lestrade · condizioni per l’inseguimento','domain','Lestrade attende la deduzione sui piani e quella sul luogo della vendita. Quando sono confermate, EA5B lo manda a ovest e EA5D avvisa Straker. Percorso originale verificato da Scotland Yard a Old Mill Road.',listed(0xEA25,0xEA5F),victory_trace,priority=100)
add(0xEF7A,0xEF8C,'Basil · ultimi spostamenti verso il binario','domain','Prende un cab per Buckingham Palace Road, passa per l’atrio di Victoria e arriva al binario 1. EF83 prova la compresenza con Holmes prima di invocare 9E48. Nel percorso originale lo scarto di due minuti all’ingresso nel binario distingue i due finali.',listed(0xEF7A,0xEF8C),victory_trace,priority=100)
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
 add(a,b,title,'workspace',note,[],sid,status='partial',priority=100,fields=([['5D02','F della scansione durante il ritorno a capo','Nel cortile, il frammento 68E4 provoca il flush di door. con frame 5D14. C374 pulisce la riga con frame 5D0E e C3B8 scrive 5D02.'],['5D0E–5D11','Workspace sotto l’avvertimento del cabbie','E725 conserva un AF aggiuntivo. C39D/C3B8 hanno scritto 00 a 5D0E nel viaggio da Portman Street, tick 1728. Il modello revoca i residui precedenti in questo ramo.'],['5D18','F della scansione nel frame 5D24','Arrivo a Camden al tick 1803. C3B8 salva i flag dell’ultimo glifo di exits. La cuoca legge il byte al tick 1812. Il valore deriva dalla colonna e dallo shift del glifo.'],['5D15','A della scansione nel frame5D20; altri frame hanno ruoli distinti','C39D/C3B8: ottava riga grezza del font. TELL di MrsJones95 prima del destinatarioYOU scarica TO: ultimo glifo o,frame5D20,tick1472. Lettura cuoca9 al1519. HAIL DOMAIN invisibile non lo sovrascrive (SPmin5D4E); oldSAVE assente restaunknown. Altri frame:16=A chiamante,18=B chiamante,1A=D descrittore,1C=H video,1E=B scansione. Nessuno zero globale'],['5D30','F o altro registro: identità del frame necessaria','Frame5D32 salva F del CP0D del chiamante (q=26,n=10); clearC374 usaF54. Frame34=C chiamante,36=E descrittore,38=L video,3A=C scansione,3C=F scansione. CALL realeC374/frame30 lascia77. BC/return o chiamante ignoti revocano; vecchiSAVE assenti restanounknown.I byte 2B–31 hanno ulteriori ruoli nei nuovi contratti'],['5D25','A del carattere nel passaggio; sei ruoli secondo il frame','Nuovo frame5D26 del prefisso del passaggio:C388/PUSH AF salva A,codice del carattere emesso,indipendente daF a24. Writer naturale:Holmes0,n di plain,AF6E0A,tick1653/Tue11:32;giardiniere8 legge110 al3102/Wed11:41.904store su24/25(452 per byte),zero transizioni non classificate;nessun ulteriore store rispetto alla traccia precedente fermata al3012.1296ABI originali del glifo riutilizzate;test del modello su96codici supportati,nessun110 globale.720geometrie originali,290 valori noti coincidenti;720arrivi propri semplici e129rifiuti provati preservano. Clear profondi,wrap finale e nomi successivi non proiettati revocano;oldSAVE assente resta ignoto anche se24 è noto. Frame C388:5D26=A chiamante;5D28=B chiamante;5D2A=D descrittore;5D2C=H video;5D2E=B scansione prima diDJNZ;5D30=A ottava riga grezza del font. CALL realeC374 con frame5D24 lasciaC3 del returnC377. BC o return link ignoti revocano la proprietà; vecchi LOAD senza25 restano sconosciuti anche con24 noto. Nessuno zero catturato come fallback;2B ha un contratto indipendente'],['5D2A','L della posizione video nel frame verificato','Con ingresso C388 a5D32, C38B/C398 salva il byte basso di5020+floor((2+7*colonna)/8). Altri frame conservanoF/C chiamante, E descrittore, C shift o F scansione; CALL realeC374 con frame5D2A lascia77. Old LOAD senza2A resta sconosciuto anche con29 noto. Non inferire53 da una registrazione;2B ha un contratto indipendente'],['5D29','B della scansione o alto di altri registri','Nel frame5D32 dello spazio dopo plain, C39C/C3B7 salva B prima di DJNZ. Ultimo B=1, Holmes al tick1653. Il giardiniere legge il byte al3469 senza ulteriori scritture. Il ramo allineato conserva il valore di C39C. Gli arrivi lo conservano con riga fresca e margine prima del MORE. Altri frame: A/B del chiamante,D descrittore,H video,A del font. CALL realeC374/frame5D28 lasciaC3. OldLOAD assente restaunknown anche con28 noto;25 ha un contratto distinto per il byte alto'],['5D1A / 5D1B','F / A, provenienza condizionata','Con frame glifo5D26: flag e ottava riga non allineata del font. Il nuovo dossier verifica il chiamante della pulizia del prefisso qualificato'],['5D1B','altri frame','Con frame5D24 conserva B=1; le stampe prive di contratto revocano la proprietà. Nessun valore iniziale mostrato come stato corrente'],['5D1C','C dello shift nel frame verificato','Con frame5D26: (2+7*colonna)&7. D60B/D658 scarica il qualificatore plain prima di door; ultimo n,colonna21,tick1653/Tue11:32,writerC3B7,lettura giardiniere8 al2156/Tue19:55.720ABI passaggi movimento/LOOK. CBC2 ordinaryAction con persona propria semplice preserva1A–1D; nomi composti hanno controesempi. Errori direzionali e EXAMINE semplice assente senza prosa:129ABI completi. Altri chiamanti revocano; oldSAVE assente restaunknown.5D1D=B indipendente,nessun5 globale'],['5D1D','B salvato nel frame verificato','Frame5D26: contatore della scansione salvato PRIMA di DJNZ, ultimo valore1. Non è un valore globale: gli altri frame conservano A del chiamante, B del chiamante, descrittore, indirizzo o byte del font. GO TO verificato preserva; vecchi LOAD restano sconosciuti'],['5D21','D del descrittore nel prefisso del passaggio','C38A/PUSH DE,frame5D26,n di plain,DE5C0B,Holmes0,tick1653/Tue11:32;giardiniere8 legge92 al3288/Wed14:47. Traccia3020store su20–27 identica alla precedente fino alla lettura successiva,zero transizioni non classificate. DerivareD dal parametro completo,non daE20/92;144varianti originali del descrittore. LOOK/remote/container ecaller sconosciuti esclusi;oldSAVE assente restaignoto'],['5D20','E del descrittore nel prefisso del passaggio','C38A/PUSH DE,frame5D26,n di plain,DE5C0B,Holmes0,tick1653/Tue11:32;cuoca9 legge11 al3195/Wed13:14. Derivare dal parametro effettivo,non dal vicinoD o da0B fisso.144varianti del descrittore e1296ABI dei ruoli.26 ha un contratto distinto per lo spazio successivo. Scene root dopo movimento;LOOK/remote/container e caller non verificati restano ignoti. OldSAVE assente restaunknown,21 non introdotto'],['5D1F','H del video nel prefisso qualificato del passaggio','D658/C388 SP5D26: C38B/C398 salva H di5020+floor((2+7*colonna)/8). Ultimo n di plain,Holmes0,tick1653/Tue11:32;cuoca9 legge80 al2566/Wed02:45.974store senza transizioni nonclassificate,720ABI passaggi. Arrivi ordinaryAction propri semplici e129rifiuti provati preservano il byte;LOOK,remote,container,nomi composti e altri errori revocano. Frame5D2A ha inveceA del font,nonH. OldSAVE assente restaunknown;1E rimane indipendente,nessun80 globale'],['5D1E','L video nel passaggio; altri ruoli secondo il frame','Nuovo frame5D26:C38B/C398 conserva L di5020+floor((2+7*colonna)/8). Ultimo n di plain,colonna21,Holmes0,tick1653/Tue11:32;giardiniere8 legge50 al3012/Wed10:11.974store su1E/1F(487 per byte),zero transizioni non classificate.720geometrie originali:290valori noti coincidenti,L assume19valori. Proprietà indipendente da1F e24;nessun50 iniziale né riparazione oldSAVE. Frame5D2A: C39D salvaF diINC H; C3B8 salvaF diDEC/INC C. Calcolo daindirizzo video/shift, non0 di default. Altri frame conservanoF/C del chiamante,E del descrittore,L video,C scansione. GO TO verificato preserva; old LOAD assente resta sconosciuto'],['5D28','Offset C della scansione, incluso lo spazio di passaggio','Nel frame5D32 dello spazio dopo il qualificatore, C39C e, con offset nonzero, C3B7 salvano (2+7*colonna)&7. Colonna22:4. Il campo resta distinto da AF26/27 e B29. Frame5D32 del prefisso proprio della destinazioneCE13: C39C/C3B7 conservano(2+7*colonna)&7. Non un2 globale. RamoC0 saltaC3B7. OldLOAD assente restaunknown anche con27 noto;25 ha sei ruoli distinti per il byte alto;29 ha un contratto B distinto'],['5D27','A grezzo del font: spazio del passaggio e altro nome verificato','Nuovo caller:spazio dopo plain,frame5D32,colonna22,descriptor526E,C3B8/AF0000,tick1653/Tue11:32;giardiniere8 legge0 al3288. Il byte viene dal font prima delle rotazioni,non dal pixel/codice32 o daF26. Traccia estesa invariata3020store,zero transizioni non classificate.27 ha lo stesso limite di riga nuova e counter+2<15 verificato indipendentemente;vecchiSAVE assenti restanoignoti anche con26 noto. Frame5D32 del prefisso proprio della destinazione CE13: C39D/C3B8 salvano glyph[7] prima dello shift. Non il byte della bitmap e non F di26: t=0,q=6,underscore=255. OldLOAD assente restaunknown;25 ha sei ruoli distinti per il byte alto;29 ha un contratto B distinto;28 ha il contrattoC della scansione'],['5D26','F della scansione dello spazio del passaggio o del nome locazione','Nuovo chiamante:spazio dopo plain,frame5D32,colonna22,descriptor526E,C3B8/AF0000,tick1653/Tue11:32,cuoca9 legge0 al3195/Wed13:14. Calcolo daINC H e shift,non0 iniziale.300controlli riga fresca counter0..14;20dei720arrivi propri su riga parziale alterano26. Runtime:riga nuova,buffer vuoto,nome cheentra,counter+2<15. Il prefisso Inspector richiede un qualificatore nel record; il probe CBC2 senza qualificatore stampa Lestrade. Altri caller,wrap eMORE non proiettati revocano;27 non introdotto,oldSAVE assente resta ignoto. Il prefisso proprio della destinazione nell’ordine CE13 usa frame5D32 e sovrascriveC del precedente nome attore5D2A. C3B8 salvaF della scansione; il sostantivo finale rimane nel buffer. OldLOAD assente restaunknown;25 ha sei ruoli distinti per il byte alto;29 ha il contratto B della scansione;28 ha il contrattoC della scansione;27 ha un contratto distinto perA del font'],['5D24','F chiamante nel passaggio; E descrittore in altro frame','Nuovo frame5D26:C388 conserva F del CP0D del canale superiore(C2C6/C2EE). Ultimo n di plain,AF6E0A,Holmes0,tick1653/Tue11:32;giardiniere8 legge10 al3012/Wed10:11 nella stessa estrazione di1E.904store su24/25(452 per byte),zero transizioni non classificate. CP indipendente256casi,glifi supportati confrontati; q26/n10,non10 globale.720geometrie,290valori noti;arrivi propri semplici720/1512 e rifiuti129/138 preservano. Scrolling,wrap finale e nomi successivi non proiettati revocano;vecchiSAVE assenti restano ignoti. Frame5D2A: C38A salvaDE prima del puntatore al font. Byte basso del descrittore fornito dal chiamante; buffer parola5C0B, non valore globale0B. Altri frame conservanoF/C chiamante,L video,C/F scansione. Old LOAD assente resta sconosciuto;5D25 ha sei ruoli distinti per il byte alto;5D29 ha il contratto B della scansione;5D26/5D27 hanno contratti distinti nel nome locazione'],['5D23','Sei ruoli: B del chiamante nel passaggio verificato','Nuovo frame5D26:C389 conserva B,numero di caratteri rimanenti fornito daA9F5. Ultimo n di plain,tick1653/Tue11:32,letto dalgiardiniere8 al2926/Wed08:45.554 scritture su22/23 (277 per byte), nessuna transizione non classificata. Non1 globale:ABI conB3/7. Altri frame24=A chiamante,28=D descrittore,2A=H video,2C=B scansione,2E=A font. Scrolling C316 può riscriverlo dalprologo:percorsi non proiettati revocano.720 ABI passaggi:290 valori noti coincidenti;1296 ABI glifo riutilizzate. Wrap finale e nomi successivi non proiettati revocano. Vecchi SAVE assenti restano ignoti;22 indipendente'],['5D22','C del chiamante nel passaggio; L video in altro frame','Con frame5D26, C389 salva C = (2+7*colonna)&7 mentre viene emesso il qualificatore. La n di plain alla colonna21 lascia5. Con frame5D2A: (5020+floor((2+7*colonna)/8))&FF. Il prefisso del nome dell’attore nell’ordine682A salva HL a C38B/C398; gli altri chiamanti revocano, vecchi LOAD rimangono sconosciuti. 5D23 ha un contratto H indipendente;5D24 ha il proprio contratto E;5D25 ha sei ruoli distinti per il byte alto;5D29 ha il contratto B della scansione;5D26/5D27 hanno contratti distinti nel nome locazione']]if a==0x5CEC else [['5C13','Nono byte del buffer di parola','La listaD526/D3D5 del salotto scrive bloodstained da4109: i alposto8,Holmes0,tick1651/Tue11:30. Clothes e parole più corte lasciano la coda; cuoca9 legge105 al1882/Tue15:21. Derivare dal dizionario e dalla sequenza grezza, non dal testo maiuscolo visibile o da un105 fisso. Elenchi a terra, inventari e contenitori condividono il formatter; nomi non corrispondenti restanounknown. LOAD preserva i byte e non riempie assenze vecchie']] if a==0x5C0B else None))

# Runtime-only fields are shown without inferring their current value from
# the static tape. Keep them on the pre-existing workspace entries.
brown_fields = {
 0x5C0B: [
  ['5C12','Ottavo carattere grezzo','A9D7 scrive la e di entrance nei nomi di locazione stampati all’ingresso.'],
  ['5C13','Nono carattere grezzo','A9D7 scrive la t di northeast nella direzione di un passaggio.'],
  ['5C12–5C14','Coda di una direzione stampata','D6A6 e A414 stampano southeast. sulla sponda est. Il successivo svuotamento del buffer conserva s, t e il punto, letti dal generatore durante l’attesa del martedì.'],
  ['5C36–5C3A','Variabili di sistema nella coda del buffer','All’avvio CHARS=3C00 da ROM 121F; RASP/PIP=0040 da ROM 1215; ERR-NR FF da ROM 12F8. Il giardiniere legge RASP 40 giovedì alle 18:42. Le successive copie lessicali lunghe possono sovrascriverle.'],
  ['5C3D–5C41','Puntatori BASIC e modo del cursore','Nel profilo 48K, ROM 122B inizializza ERR-SP a FF54, tre byte sotto RAMTOP. LIST-SP e MODE restano zero fino al riuso come spazio di lavoro.'],
  ['5C42–5C50','Candidati del dizionario decompresso','A95B conserva il prefisso e A92F aggiunge i quattro byte del suffisso. Il lexer decodifica prima di scartare i record D0 o fermarsi sul primo candidato dopo una corrispondenza esatta. Dopo UNTIL, UP lascia p e zero, mentre il resto conserva la coda dei candidati precedenti.'],
  ['5C51–5C52','Canale BASIC fuori dallo spazio di lavoro del candidato','CURCHL punta al canale dello stream 2 del loader. Nessuna voce del dizionario originale scrive oltre 5C50.'],
  ['5C53–5C54','Indirizzo di inizio del programma BASIC','La ROM carica CHANS=5CB6 e copia 21 byte, incluso il terminatore, da 15AF. Il primo byte libero 5CCB diventa PROG. Il caricatore conserva l’inizio del programma.'],
  ['5C55–5C56','Prossima riga BASIC','1BD1 calcola NXTLIN dall’intestazione di quattro byte e dalla lunghezza della riga 5. LOAD e USR condividono quella riga. Il valore 5CE2 sopravvive nella coda del buffer.'],
  ['5C57–5C58','Puntatore DATA del BASIC','1246 salva PROG meno uno in DATADD. Il caricatore non usa READ e conserva il puntatore iniziale.'],
  ['5C59–5C5E','Riga editor e cursori BASIC','167C sposta E-LINE e K-CUR dopo la riga caricata e il terminatore delle variabili. 26C0 conserva in CH-ADD la posizione dopo il valore numerico passato a USR.'],
  ['5C5F–5C60','Riferimento al primo header di caricamento','0878 salva X-PTR. Il caricamento del BASIC e la successiva riserva di due header spostano il riferimento tramite 167C.'],
  ['5C61–5C66','Spazio di lavoro e pila del calcolatore BASIC','16A8 ripristina WORKSP dopo la lettura del nome. 16C2 e 16C8 allineano STKBOT e STKEND; il calcolatore ripristina la base dopo aver consumato l’operando di USR.'],
  ['5C67–5C69','Operazione e memoria del calcolatore BASIC','335F conserva BREG. Il token USR C0 passa da 26ED, 26FE e 2753, diventando 2D. 16CF inizializza MEM a 5C92.'],
  ['5C0E','Quarto carattere di una direzione annunciata','Il movimento del giardiniere lascia la t di west in A9D7. Un output successivo più corto non la cancella.'],
 ],
 0x5CEC: [
  ['5D15','Ultima riga del glifo durante la pulizia','Nel percorso di vittoria, A89F chiama il renderer mentre stampa wall safe. C374 cancella la nuova riga con SP 5D20. C3B8 salva l’ultima riga dello spazio. La lettura casuale delle 09:54 conserva il byte scritto alle 03:19.'],
  ['5D16 / 5D17','AF durante il ritorno a capo della direzione','Il frame 5D22 di C374 salva AF della scansione quando north non entra nel resto della riga. La successiva stampa di is nel frame 5D24 aggiorna invece 5D18/19.'],
  ['5D1A–5D21','Registri del frame 5D22 nella descrizione breve','A 5D1A–1B resta HL video, a 5D1C–1D DE del buffer e a 5D20–21 AF del carattere. Nella traccia notturna persistono fino alle letture del mattino. Lo spazio del frame 5D2E lascia A del font a 5D23.'],
  ['5D17','A del font nel frame 5D22','Il qualificatore china nella descrizione breve passa per D187 e 68DD. C3B8 conserva l’ultima scansione di a; Watson legge 5D17 al tick 2316.'],
  ['5D17','H del video durante la pulizia','Nel salotto di Tricia C398 conserva H dopo wall. La congiunzione prima del nome proprio scorre su un frame differente.'],
  ['5D19 / 5D1A','A grezzo del font e C dello shift','C3B8/C3B7 con frame 5D24 durante la richiesta di pagamento 6BB7. La o di to viene scaricata mentre comincia il nome del destinatario.'],
  ['5D2B','H della posizione video nel frame 5D32','C38B/C398 salva il byte alto di 5020+floor((2+7*colonna)/8) per lo spazio dopo il qualificatore del passaggio.'],
  ['5D32–5D35','AF e BC lasciati dallo scorrimento inferiore','Nel rifiuto di EXAMINE ROCK, C3B7 e C3B8 nel frame 5D3E conservano i registri dell’ottava scansione dell’ultimo spazio a x=246. Il contatore è ancora 1, lo shift vale 6. Le attese successive conservano questi quattro byte. Il puntatore video a 5D36–5D37 ha una storia di scritture distinta.'],
  ['5D36–5D37','Ritorno del decoder dell’articolo per la richiesta di tariffa','A809 salva A80C quando 6BB7 cerca l’articolo del nome del cocchiere fuori scena. A887 ritorna con 5C3C a zero. Il giardiniere legge A8 giovedì alle 17:06, dopo la sostituzione del precedente indirizzo video 50FE.'],
  ['5D38–5D3F','Salvataggi del nome del cocchiere fuori scena','A827 salva HL sull’articolo scelto nel dizionario; D442 lascia D445; D3E9 salva l’offset del testo chiamante; D3E8 lascia A=ID del cocchiere e F dai calcoli del suo record.'],
  ['5D40–5D45','Scelta del tono e nome del destinatario della tariffa','D2D3 salva il puntatore A6D3 dopo aver letto la coppia casuale. A7D8 e A827 lasciano 09EE nel nome proprio del destinatario; il richiamo 6C54 più tardi sostituisce il ritorno precedente a 5D44–5D45 con A80C.'],
  ['5D46–5D4F','Scarico del punto del treno fuori scena','Con 7611, il dizionario viene soppresso ma il punto si scarica. C1E1 conserva AF, A9FD il ritorno AA00, A9F4 BC e A9EC il confronto della larghezza. A9DF salva il descrittore finale del testo. Altri chiamanti riscrivono alcuni della stessa famiglia di slot.'],
  ['5D48–5D51','Apertura, chiusura e attraversamento fuori scena','L’annuncio di una porta comune può sostituire il ritorno del treno con A80C. A827 salva l’indice della tabella scelta da A2E4. A398 lascia in C il flag del modello dell’azione, che A9F4 salva quando scarica il punto.'],
  ['5D54–5D5D','Ricerca della direzione D471/DD6E','D231 salva l’indirizzo ricavato dall’indice 840B. D228 e D224 salvano rispettivamente il predicato e la coppia di operandi. D344 conserva il ritorno, D33C AF della destinazione.'],
  ['5D5E–5D5F','Ricerca di un’entità nella verifica del passaggio','C7FE chiama C821. Nel frame DOMAIN ordinario C863 passa per D237 e D363 lascia il puntatore al record nell’indice 8B6F. D212 e D344 possono riscrivere gli stessi byte.'],
  ['5D60–5D69','Ingresso del calcolo percentuale F19A','D2AF salva B della visita precedente e C del primo operando. D2AD salva IX del ponte CB28. D2A4/D29F/F19A lasciano tre ritorni. D486 usa 5D60–61 anche durante la scansione di un’uscita.'],
  ['5D2C–5D31','Ultima cella della pulizia della console','C271/C293 conservano AF e BC della scansione e HL video nel frame 5D38. L’ultima cella parte da x=246.'],
 ],
}
for candidate in candidates:
 if candidate['kind']=='workspace' and candidate['start'] in brown_fields:
  candidate['fields'].extend(brown_fields[candidate['start']])

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
