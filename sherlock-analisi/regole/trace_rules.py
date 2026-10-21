#!/usr/bin/env python3
"""Tracce di intestazioni, predicati, effetti e costo temporale delle regole.

Le prove ordinarie partono dal prompt originale; le fixture sintetiche sono
marcate e preparate separatamente, senza modificare i file sorgente.
"""
import argparse,json,sys
from pathlib import Path
from sherlock_rules import extract,decode_header,word

def world_changes(before,after,entities):
    result=[]
    for obj in entities:
        start=int(obj['record'],16);size=obj['size']
        changes=[{'offset':f'{i:02X}','before':before[start+i],'after':after[start+i]} for i in range(size) if before[start+i]!=after[start+i]]
        if changes:result.append({'id':obj['id'],'name':obj['name'],'changes':changes})
    return result

def run(engine,meta,entities,command,state=None):
    s=engine.new_sim(state);m,r,R=s.memory,s.registers,engine.R;initial=m[:];keys=list(command.encode('ascii')+b'\r');out={'input':command,'events':[]};stack=[];lower=[];upper=[]
    definitions={int(x['address'],16):x for x in meta['rules']};bodies={int(x['body'],16):x for x in meta['rules'] if not x['deferred']};predicates={int(x['predicate'],16) for x in meta['rules'] if x['predicate']};ops={int(op['address'],16) for x in meta['rules'] for op in x.get('script',[])}
    def start(kind,extra):
        event={'kind':kind,'step_start':step,'actor':m[0xa036],'action':m[0xa033],'arguments':[m[0xa034],m[0xa035]],'execute':bool(m[0xa00b]),**extra}
        out['events'].append(event);stack.append((word(m,r[R.SP]),r[R.SP]+2,event,m[:]))
    for step in range(3500000):
        pc=r[R.PC];sp=r[R.SP]
        while stack and pc==stack[-1][0] and sp==stack[-1][1]:
            _,_,event,before=stack.pop();event.update(z=bool(r[R.F]&64),carry=bool(r[R.F]&1),hl=f'{r[R.H]*256+r[R.L]:04X}',duration_word=word(m,0xa01f),step_end=step,entity_changes=world_changes(before,m,entities),note_counter_before=before[0x9ca1],note_counter_after=m[0x9ca1])
        if pc==0xa536:
            if not keys:break
            r[R.A],r[R.F]=keys.pop(0),0;r[R.PC]=word(m,sp);r[R.SP]+=2;continue
        if pc==0xc415:
            r[R.A],r[R.F]=32,0;r[R.PC]=word(m,sp);r[R.SP]+=2;continue
        if pc in (0xc040,0xc0df,0x04c2,0x0556):
            out['stopped_before_external_io']=f'{pc:04X}';break
        if pc==0xc1fd:lower.append(r[R.A])
        if pc==0xc2ba:upper.append(r[R.A])
        if pc==0xc9bf:
            address=r[R.H]*256+r[R.L]
            if address in definitions:start('rule',{'address':f'{address:04X}','label':definitions[address]['label']})
        if pc in bodies:start('native_body',{'address':f'{pc:04X}','rule':bodies[pc]['address']})
        if pc in predicates:start('predicate',{'address':f'{pc:04X}'})
        if pc==0xcc9e:
            addr=r[R.IXh]*256+r[R.IXl]
            if addr in ops:out['events'].append({'kind':'script_opcode','address':f'{addr:04X}','opcode':m[addr],'actor':m[0xa036],'step':step})
        if pc==0xa0bd:
            row=r[R.IYh]*256+r[R.IYl];actor=m[row]
            if actor in (0,3):out['events'].append({'kind':'scheduler_advance','actor':actor,'row':f'{row:04X}','cost':r[R.H]*256+r[R.L],'due_before':word(m,row+6),'clock':word(m,0x9fdd)})
        if pc==0xb8aa:out['events'].append({'kind':'parse_quote','recipient':m[0xa034],'step':step})
        if pc==0xb191:out['events'].append({'kind':'semantic_entry','actor':m[0xa036],'step':step})
        s.opcodes[m[r[R.PC]]]()
    else:raise RuntimeError(f'Budget superato per{command} a{r[R.PC]:04X}')
    # Può restare uno stack di callback se il gioco richiede altro input dentro
    # una routine. Lo esponiamo, senza inventare un ritorno.
    clean=lambda chars:''.join(chr(x) if x>=32 else '\n' if x==13 else '' for x in chars)
    out.update(steps=step,lower=clean(lower),upper=clean(upper),clock_before=word(initial,0x9fdd),clock_after=word(m,0x9fdd),entity_changes=world_changes(initial,m,entities),unfinished_callbacks=len(stack))
    return out,engine.freeze(s)

def fixture(engine,room=None,changes=()):
    s=engine.new_sim();m,r,R=s.memory,s.registers,engine.R;saved=r[:];saved_stack=m[0x5d00:0x5d80]
    if room is not None:
        r[R.B]=room;engine.call(s,0xdd0b);engine.call(s,0xd045)
    for address,value in changes:m[address]=value
    m[0x5d00:0x5d80]=saved_stack;r[:]=saved
    return engine.freeze(s)

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');args=ap.parse_args()
    sys.path[:0]=[str(args.project/'sherlock-analisi/parser'),str(args.project/'sherlock-analisi/entita')]
    from sherlock_parser import SherlockParser
    from sherlock_entities import catalog
    engine=SherlockParser(args.project);meta=extract(args.project);entities=catalog(args.project)['entities'];out=[]
    sequences=[['TAKE LAMP','TAKE LAMP','GIVE LAMP TO WATSON'],['GIVE LAMP TO WATSON'],['TAKE ARMCHAIR'],['OPEN YOUR DOOR','OPEN YOUR DOOR','CLOSE YOUR DOOR'],['OPEN LAMP'],['OPEN DOOR'],['SAY TO WATSON "LOOK"','"LOOK"'],['SAY TO WATSON "TAKE LAMP"'],['SAY TO WATSON "THE"'],['SAY TO ARMCHAIR "LOOK"']]
    for seq in sequences:
        state=None
        for index,text in enumerate(seq):
            result,state=run(engine,meta,entities,text,state);result.update(source='prompt originale',previous=seq[:index]);out.append(result)
            print(text,result['clock_before'],result['clock_after'],repr(result['lower'][-150:]),repr(result['upper'][-160:]),flush=True)
    # Stati alterati intenzionalmente: niente pretesa che siano raggiunti in
    # questa fase tramite una partita ordinaria.
    cases=[('porta bloccata',None,[(int(entities[21]['record'],16)+5,0x81)],'OPEN YOUR DOOR'),
      ('Mrs Brown resa percepibile nella stanza iniziale',None,[(int(entities[94]['record'],16)+15,8)],'SAY TO MRS BROWN "LOOK"'),
      ('Holmes nella stanza35; nota85 resa visibile; timer9CA1=1',35,[(int(entities[85]['record'],16)+5,0xa0),(0x9ca1,1)],'TAKE NOTE'),
      ('Holmes nella stanza35; nota85 resa visibile; timer9CA1=10',35,[(int(entities[85]['record'],16)+5,0xa0),(0x9ca1,10)],'TAKE NOTE'),
      ('Holmes nella stanza47, cassaforte86',47,[],'OPEN WALL SAFE'),
      ('Holmes nella stanza58, cassaforte89',58,[],'OPEN WALL SAFE')]
    for note,room,changes,command in cases:
        result,_=run(engine,meta,entities,command,fixture(engine,room,changes));result.update(source='fixture sintetica',fixture=note);out.append(result)
        print('FIXTURE',note,repr(result['lower'][-150:]),repr(result['upper'][-180:]),flush=True)
    args.output.mkdir(parents=True,exist_ok=True);(args.output/'execution-traces.json').write_text(json.dumps(out,ensure_ascii=False,indent=2)+'\n')
    print('Salvate',len(out),'prove')
if __name__=='__main__':main()
