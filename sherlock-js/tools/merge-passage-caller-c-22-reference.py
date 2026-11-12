"""Append the new natural checkpoints and verify the unchanged original prefix."""
import hashlib
import json
from pathlib import Path

project = Path(__file__).resolve().parents[1]
output = project / 'results/passage-caller-c-22'
prior_file = project / 'results/passage-descriptor-high-21/extended-reference.json'
native_file = output / 'extended-native.json'
prior = json.loads(prior_file.read_bytes())
native = json.loads(native_file.read_bytes())
old = prior['cases'][0]['steps']
tail = native['cases'][0]['steps']
steps = old[:338] + tail
assert len(old) == 521
assert steps[:len(old)] == old
assert steps[-1]['after']['clock']['tick'] > 3469
case = {**native['cases'][0], 'label': 'brown-passage-offsets', 'steps': steps}
reference = {'protocol': native['protocol'], 'cases': [case]}
provenance = {
    'identical_original_checkpoints': len(old),
    'prefix_before_Brown_prompt': 338,
    'new_continuation_checkpoints': len(tail),
    'checkpoint_ticks': [2928, 3014, 3104, 3197, 3290, 3379],
    'final_original_tick': steps[-1]['after']['clock']['tick'],
    'sha256': {
        str(path.relative_to(project)): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in (prior_file, native_file, project / 'results/cab-stack-15/lookahead-manifest.json')
    },
}
(output / 'reference-provenance.json').write_text(json.dumps(provenance, indent=2) + '\n')
temporary = output / 'extended-reference.tmp'
temporary.write_text(json.dumps(reference, separators=(',', ':')) + '\n')
temporary.replace(output / 'extended-reference.json')
print(len(steps), steps[-1]['after']['clock']['label'])
