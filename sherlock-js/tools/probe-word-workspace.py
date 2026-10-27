"""Offline provenance of a stale word-workspace byte in the natural loss path."""
import sys,json
from collections import deque
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
s=json.loads((p/'sherlock-js/test/fixtures/natural-loss-reference.json').read_text())['cases'][1]
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0
trace=deque(maxlen=180);found=False;changes=[];last_value=w.m[0x5c0d];previous_pc=None;initial=list(w.m[0x5c0b:0x5c2b])
root=p/'sherlock-js/results/natural-loss';root.mkdir(exist_ok=True)
def observe(m,r,R):
 global found,last_value,previous_pc
 pc=r[R.PC]
 if m[0x5c0d]!=last_value:changes.append(dict(clock=w.clock()['label'],actor=m[0xa036],writer_pc=f'{previous_pc:04X}'if previous_pc is not None else None,before=last_value,after=m[0x5c0d],word_bytes=list(m[0x5c0b:0x5c1b])));last_value=m[0x5c0d]
 previous_pc=pc
 if pc==0xa9d7:
  at=r[R.H]*256+r[R.L]
  if 0x5c0b<=at<0x5c8b:trace.append(dict(clock=w.clock()['label'],actor=m[0xa036],address=f'{at:04X}',value=r[R.A],text=chr(r[R.A]),visible=m[0x5c3c],channel=m[0xa027]))
 if pc==0xd2d0 and (r[R.IXh]*256+r[R.IXl]+1)&65535==0x5c0d:
  found=True;(root/'word-workspace-provenance.json').write_text(json.dumps(dict(clock=w.clock(),value=m[0x5c0d],word_bytes=list(m[0x5c0b:0x5c2b]),initial=initial,changes=changes,last_writes=list(trace)),indent=2)+'\n');raise RuntimeError('Research stop: workspace provenance captured')
w.observer=observe
for command in s['prefix']:g.command(command)
out=g.start_command('WAIT UNTIL 11PM')
while out['running']and not found:out=g.continue_command(out['job'])
print('captured',found,w.clock()['label'],flush=True)
