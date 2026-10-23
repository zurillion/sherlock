"""Offline conversations: original bodies and delayed Watson requests.

No captured answer is used by the playable engine. The body cases isolate TELL
from autonomous programs and callbacks; the request cases keep Watson active.
"""
import argparse, json, sys
from pathlib import Path
sys.dont_write_bytecode = True
ap = argparse.ArgumentParser()
ap.add_argument('--project', type=Path, required=True)
ap.add_argument('--output', type=Path, required=True)
args = ap.parse_args(); p = args.project
sys.path.insert(0, str(p / 'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import NativeWorld, word

data = extract(p)
def record_random(w):
    calls = []; pending = None
    def observe(m, r, R):
        nonlocal pending
        pc = r[R.PC]
        if pc == 0xd2ad:
            pending = dict(width=r[R.A], mixOffset=r[R.D]*256+r[R.E],
                           seed=m[0xa037], cursor=word(m,0xa039), reads=[])
            calls.append(pending)
        if pending is not None and pc in (0xd2cb,0xd2d0):
            address=(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535
            pending['reads'].append(dict(address=address,value=m[address]))
        if pending is not None and pc == 0xd2ec:
            pending.update(output=r[R.A],next_seed=m[0xa037],next_cursor=word(m,0xa039))
            pending = None
    w.observer = observe
    return calls
payload = bytes(0x5d80) + (p / 'sherlock-analisi/block-10.bin').read_bytes()
topics = {}; cursor = 0xe22a
while payload[cursor] != 255:
    actor = payload[cursor]; cursor += 1; topics[actor] = {}
    while payload[cursor] != 255:
        topics[actor][payload[cursor]] = f'{word(payload, cursor+1):04X}'
        cursor += 3
    cursor += 1

bodies = []
for actor in [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 31, 34, 95]:
    for topic in sorted(set([2, 3, 16, 17, 18, 67]) | set(topics.get(actor, {}))):
        w = NativeWorld(p, active_npcs=[]); m = w.m
        m[0xa036] = actor; w.call(0xcc29); m[0xa027] = 0
        m[0x5c3c] = 1; m[0xa034:0xa036] = [0 if actor else 3, topic]
        calls = record_random(w); out = w.call(0xe1d8)
        bodies.append(dict(actor=actor, recipient=0 if actor else 3, topic=topic,
                           success=not out['z'], text=out['text'],
                           screen_events=out['screen_events'], random=calls))

requests = []
cases = {
    'questions': ['SAY TO WATSON "TELL ME ABOUT LESTRADE"',
                  'SAY TO WATSON "TELL ME ABOUT WATSON"',
                  'SAY TO WATSON "TELL ME ABOUT CASE"'],
    'delayed': ['SAY TO WATSON "WAIT"',
                'SAY TO WATSON "TELL ME ABOUT LESTRADE"', 'WAIT'],
    'multiple': ['SAY TO WATSON "TELL ME ABOUT LESTRADE. TAKE LAMP"',
                 'SAY TO WATSON "TELL ME ABOUT LESTRADE"'],
    'invalid_topic': ['SAY TO WATSON "TELL ME ABOUT DOOR"'],
    'direct': ['TELL WATSON ABOUT CASE', 'TELL WATSON ABOUT LESTRADE'],
    'bare_tell': ['SAY TO WATSON "TELL ME"', 'SAY TO WATSON "TELL ABOUT CASE"'],
    'payments': ['PAY 1/- TO WATSON', 'PAY 1/- TO WATSON',
                 'SAY TO WATSON "PAY 1/- TO ME"', 'COUNT MONEY'],
    'payment_literals': ['PAY £1 TO WATSON', 'PAY 2/6 TO WATSON',
                         'PAY £100 TO WATSON', 'PAY 0/- TO WATSON'],
    'payment_funds': ['PAY £9 TO WATSON', 'PAY 6d. TO WATSON', 'COUNT MONEY'],
    'payment_errors': ['PAY TO WATSON', 'PAY LAMP TO WATSON',
                       'PAY 1/- TO LAMP', 'PAY 1/-', 'PAY 8:30 TO WATSON'],
}
for label, commands in cases.items():
    g = Game(p, data, active_npcs=[3]); rows = []
    for command in commands:
        calls = record_random(g.world)
        out = g.command(command)
        rows.append(dict(input=command,
                         messages=[dict(kind=m['kind'], text=m['text']) for m in out['messages'] if m['text']],
                         clock=g.world.clock(), actions=g.last_analysis.get('actions', []),
                         watson_due=word(g.world.m, 0x9876),
                         parent_lamp=g.world.m[word(g.world.m, 0x8b70+22*3)+1],
                         money={str(i):list(g.world.m[word(g.world.m,0x8b70+i*3)+9:word(g.world.m,0x8b70+i*3)+11]) for i in [27,32,35]}, random=calls))
    requests.append(dict(label=label, commands=rows))
    print(label, [(r['input'], r['messages']) for r in rows], flush=True)
g = Game(p, data, active_npcs=[]); g.teleport(5); rows = []
for command in ['HAIL CAB', 'PAY 1/- TO CABBIE', 'PAY 2/6 TO CABBIE', 'PAY £9 TO CABBIE', 'COUNT MONEY']:
    out=g.command(command)
    rows.append(dict(input=command,messages=[dict(kind=m['kind'],text=m['text']) for m in out['messages'] if m['text']],clock=g.world.clock(),money={str(i):list(g.world.m[word(g.world.m,0x8b70+i*3)+9:word(g.world.m,0x8b70+i*3)+11]) for i in [27,32,35]}))
requests.append(dict(label='cab_player_payments_no_driver_turns',commands=rows))
args.output.write_text(json.dumps(dict(
    scope='TELL body fixtures isolate actor/topic; requests use historical free first prompt with only Watson active. No seed-parity claim.',
    bodies=bodies, requests=requests), ensure_ascii=False, indent=2)+'\n')
