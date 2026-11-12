"""Consolidate the original evidence and verified JavaScript results."""
from collections import Counter
from hashlib import sha256
import json
from pathlib import Path
import re

project = Path(__file__).resolve().parents[1]
directory = Path('results/passage-caller-c-22')
output = project / directory

def read(path):
    return json.loads((project / path).read_bytes())

def result(name):
    return read(directory / name)

def digest(path):
    return sha256((project / path).read_bytes()).hexdigest()

trace = result('natural-stores.json')
earlier_trace = read('results/passage-descriptor-high-21/natural-stores.json')
observed_prefix = [row for row in trace['stores'] if int(row['address'], 16) <= 0x5D27]
assert observed_prefix[:len(earlier_trace['stores'])] == earlier_trace['stores']
assert not trace['unclassified_transitions']
writers = []
for address, pc, frame, char, value in [
    ('5D22', 'C389', 0x5D26, 110, 5),
    ('5D28', 'C3B7', 0x5D32, 32, 4),
]:
    reading = next(row for row in trace['reads'] if row['address'] == address and row['clock']['tick'] == 3377)
    writer = reading['last_store']
    assert reading['actor'] == 9 and reading['value'] == value
    assert writer['pc'] == pc and writer['actor'] == 0 and writer['clock']['tick'] == 1653
    assert writer['glyph']['frame'] == frame and writer['glyph']['char'] == char
    assert writer['bc'] & 255 == value == writer['glyph']['shift']
    writers.append(reading)

reference = result('extended-reference.json')
case = reference['cases'][0]
comparison = result('full-comparison.json')
assert comparison['checkpoints'] == 530 and comparison['stoppedAt'] == '5D29'
assert comparison['clock'] == case['steps'][529]['after']['clock']
assert comparison['compared_random_draws'] == 8456 and comparison['compared_random_reads'] == 18036
assert comparison['load_future_compared'] and comparison['bitmaps_compared']
assert result('reference-provenance.json')['identical_original_checkpoints'] == 521
excluded = case['steps'][530]
next_draw = next(draw for draw in excluded['random'] if any(q['address'] == 0x5D29 for q in draw['reads']))
assert next_draw['actor'] == 8
lookahead = result('research-last.json')[-1]
assert lookahead['clock']['tick'] == 3469 and '$5D29' in lookahead['notice']

baseline = result('baseline-6a33.json')
assert baseline['checkpoints'] == 521 and baseline['full_ending_certified']
assert baseline['terminal']['text_pointer'] == '6A33'

runs = []
for name, expected in [('existing-tests.log', 1899), ('focused-tests.log', 5), ('atlas-tests.log', 5)]:
    log = (output / name).read_text()
    metrics = {key: int(re.search(r'ℹ ' + key + r' (\d+)', log)[1])
               for key in ('tests', 'pass', 'fail', 'cancelled', 'skipped')}
    assert metrics['tests'] == metrics['pass'] == expected
    assert not any(metrics[key] for key in ('fail', 'cancelled', 'skipped'))
    runs.append({'file': name, **metrics})

atlas = result('atlas-delta.json')
listing = result('listing-verification.json')
assert not atlas['status_changed_byte_count']
assert listing['roundtrip_equal'] and listing['instructions'] == 395 and listing['bytes_roundtripped'] == 715
probes = {name: result('wide-abi/' + name + '-abi.json')['cases']
          for name in ('passage', 'arrival-low', 'arrival-fresh-row', 'simple-error')}
assert [len(rows) for rows in probes.values()] == [720, 1512, 300, 138]
arrivals = [row for row in probes['arrival-low'] if row['eligible']]
errors = [row for row in probes['simple-error'] if row['eligible']]
assert len(arrivals) == 720 and all(row['cells'][8] == 165 for row in arrivals)
assert sum(row['cells'][14] != 165 for row in arrivals) == 110
assert all(row['cells'][14] == 165 for row in probes['arrival-fresh-row'])
assert len(errors) == 129 and all(row['cells'][8] == row['cells'][14] == 165 for row in errors)
paths = [directory / ('wide-abi/' + name + '-abi.json') for name in probes]
paths += [directory / name for name in ['natural-stores.json', 'extended-reference.json',
          'full-comparison.json', 'baseline-6a33.json', 'existing-tests.log', 'focused-tests.log']]
paths += ['data/game.json', 'test/fixtures/glyph-address-high-abi.json',
          'results/final-solution/witness-native-reference.json.gz',
          'src/random-display.mjs', 'src/text.mjs', 'src/game.mjs', 'src/npc-runtime.mjs']
report = {
    'runtime': 'Both bytes derive from the pixel-column offset, with independent caller and separator scopes. Native execution is restricted to the offline probes.',
    'natural_writers': writers,
    'observed_stack_stores': len(trace['stores']),
    'stack_stores_per_address': dict(sorted(Counter(row['address'] for row in trace['stores']).items())),
    'unclassified_stack_transitions': len(trace['unclassified_transitions']),
    'prior_store_prefix_exact': True,
    'additional_20_through_27_stores': len(observed_prefix) - len(earlier_trace['stores']),
    'controlled_original': {
        'reused_22_glyph_cases': 1296,
        'whole_passage_cases': 720,
        'passage_matches_per_address': 290,
        'eligible_arrivals_preserving_22': 720,
        'eligible_arrivals_overwriting_28': 110,
        'fresh_rows_preserving_28': 300,
        'eligible_errors_preserving_both': 129,
        'runtime_28_scope': 'Ordinary proper-name arrival, fresh row, empty buffer, zero spacing, fits, counter + 2 < 15.',
    },
    'natural_certificate': {'protocol': reference['protocol'], **comparison},
    'next_limit': {'address': '5D29', 'model_clock': lookahead['clock'],
                   'first_excluded_checkpoint': 530, 'original_checkpoint_clock': excluded['after']['clock'],
                   'original_draw': next_draw, 'natural_writer_still_to_trace': True},
    'baseline_6a33': baseline,
    'test_runs': runs,
    'distinct_tests_passed': 1904,
    'listing': listing,
    'atlas': atlas,
    'sha256': {str(path): digest(path) for path in paths},
}
(project / 'results/passage-caller-c-22-verification.json').write_text(json.dumps(report, indent=2) + '\n')
print(comparison['checkpoints'], comparison['clock']['label'], report['observed_stack_stores'])
