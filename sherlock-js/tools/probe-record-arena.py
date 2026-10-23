#!/usr/bin/env python3
"""Offline exact-byte tests of record allocation and the context-return quirk."""
import argparse,sys,json,random
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args();sys.path.insert(0,str(a.project/'sherlock-analisi/parser'))
from sherlock_parser import SherlockParser
E=SherlockParser(a.project);R=E.R
base,length=0x9570,752
word=lambda m,p:m[p]+256*m[p+1]
def init():
 s=E.new_sim();m=s.memory;m[base:base+length]=[0]*length;E.put(s,base,length);E.put(s,0x9fe3,base)
 for h in [0x9fe5,0x9fe7,0x9fe9,0x9fee,0x9ff0]:E.put(s,h,0)
 return s
s=init();m=s.memory;r=s.registers;live={};seq=[];rng=random.Random(741)
# This Python generator chooses TEST operations only; it is not gameplay randomness.
for i in range(140):
 sizes=[1,2,5,7,8,11,16,25];size=rng.choice(sizes);free=[];q=word(m,0x9fe3)
 while q:free.append(word(m,q));q=word(m,q+2)
 if live and (i%4==3 or len(live)>12 or not any(n>=size+3 for n in free)):
  ident=rng.choice(list(live));ptr=live.pop(ident);r[R.IXh],r[R.IXl]=ptr>>8,ptr&255;E.call(s,0xa1c7);op={'op':'release','id':ident}
 else:
  r[R.A]=size;E.call(s,0xa11c);ptr=r[R.IXh]*256+r[R.IXl];live[i]=ptr;values=[(i*17+n*11)&255 for n in range(size)];m[ptr:ptr+size]=values;op={'op':'allocate','id':i,'size':size,'values':values,'pointer':ptr}
 op.update(free_head=word(m,0x9fe3),bytes=list(m[base:base+length]));seq.append(op)
contexts=[]
for actor_order,requests,syntax in [([3],0,False),([3],2,True),([2,3],1,True),([3,2],1,True),([3,2,3],2,True)]:
 s=init();m=s.memory;r=s.registers;insertions=[]
 def add(head,values,kind):
  r[R.A]=len(values);E.call(s,0xa11c);ptr=r[R.IXh]*256+r[R.IXl];E.put(s,ptr-2,word(m,head));E.put(s,head,ptr);m[ptr:ptr+len(values)]=values;insertions.append({'list':kind,'values':values,'pointer':ptr});return ptr
 for n in range(requests):add(0x9fee,[3,255,49,n,255,0,0,0],'requests')
 if syntax:add(0x9ff0,[1,2,3,4,5,6,7,8,9],'syntax')
 for n,actor in enumerate(actor_order):add(0x9fe9,[actor,0x80+n,0x5b,20+n,40+n,1,60+n],'contexts')
 m[0xa036]=3;E.put(s,0x9fdb,0x9870);r[R.IYh],r[R.IYl]=0x98,0x70
 E.call(s,0xcfcf)
 contexts.append({'insertions':insertions,'saved':list(m[0x9fd6:0x9fd9]),'remaining_context_head':word(m,0x9fe9),'bytes':list(m[base:base+length])})
a.output.write_text(json.dumps({'scope':'Controlled allocator/list fixtures, original code unchanged. Exact bytes and pointers, not a full gameplay test.','base':base,'length':length,'operations':seq,'context_returns':contexts},separators=(',',':'))+'\n');print('saved',len(seq),'allocator operations and',len(contexts),'context returns')
