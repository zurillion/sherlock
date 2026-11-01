"""Auditable boundaries for the natural murder-evidence investigation."""
import gzip,hashlib,json,re
from pathlib import Path
app=Path(__file__).resolve().parents[1];root=app/'results/murder-ending'
def read(name):return json.loads((root/name).read_text())
def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()
bounded=read('bounded-308-comparison.log')[0];assert bounded['passed']and bounded['checkpoints']==308 and bounded['clock']['tick']==1513
assert read('word-byte-native.json')['unclassified_transitions']==[]
assert read('name-byte-native.json')['unclassified_transitions']==[]
assert read('hail-vehicle-native.json')['events'][1]['a']==30
chain=[]
for name in ['monday','night','portman','confession','reveal','talk','brown']:
 path=root/(name+'-native-prompt.json.gz');s=json.loads(gzip.decompress(path.read_bytes()));history=app/s['history'];assert s['history_sha256']==digest(history);parent=app/s['parent']if s.get('parent')else None
 if parent:assert parent.exists()
 chain.append(dict(path=str(path.relative_to(app)),sha256=digest(path),history=s['history'],history_sha256=digest(history),parent=s.get('parent'),parent_sha256=digest(parent)if parent else None,clock=s['clock']))
inputs={str(p.relative_to(app)):digest(p)for p in sorted(root.iterdir())if p.is_file()and(p.name.endswith('-native.json')or p.name in ['entity-name-abi.json','root-space-abi.json','article-abi.json','native-bounded-308.json','native-brown-full.json','brown-dense-native.json','train-prefix-native.json.gz','word-byte-native.json','name-byte-native.json'])}
log=(root/'final-full-suite-hail.log').read_text();tests=re.search(r'ℹ tests (\d+)\nℹ suites \d+\nℹ pass (\d+)\nℹ fail (\d+)',log);assert tests and tests[1]==tests[2]and tests[3]=='0',log[-400:]
next_report=read('dense-difference.json');assert '$5D15'in next_report['notice']
report=dict(implemented=True,full_6ABD_ending_certified=False,profile='seed1/all24/free initial LOOK/native graphics off after boot/injected uppercase/immediate MORE',runtime='Autonomous functional JavaScript; no native state import, CPU interpreter or trace replay.',positive=bounded,dense_diagnostic=dict(through='Tue09:18',from_save='results/murder-ending/jones-confession-save.json',scope='Every random draw/read and full source state each minute; no browser-packet or repeated-LOAD future certificate for this diagnostic.',first_unknown='$5D15',actor=9,attempted_clock='Tue09:19',observed_original=0,old_stale_js=115,no_fallback=True),tests=dict(total=int(tests[1]),passed=int(tests[2]),failed=0,log='results/murder-ending/final-full-suite-hail.log'),abi_cases=dict(entity_names=110,articles=16,raw_space_columns=36),original_chain=chain,inputs_sha256=inputs,runtime_sha256={str(p.relative_to(app)):digest(p)for p in sorted((app/'src').glob('*.mjs'))},listing=read('listing-verification.json'),atlas=json.loads((app/'results/memory-map-verification.json').read_text()),baseline_6A33=json.loads((app/'results/glyph-caller-flags-30/witness-complete.json').read_text()),remaining=['Identify real5D15 writer on nested cab service','Natural Brown suicide proof and delivery of both murder conclusions to Lestrade','Full6ABD ending','Other natural endings6AF3/6B79/75D2','Other backlog limits remain'])
(app/'results/murder-evidence-verification.json').write_text(json.dumps(report,indent=2)+'\n');print('308 checkpoints; tests',tests[1],';6ABD still open')
