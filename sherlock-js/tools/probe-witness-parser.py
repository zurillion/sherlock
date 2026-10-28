import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0
commands=(p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines()
for c in commands[:25]:g.command(c)
last=None;events=[]
def obs(m,r,R):
 global last
 pc=r[R.PC];iy=r[R.IYh]*256+r[R.IYl];ix=r[R.IXh]*256+r[R.IXl]
 state=list(m[0x97ae:0x97d5])
 if state!=last:events.append(dict(pc=f'{pc:04X}',iy=f'{iy:04X}',ix=f'{ix:04X}',bc=r[R.B]*256+r[R.C],data=state));last=state
 if pc in [0xac17,0xac1a,0xab7c,0xab83,0xad57,0xae6a,0xa1af]:events.append(dict(at=f'{pc:04X}',iy=f'{iy:04X}',ix=f'{ix:04X}',bc=r[R.B]*256+r[R.C],parsed=word(m,0x9ff2),syntax=word(m,0x9ff0)))
w.observer=obs
out=g.command(commands[25]);p.joinpath('sherlock-js/results/parser-rule-lifetimes/parser-trace.json').write_text(json.dumps(dict(command=commands[25],events=events,analysis=out['state']['analysis']),indent=2));print(commands[25],w.clock())
