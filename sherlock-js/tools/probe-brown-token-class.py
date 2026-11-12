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
prompt = project / 'sherlock-js/results/murder-ending/brown-native-prompt.json.gz'
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
    if pc == 0xAE86:
        at = word(memory, 0xA029)
        sp = registers[R.SP]
        writes.append(dict(tick=world.clock()['tick'], actor=memory[0xA036], pc='AE86',
                           value=registers[R.A], pointer=at, current_type=memory[at],
                           stack=[f'{word(memory, i):04X}' for i in range(sp, min(sp+20, 0x5D80), 2)]))
    elif pc in (0xD2CB, 0xD2D0):
        at = (registers[R.IXh] * 256 + registers[R.IXl] + (pc == 0xD2D0)) & 0xFFFF
        if at in (0xA02D, 0xA033):
            reads.append(dict(address=f'{at:04X}', tick=world.clock()['tick'],
                              actor=memory[0xA036], value=memory[at],
                              last_writer=writes[-1] if at == 0xA02D and writes else None))

controls = []
for command in ['WAIT UNTIL 10AM', 'WAIT UNTIL 11PM', 'WAIT UNTIL 9:00', 'WAIT',
                'LOOK', 'EXAMINE ROCK', 'SAY WATSON "HELLO"', 'WAIT UNTIL 10AM AND LOOK']:
    restore()
    writes.clear()
    reads.clear()
    world.observer = observe
    outcome = game.start_command(command)
    controls.append(dict(input=command, clock=world.clock(), writes=writes[:],
                         current=world.m[0xA02D], running=outcome['running']))
(output / 'token-class-controls.json').write_text(json.dumps(controls, indent=2) + '\n')
print('Controls', len(controls), flush=True)

restore()
writes.clear()
reads.clear()
world.observer = None
for command in ['WAIT UNTIL 11PM', 'WAIT UNTIL 10AM', 'WAIT UNTIL 11PM']:
    outcome = game.start_command(command)
    while outcome['running']:
        outcome = game.continue_command(outcome['job'])
assert world.clock()['tick'] == 3781
world.observer = observe
outcome = game.start_command('WAIT UNTIL 10AM')
while outcome['running'] and not any(row['address'] == 'A02D' and row['tick'] >= 3985 for row in reads):
    outcome = game.continue_command(outcome['job'])
assert any(row['address'] == 'A02D' and row['tick'] == 3985 for row in reads)
(output / 'token-class-natural.json').write_text(json.dumps(dict(writes=writes, reads=reads), indent=2) + '\n')
print('Natural', reads[-2:], flush=True)
