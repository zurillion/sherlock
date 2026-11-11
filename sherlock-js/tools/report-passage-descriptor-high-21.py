"""Validate the offline certificate. Never imports native state into the game."""
import json, hashlib, re, collections
from pathlib import Path
p=Path(__file__).resolve().parents[1]; root=p/'results/passage-descriptor-high-21'
def read(path): return json.loads((p/path).read_text())
def local(name): return json.loads((root/name).read_text())
def sha(path): return hashlib.sha256((p/path).read_bytes()).hexdigest()
ref=local('extended-reference.json'); c=ref['cases'][0]; comp=local('full-comparison.json')[0]
assert not comp['passed'] and '$5D22' in comp['error']
n=comp['completed_checkpoints']; rows=c['steps'][:n]
assert n==520 and rows[-1]['after']['clock']==comp['last_complete_clock']
old=read('results/passage-descriptor-20/extended-reference.json')['cases'][0]['steps']
assert len(old)==511 and old==c['steps'][:511]
prior=local('prior-comparison.json')[0]; assert prior['passed'] and prior['checkpoints']==511
runs=[]
for file,total in [('full-tests.log',1891),('focused-tests.log',8)]:
 log=(root/file).read_text(); stats={k:int(re.search(r'ℹ '+k+r' (\d+)',log)[1]) for k in ['tests','pass','fail','cancelled','skipped']}
 assert stats['tests']==stats['pass']==total and stats['fail']==stats['cancelled']==stats['skipped']==0
 runs.append(dict(file=file,**stats))
natural=local('natural-stores.json'); previous=read('results/passage-descriptor-20/natural-stores.json')
assert natural['stores']==previous['stores'] and len(natural['stores'])==3020 and not natural['unclassified_transitions']
counts=dict(collections.Counter(s['address'] for s in natural['stores']))
writers=[]
for address,pc,frame,char in [('5D21','C38A',0x5D26,110),('5D27','C3B8',0x5D32,32)]:
 r=next(r for r in natural['reads'] if r['address']==address and r['clock']['tick']==3288); s=r['last_store']
 assert r['actor']==8 and s['pc']==pc and s['actor']==0 and s['clock']['tick']==1653 and s['glyph']['frame']==frame and s['glyph']['char']==char
 assert r['value']==(s['de']>>8 if address=='5D21' else s['af']>>8)
 writers.append(r)
abi=local('abi-provenance.json')
for r in abi['reused']: assert sha(r['path'])==r['sha256']
for name,total in [('passage-abi.json',720),('arrival-low-abi.json',1512),('simple-error-abi.json',138),('arrival-fresh-row-abi.json',300)]: assert len(read('results/passage-descriptor-20/wide-abi/'+name)['cases'])==total
es=[r for r in read('results/passage-descriptor-20/wide-abi/arrival-low-abi.json')['cases'] if r['eligible']]
assert len(es)==720 and all(r['cells'][7]==165 for r in es) and sum(r['cells'][13]!=165 for r in es)==20
fresh=read('results/passage-descriptor-20/wide-abi/arrival-fresh-row-abi.json')['cases']
assert all(r['column']==0 and r['cells'][13]==165 for r in fresh)
errors=[r for r in read('results/passage-descriptor-20/wide-abi/simple-error-abi.json')['cases'] if r['eligible']]
assert len(errors)==129 and all(r['cells'][7]==r['cells'][13]==165 for r in errors)
scope=local('passage-scope.json'); assert all(v['owned']==290 and v['mismatch']==0 for v in scope.values())
entry=local('entry-validation.json'); assert entry['full_world_equal'] and entry['checkpoint']==325 and entry['save_sha256']==sha('results/passage-descriptor-high-21/entry-js-save.json')
baseline=local('baseline-6a33.json'); assert baseline['checkpoints']==521 and baseline['full_ending_certified']
atlas=local('atlas-delta.json'); listing=local('listing-verification.json')
assert listing['roundtrip_equal'] and listing['instructions']==395 and listing['bytes_roundtripped']==715 and atlas['status_changed_byte_count']==0
look=local('research-last.json')[-1]; assert '$5D22' in look['notice'] and look['clock']['tick']==3377
reads=[dict(actor=d['actor'],read=q,checkpoint_clock=row['after']['clock']) for row in c['steps'][n:] for d in row['random'] for q in d['reads'] if q['address']==0x5D22]; assert reads and reads[0]['actor']==9
paths=['src/random-display.mjs','src/text.mjs','src/game.mjs','src/npc-runtime.mjs','data/game.json']+['results/passage-descriptor-high-21/'+name for name in ['natural-stores.json','extended-reference.json','full-comparison.json','baseline-6a33.json','full-tests.log','focused-tests.log','entry-js-save.json']]
out=dict(implemented=True,runtime='Independent high descriptor D at frame5D26 and raw font byte A before rotation at frame5D32. Derived by autonomous JS; no CPU, native RAM import, fixed5C/0, recorded sequence or old-SAVE repair.',natural_writers=dict(protocol=natural['protocol'],observed_writes=3020,stores_per_address=counts,identical_to_previous_store_sequence=True,unclassified_transitions=0,reads=writers),controlled_original_abi=dict(provenance=abi,new_abi_acquisitions=0,reused_glyph_cases_per_address=1296,reused_descriptor_variants=144,whole_passage_cases=720,owned_matches_per_address=290,arrival_cases=1512,eligible_preserve21=720,eligible_overwrite27=20,fresh_row_cases=300,fresh_row_counter_range=[0,14],runtime_Watson_counter_test_accepted=13,runtime_Watson_counter_test_total=15,runtime_guard='counter+2<15;cursor0;remaining36;pending empty;spacing0;name fits',eligible_errors_preserve_both=129,not_natural_reachability_of_all_setups=True),regression_entry=entry,natural_certificate=dict(protocol=ref['protocol'],checkpoints=n,certified_checkpoint_range=[0,n-1],clock=rows[-1]['after']['clock'],compared_random_draws=sum(len(row['random']) for row in rows),compared_random_reads=sum(len(d['reads']) for row in rows for d in row['random']),runtime_draws_including_two_boot=2+sum(len(row['random']) for row in rows),all_actors=24,arena_bytes=752,bitmaps_compared=True,load_future_compared=True,prior_identical_native_checkpoints=511,new_native_continuation_checkpoints=183,extra_sampler_checkpoint_ticks=[2928,3014,3104,3197,3290],full_ending_certified=False),next_limit=dict(address='5D22',js_stopped=look['clock'],first_excluded_checkpoint=n,native_checkpoint=c['steps'][n]['after']['clock'],native_reads=reads,last_writer_at_this_later_read_untraced=True,do_not_infer_from_old_22_store_or_value=True),baseline_6a33=dict(**baseline,oracle_reused=True,oracle_sha256=sha('results/final-solution/witness-native-reference.json.gz')),tests=dict(aggregate_tests=1899,aggregate_pass=1899,runs=runs,protocol=local('test-protocol.json'),preliminary_attempt='preliminary-provenance-pending.log records an invocation before its required evidence file existed; not counted as a positive test run.'),listing=listing,atlas=atlas,open_scope=['Natural6ABD and other pending endings remain uncertified; failed journeys and missing Brown proof retained.','21 and27 have independent ownership; missing old SAVE fields remain unknown until modeled writes.','Wrapped arrivals, nonordinary callers, later names, deep clears and pending MORE do not inherit a broad27 preservation contract.','Natural writer trace ends3288; extend to3377 before assigning a writer to next5D22.'],sha256={path:sha(path) for path in paths})
(p/'results/passage-descriptor-high-21-verification.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out['natural_certificate'],indent=2)); print(json.dumps(out['next_limit'],indent=2))
