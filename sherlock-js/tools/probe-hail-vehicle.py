"""Natural raw-word provenance at5C15, including identical A9D7 stores."""
import sys,json,gzip,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;root=p/'sherlock-js/results/murder-ending';restore=json.loads(gzip.decompress((root/'talk-native-prompt.json.gz').read_bytes()));assert restore['payload_sha256']==hashlib.sha256((p/'sherlock-analisi/block-10.bin').read_bytes()).hexdigest();m[:]=restore['memory'];w.sim.registers[:]=restore['registers'];w.input_registers=restore['input_registers'];w.input_stack=restore['input_stack'];g.explored=set(restore['explored']);g.last_listed=restore['last_listed'];g.last_analysis=restore['last_analysis'];g.opening_pending=False;g.cached_state=None
from native_world import word
commands=(root/'to-brown-clues.txt').read_text().splitlines();events=[]
def observe(m,r,R):
 if not(1510<=w.clock()['tick']<=1514) or m[0xa036]!=6:return
 if r[R.PC]in(0xe2ba,0xcfb9,0xe2c3):
  contexts=[];q=word(m,0x9fe9)
  while q:contexts.append(dict(pointer=q,bytes=m[q:q+7]));q=word(m,q-2)
  events.append(dict(pc=f'{r[R.PC]:04X}',a=r[R.A],argument=m[0xa034],actor=m[0xa036],clock=w.clock(),contexts=contexts))
w.observer=observe
for c in commands:
 out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running')and w.clock()['tick']<1514:out=g.continue_command(out['job'])
 if w.clock()['tick']>=1514:break
events=[e for e in events if e['pc']!='CFB9' or e['a']==30]
assert [e['pc']for e in events[:3]]==['E2BA','CFB9','E2C3'],events
assert events[1]['a']==30
assert any(c['bytes'][0]==31 for c in events[1]['contexts'])
assert not any(c['bytes'][0]==30 for c in events[1]['contexts'])
(root/'hail-vehicle-native.json').write_text(json.dumps(dict(protocol='Natural original full Jones-confession prompt restored unchanged; ordinary DROP/cab commands and minute WAIT. Observe Basil over ticks1510..1514; the successful HAIL is tick1513 before the minute increment. Source argument30 succeeds despite driver31 context.',events=events),indent=2)+'\n');print(events)
