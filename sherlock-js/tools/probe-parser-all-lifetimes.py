"""Source node lifetime evidence for shared ALL and exclusion edge cases."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
catalog=extract(p);cases=[]
for text in ['OPEN ALL AND PLAIN DOOR ALL','OPEN ALL AND PLAIN DOOR BUT YOUR DOOR']:
 g=Game(p,catalog,seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;events=[]
 def observe(m,r,R):
  pc=r[R.PC]
  if pc in [0xaf67,0xae19,0xae57]:
   nodes=[];q=word(m,0x9ff2)or word(m,0x9ff0);seen=set()
   while q and q not in seen:
    seen.add(q);nodes.append(dict(pointer=f'{q:04X}',words=[word(m,q+i)for i in range(0,30,2)]));q=word(m,q-2)
   events.append(dict(pc=f'{pc:04X}',iy=f'{r[R.IYh]*256+r[R.IYl]:04X}',all=m[0xa01a],nodes=nodes))
 w.observer=observe;out=g.command(text);cases.append(dict(input=text,events=events,messages=out['messages']));print(text,events,flush=True)
root=p/'sherlock-js/results/parser-all';root.mkdir(exist_ok=True);root.joinpath('node-lifetimes.json').write_text(json.dumps(dict(protocol='Fresh seed1 natural inputs, all actors; source node lists observed before failure/postprocessing. No world overlays. Offline evidence only.',cases=cases),indent=2)+'\n')
