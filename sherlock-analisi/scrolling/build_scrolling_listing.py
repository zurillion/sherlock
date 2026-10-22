#!/usr/bin/env python3
"""Listato mirato dello scrolling, con dati separati e ri-assemblaggio identico."""
import argparse
import hashlib
import json
import sys
from pathlib import Path


def build(project,output):
    project=Path(project);sys.path.insert(0,str(project/'skoolkit-10.1'))
    from skoolkit.traceutils import disassemble
    from skoolkit.z80 import Assembler
    payload=(project/'sherlock-analisi/block-10.bin').read_bytes();memory=bytes(0x5d80)+payload
    regions=[(0xa019,0xa01a,'data'),(0xa296,0xa2aa,'code'),
             (0xa9b5,0xa9b7,'data'),(0xa9b7,0xaa71,'code'),
             (0xc10f,0xc128,'code'),(0xc128,0xc129,'data'),(0xc129,0xc190,'code'),
             (0xc190,0xc1a8,'data'),(0xc1a8,0xc1c0,'code'),(0xc1e1,0xc1f4,'code'),
             (0xc1f4,0xc1fc,'data'),(0xc1fc,0xc3e4,'code'),(0xc3e4,0xc415,'code'),
             (0xc415,0xc45e,'code'),(0xd714,0xd719,'data'),(0xd719,0xd726,'code'),
             (0xd898,0xd8c6,'code')]
    comments={0xa019:'Contatore condiviso dei ritorni a capo superiori; soglia 15.',
              0xa296:'Invia 18 CR e azzera A019 DOPO ciascuno; non cancella con un unico riempimento.',
              0xa2a2:'Invia un CR tramite il formatter A9B7 e il canale selezionato.',
              0xa9b5:'Puntatore al buffer parola 5C0B; dato, non istruzioni.',
              0xa9b7:'Buffer parola: considera la larghezza rimasta prima di stampare.',
              0xa9ef:'CR di word wrap prima della parola che non entra.',
              0xaa14:'Formatter: spazi, maiuscole, virgolette.',
              0xc128:'Modo della finestra: 0=36 colonne; nonzero=18 colonne.',
              0xc129:'Passa a 18 colonne E azzera il contatore.',
              0xc142:'Passa a 36 colonne e ripristina il cursore; NON azzera A019.',
              0xc14a:'Inizializza schermo, cursori e striscia delle pistole.',
              0xc190:'24 byte della striscia; dati bitmap, non codice.',
              0xc1a8:'Orologio diretto al renderer: non attraversa il contatore superiore.',
              0xc1e1:'Canale superiore/inferiore e soppressione del testo.',
              0xc1f4:'Colonne residue dei due canali; poi puntatori bitmap e offset in bit.',
              0xc1fc:'Ripristina AF prima del canale inferiore.',
              0xc1fd:'Canale comandi e messaggi inferiori: scroll separato, senza A019.',
              0xc271:'Scroll fisico della zona inferiore.',
              0xc2ba:'Emette il carattere superiore: CR esplicito o esaurimento colonne.',
              0xc2ca:'Prima dello scroll controlla il contatore.',
              0xc2cd:'Soglia esatta 0F: il sedicesimo CR chiede MORE.',
              0xc2d1:'Pausa prima dello scroll pendente.',
              0xc2d4:'Dopo MORE: FF, poi INC -> 00. Il CR pendente non viene contato come 1.',
              0xc2df:'Scroll fisico di una riga, dopo il controllo MORE.',
              0xc2f5:'Anche l ultima colonna provoca lo stesso percorso di linefeed.',
              0xc306:'MORE: FLASH dell ultima cella della barra, attesa tasto, ritorno a 36 colonne.',
              0xc307:'5A5F = attributo riga 18, colonna 31, cella 8x8 a x248,y144.',
              0xc316:'Copia 17 righe alte 8 pixel verso l alto e svuota la riga inferiore.',
              0xc326:'17 righe da copiare: la finestra fisica e alta 18 righe.',
              0xc32d:'32 byte per riga pixel in modo largo.',
              0xc331:'16 byte per riga pixel in modo stretto.',
              0xc358:'In modo largo sposta anche 17 righe di attributi.',
              0xc36d:'Svuota in basso con 36 o 18 glifi spazio.',
              0xc388:'Glifo ROM 8x8 con passo orizzontale di sette pixel.',
              0xc3e4:'Servizio stampante opzionale durante lo scroll largo; non e il controllo MORE.',
              0xc415:'Attende un tasto tramite scansione ROM/interrupt.',
              0xd714:'Flag D714 e intestazione della regola D715: dati, non Z80.',
              0xd719:'Ingresso della tokenizzazione dopo il preflight lessicale.',
              0xd71a:'Azzera A019 prima del parsing, non alla fine del comando.',
              0xd898:'Ingresso editor: seleziona il canale inferiore, senza azzerare A019.',
              0xd8ad:'Prompt > e spazio nel canale inferiore.'}
    assembler=Assembler();lines=['; Sherlock v2.0: scorrimento e paginazione. Estratti non contigui.',
                                '; Codice e dati separati; tutti i byte ricomposti identici al payload.'];count=total=0
    for start,end,kind in regions:
        lines+=['',f'    ORG ${start:04X}',f'; {kind.upper()} fino a ${end-1:04X}'];address=start
        while address<end:
            if address in comments:lines.append('; '+comments[address])
            if kind=='code':operation,size=disassemble(memory,address);count+=1
            else:
                size=min(8,end-address);operation='DEFB '+','.join(f'${v:02X}' for v in memory[address:address+size])
            assert address+size<=end,(address,operation)
            assert bytes(assembler.assemble(operation,address))==memory[address:address+size]
            lines.append(f'    {operation:<30} ; ${address:04X} {memory[address:address+size].hex(" ")}')
            address+=size;total+=size
    output=Path(output);output.mkdir(parents=True,exist_ok=True)
    (output/'scrolling.asm').write_text('\n'.join(lines)+'\n')
    report={'all_bytes_match':True,'instructions':count,'bytes_verified':total,
            'source_payload_sha256':hashlib.sha256(payload).hexdigest(),
            'regions':[{'start':f'{s:04X}','end_exclusive':f'{e:04X}','kind':k} for s,e,k in regions]}
    (output/'listing-verification.json').write_text(json.dumps(report,indent=2)+'\n')
    return report


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results')
    args=ap.parse_args();print(json.dumps(build(args.project,args.output)))
