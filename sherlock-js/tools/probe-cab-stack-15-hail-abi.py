"""Controlled E2CB calls from the captured natural hidden DOMAIN entry."""
import sys,json,gzip
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
root=p/'sherlock-js/results/cab-stack-15';saved=json.loads(gzip.decompress((root/'hail-entry.json.gz').read_bytes()));g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;rows=[]
for frame in [0x5d66,0x5d6e]:
 for vehicle in [30,33]:
  for prior in [0,31,255]:
   for marker in [0,165]:
    m[:]=saved['memory'];r[:]=saved['registers'];m[0xa034]=vehicle;m[0xa00a]=prior;m[0x5d15]=marker;entered=[];depth=[];glyphs=[]
    def observe(m,r,R):
     if not entered:r[R.SP]=frame;m[frame:frame+2]=[8,0];entered.append(True)
     depth.append(r[R.SP])
     if r[R.PC]==0xc388:glyphs.append(r[R.A])
    w.observer=observe;out=w.call(0xe2cb);assert m[0x5d15]==marker and not glyphs
    rows.append(dict(frame=frame,vehicle=vehicle,prior=prior,marker=marker,after=m[0x5d15],min_sp=min(depth),glyphs=len(glyphs),steps=out['steps']))
(root/'hail-abi.json').write_text(json.dumps(dict(protocol='Controlled E2CB ABI restored from a real hidden Basil HAIL entry. Vary entry frame66/6E, vehicle30/33, prior action0/31/255 and5D15marker0/A5. Synthetic return0008; not natural reachability of all cases. Ordinary allocation, no visible relocation or renderer calls. Scope is hidden DOMAIN HAIL; visible/requested callers remain unowned.',cases=rows),indent=2)+'\n');print(len(rows),hex(min(x['min_sp']for x in rows)))
