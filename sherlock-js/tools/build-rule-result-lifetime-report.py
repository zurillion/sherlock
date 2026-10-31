"""Assemble the offline evidence and its hashes; never consumed by gameplay."""
import sys,json,gzip,hashlib,re
from pathlib import Path
p=Path(__file__).resolve().parents[2];root=p/'sherlock-js/results/rule-result-lifetime'
def read(name):return json.loads((root/name).read_text())
trace=json.loads(gzip.decompress((root/'natural-reference.json.gz').read_bytes()));assert trace['bridge_frames'];assert not trace['unclassified_transitions']
rows=[dict(checkpoint=i,**d)for i,s in enumerate(trace['steps'])for d in s['random']if any(v['address']==0xcb28 and v['value']==131 for v in d['reads'])];assert len(rows)==1
selected=rows[0];stores=[]
for step in trace['steps']:
 for e in step['stores']:
  if e['tick']==selected['tick']and e['pc']=='CB37':stores.append(e)
  if e==selected['last_stores'][0]:break
 else:continue
 break
assert stores[-1]==selected['last_stores'][0]
proof=dict(read=selected,preceding_visit_stores=stores,meaning='8583 is the FF terminator of SlaterStreet12, reached by Watson3 searching destination12. DD6E publishes it on failure; Daphne preflight has no callback stores; WAIT6/104 preserve it until cook9 reads CB28.')
(root/'boundary-provenance.json').write_text(json.dumps(proof,indent=2)+'\n')
paths=['sherlock-analisi/block-10.bin',*[f'sherlock-js/{s}'for s in ['results/final-solution/witness-native-reference.json.gz','results/final-solution/major-witness.txt','results/rule-result-lifetime/natural-reference.json.gz','results/rule-result-lifetime/boundary-state.json.gz','results/rule-result-lifetime/exit-controls.json','src/npc-runtime.mjs','src/rule-results.mjs','tools/probe-rule-result-lifetime.py','tools/probe-rule-result-boundary.py','tools/probe-exit-rule-results.py','tools/build-rule-result-lifetime-listing.py','tools/verify-rule-result-lifetime-continuous.mjs','tools/verify-rule-result-lifetime-prefix.mjs']]]
provenance=dict(profile='seed1/all24/free initial LOOK/native graphics off after boot/injected uppercase/immediate MORE',bridge_frames=trace['bridge_frames'],prior_oracle='Full witness checkpoints0–497 reused with hash. Minute4229 independently acquired this turn. Unknown next minute excluded.',sha256={s:hashlib.sha256((p/s).read_bytes()).hexdigest()for s in paths});(root/'provenance.json').write_text(json.dumps(provenance,indent=2)+'\n')
summaries={}
for file in ['tests.log','full-suite-final.log']:
 text=(root/file).read_text();row={k:int(re.findall('ℹ '+k+r' (\d+)',text)[-1])for k in ['tests','pass','fail','cancelled','skipped']};assert row['fail']==row['cancelled']==row['skipped']==0;summaries[file]=row
report=dict(mechanism='First exit or FF terminator result; first-match rejection, body preservation, proven preflight lifetimes. Semantic JS only.',abi_cases=len(read('exit-controls.json')['cases']),native_trace=dict(checkpoints=len(trace['steps']),stores=trace['store_counts'],unclassified=trace['unclassified_transitions']),continuous=read('continuous-verification.json'),full_state=read('witness-prefix.json'),next_boundary=read('next-boundary.json'),atlas=read('listing-verification.json'),tests=summaries,runtime_imports_captured_bytes=False,remaining=['Five natural terminal variants','Police cab5D0C','PRINT/MORE','TAKE TO','WatsonKilledYou7JSvs10native'])
assert report['full_state']['clock']['tick']==4229
(p/'sherlock-js/results/rule-result-lifetime-verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(abi=report['abi_cases'],tests=summaries,clock=report['full_state']['clock'],next=report['next_boundary']),indent=2))
