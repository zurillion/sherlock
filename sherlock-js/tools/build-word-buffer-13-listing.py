"""Typed source dossier: physical byte5D15: recipient delimiter and hidden HAIL preservation."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'skoolkit-10.1'))
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler()
regions=[(54554, 54729, 'code', 'Liste visibili e contenuti ricorsivi: nomi grezzi nel buffer riutilizzato'), (54229, 54344, 'code', 'Formatter D3D5: qualificatori inflettuti e sostantivo non inflettuto'), (42987, 43022, 'code', 'Articolo del nome: due politiche verificate sulle110entità'), (41549, 41565, 'data', 'Tabelle degli articoli: descrizioni e annunci'), (43100, 43136, 'data', 'Suffissi grezzi: maiuscole, backspace e terminatori'), (43311, 43341, 'code', 'Scrittura del suffisso prima della normalizzazione'), (43143, 43193, 'code', 'Riferimento del dizionario e spazio che scarica il nome precedente'), (43447, 43633, 'code', 'Buffer di parola: i nomi nelle liste sovrascrivono solo i byte emessi')]
notes={54585: 'D526 stampa l’entità con D3D5. Il nome visibile non è la rappresentazione grezza: i byte dipendono da qualificatori, articolo e suffissi. Lo stesso formatter serve liste a terra e contenuti ricorsivi.', 54639: 'La ricorsione conserva i delimitatori di ogni livello. La nuova traccia raw-name affianca le profondità dei glifi senza cambiarne il contratto.', 54248: 'Prima seleziona l’articolo con il sostantivo; i qualificatori restano in contesto4 e possono avere suffissi. Il sostantivo successivo usa contesto5/stem.', 54308: 'Invia il primo qualificatore se non soppresso; nel caso naturale DE4109 seleziona bloodstained. La i indice8 va a5C13.', 54338: 'Il sostantivo clothes è più corto del qualificatore bloodstained. Il reset del puntatore non cancella la coda: indice8/i sopravvive.', 42994: 'OriginaleD3D5:220ABI, tutte110entità con A2AA0/1 e canale0. Tabella A24D descrittiva e A255 per annunci/definiti.', 43148: 'Conserva il riferimento completo. Traccia naturale5C13:4109 durante bloodstained nella lista del salotto, tick1651/Tue11:30.', 43311: 'Non sostituire il suffisso grezzo con la parola formattata sullo schermo. La sequenza può contenere maiuscole e backspace.', 43479: 'Ultimo writer naturale5C13: Holmes0,qualificatore4109,bloodstained,i alposto8,tick1651/Tue11:30. La cuoca9 legge105 al1882/Tue15:21; nessuna transizione non classificata nel periodo osservato.', 43513: 'Resetta il puntatore a5C0B, non pulisce il buffer. Dopo clothes e parole più corte resta la coda del qualificatore.', 43540: 'La proiezione dei pixel segue la formattazione, separata dagli eventi grezzi del nome. Solo una derivazione corrispondente al nome effettivo può diventare nota.'}
lines=['; Dossier offline: istruzioni e dati tipizzati, verificati e riassemblati sul payload.'];count=total=0
for a,b,kind,label in regions:
 lines+=['',f'    ORG ${a:04X}',f'; {kind.upper()}: {label}'];at=a
 while at<b:
  if kind=='data':n=min(8,b-at);op='DEFB '+','.join(f'${v:02X}'for v in m[at:at+n])
  else:op,n=disassemble(m,at);count+=1
  assert at+n<=b,(hex(at),op);assert bytes(asm.assemble(op,at))==m[at:at+n]
  lines.append(f'    {op:<37} ; ${at:04X} {m[at:at+n].hex(" ")}'+(' | '+notes[at]if at in notes else''));at+=n;total+=n
root=p/'sherlock-js/results/word-buffer-13';root.mkdir(exist_ok=True);(root/'word-buffer-13.asm').write_text('\n'.join(lines)+'\n');(root/'listing-verification.json').write_text(json.dumps(dict(roundtrip_equal=True,instructions=count,bytes_roundtripped=total,regions=[dict(start=f'{a:04X}',end_exclusive=f'{b:04X}',kind=k,label=l,atlas_priority=161)for a,b,k,l in regions]),indent=2)+'\n');print(count,total)
