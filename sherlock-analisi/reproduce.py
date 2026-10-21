"""Riproduce inventario, estrazione e listing. Non modifica i file sorgente.

Uso: python3 -B reproduce.py '/percorso/Sherlock rebuild' [--simulate]
--simulate ricrea lo snapshot all'ingresso $A040 (puo richiedere diversi minuti).
"""
import functools
import hashlib
import json
import operator
from pathlib import Path
import subprocess
import sys

sys.dont_write_bytecode = True
root = Path(sys.argv[1]).resolve()
kit = root / 'skoolkit-10.1'
out = Path(__file__).resolve().parent
sys.path.insert(0, str(kit))
from skoolkit.tape import parse_tap, parse_tzx

def run(tool, args, filename):
    with (out / filename).open('w') as stream:
        subprocess.run([sys.executable, '-B', str(kit / tool), *map(str, args)],
                       stdout=stream, check=True)

tap = root / 'SHERLOCK.TAP'
tzx = root / 'Sherlock v2.0.tzx'
a, b = parse_tap(str(tap)), parse_tzx(str(tzx))
aa = [bytes(x.data) for x in a.blocks if x.data is not None]
bb = [bytes(x.data) for x in b.blocks if x.data is not None]
meta = {'files': {p.name: {'bytes': p.stat().st_size,
        'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in (tap, tzx)},
        'all_tape_blocks_identical': aa == bb, 'warnings': list(a.warnings) + list(b.warnings),
        'blocks': []}
for i in range(0, len(aa), 2):
    h, d = aa[i:i+2]
    payload = d[1:-1]
    item = {'tap_header_block': i+1, 'tap_data_block': i+2,
            'name': h[2:12].decode('ascii'), 'type': h[1],
            'declared_length': int.from_bytes(h[12:14], 'little'),
            'parameter1': int.from_bytes(h[14:16], 'little'),
            'parameter2': int.from_bytes(h[16:18], 'little'),
            'payload_length': len(payload),
            'sha256': hashlib.sha256(payload).hexdigest(),
            'header_checksum_ok': functools.reduce(operator.xor, h) == 0,
            'data_checksum_ok': functools.reduce(operator.xor, d) == 0}
    assert item['declared_length'] == len(payload)
    assert item['header_checksum_ok'] and item['data_checksum_ok']
    meta['blocks'].append(item)
    (out / f'block-{i+2:02d}.bin').write_bytes(payload)
(out / 'inventory.json').write_text(json.dumps(meta, indent=2) + '\n')
run('tapinfo.py', [tap], 'tap-blocks.txt')
run('tapinfo.py', [tzx], 'tzx-blocks.txt')
run('tapinfo.py', ['-b', '2', tap], 'basic-loader.txt')
run('sna2skool.py', ['-H', '-o', '23296', '-c', out/'loader.ctl',
                   out/'block-04.bin'], 'loader.skool')
run('sna2skool.py', ['-H', '-o', '23936', '-c', out/'game-excerpts.ctl',
                   out/'block-10.bin'], 'game-excerpts.skool')
run('skool2bin.py', [out/'loader.skool', out/'loader-roundtrip.bin'], 'roundtrip.log')
assert (out/'loader-roundtrip.bin').read_bytes() == (out/'block-04.bin').read_bytes()
if '--simulate' in sys.argv:
    run('tap2sna.py', ['-s', '41024', '-c', 'timeout=600', tap,
                     out/'game-entry.z80'], 'load-tap.log')
    from skoolkit.snapshot import Snapshot, get_snapshot
    snap = Snapshot.get(str(out/'game-entry.z80'))
    mem = get_snapshot(str(out/'game-entry.z80'))
    checks = {'pc': snap.pc, 'sp': snap.sp, 'iff1': snap.iff1, 'im': snap.im,
              'main_payload_matches_memory': bytes(mem[23936:]) == (out/'block-10.bin').read_bytes(),
              'screen_payload_matches_memory': bytes(mem[16384:23296]) == (out/'block-08.bin').read_bytes(),
              'loader_status': mem[0x5b2f]}
    assert checks['pc'] == 41024 and checks['main_payload_matches_memory']
    assert checks['screen_payload_matches_memory'] and checks['loader_status'] == 1
    (out/'snapshot-checks.json').write_text(json.dumps(checks, indent=2)+'\n')
    run('trace.py', ['-m', '1000000', '--map', out/'startup.map', '--stats',
                    out/'game-entry.z80', out/'startup.z80', out/'startup.png'], 'startup.log')
print('Inventario, estrazione, listing e round-trip verificati.')
