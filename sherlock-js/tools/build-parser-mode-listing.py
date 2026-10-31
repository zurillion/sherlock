"""Typed source dossier: parser mode writers, quoted units and ordinary entry."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(0xA024,0xA025,'data','Modalità sintattica persistente:0 automatica,1 comando,2 affermazione'),(0xAAB2,0xAB11,'code','Parser comune: continuazione e scelta speculativa della modalità'),(0xB135,0xB16D,'code','Pronomi HE e IT/THEY: writer espliciti della modalità affermazione'),(0xB8AA,0xB90E,'code','Citazione differita: modo0 una volta, conservato fra le unità e nel record'),(0xD780,0xD7B2,'code','Parser ordinario: modo1 a ogni ingresso, prima dell’analisi')]
notes={0xA024:'Byte persistente.0 autodetect,1 comando,2 affermazione. Il lexer non lo resetta. Vecchi LOAD senza campo restano sconosciuti fino a un writer verificato; non installare1 dal riferimento casuale.',0xAACC:'Una continuazione pendente forza1 prima della scansione comune, anche se il chiamante citato era in modo0.',0xAAD2:'Legge il modo corrente: il parser comune non lo azzera automaticamente a ogni unità.',0xAADF:'In modo0 tenta il gruppo soggetto. Relazioni o fallimento ripristinano il cursore e passano al comando.',0xAAEC:'Soggetto riconosciuto senza relazioni: scrive2, poi copia i sei byte del soggetto nel nodo.',0xAB0A:'Scansione speculativa fallita: scrive1 prima di ripristinare il cursore dei token.',0xB13A:'HE scrive2 dopo il controllo AFE1; errori prima del controllo non costituiscono writer.',0xB156:'IT/THEY scrivono2 dopo il controllo AFE1; il flag del soggetto resta distinto dalla modalità.',0xB8B1:'Ingresso nella citazione: scrive0 una sola volta. Non ristabilire0 fra le frasi della stessa citazione.',0xB8BE:'Ripete AAB2 conservando A024; una frase comando non riattiva autodetect per il soggetto seguente.',0xB8FC:'Legge il modo finale e lo conserva al byte7 del record: non lo deduce dal singolo nodo.',0xD785:'Ogni ingresso ordinario scrive1. Una riga composta può passare qui più volte, a differenza del ciclo B8BE.'}
lines=['; Dossier offline: istruzioni e dati tipizzati, verificati e riassellati sul payload.'];count=total=0
for a,b,kind,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=b,(hex(at),op);assert bytes(asm.assemble(op,at))==m[at:at+n]
  lines.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}'+(' | '+notes[at]if at in notes else''));at+=n;total+=n
root=p/'sherlock-js/results/parser-mode';root.mkdir(exist_ok=True);(root/'parser-mode.asm').write_text('\n'.join(lines)+'\n');(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=151)for a,b,k,l in regions]),indent=2)+'\n');print(count,total)
