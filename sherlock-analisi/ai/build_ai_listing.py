#!/usr/bin/env python3
"""Listato misto verificato: Z80, intestazioni e bytecode NPC distinti."""
import argparse,json,sys
from pathlib import Path
from decode_npc_ai import extract
sys.dont_write_bytecode=True

def build(project,output):
 p=Path(project);sys.path.insert(0,str(p/'skoolkit-10.1'))
 from skoolkit.traceutils import disassemble
 from skoolkit.z80 import Assembler
 m=bytes(0x5d80)+(p/'sherlock-analisi/block-10.bin').read_bytes();asm=Assembler();data=extract(p);items={}
 def add(a,n,kind,op,comment=''):
  item={'size':n,'kind':kind,'operation':op,'comment':comment}
  if a in items:assert items[a]['size']==n and items[a]['kind']==kind,(a,item,items[a])
  items[a]=item
 regions=[(0x9c6a,0x9c85),(0x9ca2,0x9d10),(0x9d13,0x9d2e),(0x9d95,0x9e48),(0xb86a,0xb934),(0xb936,0xba13),(0xba20,0xba60),(0xba67,0xbb67),(0xcba7,0xcbbb),(0xcc0e,0xd045),(0xd29d,0xd2ed),(0xdd65,0xdd84),(0xdd88,0xdd9e),(0xe48a,0xe497),(0xe49b,0xe4c9),(0xe531,0xe57a),(0xe57e,0xe588),(0xe58c,0xe5a8),(0xe5aa,0xe5ad),(0xe5b1,0xe5c1),(0xe5c3,0xe5d8),(0xe5dc,0xe5fd),(0xe601,0xe619),(0xe7e4,0xe7e7),(0xf1d8,0xf1f6)]
 comments={0xcc37:'Prepara attore, rileva richieste pendenti e azzera contatore fallimenti.',0xcc78:'Riprende lo stato persistente e il programma dell attore.',0xccae:'Elabora al massimo una richiesta per preparazione dell attore; poi riprende il programma.',0xcd08:'Trappola intenzionale: JR su se stesso (opcode0C); non un normale yield.',0xcdbf:'Opcode04: crea richiesta gia risolta [destinatario, FF, azione, arg1, arg2].',0xcd24:'Opcode08: aggiunge coppia mittente/destinatario alla lista9FE7.',0xcd47:'Opcode09: cerca segnale per attore corrente e mittente richiesto; lo consuma.',0xce8f:'Successo: ramo bit7 oppure sequenza; bit5 cancella bytecode eseguito.',0xceb8:'Fallimento: incrementaCC0B e segue ramo bit4; autoloop o10fallimenti -> costo1.',0xcede:'F5..F9 eFD=arg1, FA=slot9FD6, FB=attore, FC=arg2; FE/FF invariati.',0xcf80:'Salva contesto sospeso nella lista9FE9.',0xcfcf:'Ripristina contesto e libera record.',0xb8d3:'Richiesta da citazione: record8byte, con lista di nodi sintattici e modo.',0xb91f:'Cerca richiesta destinata all attore corrente nella lista9FEE.',0xba20:'Modo2 (asserzioni): dispatch speciale Watson BA67 / Lestrade BB67.',0xcba7:'Rifiuto condizionato dal bit6 del bytecode sospeso; chiamato solo da alcune regole.',0xe531:'Contatore privato: base + D2A4(ampiezza); non una scadenza assoluta.',0xe57e:'Decrementa contatore; zero lo elimina e restituisce fallimento.',0xf1d8:'Test ora: 1..12am,13..24pm; non confronta minuti ne giorno.',0x9d13:'Callback Watson: saluti con contatori di incontri; poi E691.',0x9dff:'Callback Lestrade: controlla presenza/percezione di Straker e Holmes, modifica stato e callback.'}
 for start,end in regions:
  a=start
  while a<end:
   op,n=disassemble(m,a);assert a+n<=end,(hex(a),op);add(a,n,'Z80',op,comments.get(a,''));a+=n
 for h in data['rules']:
  a=int(h['address'],16);n=h['header_size'];add(a,n,'HEADER','DEFB '+','.join(f'${v:02X}' for v in m[a:a+n]),f"{h['label']}; corpo {h['body_kind']} ${h['body']}; costo{h['duration']}")
 for s in data['scripts']+data['subscripts']:
  for o in s['instructions']:
   a=int(o['address'],16);n=o['size'];add(a,n,'BYTECODE','DEFB '+','.join(f'${v:02X}' for v in m[a:a+n]),o['operation']+(f"; regola ${o['rule']}" if 'rule' in o else ''))
 for start,end in [(0x9c85,0x9ca2),(0x9d10,0x9d13),(0xb934,0xb936),(0xba13,0xba20),(0xba60,0xba67)]:
  for a in range(start,end,8):
   n=min(8,end-a);add(a,n,'DATA','DEFB '+','.join(f'${v:02X}' for v in m[a:a+n]))
 addresses=sorted(items);previous_end=None;lines=['; Sherlock: AI. Dati/bytecode non vengono disassemblati come istruzioni Z80.'];total=0
 for a in addresses:
  row=items[a];n=row['size'];assert previous_end is None or a>=previous_end,(hex(a),hex(previous_end))
  if a!=previous_end:lines+=['',f'    ORG ${a:04X}']
  if row['comment']:lines+=['; '+row['kind']+': '+row['comment']]
  actual=bytes(asm.assemble(row['operation'],a));assert actual==m[a:a+n],(hex(a),row)
  lines+=[f"    {row['operation']:<45} ; ${a:04X} {m[a:a+n].hex(' ')}"]
  previous_end=a+n;total+=n
 output.mkdir(parents=True,exist_ok=True);(output/'npc-ai.asm').write_text('\n'.join(lines)+'\n')
 result={'roundtrip_equal':True,'bytes_roundtripped':total,'z80_instructions':sum(x['kind']=='Z80' for x in items.values()),'bytecode_instructions':sum(x['kind']=='BYTECODE' for x in items.values()),'rule_headers':sum(x['kind']=='HEADER' for x in items.values()),'note':'Identita dei byte verificata; non prova da sola tutte le interpretazioni.'}
 (output/'listing-verification.json').write_text(json.dumps(result,indent=2)+'\n');print(result)
def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args();build(a.project,a.output)
if __name__=='__main__':main()
