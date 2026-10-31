"""Controlled original token-reader calls; no code patches or natural-play claim."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
catalog=extract(p);initial=[]
for seed in [1,2,77,255]:
 g=Game(p,catalog,seed=seed,active_npcs=None);initial.append(dict(seed=seed,mode=g.world.m[0xa024]))
root=p/'sherlock-js/results/parser-mode';(root/'boot.json').write_text(json.dumps(dict(protocol='Four original cold starts with all24 actor slots; source A024 initial mode, not a controlled overwritten byte.',boot=initial),indent=2)+'\n');print(initial)
