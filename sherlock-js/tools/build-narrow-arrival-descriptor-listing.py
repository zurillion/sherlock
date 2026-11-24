"""Checked source excerpts for pictured full arrival and next root-name descriptor E."""
import json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent
sys.path.insert(0,str(project/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
memory=bytes(0x5D80)+(project/'sherlock-analisi/block-10.bin').read_bytes();assembler=Assembler()
regions=[(0xA887,0xA8B9,'Descrittore del nome selezionato prima dello spazio'),(0xC388,0xC39E,'PUSH DE del glifo: E inframe-6'),(0xD102,0xD11B,'Arrivo completo e immagine della locazione'),(0xD3D5,0xD448,'Nome comune: articolo,qualificatori e sostantivo'),(0xD526,0xD55A,'Elenco degli oggetti visibili alla radice')]
notes={0xA89C:'Lo spazio che scarica steam usa già DE58EB,train. Il parametro non è il buffer5C0B della parola precedente.',0xC388:'Arrivo al binario55: prefisso a steam a5D1C,spazio del sostantivo a5D28. In finestra stretta la posizione osservata è colonna5.',0xC38A:'PUSH DE salva E a5D22 quando frame5D28. E deriva da5000|noun,non da unoEB fisso. D23 resta senza nuovo contratto.',0xD102:'Il chiamante dell’arrivo completo è distinto dal LOOK. Le PUSH e CALL seguenti determinano il frame dell’elenco della stanza.',0xD118:'La grafica riapre una finestra stretta per il testo. Non attribuire il contratto alla sola parola inglese train.',0xD3E1:'D3D9 ha ricevuto IY dell’oggetto da elencare; D3DC sposta IY di7 ai riferimenti nominali.',0xD424:'Qualificatore steam nel contesto4,484C; il successivo sostantivo selezionerà contesto5,58EB.',0xD442:'Il sostantivo resta in buffer fino al puntoA414 e alCR esterno. Scarico finale a5D48,non allo stesso frame del qualificatore.',0xD531:'Marca l’oggetto elencato. Il nuovo contratto runtime richiede un solo oggetto comune alla radice e senza contenuti.',0xD536:'A028=0 per il nome ordinario dell’elenco,non il nome richiesto in una citazione.',0xD539:'D3D9 formatta l’oggetto corrente. Entrata D3E8 misurata aSP5D42 per il treno.',0xD541:'Ultimo oggetto: A414 emette il punto. A9B7 riceve46 aSP5D48; il successivoCR esterno haSP5D5C.'}
lines=['; Analisi del gioco Sherlock (1984), offline. Nessuna CPU nel motore JavaScript.'];count=total=0
for a,b,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; CODE: {label}'];at=a
 while at<b:
  op,n=disassemble(memory,at);assert at+n<=b;assert bytes(assembler.assemble(op,at))==memory[at:at+n]
  lines.append(f'    {op:<36} ; ${at:04X} {memory[at:at+n].hex(" ")}' + (' | '+notes[at]if at in notes else''));at+=n;count+=1;total+=n
out=root/'results/narrow-arrival-descriptor';out.mkdir(exist_ok=True)
(out/'narrow-arrival-descriptor.asm').write_text('\n'.join(lines)+'\n')
(out/'listing-verification.json').write_text(json.dumps(dict(instructions=count,bytes_roundtripped=total,roundtrip_equal=True,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind='code',label=label,atlas_priority=98)for a,b,label in regions]),indent=2)+'\n')
print(count,total)
