"""Checked typed excerpts: countryside glyph ownership and next saved-rule index."""
import json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
memory=bytes(0x5d80)+(project/'sherlock-analisi/block-10.bin').read_bytes();assembler=Assembler()
regions=[(0xa9df,0xaa10,'code','Scarico della parola e CR esterno'),(0xc388,0xc3e4,'code','Font A e descrittore D salvati indipendentemente'),(0xd16b,0xd187,'code','Descrizione della stanza mobile e decoder'),(0xcb28,0xcb2c,'data','IX e IY temporanei delle regole'),(0xcb2c,0xcb41,'code','Chiamata del predicato/corpo e salvataggio degli indici')]
notes={0xA9DF:'English resta in buffer fino al riferimento successivo. La parola esce nel frame del decoder7E45,non nel chiamante finale del CR.',0xA9F5:'BC del chiamante contiene caratteri residui e shift;non e A dell ultima riga del font.',0xC388:'English nel testo della campagna: frame5D2E. Nuova proprietà A23 della scansione e D29 del descrittore,indipendenti dai BC/video già ricostruiti.',0xC38A:'PUSH DE nel frame5D2E salva D in5D29. Nel writer naturale3504,DE=5C0B; il valore deriva dal parametro,non da92costante.',0xC39D:'Il ramo allineato conserva A prima della rotazione. Vale la stessa formula di scansione del ramo con shift.',0xC3B8:'Ultima h di english,tick3504,giocatore0,frame5D2E:salva A grezzo dell ottava riga del font in23. Il valore0 osservato non e un fallback.',0xC3D2:'Il decremento segue la scansione corrente. A proviene dal font prima delle rotazioni sullo schermo.',0xD171:'D182 riceve il frammento descrittivo dalla stanza. Per il treno in corsa e7E45.',0xD184:'Con puntatore nonzero entra in A59F. Nel percorso naturale A59F/SP5D5A scarica English a C388/SP5D2E;CRsuccessivo A9B7/SP5D58.',0xCB28:'Dati mutabili: IX/IY del predicato e corpo. Gli zeri sono solo il payload iniziale,non il valore durante la partita.',0xCB37:'Prossimo limiteCB29:salva IX. Al3581,l attore104 ritorna dal callbackE5AA con IX9997 eIYDDBE;il giardiniere legge il byte99. Contratto specifico del callback ancora non ricostruito.'}
lines=['; Analisi offline Sherlock1984. Dati e codice distinti;nessuna CPU nel motore JS.'];count=total=0
for a,b,kind,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=b-at;op='DEFB '+','.join(f'${v:02X}'for v in memory[at:at+n])
  else:op,n=disassemble(memory,at);count+=1
  assert at+n<=b;assert bytes(assembler.assemble(op,at))==memory[at:at+n]
  lines.append(f'    {op:<36} ; ${at:04X} {memory[at:at+n].hex(" ")}' + (' | '+notes[at]if at in notes else''));at+=n;total+=n
out=root/'results/train-countryside-font';(out/'train-countryside-font.asm').write_text('\n'.join(lines)+'\n');(out/'listing-verification.json').write_text(json.dumps(dict(instructions=count,bytes_roundtripped=total,roundtrip_equal=True,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=98)for a,b,k,l in regions]),indent=2)+'\n');print(count,total)
