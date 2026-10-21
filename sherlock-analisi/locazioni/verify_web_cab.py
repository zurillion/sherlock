#!/usr/bin/env python3
"""Regressioni dell'integrazione web del cab e confronto col flusso originale."""
import argparse,json,re,sys
from pathlib import Path
from explorer import Game
from native_world import NativeWorld,word
from extract_locations import extract

def norm(text):return ' '.join(text.split()).replace('`','£')
def cash(world,ident):
    p=word(world.m,0x8b70+3*ident);hi=world.m[p+10]
    return (hi if hi<128 else hi-256)*128+(world.m[p+9]&127)
def transcript(result):return norm(' '.join(m['text'] for m in result['messages']))
NATURAL=['OPEN YOUR DOOR','WEST','DOWN','OPEN FRONT DOOR','SOUTH','HAIL CAB','GET INTO CAB','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3

def verify_currency(project):
    g=Game(project,extract(project))
    count=transcript(g.command('COUNT YOUR MONEY'));assert '£5 4/-' in count and '`' not in count
    g.teleport(5)
    for c in ['HAIL CAB','GET INTO CAB','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3:g.command(c)
    paid=transcript(g.command('PAY £1 TO CABBIE'))
    assert 'You pay £1' in paid and '19/4' in paid and '`' not in paid
    assert cash(g.world,27)==1240 and cash(g.world,32)==0
    return {'count':count,'payment':paid,'player_pence':1240,'driver_balance':0}

def verify(project):
    class Checks(list):
        def append(self,value):
            print('OK:',value,flush=True);super().append(value)
    data=extract(project);checks=Checks();traces=[]
    g=Game(project,data)
    initial=g.state();assert initial['clock']['label']=='Mon 08:00am'
    stationary={i:g.world.m[word(g.world.m,0x8b70+3*i)+15] for i in (2,3,4,6)}
    for command in NATURAL:
        out=g.command(command);assert out['state']['analysis']['outcome']!='tool_limit',out
        traces.append({'command':command,'state':out['state'],'messages':out['messages']})
    assert g.world.room==28 and g.world.m[word(g.world.m,0x8b70)+1]==30
    assert cash(g.world,32)==-8
    assert stationary=={i:g.world.m[word(g.world.m,0x8b70+3*i)+15] for i in stationary}
    assert next(c for c in g.characters() if c['id']==31)['rooms']==[28]
    assert {1,5,28}<=g.explored
    checks.append('Natural walk, hail, boarding, quoted destination, transit and arrival; C1 and player markers move, other NPCs stay put')
    assert g.world.clock()['label']=='Mon 08:26am'
    images=[m.get('image_room') for row in traces for m in row['messages']]
    assert 1 in images and 28 in images
    checks.append('Native scheduler updates clock and scene/image events when an NPC moves the passenger')
    text=transcript(g.command('GET OUT OF CAB'));assert 'What about me money' in text
    text=transcript(g.command('PAY 1/- TO CABBIE'));assert 'pays 4d.' in text
    assert cash(g.world,27)==1240 and cash(g.world,32)==0
    checks.append('Disembarkation, protest, payment of a shilling and native four-penny change')

    def aboard():
        q=Game(project,data);q.teleport(5)
        for c in ['HAIL CAB','GET INTO CAB']:q.command(c)
        return q
    q=aboard();q.command('SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"')
    before=(q.world.clock(),cash(q.world,27),cash(q.world,32))
    for command in ['XYZZY','PICK THE NOTE UP','GET OUT OF CAB']:
        q.command(command);assert q.world.room==1 and before==(q.world.clock(),cash(q.world,27),cash(q.world,32))
    for _ in range(3):
        # Same observations as a page reload or compatibility-mode switch.
        q.world.scene();q.state()
    for c in ['WAIT']*3:q.command(c)
    assert q.world.room==28
    checks.append('Syntax errors and rejected exit do not advance a trip; repeated scene/state inspection preserves suspended NPC context')
    q=aboard();q.command('SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"')
    q.command('PAY 1/- TO CABBIE')
    for c in ['WAIT']*3:q.command(c)
    assert cash(q.world,32)==4 and cash(q.world,27)==1236
    q.command('SAY TO CABBIE "PAY 4D TO ME"');q.command('WAIT')
    assert cash(q.world,32)==0 and cash(q.world,27)==1240
    checks.append('Payment during transit retains native credit behaviour; a quoted PAY order recovers the change')
    q=aboard();q.command('SAY TO CABBIE "FURIOUSLY GO TO BUCKINGHAM PALACE ROAD"')
    assert cash(q.world,32)==-24
    for c in ['WAIT']*3:q.command(c)
    assert q.world.room==28
    checks.append('FURIOUSLY invokes the native accelerated trip and triple fare')
    q=aboard();q.command('SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"')
    for c in ['WAIT']*3:q.command(c)
    q.command('GET OUT OF CAB');out=q.command('EAST')
    assert 'You bloody snob' in transcript(out) and cash(q.world,32)==-8
    checks.append('Unpaid departure prints the original threat and keeps the debt')
    q=aboard();q.command('SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"');clock=q.world.clock()
    q.teleport(74)
    assert q.world.room==74 and q.world.m[word(q.world.m,0x8b70)+1]==255 and q.world.clock()==clock
    taxi_text=' '.join(transcript(q.command(c)) for c in ['WAIT']*3)
    assert q.world.room==74 and q.world.m[word(q.world.m,0x8b70)+1]==255
    assert 'You bloody snob' in taxi_text and q.world.m[word(q.world.m,0x8b70+30*3)+15] in (0,28)
    checks.append('Map teleport detaches player from cab without consuming time; the scheduled cab arrival cannot drag the player back')
    fresh=Game(project,data);assert fresh.state()==initial
    checks.append('Restart restores initial NPC rows, money, location and 08:00 clock')

    # Independent full-game probe: all NPCs enabled in both, no web clock offset.
    sys.path.insert(0,str(project/'sherlock-analisi/ai'));from trace_npc_ai import Probe
    ref=Probe(project,1);w=NativeWorld(project,active_npcs=None);w.m[0xa037]=1;w.engine.put(w.sim,0xa039,0);visited={8};compared=[]
    for c in NATURAL+['GET OUT OF CAB','PAY 1/- TO CABBIE']:
        original=ref.command(c);actual=w.submit(c,visited)
        assert norm(original['upper'])==norm(' '.join(m['text'] for m in actual['messages'] if m['kind']=='narrative')),(c,original['upper'],actual)
        assert norm(original['lower']).upper()==norm(' '.join(m['text'] for m in actual['messages'] if m['kind']=='error')).upper(),c
        for ident in [0,2,3,27,28,30,31,32,33,34,35]:
            p=word(w.m,0x8b70+3*ident)
            assert w.m[p:p+16]==ref.m[p:p+16],(c,ident)
        assert w.clock()['tick']==word(ref.m,0x9fdd)
        compared.append(c)
    checks.append('Bridge with all NPCs enabled matches independent full-game probe on 13 identical commands, texts, clock and 11 full entity records')
    currency=verify_currency(project);checks.append('Spectrum currency glyph is rendered as £; paying £1 returns 19/4 and settles the 8d fare')
    return {'currency':currency,'passed':True,'checks':checks,'active_npcs':[31,34],'full_game_comparison':compared,'traces':traces}

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results/web-cab-verification.json');a=ap.parse_args();result=verify(a.project);a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n');print('OK:',len(result['checks']),'controlli cab web e confronto originale.')
