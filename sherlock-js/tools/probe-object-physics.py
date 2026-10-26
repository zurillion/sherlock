"""Controlled original weight, containment, perception and light contracts.

Each case restores the seeded startup before calling a single researched
routine. These observations are assertions, never playable-engine inputs.
"""
import argparse,itertools,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--output',type=Path,required=True);args=ap.parse_args()
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;R=w.R;base=m[:];registers=w.sim.registers[:]
record=lambda ident:word(m,0x8b70+3*ident)
def restore():m[:]=base;w.sim.registers[:]=registers
def a(value):w.sim.registers[R.A]=value
def ix(value):w.sim.registers[R.IXh]=value>>8;w.sim.registers[R.IXl]=value&255
weights=[]
for capacity,contents,nested,root_weight in itertools.product([0,1,31,127,128,254,255],[[],[1],[127,1],[128,128],[255,1],[1,255],[127,127],[200,100]], [False,True],[0,1,127,255]):
 restore()
 for ident in range(110):
  q=record(ident)
  if m[q+1]in(0,15,16,22):m[q+1]=255
 m[record(0)+3]=capacity;m[record(22)+3]=root_weight;m[record(22)+1]=255
 for i,weight in enumerate(contents):m[record(15+i)+1]=15 if nested and i else 0;m[record(15+i)+3]=weight
 a(0);out=w.call(0xd2f2);total=out['a']
 a(0);w.sim.registers[R.B]=22;allowed=not w.call(0xc8c6)['z']
 weights.append(dict(capacity=capacity,contents=contents,nested=nested,object_weight=root_weight,total=total,allowed=allowed))
perception=[]
for actor_parent,obj_parent,outer_flags,inner_flags,obj_flags,obj_room in itertools.product([None,15,16],[None,15,16],[0,128,136,160],[0,128,136,160],[0,128],[8,9]):
 restore()
 for ident,parent,room,flags in [(0,actor_parent,8,224),(22,obj_parent,obj_room,obj_flags),(15,None,8,outer_flags),(16,15,8,inner_flags)]:
  q=record(ident);m[q+1]=255 if parent is None else parent;m[q+15]=room;m[q+5]=flags
 m[0xa036]=0;m[0xa00a]=8;a(22);visible=not w.call(0xc821)['z']
 a(0);actor_barrier=w.call(0xc863)['a'];a(22);object_barrier=w.call(0xc863)['a']
 perception.append(dict(actor_parent=actor_parent,object_parent=obj_parent,outer_flags=outer_flags,inner_flags=inner_flags,object_flags=obj_flags,object_room=obj_room,visible=visible,actor_barrier=None if actor_barrier==255 else actor_barrier,object_barrier=None if object_barrier==255 else object_barrier))
light=[]
for hour,room_flags,actor_props,actor_parent,box_flags,lamp_flags,lamp_props,lamp_parent in itertools.product([0,6,7,12,13,19,20],[4,132],[0,128],[None,15],[128,160],[0,128,160,180,224],[0,128],[None,15]):
 restore()
 for ident in range(110):m[record(ident)+4]&=127
 m[record(0)+4]=actor_props;m[record(0)+1]=255 if actor_parent is None else actor_parent;m[record(0)+15]=8
 m[record(15)+1]=255;m[record(15)+5]=box_flags;m[record(15)+15]=8
 q=record(22);m[q+1]=255 if lamp_parent is None else lamp_parent;m[q+4]=lamp_props;m[q+5]=lamp_flags;m[q+15]=8
 m[word(m,0x840b+16)]=room_flags;m[0xa036]=0;m[0xa009]=m[0xa00a]=8;w.engine.put(w.sim,0xa017,record(0));m[0x9fe0]=hour%12 or 12;m[0x9fe2]=ord('a'if hour<12 else'p')
 result=w.call(0xd078)
 light.append(dict(hour=hour,room_flags=room_flags,actor_properties=actor_props,actor_parent=actor_parent,box_flags=box_flags,lamp_flags=lamp_flags,lamp_properties=lamp_props,lamp_parent=lamp_parent,dark=result['carry']))
args.output.write_text(json.dumps(dict(scope='Isolated original D2F2/C8C6, C863/C821 and D078 after an explicit logical setup; no actor turns or random draws. All other light sources disabled in light cases.',weights=weights,perception=perception,light=light),indent=2)+'\n')
print(len(weights),'weight,',len(perception),'perception,',len(light),'light cases')
