"""Original Sherlock1984: offline container-exit AF evidence, direction-abi."""
import sys,json,gzip
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
s=json.loads(gzip.decompress((root/'results/container-exit-af/caption-entry.json.gz').read_bytes()));g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;rows=[]
for room in range(1,11):
 for column in [0,10,35]:
  for counter in [0,8,12,14]:
   m[:]=s['memory'];r[:]=s['registers'];frame=s['sp'];m[0xa033:0xa036]=[room,255,255];m[0xa036]=0;m[0x5d1a:0x5d2c]=[165]*18;m[0xa019]=counter;m[0xc128]=0;m[0xa025]=int(column>0);m[0xa026]=1;m[0xa9b5:0xa9b7]=[11,92]
   x=2+7*column;at=0x5020+x//8;m[0xc1f8:0xc1fa]=[at&255,at>>8];m[0xc1fa]=x&7;m[0xc1f5]=36-column
   first=True;flush_entry=False;word_text='';glyphs=[]
   def observe(m,r,R):
    global first,word_text,flush_entry
    if first:r[R.SP]=0x5d5a if flush_entry else frame;m[r[R.SP]:r[R.SP]+2]=[8,0];first=False
    if r[R.PC]==0xa9df:
     length=(r[R.H]*256+r[R.L]-0x5c0b)&65535
     if length<64:word_text=bytes(m[0x5c0b:0x5c0b+length]).decode('latin1')
    if r[R.PC]==0xc388 and r[R.A]!=32:glyphs.append(dict(word=word_text,char=chr(r[R.A]),frame=r[R.SP],shift=r[R.C],counter=m[0xa019]))
   w.observer=observe;out=w.call(0xca76);first=True;flush_entry=True;tail=w.call(0xa9b7,a=13)
   rows.append(dict(action=room,column=column,counter=counter,text=out['text']+' '+tail['text'],pending=bytes(m[0x5c0b:m[0xa9b5]+256*m[0xa9b6]]).decode('latin1'),glyphs=glyphs,cells={str(a):m[a]for a in range(0x5d1a,0x5d2c)},final_counter=m[0xa019]))
(root/'results/container-exit-af/direction-abi.json').write_text(json.dumps(dict(protocol='Controlled CA76/SP5D6C caption plus final CR A9B7/SP5D5A. Actor0,all10directions,no arguments,columns0/10/35,counters0/8/12/14;empty pending,spacing by column,capital1,A5 markers. No world ticks; all24 actor programs retained. This tests the caption, not movement reachability.',entry_sp=s['sp'],cases=rows),separators=(',',':'))+'\n');print(len(rows),flush=True)
