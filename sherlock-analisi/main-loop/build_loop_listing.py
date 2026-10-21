#!/usr/bin/env python3
"""Listato del ciclo principale: Z80, stato e bytecode separati e ricomposti."""
import argparse,json,sys
from pathlib import Path

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results')
    a=ap.parse_args();sys.path.insert(0,str(a.project/'skoolkit-10.1'))
    from skoolkit.traceutils import disassemble
    from skoolkit.z80 import Assembler
    assembler=Assembler();m=bytes(0x5d80)+(a.project/'sherlock-analisi/block-10.bin').read_bytes()
    regions=[(0x9860,0x9921,'data'),(0x9921,0x994d,'data'),(0x9c6a,0x9c85,'code'),(0x9c85,0x9ca2,'data'),(0x9fdd,0xa040,'data'),(0xa040,0xa0d8,'code'),(0xa0d8,0xa0db,'data'),(0xa0db,0xa0f7,'code'),(0xa536,0xa55d,'code'),(0xb0ac,0xb0fd,'code'),(0xbfd9,0xc00c,'code'),(0xc415,0xc45e,'code'),(0xcc0e,0xcc9b,'code'),(0xd008,0xd045,'code')]
    comments={0x9860:'24 righe attore, 8 byte: ID, PC(word), azione, arg1, arg2, scadenza(word).',0x9920:'FF: fine tabella attori.',0x9921:'BYTECODE: 01 22 = LOOK iniziale.',0x9923:'BYTECODE: regola D6BF editor; fallimento ->9948 (WAIT automatico).',0x9928:'BYTECODE: regola D715 lessico/tokenizzazione; fallimento ->9923.',0x992d:'BYTECODE: regola D769 verifica token residui; fallimento ->9923.',0x9932:'BYTECODE: regola D77E parsing; fallimento ->9923.',0x9937:'BYTECODE: regola D7D9 verifica nodo; fallimento ->992D.',0x993c:'BYTECODE: regola D7FA semantica; fallimento ->9937.',0x9941:'BYTECODE: 02 FA FD FC = esegui azione e argomenti salvati.',0x9945:'BYTECODE: salto 9937, altri nodi del comando.',0x9948:'BYTECODE: 01 31 = WAIT HERE.',0x994a:'BYTECODE: salto 9923, nuovo input.',0x9c6a:'Selezione callback specifica per attore.',0x9c85:'Tabella callback; non codice. Include il contatore mutabile 9CA1.',0x9fdd:'Contatore globale word; poi minuti, ore, giorno, a/p.',0xa01f:'Costo restituito dal passo corrente, word.',0xa036:'ID attore corrente.',0xa037:'Seme casuale.',0xa03b:'Contatore inattivita tastiera, word.',0xa040:'Avvio UI/sessione; stato iniziale del mondo gia presente nel payload.',0xa048:'Inizializzazione schermo.',0xa04e:'Scelta grafica iniziale.',0xa05f:'Seme casuale dal registro R.',0xa064:'Azzera richiesta SAVE/LOAD.',0xa068:'Inizio ciclo: serve eventuale richiesta pendente.',0xa06e:'Avanza tempo PRIMA della scansione attori.',0xa071:'Aggiorna visualizzazione orologio.',0xa078:'Azione salvata 32 hex = WAIT UNTIL: controlla ENTER.',0xa08a:'ENTER anticipa scadenza di Holmes al tick corrente.',0xa093:'Riparte dalla prima riga, Holmes.',0xa097:'FF termina la scansione.',0xa0a0:'Confronta tempo globale e scadenza: carry se troppo presto.',0xa0ab:'Prepara contesto attore una volta per visita eleggibile.',0xa0b0:'Esegue un passo della sequenza.',0xa0b8:'Costo zero: stesso attore, nuovo passo.',0xa0bd:'Scadenza nuova = scadenza PRECEDENTE + costo.',0xa0cc:'Callback dopo la porzione di attivita con costo positivo.',0xa0d1:'Prossimo attore: passo fisso 8.',0xa0d8:'Stato mutabile, NON INC C / OR 00.',0xa0da:'Richiesta servizio: 0 normale, 1 caricamento, 2 salvataggio.',0xa0db:'Confronto unsigned a 16 bit HL vs scadenza attore.',0xa0e7:'Servizi a fine scansione: SAVE oppure LOAD/QUIT.',0xa536:'Attende un carattere o esaurimento contatore.',0xa53a:'Lettura tastiera sincronizzata con interrupt.',0xa548:'Una iterazione senza tasto consuma una unita.',0xa54f:'Timeout: cancella input incompleto.',0xa555:'Ripristina 3000 iterazioni; avviene anche dopo ogni tasto.',0xb0ac:'Richiesta LOAD/QUIT: azzera clock e scadenza Holmes, costo 1, flag 1.',0xb0c9:'Richiesta SAVE: costo 1, flag 2.',0xb0d7:'Servizio caricamento (I/O non eseguito dalle prove).',0xb0e4:'Servizio salvataggio (I/O non eseguito dalle prove).',0xb0ee:'Intervallo salvato: 840B..A01E, 7188 byte.',0xbfd9:'Incrementa contatore globale e calendario.',0xc415:'Attesa tasto senza timeout usata da scelta grafica/paginazione.',0xc41f:'EI/HALT/DI e lettura stato tastiera ROM.',0xcc0e:'Ricerca ID nella tabella attori.',0xcc37:'Prepara attore, riferimenti e contesto; costo iniziale zero.',0xcc78:'Ripristina azione e argomenti; poi interprete bytecode.',0xcc82:'Legge puntatore alla sequenza corrente.',0xd008:'Ripristina azione e argomenti da riga attore o contesto sospeso.',0xd026:'Salva azione e argomenti nella riga o contesto sospeso.'}
    for p in range(0x9868,0x9920,8):comments[p]=f'Riga attore ID {m[p]}.'
    lines=['; Sherlock v2.0 - main loop. Indirizzi esadecimali, intervalli selezionati.'];instructions=total=0
    for start,end,kind in regions:
        lines+=['',f'    ORG ${start:04X}',f'; {kind.upper()} fino a ${end-1:04X}'];p=start
        while p<end:
            if p in comments:lines.append('; '+comments[p])
            if kind=='code':op,n=disassemble(m,p);instructions+=1
            else:
                n=min([p+8,end]+[q for q in comments if p<q<min(p+8,end)])-p
                op='DEFB '+','.join(f'${v:02X}' for v in m[p:p+n])
            assert p+n<=end,(hex(p),op)
            assert bytes(assembler.assemble(op,p))==m[p:p+n],(hex(p),op)
            lines.append(f'    {op:<34} ; ${p:04X} {m[p:p+n].hex(" ")}');p+=n;total+=n
    a.output.mkdir(parents=True,exist_ok=True)
    (a.output/'main-loop.asm').write_text('\n'.join(lines)+'\n')
    report={'instructions':instructions,'bytes_roundtripped':total,'regions':[{'start':f'{s:04X}','end_exclusive':f'{e:04X}','kind':k} for s,e,k in regions]}
    (a.output/'listing-verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
if __name__=='__main__':main()
