#!/usr/bin/env python3
"""Dati e modello Python delle rotte e del conto del cab di Sherlock v2.0."""
import hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
SHA256='c5d48285c0cee5c25cf4734dff0ac8296c0ec0194135e3a72267e49724ac8407'
def word(m,a):return m[a]+256*m[a+1]
def unpack_money(raw):
    """E39C: high byte signed, seven low amount bits; low bit7 is metadata."""
    return ((raw>>8) if raw<0x8000 else (raw>>8)-256)*128+(raw&127)
def pack_money(value):
    if not -16384<=value<=16383:raise ValueError('Importo fuori dal campo signed a 15 bit')
    return (value&127)|((value<<1)&0xff00)
def fare(duration,furiously=False):
    """9B25 adds a unit before subtracting five, including an exact multiple."""
    if not 1<=duration<=255:raise ValueError('Durata della tabella non valida')
    return (duration//5+1)*(6 if furiously else 2)

def extract(project):
    p=Path(project);payload=(p/'sherlock-analisi/block-10.bin').read_bytes()
    assert hashlib.sha256(payload).hexdigest()==SHA256
    m=bytes(0x5d80)+payload
    sys.path[:0]=[str(p/'sherlock-analisi/decoder'),str(p/'sherlock-analisi/ai'),str(p/'sherlock-analisi/regole')]
    from sherlock_text import Decoder
    from decode_npc_ai import decode_op
    from sherlock_rules import decode_header
    d=Decoder.load(p/'sherlock-analisi/block-10.bin');rooms={x['id']:x['name_hint'] for x in d.locations()}
    routes=[]
    for a in range(0x9b7f,0x9c06,3):
        source,target,duration=m[a:a+3]
        routes.append({'address':f'{a:04X}','source':source,'source_name':rooms[source],'target':target,'target_name':rooms[target],'duration':duration,'fare_pence':fare(duration),'furious_duration':(duration-2)&255,'furious_fare_pence':fare(duration,True)})
    scripts=[]
    for start,end in [(0xf2b2,0xf380),(0xf384,0xf389),(0xf3a2,0xf3c2),(0xe08f,0xe0a0),(0xe508,0xe518)]:
        pc=start;ops=[]
        while pc<end:
            o=decode_op(m,pc);assert pc+o['size']<=end
            ops.append(o);pc+=o['size']
        scripts.append({'entry':f'{start:04X}','end_exclusive':f'{end:04X}','instructions':ops})
    roots={int(o['rule'],16) for s in scripts for o in s['instructions'] if 'rule' in o}
    roots|={0x9ae1,0x9af4,0x9c41,0xe08d,0xe2c7,0xe328,0xe370,0xe3ea,0xe432,0xe506}
    rules=[decode_header(m,a) for a in sorted(roots)]
    texts=[{'address':f'{a:04X}',**d.render(a)} for a in [0x6b9e,0x6bac,0x6bb7,0x6bc7,0x6bf6,0x6c1b,0x6c34,0x6c54]]
    return {'payload_sha256':SHA256,'routes':routes,'destinations':[{'id':i,'name':rooms[i]} for i in sorted({r[k] for r in routes for k in ['source','target']})],'scripts':scripts,'rules':rules,'texts':texts}

def write_data(project,output):
    output=Path(output);output.mkdir(parents=True,exist_ok=True);data=extract(project)
    (output/'cab-data.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n')
    lines=['# Rotte del cab','','45 record di tre byte a $9B7F, terminatore FF a $9C06. Ogni coppia funziona nei due sensi. Durate = costo attribuito al turno del cocchiere; minuti osservati al prompt dipendono anche dallo scheduler. Prezzi in pence.','','| Da | A | Costo tempo | Pence | Furiously: tempo / pence |','|---|---|---:|---:|---:|']
    for r in data['routes']:lines.append(f"| {r['source']:03d} {r['source_name']} | {r['target']:03d} {r['target_name']} | {r['duration']} | {r['fare_pence']} | {r['furious_duration']} / {r['furious_fare_pence']} |")
    (output/'ROTTE.md').write_text('\n'.join(lines)+'\n')
    lines=['# Bytecode del cab e regole differite','','I byte di queste sequenze sono istruzioni della VM del gioco, non istruzioni Z80. FD/FC/FB sono riferimenti dinamici.','']
    for s in data['scripts']:
        lines+=['## $'+s['entry'],'','| PC | Byte | Operazione / regola / argomenti | Successo | Fallimento |','|---|---|---|---|---|']
        for o in s['instructions']:
            desc=o['operation']
            if 'rule'in o:desc+=' $'+o['rule']
            if 'action'in o:desc+=' azione '+str(o['action'])
            if 'args'in o:desc+=' '+','.join(f'{v:02X}' for v in o['args'])
            if 'text_pointer'in o:desc+=' testo $'+o['text_pointer']
            lines.append(f"| {o['address']} | {o['raw']} | {desc} | {o.get('jump',o['success'])} | {o['failure'] or '—'} |")
    (output/'BYTECODE.md').write_text('\n'.join(lines)+'\n')
    return data

if __name__=='__main__':
    import argparse
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args();data=write_data(a.project,a.output);print(len(data['routes']),'rotte;',len(data['rules']),'intestazioni; dati e bytecode estratti.')
