"""Offline original Sherlock1984: next mutable saved-rule-index input at CB29."""
import gzip,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];project=root.parent;sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
outdir=root/'results/train-countryside-font';source=root/'results/victory-route/victoria-extra-look-native-seed1.json.gz';ref=json.loads(gzip.decompress(source.read_bytes()))
cache=outdir/'pre-wait-prompt.json.gz';s=json.loads(gzip.decompress(cache.read_bytes()));assert s['source_sha256']==hashlib.sha256(source.read_bytes()).hexdigest()
g=Game(project,extract(project),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R
m[:]=s['memory'];r[:]=s['registers'];w.input_registers[:]=s['input_registers'];w.input_stack[:]=s['input_stack'];g.explored=set(s['explored']);assert w.clock()==ref['steps'][3203]['clock']
route=[row['command']for row in ref['steps']if row['command']];last=None;pending=None;owner=None;owners={};initial_returns=0;old=m[0xcb29];count=0;unclassified=[];command=None

def observe(m,r,R):
 global last,pending,owner,old,count,initial_returns
 pc=r[R.PC];sp=r[R.SP]
 if pending is not None:
  if pc==0xcb3b:last={**pending,'value':m[0xcb29]};count+=1
  pending=None
 elif old!=m[0xcb29]:unclassified.append(dict(pc=pc,value=m[0xcb29],tick=word(m,0x9fdd)))
 old=m[0xcb29]
 if pc in (0xcb2c,0xcb34) and (pc==0xcb2c or sp not in owners):owners[sp]=dict(entry=f'{pc:04X}',sp=sp,handler=r[R.H]*256+r[R.L],caller=word(m,sp),tick=word(m,0x9fdd),actor=m[0xa036],action=m[0xa033],arguments=m[0xa034:0xa036])
 if pc==0xcb37:
  # The source prompt can suspend a callback entered before this trace.
  owner=owners.pop(sp,None)
  if owner is None:initial_returns+=1
  pending=dict(pc='CB37',tick=word(m,0x9fdd),actor=m[0xa036],command=command,ix=r[R.IXh]*256+r[R.IXl],iy=r[R.IYh]*256+r[R.IYl],owner=owner)
 if pc in (0xd2cb,0xd2d0):
  at=(r[R.IXh]*256+r[R.IXl]+(pc==0xd2d0))&65535
  if at==0xcb29 and word(m,0x9fdd)>=3581:
   result=dict(protocol='Natural seed1 extra-LOOK route from original checkpoint3203;all24actors,nativegraphics,freeinitialLOOK,immediateMORE. Track every CB37 index save including unchanged values; flag unexplained CB29 changes. CB28..CB2B are mutable data,not instructions.',source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),source_cache_sha256=hashlib.sha256(cache.read_bytes()).hexdigest(),read=dict(tick=word(m,0x9fdd),actor=m[0xa036],address='CB29',value=m[at],command=command),writer=last,observed_stores=count,returns_without_recorded_entry=initial_returns,entry_points=['CB2C','CB34'],unclassified_transitions=unclassified)
   assert last['owner'] is not None
   (outdir/'next-rule-result.json').write_text(json.dumps(result,indent=2)+'\n');print('READ',result['read'],last,flush=True);raise SystemExit()
w.observer=observe
for command in route[sum(bool(row['command'])for row in ref['steps'][:3204]):]:w.submit(command,g.explored)
