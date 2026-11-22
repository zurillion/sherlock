"""Checked source excerpts for final carried-name LOOK, next-word descriptor and caller depths."""
import json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent
sys.path.insert(0,str(project/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
memory=bytes(0x5D80)+(project/'sherlock-analisi/block-10.bin').read_bytes();assembler=Assembler()
regions=[(0xA815,0xA82F,'Ingresso del sostantivo nel decoder'),(0xA887,0xA8B9,'Separatore con descrittore della parola successiva'),(0xC388,0xC39E,'Salvataggi DE e AF del glifo'),(0xD3E8,0xD445,'Nomi comuni: articolo, qualificatori e sostantivo'),(0xD526,0xD5C9,'Elenco ricorsivo e frase degli oggetti portati')]
notes={0xA815:'Il riferimento del sostantivo viene selezionato prima dello spazio che scarica il qualificatore precedente.',0xA89C:'Lo spazio iniziale del sostantivo passa con DE del nuovo riferimento. Il glifo spazio non porta DE del buffer della parola daily.',0xC388:'LOOK ordinario,ultimo nome portato: qualificatore a5D1A,spazio a5D26,nome finale a5D4C,wrap finale a5D46. I frame non sono intercambiabili.',0xC38A:'PUSH DE salva E inframe-6 e D inframe-5. Con frame5D26,D occupa5D21: al3315 è51 del descrittore51AB. Nessun51 fisso nel modello.',0xC39D:'Il salvataggio AF più profondo non riscrive D21. F e A della scansione hanno un contratto indipendente.',0xD424:'Qualificatori nel contesto4; il sostantivo usa contesto5. Il delimitatore viene emesso dal decoder della parola successiva.',0xD442:'Il sostantivo finale resta in buffer fino al CR del chiamante; il wrap misurato a5D46 non raggiunge21.',0xD526:'Il livello ricorsivo e il chiamante LOOK determinano lo stack. Il contratto nuovo è limitato al nome comune finale portato da una persona,con testo grezzo verificato.',0xD5C4:'Ritorno dall’elenco prima del CR esterno. La conservazione diD21 attraverso il sostantivo finale è verificata separatamente.'}
lines=['; Analisi del gioco Sherlock (1984), offline. Nessuna CPU nel motore JavaScript.'];count=total=0
for a,b,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; CODE: {label}'];at=a
 while at<b:
  op,n=disassemble(memory,at);assert at+n<=b;assert bytes(assembler.assemble(op,at))==memory[at:at+n]
  lines.append(f'    {op:<36} ; ${at:04X} {memory[at:at+n].hex(" ")}' + (' | '+notes[at]if at in notes else''));at+=n;count+=1;total+=n
out=root/'results/look-carried-descriptor';out.mkdir(exist_ok=True)
(out/'look-carried-descriptor.asm').write_text('\n'.join(lines)+'\n')
(out/'listing-verification.json').write_text(json.dumps(dict(instructions=count,bytes_roundtripped=total,roundtrip_equal=True,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind='code',label=label,atlas_priority=98)for a,b,label in regions]),indent=2)+'\n')
print(count,total)
