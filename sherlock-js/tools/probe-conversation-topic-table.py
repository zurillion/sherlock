"""Original E207/E201 table selection ABI, all actor bytes and 12 topic cases."""
import sys,json,hashlib
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
w=Game(p,extract(p),seed=1,active_npcs=None).world;m=w.m;r=w.sim.registers;R=w.R;source=bytes(m[0xe22a:0xe28d]);cases=[]
for actor in range(256):
 for subject in [0,7,13,15,16,17,18,67,98,109,254,255]:
  assert bytes(m[0xe22a:0xe28d])==source
  found=w.call(0xe207,a=actor);header=r[R.IXh]*256+r[R.IXl];assert not found['z']
  pointer=header+1;r[R.IXh]=pointer>>8;r[R.IXl]=pointer&255
  found=w.call(0xe201,a=subject);entry=r[R.IXh]*256+r[R.IXl]
  cases.append(dict(actor=actor,subject=subject,header=header,entry=entry,matched=not found['z'],text=f'{word(m,entry+1):04X}'if not found['z']else'761D'))
assert bytes(m[0xe22a:0xe28d])==source
root=p/'sherlock-js/results/conversation-topic-table';root.mkdir(exist_ok=True);(root/'selector-abi.json').write_text(json.dumps(dict(protocol='Controlled calls to original E207/E201. All256 actor-byte values,12 topic values; no game/world or opcode patches. Selector ABI only, not admissibility of arbitrary actors in play. Whole99-byte table checked unchanged after every pair. FE is source default speaker, not per-topic fallback.',table_sha256=hashlib.sha256(source).hexdigest(),table=list(source),cases=cases),separators=(',',':'))+'\n');print(len(cases),flush=True)
