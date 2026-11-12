"""Validate the offline evidence and summarize the 5D29 reconstruction."""
from hashlib import sha256
import json
from pathlib import Path
import re
import subprocess

project = Path(__file__).resolve().parents[1]
directory = Path('results/passage-scan-count-29')
previous = Path('results/passage-caller-c-22')

def read(path):
    return json.loads((project / path).read_bytes())

def digest(path):
    return sha256((project / path).read_bytes()).hexdigest()

trace = read(directory / 'natural-stores.json')
previous_trace = previous / 'natural-stores.json'
prior = read(previous_trace)
assert trace['prior_store_count'] == len(prior['stores']) == 3960
last_stores = {row['address']: row for row in prior['stores']}
assert trace['start']['tick'] == 3378 and trace['handover']['pc'] == 'A074'
assert trace['handover']['prior_sha256'] == digest(previous_trace)
assert trace['handover']['bytes'] == [last_stores[f'{a:04X}']['value'] for a in range(0x5D20, 0x5D2A)]
assert trace['stores'] == trace['unclassified_transitions'] == []
reading = next(row for row in trace['reads'] if row['address'] == '5D29')
assert reading['actor'] == 8 and reading['clock']['tick'] == 3469
writer = reading['last_store']
assert writer == last_stores['5D29']
assert writer['pc'] == 'C3B7' and writer['actor'] == 0 and writer['clock']['tick'] == 1653
assert writer['bc'] == 0x0104 and writer['glyph']['frame'] == 0x5D32
assert writer['glyph']['char'] == 32 and reading['value'] == writer['bc'] >> 8

reference_path = previous / 'extended-reference.json'
reference = read(reference_path)
steps = reference['cases'][0]['steps']
comparison = read(directory / 'full-comparison.json')
assert len(steps) == 562 and comparison['checkpoints'] == 539 and comparison['stoppedAt'] == '5D2A'
assert comparison['clock'] == steps[538]['after']['clock']
assert comparison['compared_random_draws'] == 8685 and comparison['compared_random_reads'] == 18524
assert comparison['bitmaps_compared'] and comparison['load_future_compared']
excluded = steps[539]
next_draw = next(d for d in excluded['random'] if any(q['address'] == 0x5D2A for q in d['reads']))
assert next_draw['actor'] == 9 and {'address': 0x5D2A, 'value': 51} in next_draw['reads']
lookahead = read(directory / 'research-last.json')[-1]
assert lookahead['clock']['tick'] == 3560 and '$5D2A' in lookahead['notice']

baseline = read(directory / 'baseline-6a33.json')
assert baseline['checkpoints'] == 521 and baseline['full_ending_certified']
assert baseline['terminal']['text_pointer'] == '6A33'
test_runs = []
for name, expected in [('full-tests.log', 1905), ('focused-tests.log', 46), ('atlas-tests.log', 5)]:
    log = (project / directory / name).read_text()
    counts = {key: int(re.search(r'ℹ ' + key + r' (\d+)', log)[1])
              for key in ('tests', 'pass', 'fail', 'cancelled', 'skipped')}
    assert counts['tests'] == counts['pass'] == expected
    assert not any(counts[key] for key in ('fail', 'cancelled', 'skipped'))
    test_runs.append({'file': name, **counts})

listing = read(directory / 'listing-verification.json')
assert listing['roundtrip_equal'] and listing['instructions'] == 395 and listing['bytes_roundtripped'] == 715

def classifications(atlas):
    result = {}
    for section in atlas['segments']:
        for address in range(max(atlas['base'], section['start']), section['end']):
            assert address not in result
            result[address] = section['status']
    assert len(result) == atlas['end'] - atlas['base']
    return result

old_atlas = json.loads(subprocess.check_output(
    ['git', 'show', '176b13f:sherlock-js/src/memory-map-data.json'], cwd=project))
new_atlas = read('src/memory-map-data.json')
assert classifications(old_atlas) == classifications(new_atlas)

abis = [previous / 'wide-abi' / f'{name}-abi.json'
        for name in ('passage', 'arrival-low', 'arrival-fresh-row', 'simple-error')]
abi_counts = [720, 1512, 300, 138]
probes = [read(path)['cases'] for path in abis]
assert list(map(len, probes)) == abi_counts
arrivals = [row for row in probes[1] if row['eligible']]
errors = [row for row in probes[3] if row['eligible']]
assert len(arrivals) == 720 and sum(row['cells'][15] != 165 for row in arrivals) == 110
assert all(row['cells'][15] == 165 for row in probes[2])
assert len(errors) == 129 and all(row['cells'][15] == 165 for row in errors)

paths = [*abis, previous_trace, reference_path,
         directory / 'natural-stores.json', directory / 'full-comparison.json',
         directory / 'baseline-6a33.json', directory / 'full-tests.log',
         'test/fixtures/glyph-address-high-abi.json',
         'results/glyph-scan-shift/deeper-frame-abi.json',
         'results/final-solution/witness-native-reference.json.gz',
         'src/random-display.mjs', 'src/game.mjs', 'src/text.mjs', 'src/npc-runtime.mjs']
report = {
    'natural_writer': reading,
    'trace_handover': trace['handover'],
    'additional_stack_stores': len(trace['stores']),
    'unclassified_transitions': len(trace['unclassified_transitions']),
    'original_abi': {'glyph_frames': 6, 'glyph_cases': 1296,
                     'passages': 720, 'owned_passage_matches': 290,
                     'arrivals': 1512, 'eligible_arrivals_overwriting_29': 110,
                     'fresh_rows_preserving_29': 300, 'eligible_errors_preserving_29': 129},
    'natural_certificate': {'protocol': reference['protocol'], **comparison},
    'next_limit': {'address': '5D2A', 'model_clock': lookahead['clock'],
                   'first_excluded_checkpoint': 539, 'original_clock': excluded['after']['clock'],
                   'original_draw': next_draw, 'natural_writer_untraced': True},
    'baseline_6a33': baseline,
    'test_runs': test_runs,
    'listing': listing,
    'atlas': {'counts': new_atlas['counts'], 'changed_classifications': 0},
    'sha256': {str(path): digest(path) for path in paths},
}
(project / 'results/passage-scan-count-29-verification.json').write_text(
    json.dumps(report, indent=2) + '\n')
print(comparison['checkpoints'], comparison['clock']['label'], test_runs[0]['pass'])
