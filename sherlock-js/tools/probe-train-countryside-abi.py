"""Offline Sherlock1984: countryside fragment and final CR at measured stack depths."""
import sys,json,gzip
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
outdir=root/'results/train-countryside-font';saved=json.loads(gzip.decompress((outdir/'prose-entry.json.gz').read_bytes()))
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;rows=[]
for mode in [0,1]:
 for column in range(18 if mode else 36):
  for counter in [0,5,11]:
   m[:]=saved['memory'];r[:]=saved['registers'];m[0xa025]=int(column>0);m[0xa026]=1;m[0xa019]=counter;m[0xc128]=mode;m[0xa9b5:0xa9b7]=[11,92];m[0x5d23]=165;m[0x5d29]=165
   x=2+7*column;address=0x5020+x//8;m[0xc1f8:0xc1fa]=[address&255,address>>8];m[0xc1fa]=x&7;m[0xc1f5]=(18 if mode else 36)-column;entered=False;frame=0x5d5a
   def observe(m,r,R):
    global entered
    if not entered:r[R.SP]=frame;m[frame:frame+2]=[8,0];entered=True
   w.observer=observe;first=w.call(0xa59f);entered=False;frame=0x5d58;tail=w.call(0xa9b7,a=13)
   rows.append(dict(mode=mode,column=column,counter=counter,text=[first['text'],tail['text']],screen_events=first['screen_events']+tail['screen_events'],cells={str(a):m[a]for a in range(0x5d1a,0x5d2c)},final_mode=m[0xc128],final_counter=m[0xa019]))
(outdir/'prose-abi.json').write_text(json.dumps(dict(protocol='162controlled A59F/HL7E45 calls, measuredSP5D5A and finalCR/A9B7SP5D58. Wide/narrow,36/18columns,counters0/5/11,emptybuffer,explicitflags,A5markers23/29,syntheticreturn0008. No ticks or natural-play claim; screen_events retained verbatim. Original world context from train departure.',cases=rows),separators=(',',':'))+'\n');print(len(rows),flush=True)
