"""Offline Sherlock1984: controlled root name plus its measured period/CR callers."""
import gzip,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
outdir=root/'results/narrow-arrival-descriptor';saved=json.loads(gzip.decompress((outdir/'name-entry.json.gz').read_bytes()))
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;rows=[]
for mode in [0,1]:
 for column in range(18 if mode else 36):
  for counter in [0,6,11,14]:
   m[:]=saved['memory'];r[:]=saved['registers'];m[0xa025]=int(column>0);m[0xa026]=0;m[0xa028]=0;m[0xa019]=counter;m[0xc128]=mode;m[0xa9b5:0xa9b7]=[11,92];m[0x5d22:0x5d24]=[165,165]
   x=2+7*column;address=0x5020+x//8;m[0xc1f8:0xc1fa]=[address&255,address>>8];m[0xc1fa]=x&7;m[0xc1f5]=(18 if mode else 36)-column;entry=False;frame=0x5d42
   def observe(m,r,R):
    global entry
    if not entry:r[R.SP]=frame;m[frame:frame+2]=[8,0];entry=True
   w.observer=observe;first=w.call(0xd3e8);entry=False;frame=0x5d48;period=w.call(0xa9b7,a=46);entry=False;frame=0x5d5c;tail=w.call(0xa9b7,a=13)
   rows.append(dict(mode=mode,column=column,counter=counter,text=[first['text'],period['text'],tail['text']],cells={str(a):m[a]for a in range(0x5d1a,0x5d2c)},final_counter=m[0xa019],final_mode=m[0xc128]))
(outdir/'name-abi.json').write_text(json.dumps(dict(protocol='216 controlled D3E8 name calls from original train root-name entrySP5D42;mode0/1,all36/18columns,counters0/6/11/14,empty buffer,explicit flags,A5marks22/23,synthetic return0008. Measured periodA9B7/SP5D48 thenCRA9B7/SP5D5C. No ticks; all actor programs retained. Not216 natural histories.',cases=rows),separators=(',',':'))+'\n');print(len(rows),flush=True)
