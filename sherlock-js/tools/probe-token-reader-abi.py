"""Controlled original token-reader calls; no code patches or natural-play claim."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
catalog=extract(p);initial=[]
for seed in [1,2,77,255]:
 g=Game(p,catalog,seed=seed,active_npcs=None);initial.append(dict(seed=seed,pointer=word(g.world.m,0xa029)))
w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
for at in [0x5b81,0x5b90,0x5be0]:
 for kind in range(0,256,16):
  m[:]=memory;r[:]=registers;m[at:at+3]=[kind,0x12,0x34];m[0xa02b:0xa02d]=[at&255,at>>8];r[R.D]=0x70
  w.call(0xae7f);cases.append(dict(pointer=at,type=kind,start=word(m,0xa029),next=word(m,0xa02b),value=r[R.B]*256+r[R.C],previous_class=m[0xa02d],result_class=r[R.A]))
root=p/'sherlock-js/results/parser-token-start';root.mkdir(exist_ok=True);(root/'reader-abi.json').write_text(json.dumps(dict(protocol='Original AE7F called with controlled token-buffer address, type and 1234 payload; code and dictionary untouched. These are ABI calls, not naturally reached states. Four complete seed boots separately establish initial A029/A02A.',boot=initial,cases=cases),indent=2)+'\n');print(len(cases),initial)
