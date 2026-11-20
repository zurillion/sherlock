"""Controlled WEAR formatter geometry in the original 1984 game."""
import json,gzip,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
saved=json.loads(gzip.decompress((root/'results/extra-look-wear-scan/wear-entry.json.gz').read_bytes()))
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;rows=[]
for target in [14,101]:
 for column in range(36):
  for counter in range(15):
   m[:]=saved['memory'];r[:]=saved['registers'];frame=r[R.SP];m[0xa034]=target;m[0x5d1a:0x5d2c]=[165]*18;m[0xa019]=counter;m[0xc128]=0;m[0xa9b5:0xa9b7]=[11,92]
   x=2+7*column;at=0x5020+x//8;m[0xc1f8:0xc1fa]=[at&255,at>>8];m[0xc1fa]=x&7;m[0xc1f5]=36-column
   entered=False;minimum=65535
   def observe(m,r,R):
    global entered,minimum
    if not entered:r[R.SP]=frame;m[frame:frame+2]=[8,0];entered=True
    minimum=min(minimum,r[R.SP])
   w.observer=observe;out=w.call(saved['entry'])
   rows.append(dict(target=target,column=column,counter=counter,min_sp=minimum,text=out['text'],cells={str(a):m[a]for a in range(0x5d1a,0x5d2c)}))
(root/'results/extra-look-wear-scan/wear-abi.json').write_text(json.dumps(dict(protocol='Controlled CA76 announcement from the natural player WEAR entry at2286/SP5D6C. Both original disguise IDs,36columns,15line counters,wide mode. Argument override and A5 markers are controlled setups; not a natural-play certificate. Synthetic return0008.',cases=rows),separators=(',',':'))+'\n');print(len(rows),flush=True)
