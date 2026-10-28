"""Source analysis of predicate-node writes and direct rule phase selection."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[
(0xAB75,0xAB8E,'Nuovo predicato implicito: scrittura nel nodo corrente, poi coordinazione'),
(0xABF3,0xAC24,'Predicati: riconoscimento e sovrascrittura della word del verbo'),
(0xACCC,0xACFB,'Coordinazione: conserva il nodo e prepara la prossima allocazione'),
(0xC591,0xC628,'Regole: pre-verifica, enumerazione e fase di esecuzione'),
]
notes={
0xAB7C:'ABF3 scrive il nuovo verbo nel nodo corrente PRIMA di allocare il successivo: non conserva il verbo ereditato.',
0xAB83:'Ripristina il cursore al token successivo al predicato; ACCC ne prepara una nuova lettura nel prossimo nodo.',
0xAC17:'Payload sintassi +00: byte basso del predicato lessicale riconosciuto.',
0xAC1A:'Payload +01: byte alto del predicato. Nella storia major-witness, nodo 97B4: IS=0485, non VISIT=0956.',
0xAC1F:'Consuma il token seguente. I byte del nodo intermedio persistono anche dopo la sua liberazione.',
0xACD6:'Salva la posizione di ripresa dopo il separatore; AB83 usa questo stesso percorso senza AND esplicito.',
0xACE4:'Conserva il nodo corrente per il backtracking. La successiva allocazione aggiunge un nodo: non sostituisce questo.',
0xC59B:'A00B=0: inizio pre-verifica. Non significa che ogni predicato sia eseguito in fase zero.',
0xC5B2:'Classi letterali 5/6: FE obbligatorio, altrimenti rifiuto prima di passare alla fase uno.',
0xC5D3:'Il primo argomento FF con classe non zero richiede enumerazione dei candidati.',
0xC5DF:'Nessun candidato: ritorna mantenendo fase zero.',
0xC5E3:'Per i candidati enumerati verifica C989 in fase zero; soltanto un successo raggiunge C5F4.',
0xC5EB:'Argomento primo già specificato: verifica se il secondo richiede enumerazione.',
0xC5EE:'Se anche il secondo è specificato (o classe zero), passa DIRETTAMENTE alla fase uno, senza predicato preventivo.',
0xC5F6:'A00B=1 PRIMA di C989: anche un successivo predicato falso lascia fase uno. Byte letto dal generatore casuale.',
0xC5F9:'Controlla luce, classi e predicato; il risultato falso non ripristina A00B.',
0xC61E:'Secondo argomento enumerato: prova in fase zero, poi ripete il controllo in esecuzione quando ha successo.',
}
lines=['; Analisi offline: nessun opcode o dato del gioco modificato.'];count=total=0
for a,b,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; CODE: {label}'];at=a
 while at<b:
  op,n=disassemble(m,at);assert at+n<=b;assert bytes(asm.assemble(op,at))==m[at:at+n]
  lines.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}'+(' | '+notes[at]if at in notes else''));count+=1;total+=n;at+=n
root=p/'sherlock-js/results/parser-rule-lifetimes';root.mkdir(exist_ok=True)
(root/'parser-rule-lifetimes.asm').write_text('\n'.join(lines)+'\n')
(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind='code',label=label,atlas_priority=85)for a,b,label in regions]),indent=2)+'\n');print(count,total)
