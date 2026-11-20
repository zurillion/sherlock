"""Controlled announcement ABI from natural extra-LOOK entries, offline only."""
import gzip,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;rows=[]
for tick in [1805,1806,1808,1809]:
 saved=json.loads(gzip.decompress((root/f'results/extra-look-carried-scan/entry-{tick}.json.gz').read_bytes()))
 for column,counter in [(0,c)for c in range(15)]+[(c,0)for c in range(1,36)]:
  m[:]=saved['memory'];r[:]=saved['registers'];frame=r[R.SP];entry=saved['entry'];m[0x5d1a:0x5d1e]=[165]*4;m[0xa019]=counter;m[0xc128]=0;m[0xa9b5:0xa9b7]=[11,92]
  x=2+7*column;address=0x5020+x//8;m[0xc1f8:0xc1fa]=[address&255,address>>8];m[0xc1fa]=x&7;m[0xc1f5]=36-column
  entered=False;minimum=65535;frames=set()
  def observe(m,r,R):
   global entered,minimum
   if not entered:r[R.SP]=frame;m[frame:frame+2]=[8,0];entered=True
   minimum=min(minimum,r[R.SP])
   if r[R.PC]==0xc388:frames.add(r[R.SP])
  w.observer=observe;out=w.call(entry)
  rows.append(dict(tick=tick,entry=entry,frame=frame,column=column,counter=counter,min_sp=minimum,glyph_frames=sorted(frames),text=out['text'],cells=m[0x5d1a:0x5d1e]))
(root/'results/extra-look-carried-scan/announcement-abi.json').write_text(json.dumps(dict(protocol='Controlled re-entry of four announcements captured from the natural extra-LOOK seed1 history; synthetic return0008. Marker A5 in1A–1D, all36 columns at counter0, fresh row counters0..14, wide mode. Does not certify natural reachability of altered geometry.',cases=rows),separators=(',',':'))+'\n')
print(len(rows),sum(r['cells']==[165]*4 for r in rows),flush=True)
