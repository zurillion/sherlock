"""Original Sherlock1984: controlled geometry of D68C and the final formatter CR."""
import sys,json,gzip
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
s=json.loads(gzip.decompress((root/'results/full-arrival-exits/d68c-entry.json.gz').read_bytes()));g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;rows=[]
for room in [21,23,45]:
 for column in range(36):
  for counter in [0,3,8,12,14]:
   m[:]=s['memory'];r[:]=s['registers'];frame=s['sp'];r[R.A]=room;r[R.B]=room;m[0x5d1a:0x5d2c]=[165]*18;m[0xa019]=counter;m[0xc128]=0;m[0xa025]=int(column>0);m[0xa026]=1;m[0xa9b5:0xa9b7]=[11,92]
   x=2+7*column;at=0x5020+x//8;m[0xc1f8:0xc1fa]=[at&255,at>>8];m[0xc1fa]=x&7;m[0xc1f5]=36-column
   first=True;flush_entry=False;word_text='';glyphs=[]
   def observe(m,r,R):
    global first,word_text,flush_entry
    if first:r[R.SP]=0x5d5c if flush_entry else frame;m[r[R.SP]:r[R.SP]+2]=[8,0];first=False
    if r[R.PC]==0xa9df:
     length=(r[R.H]*256+r[R.L]-0x5c0b)&65535
     if length<64:word_text=bytes(m[0x5c0b:0x5c0b+length]).decode('latin1')
    if r[R.PC]==0xc388 and r[R.A]!=32:glyphs.append(dict(word=word_text,char=chr(r[R.A]),frame=r[R.SP],shift=r[R.C],counter=m[0xa019]))
   w.observer=observe;out=w.call(0xd68c);first=True;flush_entry=True;tail=w.call(0xa9b7,a=13)
   rows.append(dict(room=room,column=column,counter=counter,text=out['text']+' '+tail['text'],pending=bytes(m[0x5c0b:m[0xa9b5]+256*m[0xa9b6]]).decode('latin1'),glyphs=glyphs,cells={str(a):m[a]for a in range(0x5d1a,0x5d2c)},final_counter=m[0xa019]))
(root/'results/full-arrival-exits/formatter-abi.json').write_text(json.dumps(dict(protocol='Controlled original D68C from its genuine full-arrival entry SP5D5E; rooms21(two directions),23(one),45(no ungated direction);36 columns and five counters; wide mode, empty pending buffer, spacing flag0 at column0/1 otherwise, capitalization flag1, and A5 markers. Then flush the last direction using the measured final CR entry A9B7/SP5D5C (glyph5D48); this is the no-contents arrival continuation. All24 actor programs retained but no world ticks during this isolated call. This is an isolated formatter ABI, not a natural-play certificate.',entry_sp=s['sp'],cases=rows),separators=(',',':'))+'\n');print(len(rows),flush=True)
