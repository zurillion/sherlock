"""Offline Sherlock1984 C388: saved font A and descriptor D are independent."""
import sys,json,gzip
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
outdir=root/'results/train-countryside-font';saved=json.loads(gzip.decompress((outdir/'prose-entry.json.gz').read_bytes()))
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;rows=[]
for descriptor in [0x5c0b,0x51f7]:
 for char in [104,113,84]:
  for column in range(36):
   m[:]=saved['memory'];r[:]=saved['registers'];x=2+7*column;address=0x5020+x//8;difference=(char-13)&255;flags=2|8|(difference&128)|(64 if difference==0 else 0)|(16 if(char&15)<13 else 0)|(4 if((char^13)&(char^difference)&128)else 0)|(1 if char<13 else 0)
   r[R.A]=char;r[R.F]=flags;r[R.B]=3;r[R.C]=x&7;r[R.D]=descriptor>>8;r[R.E]=descriptor&255;r[R.H]=address>>8;r[R.L]=address&255;entered=False
   def observe(m,r,R):
    global entered
    if not entered:r[R.SP]=0x5d2e;m[0x5d2e:0x5d30]=[8,0];entered=True
   w.observer=observe;w.call(0xc388);rows.append(dict(char=chr(char),column=column,descriptor=descriptor,cells={str(a):m[a]for a in range(0x5d1a,0x5d2c)}))
(outdir/'glyph-abi.json').write_text(json.dumps(dict(protocol='216controlled C388/frame5D2E calls,threeglyphs including nonzero last font row,twoDE descriptors,36columns,CP13flags,syntheticreturn0008. No ticks or natural-play claim.',cases=rows),separators=(',',':'))+'\n');print(len(rows),flush=True)
