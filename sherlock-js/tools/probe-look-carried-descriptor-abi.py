"""Controlled original Sherlock1984 LOOK input: final name descriptor and wrap."""
import gzip,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
outdir=root/'results/look-carried-descriptor';saved=json.loads(gzip.decompress((outdir/'pre-look-prompt.json.gz').read_bytes()))
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;rows=[]
for column in range(36):
 for counter in [0,4,12,14]:
  m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored']);m[0xa025]=int(column>0);m[0xa026]=1;m[0xa019]=counter;m[0xc128]=0;m[0xa9b5:0xa9b7]=[11,92]
  x=2+7*column;address=0x5020+x//8;m[0xc1f8:0xc1fa]=[address&255,address>>8];m[0xc1fa]=x&7;m[0xc1f5]=36-column
  result=w.submit('LOOK',g.explored)
  rows.append(dict(column=column,counter=counter,clock=w.clock(),text=result['messages'],cells={str(a):m[a]for a in range(0x5d1a,0x5d2c)},final_counter=m[0xa019],final_mode=m[0xc128]))
(outdir/'look-abi.json').write_text(json.dumps(dict(protocol='144 controlled complete LOOK inputs from original checkpoint3014. 36 initial columns and counters0/4/12/14; wide mode, empty pending, explicit spacing/capital flags. All24 actor programs retained, injected uppercase input and immediate MORE, no world-position/identity changes. This varies display geometry and may change random inputs; not144 natural histories.',cases=rows),separators=(',',':'))+'\n');print(len(rows),flush=True)
