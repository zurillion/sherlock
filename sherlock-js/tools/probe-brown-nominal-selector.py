"""Trace the original parser's previous token class and its use in Brown."""
import gzip
import hashlib
import json
from pathlib import Path
import sys

project = Path(__file__).resolve().parents[2]
sys.dont_write_bytecode = True
sys.path.insert(0, str(project / 'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word

output = project / 'sherlock-js/results/brown-to-ending'
prompt = project / 'sherlock-js/results/murder-ending/talk-native-prompt.json.gz'
saved = json.loads(gzip.decompress(prompt.read_bytes()))
assert saved['payload_sha256'] == hashlib.sha256(
    (project / 'sherlock-analisi/block-10.bin').read_bytes()).hexdigest()
game = Game(project, extract(project), seed=1, active_npcs=None)
world = game.world

def restore():
    world.m[:] = saved['memory']
    world.sim.registers[:] = saved['registers']
    world.input_registers = saved['input_registers'][:]
    world.input_stack = saved['input_stack'][:]
    game.explored = set(saved['explored'])
    game.last_listed = saved['last_listed']
    game.last_analysis = saved['last_analysis']
    game.opening_pending = False
    game.cached_state = None
    game.command_job = None
    game.job_id = None
    world.ended = None

writes = []
reads = []
def observe(memory, registers, R):
    pc = registers[R.PC]
    if pc in (0xA4EB, 0xB3DA):
        sp = registers[R.SP]
        writes.append(dict(pc=f'{pc:04X}', tick=world.clock()['tick'], actor=memory[0xA036],
                           value=registers[R.A], hl=registers[R.H]*256+registers[R.L],
                           iy=registers[R.IYh]*256+registers[R.IYl],
                           stack=[f'{word(memory, i):04X}' for i in range(sp, min(sp+40, 0x5D80), 2)]))
    elif pc in (0xD2CB, 0xD2D0):
        address = (registers[R.IXh]*256+registers[R.IXl]+(pc==0xD2D0))&65535
        if address == 0xA02E:
            reads.append(dict(tick=world.clock()['tick'], actor=memory[0xA036],
                              value=memory[address], last_writer=writes[-1] if writes else None))

if '--controls' in sys.argv:
    rows = []
    for command in ['WAIT UNTIL 10AM', 'WAIT UNTIL 11PM', 'WAIT UNTIL 9:00', 'WAIT',
                    'LOOK', 'EXAMINE ROCK', 'SAY WATSON "HELLO"', 'WAIT UNTIL 10AM AND LOOK']:
        restore()
        writes.clear()
        world.observer = observe
        outcome = game.start_command(command)
        rows.append(dict(input=command, writes=writes[:], current=world.m[0xA02E],
                         running=outcome['running']))
    (output/'nominal-selector-controls.json').write_text(json.dumps(rows, indent=2)+'\n')
    print('Controls', len(rows))
    raise SystemExit

restore()
world.observer = observe
history = (prompt.parent/'to-brown-clues.txt').read_text().splitlines()
history += ['WAIT UNTIL 11PM', 'WAIT UNTIL 10AM']*2
for command in history:
    outcome = game.start_command(command)
    while outcome['running'] and not any(row['tick'] >= 4070 for row in reads):
        outcome = game.continue_command(outcome['job'])
    if not command.startswith('WAIT UNTIL') and writes:
        print(command, world.clock()['tick'], writes[-1], flush=True)
    if any(row['tick'] >= 4070 for row in reads):
        break
assert any(row['tick'] == 4070 for row in reads)
(output/'nominal-selector-natural.json').write_text(json.dumps(dict(writes=writes, reads=reads), indent=2)+'\n')
print(reads[-1], flush=True)
