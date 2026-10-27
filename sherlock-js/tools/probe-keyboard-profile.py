"""Exercise the actual ROM keyboard scanner, separately from gameplay."""
import sys,json
from pathlib import Path
from types import SimpleNamespace
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;R=w.R;result=[]
for release in [0,1,2,3,4,5,6,20]:
 m[0x5c00:0x5c0b]=[255,0,0,0,255,0,0,0,0,35,5];w.sim.registers[R.IYh],w.sim.registers[R.IYl]=0x5c,0x3a
 w.sim.set_tracer(SimpleNamespace(read_port=lambda registers,port:254 if port>>8==0xbf else 255,border=7,outfe=7));w.call(0x02bf)
 w.sim.set_tracer(SimpleNamespace(read_port=lambda *args:255,border=7,outfe=7))
 for _ in range(release):w.call(0x02bf)
 result.append(dict(releaseScans=release,bytes=list(m[0x5c00:0x5c0b])))
(p/'sherlock-js/test/fixtures/keyboard-profile-reference.json').write_text(json.dumps(result,indent=2)+'\n');print(result)
