"""Offline Sherlock1984 C388: root-name descriptor E independent from font, shifts and column."""
import sys,json,gzip
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
outdir=root/'results/narrow-arrival-descriptor';saved=json.loads(gzip.decompress((outdir/'separator-entry.json.gz').read_bytes()))
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;rows=[]
for descriptor in [0,0x40ff,0x5000,0x51ab,0x58f0,0x5fff]:
 for column in range(18):
  m[:]=saved['memory'];r[:]=saved['registers'];x=2+7*column;address=0x5020+x//8;r[R.A]=32;r[R.F]=0x1a;r[R.C]=x&7;r[R.D]=descriptor>>8;r[R.E]=descriptor&255;r[R.H]=address>>8;r[R.L]=address&255;entered=False
  def observe(m,r,R):
   global entered
   if not entered:r[R.SP]=0x5d28;m[0x5d28:0x5d2a]=[8,0];entered=True
  w.observer=observe;w.call(0xc388)
  rows.append(dict(column=column,descriptor=descriptor,cells={str(a):m[a]for a in range(0x5d1a,0x5d2c)}))
(outdir/'glyph-abi.json').write_text(json.dumps(dict(protocol='108 controlled original C388 calls from natural root-name separator entry;frame5D28,synthetic return0008,18columns,six supplied DE descriptors with different low bytes,CP13 flags. No ticks or natural-play claim.',cases=rows),separators=(',',':'))+'\n');print(len(rows),flush=True)
