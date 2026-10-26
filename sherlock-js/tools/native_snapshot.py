"""Typed offline oracle state; never imported by the playable engine."""
import hashlib
from native_world import word
def snapshot(w,cells=None):
 if cells is None:cells=[0x5cee,0x5cf5,*range(0x5d00,0x5d10)]
 m=w.m;lists={};entities=[]
 for name,head,size in [('counters',0x9fe5,2),('signals',0x9fe7,2),('contexts',0x9fe9,7),('requests',0x9fee,8),('syntax',0x9ff0,30),('parsed',0x9ff2,30)]:
  q=word(m,head);rows=[]
  while q:rows.append(dict(pointer=q,values=list(m[q:q+size])));q=word(m,q-2)
  lists[name]=rows
 for ident in range(110):
  q=word(m,0x8b70+3*ident);entities.append(dict(id=ident,parent=None if m[q+1]==255 else m[q+1],rooms=list(m[q+15:q+15+m[q]]),attributes=m[q+5],status=m[q+6],properties=m[q+4],noun=word(m,q+7),qualifiers=[word(m,q+9),word(m,q+11)],description=f'{word(m,q+13):04X}'))
 bitmap=bytes(m[0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x]for y in range(144)for x in range(32))
 return dict(player=w.player_id,player_failures=m[0xcc0b],facts=[list(m[a:b])for a,b in [(0x9965,0x9973),(0x9973,0x9981),(0x9981,0x9997),(0x9997,0x99a9),(0x99a9,0x99bb),(0x99bb,0x99c5),(0x99c5,0x99cf),(0x99cf,0x99d9),(0x99d9,0x99e3),(0x99e3,0x99f1),(0x99f1,0x99fb)]],clock=w.clock(),actors=[dict(id=m[q],pc=f'{word(m,q+1):04X}',saved=list(m[q+3:q+6]),due=word(m,q+6))for q in range(0x9860,0x9920,8)],entities=entities,rooms=[m[word(m,0x840b+2*i)]for i in range(106)],records=lists,arena=list(m[0x9570:0x9860]),free_head=word(m,0x9fe3),random_state=dict(seed=m[0xa037],cursor=word(m,0xa039)),upper_sha256=hashlib.sha256(bitmap).hexdigest(),working_cells={f'{at:04X}':m[at]for at in cells},input=list(m[0x5b00:0x5b81]),tokens=list(m[0x5b81:0x5c00]),lower_bitmap=list(m[0x4000+((y&192)<<5)+((y&7)<<8)+((y&56)<<2)+x]for y in range(152,192)for x in range(32)),mutable={f'{at:04X}':m[at]for at in [0xa01b,0xa019,0xa025,0xa024,0xd7e0,0xd6b8]})
