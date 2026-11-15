"""Trace the first video bytes that diverge between two Sherlock graphics profiles."""
import hashlib
import json
import sys
from pathlib import Path

sys.dont_write_bytecode = True
root = Path(__file__).resolve().parents[1]
project = root.parent
sys.path.insert(0, str(project / 'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word

route = (root / 'results/victory-route/victoria-full-route.txt').read_text().splitlines()[:12]
assert route[-2:] == ['W', 'D']
catalog = extract(project)
addresses = (0x4500, 0x4506)
points = {0xA277, 0xA296, 0xA284, 0xA28D, 0xA290, 0xC129, 0xD2AD, 0xF1A1}
profiles = []
for enabled in (True, False):
    game = Game(project, catalog, seed=1, active_npcs=None)
    world = game.world
    if not enabled:
        world.m[0xA011] = 0
    draws = []
    events = []
    changed = []
    focused = False
    previous_pc = None
    previous_values = None
    pending = None

    def observe(m, r, R):
        global previous_pc, previous_values, pending
        pc = r[R.PC]
        if focused:
            current_values = [m[a] for a in addresses]
            if previous_values is not None and current_values != previous_values:
                changed.append(dict(pc=f'{previous_pc:04X}', values=current_values))
            if pc in points:
                events.append(dict(pc=f'{pc:04X}', tick=word(m, 0x9FDD), actor=m[0xA036],
                                   values=current_values, narrow=m[0xC128]))
                if pc == 0xF1A1:
                    events[-1].update(threshold=r[R.A], percentage=r[R.B])
            previous_pc, previous_values = pc, current_values
        if pc == 0xD2AD:
            pending = dict(tick=word(m, 0x9FDD), actor=m[0xA036], width=r[R.A],
                           offset=(r[R.D] << 8) | r[R.E], seed=m[0xA037],
                           cursor=word(m, 0xA039), reads=[])
        elif pending is not None and pc in (0xD2CB, 0xD2D0):
            address = (((r[R.IXh] << 8) | r[R.IXl]) + (pc == 0xD2D0)) & 0xFFFF
            pending['reads'].append([address, m[address]])
        elif pc == 0xD2EC and pending is not None:
            signed = r[R.A] if r[R.A] < 128 else r[R.A] - 256
            pending.update(result=abs(signed), next_seed=m[0xA037], next_cursor=word(m, 0xA039))
            draws.append(pending)
            pending = None

    world.observer = observe
    for command in route[:-1]:
        game.command(command)
    prefix = draws[:]
    draws.clear()
    before = [world.m[a] for a in addresses]
    focused = True
    game.command(route[-1])
    focused = False
    row = next(at for at in range(0x9860, 0x9920, 8) if world.m[at] == 5)
    profiles.append(dict(graphics=enabled, prefix=prefix, before=before, checkpoints=events,
                         video_changes=changed, last_command_draws=draws, clock=world.clock(),
                         strachan=dict(pc=f'{word(world.m, row + 1):04X}', due=word(world.m, row + 6))))
on, off = profiles
assert on['prefix'] == off['prefix']
first_on, first_off = on['last_command_draws'][0], off['last_command_draws'][0]
assert first_on['reads'][:2] == [[0x4500, 0], [0x4506, 0]]
assert first_off['reads'] == [[0x4500, 17], [0x4506, 4]]
for actual, (percentage, pixels) in zip(profiles, ((81, [0, 0]), (3, [17, 4]))):
    compare = next(event for event in actual['checkpoints'] if event['pc'] == 'F1A1')
    assert (compare['actor'], compare['threshold'], compare['percentage']) == (5, 10, percentage)
    assert compare['values'] == pixels
assert all(change['pc'] == 'C33C' for p in profiles for change in p['video_changes'])
assert next(event for event in on['checkpoints'] if event['pc'] == 'A284')['values'] == [0, 0]
report = dict(protocol='Two native runs from the free initial LOOK with injected uppercase keys and immediate MORE. The second clears A011 once after boot.',
              seed=1, actors=24, route=route, matched_draws=len(on['prefix']),
              matched_reads=sum(len(d['reads']) for d in on['prefix']),
              matched_trace_sha256=hashlib.sha256(json.dumps(on['prefix'], separators=(',', ':')).encode()).hexdigest(),
              first_difference=dict(graphics_on=first_on, graphics_off=first_off),
              video=[{k: v for k,v in item.items() if k not in ('prefix', 'last_command_draws')} for item in profiles])
Path(sys.argv[1]).write_text(json.dumps(report, indent=2) + '\n')
