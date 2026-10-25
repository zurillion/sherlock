"""Offline controlled comparisons of DEC1 placement preflight, no actor turns."""
import argparse, itertools, json, sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;R=w.R
base=m[:];registers=w.sim.registers[:]
rows=[]
cases=[dict(size=32,capacity=c,contents=list(items),properties=1,attributes=160)for c,items in itertools.product([31,32,33,64,127,128,254,255],[[],[32],[64],[128],[127,1],[128,128],[255,1],[1,255]])]
cases += [dict(size=32,capacity=255,contents=[],properties=props,attributes=128|flags)for props,flags in itertools.product([0,1,2,4,5],[0,8,32,40,64|32,32|1])]
for case in cases:
 m[:]=base;w.sim.registers[:]=registers
 record=lambda ident:word(m,0x8b70+3*ident)
 obj,target,actor=record(22),record(23),record(0)
 m[obj+1]=0;m[obj+2]=case['size'];m[obj+15]=8
 m[target+2]=case['capacity'];m[target+4]=case['properties'];m[target+5]=case['attributes']
 for ident in range(110):
  q=record(ident)
  if m[q+1]==23:m[q+1]=255
 for ident,size in zip([15,16],case['contents']):
  q=record(ident);m[q+1]=23;m[q+2]=size;m[q+15]=8
 for at,value in [(0xa013,obj),(0xa015,target),(0xa017,actor)]:w.engine.put(w.sim,at,value)
 m[0xa033:0xa037]=[39,22,23,0];m[0xa009]=m[0xa00a]=8;m[0xa00b]=0
 w.sim.registers[R.H]=0xde;w.sim.registers[R.L]=0xc1
 result=w.call(0xc9bf)
 row={**case,'allowed':not result['z']}
 if row['allowed']:
  m[0xa00b]=1;w.sim.registers[R.H]=0xde;w.sim.registers[R.L]=0xc1
  execution=w.call(0xc9bf);row['execution_allowed']=not execution['z']
  if not row['execution_allowed']:
   address=w.sim.registers[R.H]*256+w.sim.registers[R.L]
   assert address==0xcb7b,hex(address)
 rows.append(row)
mask_errors=[]
for flags in [128,224]:
 m[:]=base;w.sim.registers[:]=registers;g.command('TAKE LAMP');m[word(m,0x8b70+3*23)+5]=flags
 out=g.command('PUT LAMP ON YOUR ARMCHAIR')
 mask_errors.append(dict(attributes=flags,errors=[x['text']for x in out['messages']if x['kind']=='error'],clock=w.clock(),player_saved=list(m[0x9863:0x9866]),parent=m[word(m,0x8b70+3*22)+1],failures=m[0xcc0b]))
args.output.write_text(json.dumps(dict(scope='Controlled original DEC1/DED9 preflight and execution; fixed setup from seeded startup. Full-command mask errors are separately identified and run all actors.',cases=rows,full_command_mask_errors=mask_errors),indent=2)+'\n')
print(len(rows),'controlled native placement comparisons')
