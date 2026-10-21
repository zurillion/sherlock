#!/usr/bin/env python3
"""Confronta intestazioni e maschere con il codice Z80, poi verifica le tracce."""
import argparse,json,sys
from pathlib import Path
from sherlock_rules import decode_header,extract

def mask_pass(attrs,mode,mask):
    bits=attrs&mask
    return (bits==mask,mask==0 or bits!=0,bits==0,bits!=mask)[mode]

def verify_trace(data):
    def case(command,previous=None,fixture=None):
        return next(x for x in data if x['input']==command and (x.get('previous',[])==(previous or [])) and (fixture is None and x['source']=='prompt originale' or fixture is not None and (x.get('fixture','').endswith(fixture) if fixture.startswith('timer') else fixture in x.get('fixture',''))))
    def body(row,addr):return [e for e in row['events'] if e['kind']=='native_body' and e['address']==addr]
    def changed(events,ident,offset,before,after):return any(c['id']==ident and any(v=={'offset':offset,'before':before,'after':after} for v in c['changes']) for e in events for c in e.get('entity_changes',[]))
    take=case('TAKE LAMP');assert changed(body(take,'DCC5'),22,'01',255,0)
    assert take['clock_after']-take['clock_before']==1
    give=case('GIVE LAMP TO WATSON',['TAKE LAMP','TAKE LAMP']);assert changed(body(give,'DF06'),22,'01',0,3)
    opened=case('OPEN YOUR DOOR');assert changed(body(opened,'DEA4'),21,'05',128,160)
    again=case('OPEN YOUR DOOR',['OPEN YOUR DOOR']);assert not body(again,'DEA4') and again['clock_after']==again['clock_before']
    close=case('CLOSE YOUR DOOR',['OPEN YOUR DOOR','OPEN YOUR DOOR']);assert changed(body(close,'DEB6'),21,'05',160,128)
    locked=case('OPEN YOUR DOOR',fixture='porta bloccata');assert 'locked' in locked['lower'] and not body(locked,'DEA4')
    # La maschera della porta bloccata passa in pre-verifica ma fallisce in esecuzione.
    stages=[e for e in locked['events'] if e['kind']=='rule' and e['address']=='DE9D']
    assert any(not e['execute'] and not e['z'] for e in stages)
    assert any(e['execute'] and e['z'] for e in stages)
    order=case('SAY TO WATSON "TAKE LAMP"');assert changed(body(order,'DCC5'),22,'01',255,3)
    assert any(e['actor']==3 for e in body(order,'DCC5'))
    resumed=case('"LOOK"',['SAY TO WATSON "LOOK"']);assert any(e['kind']=='parse_quote' and e['recipient']==3 for e in resumed['events'])
    inactive=case('SAY TO MRS BROWN "LOOK"',fixture='Mrs Brown');assert body(inactive,'DDA0') and not any(e['kind']=='parse_quote' for e in inactive['events'])
    burnt=case('TAKE NOTE',fixture='timer9CA1=10');assert changed(body(burnt,'DCC5'),85,'01',84,0)
    assert changed(body(burnt,'DF8D'),85,'09',0x57,0xd5) and changed(body(burnt,'DF8D'),85,'0A',1,7)
    assert [e['address'] for e in burnt['events'] if e['kind']=='script_opcode']==['DF80','DF85','DF8A']
    expired=case('TAKE NOTE',fixture='timer9CA1=1')
    assert not any(e.get('entity_changes') for e in body(expired,'DF8D'))
    assert changed([expired],85,'09',0x57,0x5b)
    safe=case('OPEN WALL SAFE',fixture='stanza47');assert changed(body(safe,'DEA4'),86,'05',128,160)
    assert [e['address'] for e in safe['events'] if e['kind']=='script_opcode']==['DFAB','DFB0','DFB5']
    assert any(e['kind']=='scheduler_advance' and e['actor']==0 and e['cost']==15 for e in safe['events'])
    ending=case('OPEN WALL SAFE',fixture='stanza58');assert ending['stopped_before_external_io']=='C0DF'
    return {'trace_cases':len(data),'assertions':'effetti, fasi, comandi NPC, script, durata e confine I/O verificati'}

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');args=ap.parse_args()
    sys.path.insert(0,str(args.project/'sherlock-analisi/parser'))
    from sherlock_parser import SherlockParser
    e=SherlockParser(args.project);R=e.R;headers=[];masks=[]
    for flags in range(16):
        for execute in (0,1):
            s=e.new_sim();m,r=s.memory,s.registers
            b0=sum(bit for bit,i in [(16,0),(32,1),(64,2),(128,3)] if flags&(1<<i));raw=[b0,0x30]
            if b0&64:raw += [0x2f,0xc6] # predicato OR1;RET
            if b0&16:raw += [0]*5
            body=0x5b00+len(raw);m[0x5b00:body]=raw
            m[body:body+8]=[0x3e,0x5a,0x32,0x70,0x5b,0xf6,1,0xc9]
            m[0x5b70]=0;m[0xa00b]=execute;m[0xa033]=255;m[0xa034]=22;m[0xa035]=255;m[0xa00f]=7;m[0xa010]=0
            e.put(s,0xa013,0x8e55);e.put(s,0xa01f,0xabcd);r[R.H],r[R.L]=0x5b,0
            decoded=decode_header(m,0x5b00);assert int(decoded['body'],16)==body
            returned=e.call(s,0xc9bf);assert not returned['z']
            if not execute:assert m[0x5b70]==0 and e.word(s,0xa01f)==0xabcd
            elif b0&128:assert m[0x5b70]==0 and r[R.F]&1 and r[R.H]*256+r[R.L]==body
            else:assert m[0x5b70]==0x5a and not r[R.F]&1
            if execute:assert e.word(s,0xa01f)==3
            headers.append({'flags':f'{b0:02X}','execute':execute,'body':f'{body:04X}','ok':True})
    for attrs in (0,1,8,16,32,33,64,128,160,255):
        for mask in (0,1,8,16,32,33,64,128,255):
            for mode in range(4):
                for execute in (0,1):
                    s=e.new_sim();r=s.registers;s.memory[0xa00b]=execute
                    r[R.C]=attrs;r[R.D]=mask;r[R.A]=mode;r[R.F]=64 if mode==0 else 0
                    result=e.call(s,0xc763);expected=mask_pass(attrs,mode,mask) if execute else True
                    assert (not result['z'])==expected,(attrs,mask,mode,execute,result)
                    masks.append({'attrs':attrs,'mask':mask,'mode':mode,'execute':execute,'accepted':expected})
    trace_path=args.output/'execution-traces.json'
    assert trace_path.exists(),'Eseguire prima trace_rules.py'
    result={'header_cases':headers,'mask_cases':len(masks),'mask_results':masks,**verify_trace(json.loads(trace_path.read_text()))}
    (args.output/'verification.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print('OK:',len(headers),'intestazioni,',len(masks),'maschere;',result['trace_cases'],'tracce')
if __name__=='__main__':main()
