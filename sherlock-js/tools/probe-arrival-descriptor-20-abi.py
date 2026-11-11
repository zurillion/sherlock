"""Controlled CBC2 arrival notification: verify the lower renderer boundary."""
import sys,json,gzip
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
root=p/'sherlock-js/results/passage-descriptor-20/wide-abi';saved=json.loads(gzip.decompress((p/'sherlock-js/results/list-stack-1c/entry-notify.json.gz').read_bytes()));data=json.loads((p/'sherlock-js/data/game.json').read_text());g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;frame=saved['registers'][R.SP];rows=[]
subjects=[(e['id'],None)for e in data['entities']if e['person']and e['id']!=0]+[(3,k)for k in range(4)]+[(e['id'],8)for e in data['entities']if e['person']and e['id']!=0]
for ident,kind in subjects:
 for column in range(36):
  m[:]=saved['memory'];r[:]=saved['registers'];ptr=m[0x8b70+ident*3]+256*m[0x8b71+ident*3];m[ptr]=1;m[ptr+1]=255;m[ptr+15]=48;m[ptr+5]|=128
  if kind is not None:
   if kind==8:m[ptr+9:ptr+13]=[0,0,0,0]
   noun=(m[ptr+7]+256*m[ptr+8])&4095;value=noun|(kind<<12);m[ptr+7:ptr+9]=[value&255,value>>8]
  r[R.A]=ident;m[0xa027]=0;m[0x5c3c]=1;m[0xa019]=0;m[0xc128]=0;m[0xa9b5:0xa9b7]=[11,92];m[0x5d1a:0x5d28]=[165]*14;x=2+7*column;at=0x5020+x//8;m[0xc1f8:0xc1fa]=[at&255,at>>8];m[0xc1fa]=x&7;m[0xc1f5]=36-column;entered=[];minimum=65535;glyph_frames=[]
  def observe(m,r,R):
   global minimum
   if not entered:r[R.SP]=frame;m[frame:frame+2]=[8,0];entered.append(True)
   minimum=min(minimum,r[R.SP])
   if r[R.PC]==0xc388:glyph_frames.append(r[R.SP])
  w.observer=observe;out=w.call(0xcbc2);cells=m[0x5d1a:0x5d28];noun=m[ptr+7]+256*m[ptr+8];qualifiers=[m[ptr+9]+256*m[ptr+10],m[ptr+11]+256*m[ptr+12]];eligible=bool(noun&32768)and all(not q or q&32768 for q in qualifiers);assert not eligible or cells[:12]==[165]*12,(ident,kind,column,minimum,cells)
  rows.append(dict(id=ident,kind=kind,eligible=eligible,column=column,frame=frame,min_sp=minimum,glyph_frames=sorted(set(glyph_frames)),text=out['text'],cells=cells))
(root/'arrival-low-abi.json').write_text(json.dumps(dict(protocol='Controlled CBC2 from real Watson walking-arrival entry; all initial person entities except player0 plus four ordinary noun classes,each36columns. Subject parent/room explicitly set to visible root in48. No natural-reachability claim. Synthetic return0008; Record markers1A–27 through wraps and name decoder. Preservation is asserted only for proper names without active qualifiers; qualified/ordinary-name counterexamples remain in the report.',cases=rows),separators=(',',':'))+'\n');print(len(rows),hex(min(r['min_sp']for r in rows)))
