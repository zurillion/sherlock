"""Offline first-token and editor boundary tests; no native state enters runtime."""
import json,sys
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/parser'))
from sherlock_parser import SherlockParser
engine=SherlockParser(p);a=engine.audit
numbers=['0','59','60','255','256','257','999','99999','9:','9:AM','9:PM','9:59','9:60','9:256','9AM','9PM','9A','9P','9M','9:30AM','9:30PM','9:30:00','0D','255D','256D','999D','999S','1/-','1/6','1/','1/256','1/6D','`0','`1','`1S','`1D','`1/-','`1/6','`1/2/6','`1/2S','`1 2/6','`1X','`1X2S','`70','`256','`255/255/255']
rows=[a.native_lookup(s)for s in numbers]
editor=[]
for n in [0,1,2,125,126,127,128,129,140]:
 for quoted in [False,True]:
  s=('"'if quoted else '')+' '*n
  sim=engine.new_sim();log={};engine.call(sim,0xd898,keys=list(s.encode())+[13],log=log);editor.append(dict(input=s,quoted=quoted,length=n,buffer=bytes(sim.memory[0x5b00:0x5b84]).split(b'\r')[0].decode('latin1'),bytes=list(sim.memory[0x5b00:0x5b81])))
r=dict(protocol='Controlled isolated original numeric scanner; input text followed by space, dot and CR. Editor invoked with injected ASCII keys and ENTER. No semantic/world state claimed.',numbers=rows,editor=editor)
(p/'sherlock-js/test/fixtures/language-numbers-reference.json').write_text(json.dumps(r,indent=2)+'\n');print(len(rows),len(editor));print([(x['input'],x['type'],x['offset'])for x in rows])
