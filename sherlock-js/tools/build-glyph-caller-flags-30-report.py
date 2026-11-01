"""Evidence manifest; no recorded byte is consumed by the playable engine."""
import json,gzip,hashlib,re
from pathlib import Path
p=Path(__file__).resolve().parents[2];app=p/'sherlock-js';root=app/'results/glyph-caller-flags-30'
def read(name):return json.loads((root/name).read_text())
reference='sherlock-js/results/final-solution/witness-native-reference.json.gz';case=next(c for c in json.loads(gzip.decompress((p/reference).read_bytes()))['cases']if c['label']=='major-witness');abi=read('glyph-abi.json');native=read('natural-verification.json');full=read('witness-complete.json');assert len(abi['cases'])==4284 and len(abi['cp_flags'])==256;assert full['checkpoints']==521 and full['terminal']['text_pointer']=='6A33' and full['full_ending_certified']
associated_source='sherlock-js/results/glyph-video-low-2a/natural-verification.json'
associated=json.loads((p/associated_source).read_text())['last_store'];assert associated['glyph']['frame']==0x5d32 and associated['pc']=='C398'
associated_proof=dict(source=associated_source,sha256=hashlib.sha256((p/associated_source).read_bytes()).hexdigest(),store=associated,derived_caller_flags=abi['cp_flags'][associated['glyph']['char']],scope='Reused natural evidence of the same real frame and character at tick964. C388 source plus independently executed CP0D derive its associated5D30 write. Not a direct complete audit of all subsequent5D30 stores.')
reads=[]
for i,row in enumerate(case['steps']):
 for j,d in enumerate(row['random']):
  if any(v['address']==0x5d30 for v in d['reads']):reads.append(dict(checkpoint=i,draw=j,clock=row['after']['clock'],random=d))
assert len(reads)==1 and reads[0]['checkpoint']==512 and reads[0]['draw']==15
(root/'native-random-reads.json').write_text(json.dumps(dict(source=reference,sha256=hashlib.sha256((p/reference).read_bytes()).hexdigest(),scope='Reused original complete-state reference, not a new terminal acquisition. Fresh late-window store acquisition is separate.',reads=reads),indent=2)+'\n')
paths=['sherlock-analisi/block-10.bin',reference,associated_source,*['sherlock-js/'+s for s in ['src/random-display.mjs','src/npc-runtime.mjs','data/game.json','tools/probe-glyph-caller-flags-30.py','tools/probe-glyph-caller-flags-30-abi.py','tools/verify-glyph-caller-flags-30-natural.mjs','tools/verify-glyph-caller-flags-30-witness.mjs','test/glyph-caller-flags-30.test.mjs','results/glyph-caller-flags-30/glyph-abi.json','results/glyph-caller-flags-30/natural-stores.json']]]
(root/'provenance.json').write_text(json.dumps(dict(profile=full['protocol'],abi_protocol=abi['protocol'],sha256={s:hashlib.sha256((p/s).read_bytes()).hexdigest()for s in paths}),indent=2)+'\n')
tests={}
for name in ['tests.log','full-tests.log','caller-and-atlas-tests.log']:
 text=(root/name).read_text();tests[name]={k:int(re.findall('ℹ '+k+r' (\d+)',text)[-1])for k in ['tests','pass','fail','cancelled','skipped']}
assert tests['tests.log']['pass']==86 and tests['caller-and-atlas-tests.log']['pass']==14
assert tests['full-tests.log']['tests']==1810 and tests['full-tests.log']['fail']<=1
report=dict(implemented=True,runtime='Functional JavaScript projection of independent byte5D30 from source caller/frame/character/column. No CPU interpreter, captured-byte fallback or normalization.',abi_cases=len(abi['cases']),independent_original_cp_cases=256,native_provenance=native,associated_native_frame=associated_proof,full_state=full,natural_reads=reads,listing=read('listing-verification.json'),atlas=json.loads((app/'results/memory-map-verification.json').read_text()),tests=tests,test_reconciliation='The full suite started before the newly acquired CP table was written: one worker loaded the earlier ABI without cp_flags. Updated ABI plus expanded caller tests and atlas all pass in the 14-test targeted rerun; 1810 distinct tests verified, not a second all-green full-suite execution.',next_work='Four remaining natural endings6ABD/6AF3/6B79/75D2; this521-checkpoint history reaches6A33 and has no subsequent unknown boundary.',remaining=['Four natural endings6ABD/6AF3/6B79/75D2','Police cab5D0C','PRINT/MORE','TAKE TO','WatsonKilledYou7JSvs10native'],full_game_equivalence_claimed=False)
(app/'results/glyph-caller-flags-30-verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(full_state=full,tests=tests,native=native),indent=2))
