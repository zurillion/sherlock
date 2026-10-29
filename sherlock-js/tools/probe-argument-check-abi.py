"""Controlled calls to argument validators; not a natural-game certificate."""
import sys,json,gzip
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];cases=[]
vectors=[]
for kind in range(16):
 ids=[0,8,9,105]if kind<5 else[22,254]if kind<7 else[0,3,22,25,48,49,50,60,109]
 for slot in[0,1]:
  for phase in[0,1]:
   for ident in ids:
    for tag in([0,128]if kind in[5,6]else[0]):vectors.append((kind,slot,phase,ident,tag,None))
for slot in[0,1]:
 for phase in[0,1]:
  for modes in range(16):
   for masks in[(0,0),(128,64),(33,40),(255,255)]:vectors.append((7,slot,phase,22,0,(modes,*masks)))
for kind,slot,phase,ident,tag,tests in vectors:
 m[:]=memory;r[:]=registers;at=0x8000;header=[0,0];header[slot]=kind;meta=dict(classes=header[:],masks=[])
 if tests:
  modes,lo,hi=tests;header[0]|=16;header += [modes<<(4 if slot==0 else 0),lo if slot==0 else 0,hi if slot==0 else 0,lo if slot==1 else 0,hi if slot==1 else 0];meta['masks']=[dict(argument=slot+1,tests=[dict(mode=modes>>2,mask=lo),dict(mode=modes&3,mask=hi)])]
 m[at:at+len(header)]=header;m[0xa034+slot]=ident;m[0xa036]=0;m[0xa00b]=phase;m[0xa021]=73;m[0xa02f:0xa033]=[tag,0,tag,0];r[R.IYh],r[R.IYl]=at>>8,at&255;events=[]
 def obs(m,r,R):
  if r[R.PC]in(0xc655,0xc6ba):events.append(r[R.A])
 w.observer=obs;out=w.call(0xc628 if slot==0 else 0xc6be)
 cases.append(dict(meta=meta,slot=slot,phase=phase,id=ident,literal=tag,initial=73,after=m[0xa021],writes=events,valid=not out['z']))
report=dict(protocol='Controlled original C628/C6BE calls from seed1/all-actors boot. Synthetic DATA header at8000, selected argument, phase, literal tag and initial A021=73 sentinel; no opcode patches. Tests both slots, all16 classes, both phases, all16 mask-mode pairs and zero/nonzero masks. Original world remains unmodified. Returns and every raw write compared; not a natural gameplay certificate.',cases=cases)
p.joinpath('sherlock-js/test/fixtures/argument-check-abi.json.gz').write_bytes(gzip.compress(json.dumps(report,separators=(',',':')).encode(),mtime=0));print(len(cases))
