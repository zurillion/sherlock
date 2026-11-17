"""Run Sherlock's own restart service with an in-memory cassette transport."""
import hashlib,json,sys
from pathlib import Path
from argparse import ArgumentParser
from types import SimpleNamespace
sys.dont_write_bytecode=True
parser=ArgumentParser(description=__doc__)
parser.add_argument('output', type=Path)
args=parser.parse_args()
project=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word

catalog=extract(project)
def state(w):
    m=w.m
    return dict(room=w.room,clock=w.clock(),graphics=m[0xA011],accumulator=m[0xA037],
                cursor=word(m,0xA039),query=m[0xA01B],syntax=word(m,0x9FF2),
                video=hashlib.sha256(bytes(m[0x4000:0x5B00])).hexdigest())
def commands(game, route):
    for line in route:
        game.command(line)
route=['OPEN YOUR DOOR','W','D','OPEN DOOR','S','LOOK']
saved=Game(project,catalog,seed=1,active_npcs=None)
commands(saved,route)
w=saved.world
start,end=0x840B,0xA01F
body=bytes(w.m[start:end])
header=bytearray(17)
header[0]=3
header[1:11]=b'SHERLOCK  '
header[11:13]=len(body).to_bytes(2,'little')
header[13:15]=start.to_bytes(2,'little')
pieces={0:header,255:body}

game=Game(project,catalog,seed=137,active_npcs=None)
commands(game,['WAIT','WAIT','WAIT','OPEN DOOR'])
world=game.world
before=state(world)
m,r,R=world.m,world.sim.registers,world.R
class ServiceReached(Exception): pass
captured=[]
def enter(m,r,R):
    if r[R.PC]==0xB0A6:
        captured.extend([m[:],r[:]])
        raise ServiceReached
world.observer=enter
try:
    world.submit('LOAD',game.explored)
except ServiceReached: pass
assert captured
m[:],r[:]=captured
world.observer=None
world.sim.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255))
events=[]
for _ in range(3_000_000):
    pc=r[R.PC]
    if pc in (0xB0AC,0xA0E7,0xB0EE,0xC0DF,0xA040,0xA05F,0xA061,0xA536):
        events.append(dict(pc=f'{pc:04X}',state=state(world)))
    if pc==0xA536:break
    if pc==0x0556:
        flag=r[R.A]
        address=(r[R.IXh]<<8)|r[R.IXl]
        length=(r[R.D]<<8)|r[R.E]
        incoming=pieces[flag]
        assert length==len(incoming)
        m[address:address+length]=incoming
        events.append(dict(pc='0556',flag=flag,address=address,length=length,
                           state=state(world)))
        r[R.F]|=1
        r[R.PC]=word(m,r[R.SP])
        r[R.SP]+=2
        continue
    if pc==0xC415:
        r[R.A]=ord('Y')
        r[R.PC]=0xC41E
        continue
    if pc==0xA061:r[R.A]=204
    world.sim.opcodes[m[pc]]()
else:raise RuntimeError('The service did not reach a new prompt.')
fresh=Game(project,catalog,seed=137,active_npcs=None)
new=fresh.command('NEW')
report=dict(protocol='LOAD typed at an ordinary prompt. Offline cassette uses real C0DF/C089 and substitutes only ROM 0556 header/data transfer. Graphics answer Y and accumulator byte 204 controlled at restart. SAVE data region taken from a normally played prompt.',saved=state(w),before=before,events=events,after=state(world),new=dict(analysis=new['state']['analysis'],messages=[m['text'] for m in new['messages']]))
assert before['query']==8 and report['after']['query']==0
assert report['after']['room']==report['saved']['room']==5
assert report['after']['cursor']==report['before']['cursor']!=report['saved']['cursor']
assert report['after']['accumulator']==204 and report['saved']['accumulator']!=204
assert report['after']['video']!=report['saved']['video']
assert new['state']['analysis']['outcome']=='lexical_error'
args.output.write_text(json.dumps(report,indent=2)+'\n')
