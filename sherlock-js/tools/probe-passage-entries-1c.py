"""Natural raw-word provenance at5C13, including identical A9D7 stores."""
import sys,json,gzip,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;root=p/'sherlock-js/results/murder-ending';restore=json.loads(gzip.decompress((root/'talk-native-prompt.json.gz').read_bytes()));assert restore['payload_sha256']==hashlib.sha256((p/'sherlock-analisi/block-10.bin').read_bytes()).hexdigest();m[:]=restore['memory'];w.sim.registers[:]=restore['registers'];w.input_registers=restore['input_registers'];w.input_stack=restore['input_stack'];g.explored=set(restore['explored']);g.last_listed=restore['last_listed'];g.last_analysis=restore['last_analysis'];g.opening_pending=False;g.cached_state=None
from native_world import word
commands=(root/'to-brown-clues.txt').read_text().splitlines()[:24]+['LOOK'];entries=[];mode='arrival'
def observe(m,r,R):
 if r[R.PC]==0xcbc2 and r[R.A]==3 and m[0xa036]==3 and m[0xa009]==48:
  (p/'sherlock-js/results/list-stack-1c/entry-notify.json.gz').write_bytes(gzip.compress(json.dumps(dict(protocol='Complete real CBC2 entry for Watson walking into kitchen, no patches. ABI only.',memory=m[:],registers=r[:],clock=w.clock())).encode()))
 if r[R.PC]==0xd60b and m[0xa036]==0 and w.clock()['tick']>=1653:
  target=p/'sherlock-js/results/list-stack-1c'/('entry-'+mode+'.json.gz')
  target.write_bytes(gzip.compress(json.dumps(dict(protocol='Complete unmodified original D60B entry, normal S into kitchen or following LOOK. Controlled ABI input only; never imported into JS.',memory=m[:],registers=r[:],clock=w.clock(),mode=mode)).encode()))
  entries.append(dict(mode=mode,sp=r[R.SP],clock=w.clock()))
w.observer=observe
for i,c in enumerate(commands):
 if i==24:mode='look'
 out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running'):out=g.continue_command(out['job'])
assert {e['mode']for e in entries}=={'arrival','look'},entries
root=p/'sherlock-js/results/list-stack-1c';(root/'entries.json').write_text(json.dumps(entries,indent=2)+'\n');print(entries)
