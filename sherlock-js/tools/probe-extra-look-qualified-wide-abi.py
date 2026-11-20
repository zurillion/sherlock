"""Controlled complete missing-object commands from original Portman Street."""
import gzip,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1];p=root.parent;sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
saved=json.loads(gzip.decompress((root/'results/extra-look-wear-scan/post-wear-prompt.json.gz').read_bytes()))
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;rows=[]
for player in [0,1,100]:
 for verb in ['OPEN','CLOSE','TAKE','GET','CARRY','EXAMINE','CLOSELY EXAMINE']:
  for name in ['LARGE OAK DOOR','THICK HEAVY DOOR','PLAIN DOOR','RIPPED NOTE','TORN NOTE','PILE','STREAM','LARGE STREAM']:
   m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers[:]=saved['input_registers'];w.input_stack[:]=saved['input_stack'];g.explored=set(saved['explored']);w.ended=None
   m[0x9860]=player
   for ident in [0,1,100]:
    ptr=word(m,0x8b70+ident*3);m[ptr]=1;m[ptr+1]=255;m[ptr+15]=45 if ident==player else 0
   m[0xcc0b]=10;m[0x5d1a:0x5d26]=[165]*12;w.input_stack[0x1a:0x26]=[165]*12;frames=set();pending=None;last20=None;glyph=None
   def observe(m,r,R):
    global pending,last20,glyph
    sp=r[R.SP];pc=r[R.PC]
    if pending and sp==pending['after_sp']:
     last20={k:v for k,v in pending.items()if k!='after_sp'};last20['value']=m[0x5d20]
    pending=None
    if pc==0xc388:
     if m[0xa027]==1:frames.add(sp)
     glyph=dict(frame=sp,character=r[R.A],descriptor=r[R.D]*256+r[R.E])
    op=m[pc];push=op in (0xc5,0xd5,0xe5,0xf5,0xcd,0xc4,0xcc,0xd4,0xdc,0xe4,0xec,0xf4,0xfc)or op in (0xdd,0xfd)and m[pc+1]==0xe5
    base=sp-2 if push else sp if op==0xe3 else None
    if base is not None and base<=0x5d20<=base+1:pending=dict(after_sp=base if push else sp,pc=pc,sp=sp,registers=[r[i]for i in (R.A,R.F,R.B,R.C,R.D,R.E,R.H,R.L)],glyph=glyph)
   w.observer=observe;command=verb+' '+name;out=w.submit(command,g.explored)
   text=' '.join(v.get('text','')for v in out['messages']).strip();eligible=text.startswith('I SEE NO ')
   rows.append(dict(player=player,command=command,text=text,eligible=eligible,cells={str(a):m[a]for a in range(0x5d1a,0x5d26)},last20=last20,frames=sorted(frames),clock=w.clock()))
   if eligible:assert m[0x5d1e:0x5d20]==[165,165],(player,command,text,m[0x5d1e:0x5d20])
(root/'results/extra-look-scan-af/rejection-abi.json').write_text(json.dumps(dict(protocol='Controlled original complete commands from natural post-WEAR prompt2287. Restore state before each, all NPC slots retained. Set active playable identity0/1/100 at root Portman Street45 (no room prose); failure budget10 and A5 in1A–25 plus editor-stack copy isolate the rejected input. Seven verb forms, eight missing nominal groups with0..2qualifiers. Only I SEE NO errors certify preservation; altered identity/markers are not natural-play claims.',cases=rows),separators=(',',':'))+'\n');print(len(rows),sum(r['eligible']for r in rows),flush=True)
