#!/usr/bin/env python3
"""Tracce del main loop originale: avvio, scadenze, input e timeout."""
import argparse,json,sys
from pathlib import Path
from types import SimpleNamespace
sys.dont_write_bytecode=True

def word(m,a):return m[a]+256*m[a+1]
def run(engine, label, command=None, boot=False, timeout=False, partial=None, interrupt_wait=False):
    R=engine.R
    s=engine.audit.from_snapshot(engine.audit.Simulator,engine.audit.entry) if boot else engine.new_sim()
    s.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255))
    m,r=s.memory,s.registers;initial=m[:];events=[];keys=list((partial if partial is not None else command or '').encode('ascii')+(b'\r' if command else b''));timed_out=False;waiting=False;lower=[];upper=[];in_loop=None;polls=0;timeout_start=None;timeout_end=None;presses=0;skipped_halts=0;interrupts=0
    def emit(kind,**fields):events.append({'event':kind,'step':step,'tick':word(m,0x9fdd),**fields})
    for step in range(12000000):
        pc=r[R.PC]
        if pc in (0xc040,0xc0df):emit('tape_boundary',pc=f'{pc:04X}');break
        if pc==0xc415:
            r[R.A],r[R.PC]=ord('N'),0xc41e;emit('boot_or_page_key',return_to=f'{word(m,r[R.SP]):04X}')
        if pc==0xa536:
            if keys:
                a=keys.pop(0);r[R.A],r[R.F]=a,0;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;presses+=1;continue
            if timeout and not timed_out:
                waiting=True;timed_out=True;timeout_start=r[R.T];emit('keyboard_wait',counter=word(m,0xa03b),partial=partial or '')
            else:
                emit('prompt',actor=m[0xa036],row=f'{word(m,0x9fdb):04X}',script=f'{word(m,word(m,0x9fdb)+1):04X}',due=word(m,0x9866));break
        if waiting and pc==0xa54d:emit('timeout',polls=polls)
        if waiting and pc==0xa55c:
            timeout_end=r[R.T];waiting=False;emit('keyboard_return',a=r[R.A],z=bool(r[R.F]&64),tstates=timeout_end-timeout_start)
        if pc==0xc41f:
            polls+=1
            if interrupt_wait and not waiting and m[0x9863]==0x32:
                r[R.A],r[R.F]=0x8d,0;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;emit('wait_enter_interrupt');interrupt_wait=False;continue
        if pc==0xbfd9:emit('tick_start',calendar_before=list(m[0x9fdf:0x9fe3]))
        if pc==0xa074:emit('clock_updated',calendar=list(m[0x9fdf:0x9fe3]))
        if pc==0xa097:
            row=r[R.IYh]*256+r[R.IYl]
            if m[row]!=255:emit('visit',row=f'{row:04X}',actor=m[row],due=word(m,row+6),eligible=word(m,row+6)<=word(m,0x9fdd))
            else:emit('pass_end')
        if pc==0xa0ab:in_loop=r[R.A];emit('actor_begin',actor=in_loop)
        if pc==0xa0b0:emit('actor_step',actor=in_loop,script=f'{word(m,word(m,0x9fdb)+1):04X}')
        if pc==0xa0b3:emit('actor_return',actor=in_loop,cost=word(m,0xa01f))
        if pc==0xa0bd:
            row=r[R.IYh]*256+r[R.IYl];cost=r[R.H]*256+r[R.L]
            emit('reschedule',actor=m[row],row=f'{row:04X}',old_due=word(m,row+6),cost=cost,new_due=(word(m,row+6)+cost)&65535)
        if pc==0xa0cc:emit('callback_dispatch',loop_actor=in_loop,context_actor=m[0xa036])
        if pc==0x9c84:emit('callback',actor=m[0xa036],address=f'{r[R.H]*256+r[R.L]:04X}')
        if pc==0xcc9e and m[0xa036]==0:emit('player_opcode',address=f'{r[R.IXh]*256+r[R.IXl]:04X}',opcode=m[r[R.IXh]*256+r[R.IXl]])
        if pc in (0xd6c1,0xd6ce,0xd719,0xd780,0xd7fc,0xc4d1):
            if m[0xa036]==0:emit('player_stage',pc=f'{pc:04X}',action=m[0xa033])
        if pc==0xb0ac:emit('request_load_or_quit')
        if pc==0xb0c9:emit('request_save')
        if pc==0xb0e4:emit('save_service')
        if pc==0xb0d7:emit('load_service')
        if pc==0xc1fd:lower.append(r[R.A])
        if pc==0xc2ba:upper.append(r[R.A])
        previous_pc=r[R.PC]
        # Accelera soltanto ripetizioni HALT, preservando T e refresh R.
        if m[previous_pc]==0x76 and r[26] and r[R.T]%s.frame_duration>=s.int_active:
            gap=s.frame_duration-r[R.T]%s.frame_duration
            skipped=max(0,(gap-1)//4);r[R.T]+=4*skipped
            r[15]=(r[15]&128)|((r[15]+skipped)&127);skipped_halts+=skipped
        s.opcodes[m[r[R.PC]]]()
        if r[26] and r[R.T]%s.frame_duration<s.int_active:
            interrupts+=bool(s.accept_interrupt(r,m,previous_pc))
    else:raise RuntimeError(f'{label}: budget a{r[R.PC]:04X}')
    clean=lambda x:''.join(chr(v) if v>=32 else '\n' if v==13 else '' for v in x)
    changes=[]
    for i in range(110):
        p=word(m,0x8b70+3*i);end=word(m,0x8b73+3*i) if i<109 else 0x956a
        diff=[{'offset':f'{j-p:02X}','before':initial[j],'after':m[j]} for j in range(p,end) if initial[j]!=m[j]]
        if diff:changes.append({'id':i,'changes':diff})
    return {'label':label,'command':command,'boot':boot,'timeout':timeout,'partial':partial,'steps':step,'clock_before':word(initial,0x9fdd),'clock_after':word(m,0x9fdd),'calendar_before':list(initial[0x9fdf:0x9fe3]),'calendar_after':list(m[0x9fdf:0x9fe3]),'lower':clean(lower),'upper':clean(upper),'events':events,'entity_changes':changes,'keyboard_polls':polls,'interrupts':interrupts,'skipped_halt_repetitions':skipped_halts,'timeout_tstates':timeout_end-timeout_start if timeout_end is not None else None}

def metadata(engine):
    m=engine.audit.decoder.mem;cat=json.loads((engine.project/'sherlock-analisi/entita/results/entities.json').read_text());names={x['id']:x['name'] for x in cat['entities']};rows=[];p=0x9860
    while m[p]!=255:
        rows.append({'position':len(rows)+1,'address':f'{p:04X}','id':m[p],'name':names[m[p]],'script_initial':f'{word(m,p+1):04X}','action_initial':m[p+3],'arg1_initial':m[p+4],'arg2_initial':m[p+5],'due_initial':word(m,p+6)});p+=8
    return rows

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args()
    sys.path.insert(0,str(a.project/'sherlock-analisi/parser'));from sherlock_parser import SherlockParser
    e=SherlockParser(a.project)
    cases=[('avvio',dict(boot=True)),('LOOK',dict(command='LOOK')),('errore lessicale',dict(command='OPEN DOR')),('errore sintattico',dict(command='PICK THE NOTE UP')),('rifiuto semantico',dict(command='TAKE ARMCHAIR')),('disambiguazione',dict(command='EXAMINE ARMCHAIR')),('due comandi',dict(command='TAKE LAMP. GIVE LAMP TO WATSON')),('WAIT',dict(command='WAIT')),('WAIT UNTIL',dict(command='WAIT UNTIL 8:05')),('WAIT UNTIL interrotto',dict(command='WAIT UNTIL 8:05',interrupt_wait=True)),('SAVE',dict(command='SAVE')),('QUIT',dict(command='QUIT')),('timeout senza input',dict(timeout=True)),('timeout input parziale',dict(timeout=True,partial='TAKE'))]
    a.output.mkdir(parents=True,exist_ok=True);result=[]
    for label,opts in cases:
        row=run(e,label,**opts);result.append(row);print(label,row['clock_before'],row['clock_after'],row['steps'],row['events'][-1]['event'],flush=True)
        (a.output/'loop-traces.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    (a.output/'actors.json').write_text(json.dumps(metadata(e),ensure_ascii=False,indent=2)+'\n')
if __name__=='__main__':main()
