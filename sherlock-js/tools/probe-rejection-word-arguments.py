"""Original B633/B62F model-word selection plus A887, controlled ABI only."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
from native_world import word
models=json.loads((p/'sherlock-analisi/locazioni/results/gameplay-action-inventory.json').read_text())['models'];g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;memory=m[:];registers=r[:];rows=[]
for model in models:
 for slot in[0,1]:
  for visible in[0,1]:
   m[:]=memory;r[:]=registers;ptr=int(model['address'],16);m[0xb18e:0xb190]=[ptr&255,ptr>>8];m[0xa022:0xa024]=[0x56,0x34];m[0x5c3c]=visible;w.call(0xb633 if slot==0 else 0xb62f);sp=r[R.SP];args=[word(m,sp),word(m,sp+2)];events=[]
   def observe(m,r,R):
    if r[R.PC]in(0xa88c,0xa8b5):events.append(dict(pc=f'{r[R.PC]:04X}',reference=r[R.D]*256+r[R.E]if r[R.PC]==0xa88c else r[R.H]*256+r[R.L]))
   w.observer=observe
   for value in args:r[R.D]=value>>8;r[R.E]=value&255;w.call(0xa887)
   w.observer=None;rows.append(dict(action=model['id'],slot=slot,visible=bool(visible),raw_model=[word(m,ptr+i)for i in range(0,8,2)],arguments=args,final=word(m,0xa022),events=events))
root=p/'sherlock-js/results/dictionary-reference-22';(root/'model-word-abi.json').write_text(json.dumps(dict(protocol='Controlled original B633(first slot)/B62F(second slot),all54real action models,both output gates. Original stack-manipulation selects two words, then original A887 emits them; prior A0223456. Fresh native boot restored per case; synthetic return0008; no claim that every failure is naturally reachable. Raw model metadata retained,including descriptors with zero offset.',cases=rows),separators=(',',':'))+'\n');print(len(rows),sorted(set(row['final']for row in rows)))
