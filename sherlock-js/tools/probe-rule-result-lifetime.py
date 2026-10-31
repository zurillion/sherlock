"""Fresh original rule-result bridge provenance, including unchanged word stores. Offline only."""
import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;previous=[word(m,0xcb28),word(m,0xcb2a)];pending=None;last=[None,None];bridge=None;bridges={};events=[];counts={};unclassified=[];draws=[];draw=None;steps=[]
def observe(m,r,R):
 global pending,bridge,previous,draw
 pc=r[R.PC];values=[word(m,0xcb28),word(m,0xcb2a)];written=set()
 if pending is not None:
  slot=pending.pop('slot');last[slot]={**pending,'value':values[slot]};events.append(last[slot]);written.add(slot);pending=None
 for i,v in enumerate(values):
  if v!=previous[i]and i not in written:unclassified.append(dict(slot=i,value=v,pc=f'{pc:04X}',tick=word(m,0x9fdd)))
 previous=values
 if pc==0xcb34:bridges[r[R.SP]]=dict(stack_pointer=r[R.SP],target=f'{r[R.H]*256+r[R.L]:04X}',ix=r[R.IXh]*256+r[R.IXl],iy=r[R.IYh]*256+r[R.IYl],args=list(m[0xa033:0xa036]),tick=word(m,0x9fdd),actor=m[0xa036],stack_top=f'{word(m,r[R.SP]):04X}')
 if pc in(0xcb37,0xcb3b):
  counts[f'{pc:04X}']=counts.get(f'{pc:04X}',0)+1
  pending=dict(slot=int(pc==0xcb3b),pc=f'{pc:04X}',tick=word(m,0x9fdd),actor=m[0xa036],ix=r[R.IXh]*256+r[R.IXl],iy=r[R.IYh]*256+r[R.IYl],bridge=bridges.get(r[R.SP]))
 if pc==0xd2ad:draw=dict(tick=word(m,0x9fdd),pointers=values,last_stores=last[:],actor=m[0xa036],width=r[R.A],mixOffset=r[R.D]*256+r[R.E],seed=m[0xa037],cursor=word(m,0xa039),reads=[]);draws.append(draw)
 if draw is not None and pc in(0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535;draw['reads'].append(dict(address=at,value=m[at]))
  if 0xcb28<=at<=0xcb2b:print('READ',f'{at:04X}',draw,flush=True)
 if draw is not None and pc==0xd2ec:
  a=r[R.A];draw.update(result=abs(a if a<128 else a-256),next_seed=m[0xa037],next_cursor=word(m,0xa039));draw=None
w.observer=observe
for command in(p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not command or command.startswith('#'):continue
 out=g.start_command(command)if command.startswith('WAIT UNTIL')else g.command(command)
 while True:
  steps.append(dict(input=command,clock=w.clock(),pointers=[word(m,0xcb28),word(m,0xcb2a)],last_stores=last[:],stores=events[:],random=draws[:],running=bool(out.get('running'))));events.clear();draws.clear();command=None
  if not out.get('running')or w.clock()['tick']>=4231:break
  out=g.continue_command(out['job'])
 print(w.clock()['label'],last[0],flush=True)
 if w.clock()['tick']>=4231 or w.ended:break
root=p/'sherlock-js/results/rule-result-lifetime';root.mkdir(exist_ok=True)
(root/'natural-reference.json.gz').write_bytes(gzip.compress(json.dumps(dict(bridge_frames='Matched by SP at CB34 and CB37/CB3B, including nested bridges.',protocol='Fresh original seed1/all24 actors/free initial LOOK/native graphics off after boot/injected uppercase/immediate MORE. Every CB37/CB3B store including unchanged values, bridge targets and input/output IX/IY, random pointers at every draw and clock-only minute checkpoints. No code/world patches. Full-state acceptance is separate.',steps=steps,store_counts=counts,unclassified_transitions=unclassified),separators=(',',':')).encode(),mtime=0));print('complete',len(steps),counts,len(unclassified),flush=True)
