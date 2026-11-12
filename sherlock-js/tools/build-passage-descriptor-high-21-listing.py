"""Typed source dossier: passage descriptor D and delimiter raw font A."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(49850, 49926, 'code', 'Canale superiore: A conservato prima del renderer'), (50056, 50148, 'code', 'Glifo: descrittore alto D e byte grezzo del font dello spazio'), (49942, 50056, 'code', 'Scroll: salvataggi esterni e revoca dei chiamanti non ricostruiti'), (54795, 54897, 'code', 'Passaggi: frame distinti del qualificatore e del separatore'), (52162, 52235, 'code', 'Arrivi propri semplici: conservazione provata fino a 5D25'), (49661, 49728, 'code', 'Rifiuti semplici: conservazione indipendente di 5D21 e 5D27'), (43029, 43055, 'code', 'Riferimenti nominali: ingresso del sostantivo nel decoder'), (43143, 43193, 'code', 'Decoder: spazio che scarica il qualificatore prima del sostantivo'), (54229, 54344, 'code', 'Nomi: qualificatori, sostantivo e loro descrittori distinti')]
notes={49862: 'CP 0D modifica F ma conserva A. Per il glifo ordinario JR NZ e CALL C388 non cambiano il codice del carattere: A e F hanno contratti indipendenti.', 49902: 'Il canale superiore passa il carattere a C388. Nel frame5D26 PUSH AF conserva A a5D25. Non è il byte grezzo dell ultima scansione del font, che occupa questo indirizzo in altri frame.', 50056: 'Nuovo contratto: A del chiamante salvato a5D25 nel prefisso del passaggio,frame5D26. Il modello deriva il codice del carattere emesso,non110 fisso.1296ABI originali dei sei ruoli riutilizzate; test del modello su tutti96 codici di glifo supportati. Traccia naturale estesa:Holmes0,n di plain,AF6E0A,tick1653/Tue11:32;giardiniere8 legge110 al3102/Wed11:41.904 scritture su24/25(452 per byte),zero transizioni non classificate;stessa sequenza904store della traccia precedente,nessun nuovo store fino al read successivo.', 50059: 'PUSH HL salva l’indirizzo bitmap prima della ricerca del font. La posizione deriva da x=2+7*colonna,HL=5020+floor(x/8); il byte L è indipendente dalla conoscenza di H.', 50072: 'Ultimo writer naturale di5D1E: risalva HL5032,Holmes0,n di plain,frame5D26,colonna21,tick1653/Tue11:32,returnD65B. Giardiniere8 legge50 al3012/Wed10:11. 974 scritture su1E/1F (487 per byte),nessuna transizione non classificata. Non un50 costante.', 49949: 'BC/HL/DE del prologo di scroll possono riscrivere25 sopra il frame del glifo. Il nuovo contratto revoca i clear profondi non proiettati,anche se il solo glifo non scrive25.', 50036: 'La vera CALL salva C377:frame5D24 lascia C3 a25. Questo ruolo già dimostrato non autorizza a preservare il carattere di un vecchio frame; il return sintetico0008 resta una prova distinta.', 54872: 'Prefisso del passaggio dopo movimento,root e nome grezzo verificato: nuovo caller A a25,indipendente dal caller F a24.720geometrie originali riutilizzate:290 valori noti coincidenti. LOOK,remote econtainer fuori dal nuovo contratto.', 52198: '26 ha un contratto più stretto di20:20dei720 arrivi propri eleggibili alterano26 su riga parziale.300nuovi controlli a colonna0,counter0..14,preservano26. Il runtime ammette solo riga fresca,nome cheentra e counter+2<15,260setup;queued/isolated esclusi. Il medesimo controllo originale è verificato indipendentemente per27:20wrap lo cambiano,300riga fresca lo preservano;runtimecounter+2<15.', 49691: '129pipeline di errore semplici preservano20 e26;qualificatori,prosa eNPCcaller esclusi. La conservazione non crea un byte assente in un vecchioSAVE.', 50075: 'Carica A dalla riga del font;questo byte è distinto dal codice del carattere già salvato dal chiamante. Il nuovo27 deriva da glyph[7],prima delle rotazioni e senza leggere il pixel composto.', 50058: 'Writer20 naturale:E del parametro DE5C0B,Holmes0,n di plain,frame5D26,tick1653/Tue11:32. Cuoca9 legge11 al3195/Wed13:14. Non un0B fisso:144varianti originali del descrittore più1296ABI dei ruoli. Nuovo21:D dello stesso parametro,non inferito daE;giardiniere8 legge92 al3288/Wed14:47 dopo traccia estesa.', 50077: 'PUSH AF conserva F della scansione prima delle rotazioni. Con frame5D32 F occupa5D26. Calcolarlo daINC H e dallo shift;il byte27 diA non viene introdotto daquesto contratto.', 50104: 'Ultimo writer26 naturale:AF0000 durante lo spazio dopo plain,frame5D32,colonna22,descriptor526E. Holmes0,tick1653;cuoca9 legge0 al3195. Non lo stesso glifo n che scrive20,e non uno0 di inizializzazione. Nuovo27:A grezzo dell ottava riga del font dello spazio,in questo caso0. Il giardiniere8 legge0 al3288,stesso writer1653. Non copiareF26 né assegnare0 di default.', 43029: 'Ingresso del riferimento lessicale del sostantivo. L emissione dello spazio iniziale può scaricare la parola precedente; il descrittore del sostantivo non è il puntatore al buffer della parola.', 43167: 'Durante il separatore del sostantivo,il ritorno A89F è nella traccia del glifo spazio,frame5D32. Il nuovo26 appartiene soltanto a questa emissione provata;non a ogni carattere del nome.', 54328: 'Carica il sostantivo nel descrittore 5000|noun. Nel caso naturale526E il separatore entra aC388 come spazio,mentre il precedente n usaDE5C0B. Distinguere i due frame ed entrambi i parametri.'}
scan_count = '--scan-count' in sys.argv[1:]
caller_c = scan_count or '--caller-c' in sys.argv[1:]
if caller_c:
 descriptions = {
  0xC388: 'Glifo: offset C del chiamante e offset C della scansione',
  0xD60B: 'Passaggi: offset del qualificatore e dello spazio successivo',
  0xCBC2: 'Arrivi propri: effetti dello scorrimento sugli offset conservati',
  0xC1FD: 'Rifiuti semplici: conservazione dei due offset',
 }
 regions = [(start, end, kind, descriptions.get(start, label)) for start, end, kind, label in regions]
 extra = {
  0xC389: 'Nel frame $5D26 PUSH BC conserva C in $5D22. C = (2 + 7 * colonna) & 7. B è il conteggio conservato separatamente in $5D23.',
  0xC39C: 'Prima delle rotazioni, PUSH BC conserva C nel byte $5D28 con frame $5D32. Vale anche con C = 0.',
  0xC3B7: 'Con C diverso da zero, la metà successiva del glifo salva di nuovo lo stesso C. Per lo spazio dopo plain (colonna 22) il valore salvato è 4.',
  0xC31D: 'I salvataggi esterni dello scroll e la relativa CALL possono raggiungere $5D22 e $5D28. Un percorso con stack non ricostruito revoca il valore noto.',
  0xCBC2: 'Nei 720 arrivi propri eleggibili, tutti preservano $5D22. In 110 casi lo scorrimento riscrive $5D28. I 300 controlli su riga fresca preservano entrambi.',
  0xC1FD: 'I 129 rifiuti semplici controllati preservano $5D22 e $5D28 lungo la pipeline completa.',
  0xD658: 'Il qualificatore e il separatore sono emessi a profondità diverse. Il valore C viene calcolato dalla colonna effettiva di ciascun glifo.',
 }
 for address, annotation in extra.items():
  notes[address] = (notes.get(address, '') + ' ' + annotation).strip()
if scan_count:
 descriptions = {
  0xC388: 'Glifo: conteggio B e offset C della scansione',
  0xD60B: 'Passaggi: scansione del glifo dello spazio separatore',
  0xCBC2: 'Arrivi propri: conservazione del conteggio B su riga fresca',
  0xC1FD: 'Rifiuti semplici: conservazione di BC della scansione',
 }
 regions = [(start, end, kind, descriptions.get(start, label)) for start, end, kind, label in regions]
 extra = {
  0xC399: 'B parte da 8, un passaggio per ciascuna riga del glifo.',
  0xC39C: 'Il salvataggio nel frame $5D32 mette B in $5D29. Nel ramo allineato questa è anche l’ultima scrittura.',
  0xC3B7: 'Lo spazio dopo plain risalva BC = $0104. Holmes lascia B = 1 martedì alle 11:32. Il giardiniere legge il byte mercoledì alle 17:48.',
  0xC3D2: 'DJNZ riduce il contatore dopo aver disegnato la riga. L’ultimo PUSH conserva B = 1 prima del decremento a zero.',
  0xC31D: 'Il prologo e la CALL C374 possono sostituire il byte alto della coppia. Nel frame $5D28 il ritorno C377 lascia C3 in $5D29.',
  0xD658: 'Il separatore emesso dal chiamante verificato fornisce il conteggio B indipendentemente dall’offset C.',
  0xCBC2: 'Lo scorrimento riscrive $5D29 in 110 su 720 arrivi propri controllati. Tutti i 300 controlli su riga fresca lo preservano.',
  0xC1FD: 'I 129 rifiuti semplici eleggibili preservano anche $5D29.',
 }
 for address, annotation in extra.items():
  notes[address] = (notes.get(address, '') + ' ' + annotation).strip()
listing = ('passage-scan-count-29' if scan_count else
           'passage-caller-c-22' if caller_c else 'passage-descriptor-high-21')
lines=['; Dossier offline: istruzioni e dati tipizzati, verificati e riassemblati sul payload.'];count=total=0
for a,b,kind,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=b,(hex(at),op);assert bytes(asm.assemble(op,at))==m[at:at+n]
  lines.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}'+(' | '+notes[at]if at in notes else''));at+=n;total+=n
root=p/'sherlock-js/results'/listing;root.mkdir(exist_ok=True);(root/(listing+'.asm')).write_text('\n'.join(lines)+'\n');(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=187 if scan_count else 186 if caller_c else 185)for a,b,k,l in regions]),indent=2)+'\n');print(count,total)
