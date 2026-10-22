#!/usr/bin/env python3
"""Attese incrementali, riferimento Z80 con interrupt e scene terminali web."""
import argparse
import json
import sys
from pathlib import Path
from types import SimpleNamespace

from explorer import Game
from extract_locations import extract
from native_world import word


def verify(project):
    project=Path(project);data=extract(project);checks=[];traces={}
    def check(name,ok,**details):
        assert ok,(name,details)
        checks.append({'check':name,'passed':True,**details});print('OK:',name,flush=True)
    def fresh():
        g=Game(project,data);g.world.m[0xa037]=1;g.parser.put(g.world.sim,0xa039,0);return g
    def run(g,command,interrupt_at=None,inspect=False):
        start=g.world.clock();part=g.start_command(command);frames=[];messages=[]
        while part['running']:
            frames.append(part['clock']);messages+=part['messages']
            if inspect:
                before=(g.world.m[:],g.world.sim.registers[:])
                for _ in range(3):assert g.state()['command_running']
                assert before==(g.world.m,g.world.sim.registers),'Inspection changed a suspended VM'
            part=g.continue_command(part['job'],interrupt=interrupt_at==len(frames))
        messages+=part['messages']
        row={'command':command,'before':start,'after':part['state']['clock'],'frames':frames,
             'messages':messages,'outcome':g.last_analysis['outcome'],'game_over':part['state']['game_over']}
        assert row['outcome']!='tool_limit',row
        return row

    g=fresh();initial=g.state()
    rows=[run(g,c) for c in ['WAIT','WAIT','LOOK','WAIT']];traces['waits']=rows
    check('WAIT lasts five minutes from startup and after other actions',
          all(r['after']['tick']-r['before']['tick']==5 and len(r['frames'])==5 for r in rows if r['command']=='WAIT'))
    check('Every elapsed minute is returned separately and in order',
          all([f['tick'] for f in r['frames']]==list(range(r['before']['tick']+1,r['after']['tick']+1)) for r in rows))
    before=g.world.clock();r=run(g,'XYZZY');check('Lexical errors have no minute frames and leave time unchanged',not r['frames'] and g.world.clock()==before)
    r=run(g,'WAIT UNTIL 9:00AM',inspect=True);traces['until_morning']=r
    check('WAIT UNTIL reaches exactly 09:00am; read-only session inspection is safe',r['after']['label']=='Mon 09:00am')
    g=fresh();g.world.m[0x9fdf:0x9fe3]=[24,6,0,112]
    r=run(g,'WAIT UNTIL 9:00');traces['until_evening']=r
    check('18:24 to implicit 9:00 selects 9pm and completes all 156 minute frames',
          len(r['frames'])==156 and r['after']['label']=='Mon 09:00pm')
    g=fresh();r=run(g,'WAIT UNTIL 9:00AM',interrupt_at=2);traces['interrupted']=r
    check('ENTER interrupts WAIT UNTIL through the native A07F poll',r['after']['label']=='Mon 08:02am' and len(r['frames'])==2)
    g=fresh();p=g.start_command('WAIT')
    try:g.command('LOOK');busy_rejected=False
    except ValueError:busy_rejected=True
    before=(g.world.m[:],g.world.sim.registers[:])
    try:g.continue_command('obsolete-job');stale_rejected=False
    except ValueError:stale_rejected=True
    check('A pending command rejects another command and a stale continuation token',busy_rejected and stale_rejected and before==(g.world.m,g.world.sim.registers))
    g.world.interrupt_wait=True
    while p['running']:p=g.continue_command(p['job'],interrupt=True)
    check('WAIT itself remains uninterruptible and lasts five minutes',g.world.clock()['label']=='Mon 08:05am')

    # Independent execution: keyboard bridge only at A536/C415. C41F runs the
    # actual ROM and HALT/interrupt path, using the verified acceleration from
    # the main-loop research. No NativeWorld.submit/iter_submit is called here.
    ref=fresh().world.engine;s=ref.new_sim();m,r,R=s.memory,s.registers,ref.R
    s.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255))
    m[0xa011]=0;m[0xa037]=1;ref.put(s,0xa039,0);ref.put(s,0x9fdd,1)
    for row in range(0x9860,0x9920,8):ref.put(s,row+6,max(0,word(m,row+6)-1))
    m[0x9fdf:0x9fe3]=[0,8,0,97];ref.put(s,0x9866,1)
    g=fresh();compared=[];interrupts=0
    for command in ['WAIT','WAIT UNTIL 8:10AM','LOOK','WAIT UNTIL 8:15AM']:
        actual=run(g,command);keys=list(command.encode())+[13];frames=[]
        for _ in range(12000000):
            pc=r[R.PC]
            if pc==0xa536:
                if not keys:break
                r[R.A],r[R.F]=keys.pop(0),0;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
            if pc==0xc415:
                r[R.A],r[R.F]=32,0;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
            if pc==0xa074:frames.append(list(m[0x9fdd:0x9fe3]))
            previous=r[R.PC]
            if m[previous]==0x76 and r[26] and r[R.T]%s.frame_duration>=s.int_active:
                skipped=max(0,(s.frame_duration-r[R.T]%s.frame_duration-1)//4)
                r[R.T]+=4*skipped;r[15]=(r[15]&128)|((r[15]+skipped)&127)
            s.opcodes[m[r[R.PC]]]()
            if r[26] and r[R.T]%s.frame_duration<s.int_active:
                interrupts+=bool(s.accept_interrupt(r,m,previous))
        else:raise AssertionError('Reference did not reach the prompt')
        assert [word(f,0) for f in frames]==[f['tick'] for f in actual['frames']]
        assert g.world.m[0x9fdd:0x9fe3]==m[0x9fdd:0x9fe3],command
        assert g.world.m[0x9860:0x9920]==m[0x9860:0x9920],(command,'actor deadlines')
        for obj in data['entities']:
            start=int(obj['record'],16);end=start+obj['size']
            assert g.world.m[start:end]==m[start:end],(command,obj['id'])
        compared.append(command)
    check('Minute frames, 110 entity records and 24 actor rows match original code with real ROM interrupts',
          interrupts>0,commands=compared,interrupts=interrupts)

    g=fresh();g.teleport(58);out=g.command('OPEN WALL SAFE');story=' '.join(x['text'] for x in out['messages'])
    traces['death']={'fixture':'Map teleport to room 58, day 0, then OPEN WALL SAFE',**out}
    check('Original wall-safe death text reaches a terminal result instead of rollback',
          out['state']['game_over']['entry']=='9E74' and 'Perhaps you should try again.' in story
          and g.last_analysis['outcome']=='game_over')
    clock=g.world.clock();again=g.command('LOOK')
    check('Ended game accepts no more actions and retains its original ending on reload',
          not again['messages'] and g.world.clock()==clock and g.state()['ending_messages']==out['messages'])
    try:g.teleport(8);teleported=True
    except ValueError:teleported=False
    check('Map travel is frozen after game over',not teleported)
    # Declared fixture: put Lestrade and Basil (with their children) in room 8
    # and point Basil at a tiny VM call to the unmodified terminal rule 9E48.
    # This tests the real victory gateway, not a complete solved playthrough.
    g=fresh();m=g.world.m
    for ident in (2,6):
        children={ident}
        for _ in range(110):
            count=len(children)
            for obj in range(110):
                if m[word(m,0x8b70+obj*3)+1] in children:children.add(obj)
            if len(children)==count:break
        for obj in children:m[word(m,0x8b70+obj*3)+15]=8
    m[0x5bf0:0x5bf4]=[3,0x48,0x9e,15]
    row=next(a for a in range(0x9860,0x9920,8) if m[a]==6)
    g.parser.put(g.world.sim,row+1,0x5bf0);g.parser.put(g.world.sim,row+6,1)
    out=g.command('WAIT');traces['victory_gateway_fixture']=out
    check('The original victory gateway retains its text and terminates without tape I/O',
          out['state']['game_over']['text_pointer']=='6AF3' and
          'worlds greatest detective' in ' '.join(x['text'] for x in out['messages']))
    g=fresh();out=g.command('QUIT');check('QUIT ends cleanly before any tape access',out['state']['game_over']['reason']=='quit')
    check('Restart restores a live world and the free 08:00 clock',fresh().state()==initial)
    g=fresh();g.world.phase_budget=1;before=g.world.m[:];out=g.world.submit('WAIT',g.explored)
    check('Genuine lack of execution progress remains bounded and rolls back safely',
          out['analysis']['outcome']=='tool_limit' and g.world.m==before and not g.world.ended)
    return {'passed':True,'checks':checks,'traces':traces,
            'reference_policy':'The original prompt receives the same explicit free-start calendar/deadline normalization as Game; Z80 instructions are unchanged.'}


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results/wait-endgame-verification.json')
    args=ap.parse_args();result=verify(args.project);args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print('OK:',len(result['checks']),'controlli attese e fine partita.')
