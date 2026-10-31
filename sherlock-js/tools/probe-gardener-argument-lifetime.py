"""Fresh natural original trace of gardener argument commits; offline only."""
import sys,json,gzip
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
from native_snapshot import snapshot
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;events=[];changes=[];previous=None;old=list(m[0x98a3:0x98a6]);steps=[]
sites={0xcc82,0xcd91,0xd026,0xd03b,0xd03e,0xd041,0xcf80,0xcfcf,0xd008,0xd01f,0xc591,0xc4d1,0xce18,0xce3b,0xce4f,0xce6a,0xce8f,0xceb8,0xce83,0xeddf,0xf198}
def obs(m,r,R):
 global previous,old
 tick=word(m,0x9fdd);value=list(m[0x98a3:0x98a6]);pc=r[R.PC]
 if tick>=3630:
  if value!=old:changes.append(dict(tick=tick,writer=previous,after=value))
  if m[0xa036]==8 and pc in sites:
   events.append(dict(tick=tick,pc=f'{pc:04X}',source_pc=f'{word(m,0x9fd9):04X}',row=list(m[0x98a0:0x98a8]),saved=list(m[0x9fd6:0x9fd9]),working=list(m[0xa033:0xa036]),actor=m[0xa036],iy=r[R.IYh]*256+r[R.IYl],ix=r[R.IXh]*256+r[R.IXl],a=r[R.A],f=r[R.F],hl=r[R.H]*256+r[R.L],contexts_head=word(m,0x9fe9)))
 previous=dict(pc=f'{pc:04X}',actor=m[0xa036],tick=tick,iy=r[R.IYh]*256+r[R.IYl],ix=r[R.IXh]*256+r[R.IXl]);old=value
w.observer=obs
for command in [c for c in(p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines()if c and not c.startswith('#')]:
 out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
 while out.get('running')and w.clock()['tick']<3651:out=g.continue_command(out['job'])
 print(w.clock()['label'],command,flush=True)
 steps.append(dict(command=command,clock=w.clock(),gardener=list(m[0x98a0:0x98a8])))
 if w.clock()['tick']>=3651:break
root=p/'sherlock-js/results/gardener-argument-lifetime';root.mkdir(exist_ok=True);(root/'natural-trace.json.gz').write_bytes(gzip.compress(json.dumps(dict(protocol='Natural seed1/all24/free initial LOOK/native graphics off/injected uppercase/immediate MORE; no world or instruction patches. Trace after tick3630.',events=events,changes=changes,steps=steps,after=snapshot(w)),separators=(',',':')).encode(),mtime=0));print('complete',len(events),len(changes),flush=True)
