"""Source-backed evidence for immutable TELL data, separate from playback logic."""
import json,gzip,hashlib,re
from pathlib import Path
p=Path(__file__).resolve().parents[2];app=p/'sherlock-js';root=app/'results/conversation-topic-table'
def read(name):return json.loads((root/name).read_text())
data=json.loads((app/'data/game.json').read_text());table=next(t for t in data['randomInputs']['worldLayout']['tables']if t.get('kind')=='immutable-conversation-topics');payload=(p/'sherlock-analisi/block-10.bin').read_bytes();raw=payload[0xe22a-0x5d80:0xe28d-0x5d80];abi=read('selector-abi.json');assert bytes(table['values'])==raw==bytes(abi['table']);assert hashlib.sha256(raw).hexdigest()==abi['table_sha256'];writers=sorted(set(range(0xe22a,0xe28d))&set(data['randomInputs']['excludedWrites']));assert not writers
reference='sherlock-js/results/final-solution/witness-native-reference.json.gz';original=json.loads(gzip.decompress((p/reference).read_bytes()));case=next(c for c in original['cases']if c['label']=='major-witness');reads=[]
for i,row in enumerate(case['steps'][:512]):
 for j,draw in enumerate(row['random']):
  hits=[v for v in draw['reads']if 0xe22a<=v['address']<0xe28d]
  if hits:
   assert all(v['value']==table['values'][v['address']-0xe22a]for v in hits);reads.append(dict(checkpoint=i,draw=j,clock=row['after']['clock'],random=draw))
assert any(any(v['address']==0xe22e for v in r['random']['reads'])for r in reads)
next_draw=case['steps'][512]['random'][15];assert next_draw['actor']==9 and any(v['address']==0x5d30 for v in next_draw['reads'])
(root/'native-random-reads.json').write_text(json.dumps(dict(source=reference,sha256=hashlib.sha256((p/reference).read_bytes()).hexdigest(),scope='Reused original natural oracle, not a fresh long capture. Table reads inside certified prefix; next draw is discovery only.',table_reads=reads,next_boundary_random=next_draw),indent=2)+'\n')
paths=['sherlock-analisi/block-10.bin',reference,*['sherlock-js/'+s for s in ['results/conversation-topic-table/selector-abi.json','tools/build-conversation-topics.mjs','tools/build-data.mjs','tools/probe-conversation-topic-table.py','tools/build-conversation-table-listing.py','tools/verify-conversation-table-prefix.mjs','tools/verify-conversation-table-lookahead.mjs','data/game.json']]]
provenance=dict(profile='Natural seed1/all24/free initial LOOK/native graphics off after boot/uppercase injected keys/immediate MORE',native_selector_scope=abi['protocol'],sha256={s:hashlib.sha256((p/s).read_bytes()).hexdigest()for s in paths});(root/'provenance.json').write_text(json.dumps(provenance,indent=2)+'\n')
tests={}
for file in ['tests.log','full-suite.log']:
 text=(root/file).read_text();row={k:int(re.findall('ℹ '+k+r' (\d+)',text)[-1])for k in ['tests','pass','fail','cancelled','skipped']};assert row['fail']==row['cancelled']==row['skipped']==0;tests[file]=row
report=dict(mechanism='Typed immutable nested TELL table, actor-wide FE default and761D missing-topic response; physical source order available to RNG through WorldSource.',data_range=['E22A','E28C'],table_bytes=len(raw),actor_sections=len(table['records']),topic_triples=sum(len(r['topics'])for r in table['records']),catalogued_direct_write_intersection=writers,abi_cases=len(abi['cases']),native_table_reads=reads,full_state=read('witness-prefix.json'),lookahead=read('lookahead.json'),next_boundary_random=next_draw,atlas=read('listing-verification.json'),tests=tests,new_mutable_save_fields=[],runtime_cpu_or_trace_playback=False,remaining=['Five natural endings','Police cab5D0C','PRINT/MORE','TAKE TO','WatsonKilledYou7JSvs10native'])
assert report['full_state']['checkpoints']==512 and report['full_state']['clock']['tick']==4361
(app/'results/conversation-topic-table-verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(dict(tests=tests,clock=report['full_state']['clock'],draws=report['full_state']['compared_random_draws'],reads=report['full_state']['compared_random_reads']),indent=2))
