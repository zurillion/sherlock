#!/usr/bin/env python3
"""Verifica scadenze, righe attori, interrupt e invarianti delle tracce."""
import argparse,json,sys
from pathlib import Path
from trace_main_loop import word

def wait_sample(engine,accelerate):
    s=engine.new_sim();m,r,R=s.memory,s.registers,engine.R;engine.put(s,0xa03b,1)
    for step in range(100000):
        pc=r[R.PC]
        if pc==0xa55c:return s,step
        if accelerate and m[pc]==0x76 and r[26] and r[R.T]%s.frame_duration>=s.int_active:
            skip=max(0,(s.frame_duration-r[R.T]%s.frame_duration-1)//4)
            r[R.T]+=skip*4;r[15]=(r[15]&128)|((r[15]+skip)&127)
        s.opcodes[m[pc]]()
        if r[26] and r[R.T]%s.frame_duration<s.int_active:s.accept_interrupt(r,m,pc)
    raise AssertionError('Campione tastiera non concluso')

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args()
    sys.path.insert(0,str(a.project/'sherlock-analisi/parser'));from sherlock_parser import SherlockParser
    e=SherlockParser(a.project);R=e.R;pairs=[(0,0),(1,0),(0,1),(255,256),(256,255),(256,256),(65535,0),(0,65535),(65535,65535)]
    for now,due in pairs:
        s=e.new_sim();r=s.registers;r[R.IYh],r[R.IYl]=0x98,0x60;r[R.H],r[R.L]=now>>8,now&255;e.put(s,0x9866,due)
        ret=e.call(s,0xa0db);assert bool(r[R.F]&1)==(now<due);assert ret['z']==(now==due)
    s=e.audit.from_snapshot(e.audit.Simulator,e.audit.entry);r=s.registers;r[R.IYh],r[R.IYl]=0x98,0x60
    s.memory[0xa036]=0;s.memory[0x9fd6:0x9fd9]=[41,22,3];e.call(s,0xd026)
    assert s.memory[0x9863:0x9866]==[41,22,3]
    s.memory[0x9fd6:0x9fd9]=[0]*3;e.call(s,0xd008);assert s.memory[0x9fd6:0x9fd9]==[41,22,3]
    slow,slow_steps=wait_sample(e,False);fast,fast_steps=wait_sample(e,True)
    assert slow.memory==fast.memory and list(slow.registers)==list(fast.registers)
    cases=json.loads((a.output/'loop-traces.json').read_text());by={x['label']:x for x in cases};actors=json.loads((a.output/'actors.json').read_text());ids=[x['id'] for x in actors]
    assert len(ids)==24 and [v['actor'] for v in by['avvio']['events'] if v['event']=='actor_begin']==ids+[0]
    assert by['avvio']['calendar_after']==[1,8,0,97]
    assert [v['address'] for v in by['avvio']['events'] if v['event']=='player_opcode']==['9921','9923']
    reschedules=0;skips=0;zero_cost=0
    for c in cases:
        last_visit=None
        for ev in c['events']:
            if ev['event']=='visit':last_visit=ev;skips+=not ev['eligible']
            if ev['event']=='actor_begin':assert last_visit and last_visit['actor']==ev['actor'] and last_visit['eligible']
            if ev['event']=='reschedule':assert ev['cost']>0 and ev['new_due']==(ev['old_due']+ev['cost'])%65536;reschedules+=1
            if ev['event']=='actor_return':zero_cost+=ev['cost']==0
    assert zero_cost>0 and skips>0
    for name in ['errore lessicale','errore sintattico','rifiuto semantico','disambiguazione']:
        assert by[name]['clock_after']==2 and not any(x['event']=='reschedule' for x in by[name]['events'])
    assert by['due comandi']['clock_after']==4
    for name in ['WAIT','timeout senza input','timeout input parziale']:
        assert by[name]['clock_after']==6
        own=[x for x in by[name]['events'] if x['event']=='reschedule' and x['actor']==0]
        assert own[0]['old_due']==1 and own[0]['cost']==5 and own[0]['new_due']==6
    for name in ['timeout senza input','timeout input parziale']:
        c=by[name];assert c['keyboard_polls']==3000
        assert any(x['event']=='player_opcode' and x['address']=='9948' for x in c['events'])
        assert any(x['event']=='keyboard_return' and x['a']==0 and x['z'] for x in c['events'])
    assert by['WAIT UNTIL']['clock_after']==5
    assert by['WAIT UNTIL interrotto']['clock_after']==3 and any(x['event']=='wait_enter_interrupt' for x in by['WAIT UNTIL interrotto']['events'])
    for name,pc in [('SAVE','C040'),('QUIT','C0DF')]:assert by[name]['events'][-1]['pc']==pc
    report={'cases':len(cases),'actors':len(ids),'deadline_cases':len(pairs),'row_action_and_arguments_roundtrip':True,'halt_equivalence':{'identical_memory_and_registers':True,'slow_steps':slow_steps,'fast_steps':fast_steps},'reschedules_checked':reschedules,'ineligible_visits':skips,'zero_cost_returns':zero_cost}
    (a.output/'verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
if __name__=='__main__':main()
