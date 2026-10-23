"""Controlled native text-selector experiment, offline only."""
import sys,json,argparse
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();p=a.project;sys.path.insert(0,str(p/'sherlock-analisi/parser'))
from sherlock_parser import SherlockParser
e=SherlockParser(p);s=e.new_sim();R=e.R;m=s.memory;r=s.registers;rows=[]
for count in [1,2,3,4,8]:
 for raw in range(256):
  seed=(raw+1)&255;offset=0x20;ix=0x6000
  m[ix:ix+count+2]=[10,count]+[65+i for i in range(count)]
  m[0xa037]=seed;e.put(s,0xa039,0);m[0x100]=(raw-seed)&255;m[0x121]=0
  r[R.IXh],r[R.IXl]=ix>>8,ix&255;r[R.D],r[R.E]=0,offset;r[R.PC]=0xa6d3;r[R.SP]=0x5d7e;e.put(s,0x5d7e,8)
  selected=[]
  for step in range(100000):
   pc=r[R.PC]
   if pc==8:break
   if pc==0xa6f0:
    selected.append((r[R.IXh]*256+r[R.IXl])-ix-2);r[R.PC]=0xa6f3;continue
   s.opcodes[m[pc]]()
  else:raise RuntimeError((count,raw,hex(r[R.PC])))
  assert len(selected)==1,(count,raw,selected)
  rows.append({'count':count,'raw':raw,'seed':seed,'cursor':0,'mixOffset':offset,'first':(raw-seed)&255,'second':0,'index':selected[0],'next_seed':m[0xa037],'next_cursor':m[0xa039]+256*m[0xa03a]})
print('native selector cases',len(rows))
a.output.write_text(json.dumps({'scope':'Native A6D3 selector; controlled input bytes; output renderer skipped after capturing the actual selected option. Not a gameplay random provider.','cases':rows},separators=(',',':'))+'\n')
