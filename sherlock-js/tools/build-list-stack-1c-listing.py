"""Typed source dossier: passage qualifier stack5D1C and proven shallow callers."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(54795, 54897, 'code', 'Descrizione dei passaggi: cornice del qualificatore prima del nome della porta'), (54229, 54344, 'code', 'Nome qualificato: il sostantivo finale scarica il prefisso'), (50056, 50148, 'code', 'Glifo e residuo BC: shift orizzontale e scansione salvati sullo stack'), (52162, 52235, 'code', 'Arrivo di un attore: nomi propri semplici contro nomi composti'), (49661, 49728, 'code', 'Canale inferiore: percorso ordinario degli errori e a capo')]
notes={54870: 'Conserva IY prima del formatter D3D5: ingresso C388 a5D26 nella descrizione dopo movimento, a5D2A dopo LOOK.720 ABI originali:36colonne,2stati di spazio,5classi del sostantivo.', 54872: 'Nel percorso naturale il nome plain door scarica plain prima del sostantivo door. Ultimo glifo n,colonna21,tick1653/Tue11:32. Non attribuire lo stesso frame ai passaggi remoti o in contenitori.', 54875: 'Return link osservato sulla pila del vero writer5D1C. La presenza di una porta senza qualificatore non basta a derivare gli stessi registri.', 50103: 'Writer naturale5D1C: C dello shift=(2+7*colonna)&7, con C388/SP5D26. Ultimo n di plain:5; a5D1D il B salvato1.1578store osservati,0transizioni nonclassificate. Il giardiniere8 legge5D1C al2156/Tue19:55.', 50130: 'Otto righe del font; PUSH BC salva B prima diDJNZ,non il contatore dopo. Nessun5 o1 globale,il ruolo dipende dal frame.', 52197: 'Il soggetto effettivo risale i contenitori. Preservazione verificata solo nel chiamante ordinaryAction e con persona propria senza qualificatori visibili:720setup eleggibili su1512ABI. Altri nomi hanno controesempi reali e devono revocare.', 52198: 'A4BC costruisce il nome prima di enters. Watson non riscrive1A–1D; non estendere a nomi composti, richieste accodate o relocate senza prova del chiamante.', 49691: 'Canale inferiore ordinario: errori di direzione e riferimenti EXAMINE semplici assenti,giocatore root in stanza senza descrizione.129casi originali completi preservano1A–1D. Qualificatori,ricerca nella prosa e chiarimenti non coperti.'}
lines=['; Dossier offline: istruzioni e dati tipizzati, verificati e riassemblati sul payload.'];count=total=0
for a,b,kind,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=b,(hex(at),op);assert bytes(asm.assemble(op,at))==m[at:at+n]
  lines.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}'+(' | '+notes[at]if at in notes else''));at+=n;total+=n
root=p/'sherlock-js/results/list-stack-1c';root.mkdir(exist_ok=True);(root/'list-stack-1c.asm').write_text('\n'.join(lines)+'\n');(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=162)for a,b,k,l in regions]),indent=2)+'\n');print(count,total)
