"""Original Sherlock1984: offline container-exit AF evidence, caption-abi."""
import json,gzip,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
saved=json.loads(gzip.decompress((root/'results/container-exit-af/caption-entry.json.gz').read_bytes()))
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;rows=[]
for actor in [0,3]:
 for action in [13,25]:
  for target in [30,42]:
   for column in range(36):
    for counter in [0,8,12,14]:
     m[:]=saved['memory'];r[:]=saved['registers'];frame=r[R.SP];m[0xa033]=action;m[0xa034]=target;m[0xa035]=255;m[0xa036]=actor;m[0xa025]=int(column>0);m[0xa026]=1;m[0x5d1a:0x5d2c]=[165]*18;m[0xa019]=counter;m[0xc128]=0;m[0xa9b5:0xa9b7]=[11,92]
     x=2+7*column;at=0x5020+x//8;m[0xc1f8:0xc1fa]=[at&255,at>>8];m[0xc1fa]=x&7;m[0xc1f5]=36-column
     entered=False;flush_entry=False;minimum=65535
     def observe(m,r,R):
      global entered,minimum,flush_entry
      if not entered:r[R.SP]=0x5d5a if flush_entry else frame;m[r[R.SP]:r[R.SP]+2]=[8,0];entered=True
      minimum=min(minimum,r[R.SP])
     w.observer=observe;out=w.call(0xca76);entered=False;flush_entry=True;tail=w.call(0xa9b7,a=13)
     rows.append(dict(actor=actor,action=action,target=target,column=column,counter=counter,min_sp=minimum,text=out['text']+' '+tail['text'],cells={str(a):m[a]for a in range(0x5d1a,0x5d2c)}))
(root/'results/container-exit-af/caption-abi.json').write_text(json.dumps(dict(protocol='Controlled CA76/SP5D6C from the natural Watson climb-out announcement at3210; actor0/3,actions13/25,targets30/42,36columns,counters0/8/12/14. Wide mode,empty pending,explicit spacing/capital flags,A5 markers. Final CR uses measured A9B7/SP5D5A. Argument overrides and synthetic return0008 are controlled caption setups, not natural gameplay. All24 actor programs retained; no world ticks.',cases=rows),separators=(',',':'))+'\n');print(len(rows),flush=True)
