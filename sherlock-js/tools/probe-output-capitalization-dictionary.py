"""Original A887 context70 after its leading-space flush; controlled ABI only."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;before=(m[:],w.sim.registers[:]);cases=[]
for visible in [False,True]:
 for flag in [0,1,254,255]:
  for descriptor in [0x5000,0x5971,0x7000,0x7971]:
   m[:]=before[0];w.sim.registers[:]=before[1];m[0x5c3c]=int(visible);m[0xa027]=0;m[0xa026]=flag;w.engine.put(w.sim,0xa9b5,0x5c0b);r=w.sim.registers;R=w.R;r[R.D]=descriptor>>8;r[R.E]=descriptor&255;w.call(0xa887);cases.append(dict(visible=visible,initial=flag,descriptor=descriptor,value=m[0xa026]))
root=p/'sherlock-js/results/output-capitalization';(root/'dictionary-abi.json').write_text(json.dumps(dict(protocol='Controlled original A887 with empty word buffer, channel0, context50/70, offset0/Watson, visibility0/1 and incoming0/1/254/255. No code patches or natural reachability claim.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
