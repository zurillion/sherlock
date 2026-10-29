"""Offline source allocation-link tests; controlled layouts, not natural play."""
import sys,json,random
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/parser'))
from sherlock_parser import SherlockParser
E=SherlockParser(p);R=E.R;base,length=0x9570,752
word=lambda m,at:m[at]+256*m[at+1]
def init(blocks):
 s=E.new_sim();m=s.memory;m[base:base+length]=[0]*length;E.put(s,0xa11a,0x4321);E.put(s,0x9fe3,blocks[0][0]if blocks else 0)
 for i,(at,size)in enumerate(blocks):E.put(s,at,size);E.put(s,at+2,blocks[i+1][0]if i+1<len(blocks)else 0)
 return s
def allocate(s,size):
 m,r=s.memory,s.registers;r[R.SP],r[R.PC],r[R.A]=0x5d7e,0xa11c,size;E.put(s,0x5d7e,8);events=[]
 for _ in range(100000):
  pc=r[R.PC]
  if pc==8:return dict(op='allocate',size=size,pointer=r[R.IXh]*256+r[R.IXl],events=events)
  if pc==0xc1d8:return dict(op='allocate',size=size,failed=True,events=events)
  if pc==0xa151:events.append(r[R.IYh]*256+r[R.IYl])
  s.opcodes[m[pc]]()
 raise RuntimeError('Allocation probe did not return')
def snapshot(s,op):
 m=s.memory;return dict(**op,allocation_link=word(m,0xa11a),free_head=word(m,0x9fe3),bytes=list(m[base:base+length]))
specs=[('head-split',[(base,100)],[10]),('equal-last',[(base,40),(base+100,40)],[10]),('improving',[(base,90),(base+120,60),(base+220,40)],[12]),('small-predecessor',[(base,5),(base+100,50),(base+200,60)],[12]),('no-fit',[(base,6),(base+100,8)],[10]),('empty',[],[1]),('consume-not-head',[(base,5),(base+100,11)],[8]),('failed-scan-retains',[(base,15)],[8,252])]
specs += [('remainder-'+str(n),[(base,11+n)],[8])for n in range(5)]
cases=[]
for label,blocks,sizes in specs:
 s=init(blocks);ops=[]
 for n in sizes:ops.append(snapshot(s,allocate(s,n)))
 cases.append(dict(label=label,blocks=[dict(start=a,size=b)for a,b in blocks],initial_link=0x4321,operations=ops))
s=init([(base,length)]);ops=[];head=0
for i,size in enumerate([2,7,30]):
 op=allocate(s,size);ptr=op['pointer'];E.put(s,ptr-2,head);op.update(id=i,link=head);head=ptr;ops.append(snapshot(s,op))
s.registers[R.IXh],s.registers[R.IXl]=head>>8,head&255;E.call(s,0xa1af);ops.append(snapshot(s,dict(op='releaseChain',head=head,events=[])))
ops.append(snapshot(s,allocate(s,8)))
cases.append(dict(label='linked-chain-release',blocks=[dict(start=base,size=length)],initial_link=0x4321,operations=ops))
s=init([(base,length)]);m=s.memory;r=s.registers;live={};seq=[];rng=random.Random(741)
for i in range(140):
 size=rng.choice([1,2,5,7,8,11,16,25]);free=[];q=word(m,0x9fe3)
 while q:free.append(word(m,q));q=word(m,q+2)
 if live and(i%4==3 or len(live)>12 or not any(n>=size+3 for n in free)):
  ident=rng.choice(list(live));ptr=live.pop(ident);r[R.IXh],r[R.IXl]=ptr>>8,ptr&255;E.call(s,0xa1c7);op=dict(op='release',id=ident,events=[])
 else:
  op=allocate(s,size);assert not op.get('failed');ptr=op['pointer'];live[i]=ptr;values=[(i*17+n*11)&255 for n in range(size)];m[ptr:ptr+size]=values;op.update(id=i,values=values)
 seq.append(snapshot(s,op))
report=dict(protocol='Original A11C/A1C7, explicit controlled free lists and initial link4321; no code patches. Python RNG chooses test operations only. Every candidate-store including same-value stores, full arena bytes, pointers, release and failed scans compared. Exhaustion stops at C1D8 before UI; not a gameplay failure-handling certificate.',base=base,length=length,cases=cases,sequence=dict(initial_link=0x4321,operations=seq))
p.joinpath('sherlock-js/test/fixtures/allocation-link-reference.json').write_text(json.dumps(report,separators=(',',':'))+'\n');print(len(cases),'layouts;',sum(len(c['operations'])for c in cases)+len(seq),'operations;',sum(len(o['events'])for c in cases for o in c['operations'])+sum(len(o['events'])for o in seq),'candidate stores')
