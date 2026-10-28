"""Reproduce the natural source call chain which owns 5D1F at the late boundary."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;glyphs=[]
def obs(m,r,R):
 sp=r[R.SP]
 if r[R.PC]==0xc388 and w.clock()['tick']==964 and sp==0x5d2a:
  glyphs.append(dict(frame=sp,char=r[R.A],descriptor=r[R.D]*256+r[R.E],word=bytes(m[0x5c0b:0x5c38]).split(b'\0')[0].decode('latin1'),stack=[f'{word(m,a):04X}'for a in range(sp,0x5d80,2)]))
for c in (p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not c or c.startswith('#'):continue
 if c.startswith('WAIT UNTIL'):
  out=g.start_command(c)
  while out['running'] and w.clock()['tick']<970:
   if w.clock()['tick']>=960:w.observer=obs
   out=g.continue_command(out['job'])
 else:out=g.command(c)
 if w.clock()['tick']>=970:break
assert ''.join(chr(x['char'])for x in glyphs)=='Inspector'
root=p/'sherlock-js/results/upper-stack';root.mkdir(exist_ok=True)
root.joinpath('order-call-chain.json').write_text(json.dumps(dict(protocol='Natural major-witness seed1, all actors; observer enabled from tick960, glyphs captured at tick964. Uppercase injected input, immediate MORE, native graphics off after boot. Actual C388 entry registers and return links; no actor/world patches. Offline evidence only.',tick=964,public_text_entry_sp='5D78',root_text='682A',calls=['682A -> 6804','6804 -> 67F7','actorName -> literal name prefix'],glyphs=glyphs),indent=2)+'\n');print('Verified Inspector prefix at tick964; C388 frame5D2A.')
