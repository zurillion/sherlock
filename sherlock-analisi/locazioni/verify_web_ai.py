#!/usr/bin/env python3
"""Verifica Watson, Lestrade e le loro dipendenze nello scheduler web originale."""
import argparse
import json
import sys
from pathlib import Path

from explorer import Game
from extract_locations import extract
from native_world import word


def norm(text):
    return ' '.join(text.replace('`', '£').split())


def verify(project):
    project = Path(project)
    sys.path.insert(0, str(project / 'sherlock-analisi/ai'))
    from trace_npc_ai import Probe

    data = extract(project)
    checks, traces = [], {}

    def check(name, condition, **details):
        assert condition, (name, details)
        checks.append({'check': name, 'passed': True, **details})
        print('OK:', name, flush=True)

    def fresh():
        game = Game(project, data)
        game.world.m[0xa037] = 1
        game.parser.put(game.world.sim, 0xa039, 0)
        return game

    def entity(game, ident):
        p = word(game.world.m, 0x8b70 + ident * 3)
        return {'room': game.world.m[p + 15], 'parent': game.world.m[p + 1]}

    def run(game, commands, label):
        rows = traces.setdefault(label, [])
        for command in commands:
            out = game.command(command)
            assert game.last_analysis['outcome'] != 'tool_limit', (label, command, out)
            rows.append({'command': command, 'clock': game.world.clock(),
                         'messages': out['messages'],
                         'watson': entity(game, 3), 'lestrade': entity(game, 2),
                         'characters': game.characters(),
                         'actions': game.last_analysis.get('actions', [])})
        return rows[-1]

    def text(row):
        return norm(' '.join(message['text'] for message in row['messages']))

    game = fresh()
    check('Production enables the full native actor scheduler', game.world.active_npcs is None)
    initial = game.state()
    actors_before = game.world.m[0x9860:0x9920]
    run(game, ['XYZZY', 'OPEN DOOR'], 'free_input')
    check('Lexical errors and clarification do not grant NPC turns',
          game.world.m[0x9860:0x9920] == actors_before and game.world.clock() == initial['clock'])
    run(game, ['YOUR'], 'free_input')
    check('Clarification still completes the original command with AI enabled',
          'You open your door.' in text(traces['free_input'][-1]))

    # Independent harness: no NativeWorld/Game command implementation is reused.
    # Both start at the same saved prompt. Apply the documented free-start offset
    # to the reference, then compare texts, all entity records and all actor rows.
    def compare(label, commands, inspect=False):
        game, ref = fresh(), Probe(project, 1)
        ref.e.put(ref.s, 0x9fdd, 1)
        for row in range(0x9860, 0x9920, 8):
            ref.e.put(ref.s, row + 6, max(0, word(ref.m, row + 6) - 1))
        ref.m[0x9fdf:0x9fe3] = [0, 8, 0, 97]
        ref.e.put(ref.s, 0x9866, word(ref.m, 0x9fdd))
        compared = []
        for command in commands:
            if inspect:
                for _ in range(3):
                    game.world.scene()
                    game.state()
            actual = run(game, [command], label)
            original = ref.command(command)
            assert original['stop'] == 'prompt', (label, command, original['stop'])
            upper = norm(' '.join(m['text'] for m in actual['messages'] if m['kind'] == 'narrative'))
            lower = norm(' '.join(m['text'] for m in actual['messages'] if m['kind'] == 'error'))
            assert upper == norm(original['upper']), (label, command, upper, original['upper'])
            assert lower.upper() == norm(original['lower']).upper(), (label, command, lower, original['lower'])
            for obj in data['entities']:
                start = int(obj['record'], 16)
                end = start + obj['size']
                assert game.world.m[start:end] == ref.m[start:end], (label, command, obj['id'])
            assert game.world.m[0x9860:0x9920] == ref.m[0x9860:0x9920], (label, command, 'actor rows')
            assert game.world.m[0x9fdd:0x9fe3] == ref.m[0x9fdd:0x9fe3], (label, command, 'clock')
            compared.append(command)
        check('Independent full-game comparison: ' + label, True, commands=compared,
              entity_records_per_command=110, actor_rows_per_command=24)
        return game

    follow = compare('watson_orders_and_follow', [
        'SAY TO WATSON "TAKE LAMP"',
        'SAY TO WATSON "DROP THE DAILY CHRONICLE"',
        'OPEN YOUR DOOR', 'WEST', 'DOWN', 'OPEN FRONT DOOR', 'SOUTH'], inspect=True)
    check('Watson takes the lamp, leaves his armchair and follows through adjacent rooms',
          entity(follow, 22)['parent'] == 3 and entity(follow, 3)['room'] == follow.world.room == 5,
          final_watson=entity(follow, 3))

    game = fresh()
    run(game, ['SAY TO WATSON "FOLLOW ME"', 'OPEN YOUR DOOR', 'WEST'], 'explicit_follow')
    check('Quoted FOLLOW ME runs the deferred native behaviour', entity(game, 3)['room'] == 7)

    game = compare('watson_information', [
        'SAY TO WATSON "TELL ME ABOUT LESTRADE"',
        'SAY TO WATSON "BASIL KILLED MRS BROWN"',
        'SAY TO WATSON "WATSON IS INNOCENT"'])
    facts, cursor, seen = [], word(game.world.m, 0x9ff4), set()
    while cursor:
        assert cursor not in seen and 0x9000 <= cursor < 0xa000
        seen.add(cursor)
        facts.append(list(game.world.m[cursor:cursor + 5]))
        cursor = word(game.world.m, cursor - 2)
    check('Statements update native information records', any(row[:3] == [6, 5, 94] for row in facts), facts=facts)

    game = fresh()
    run(game, ['OPEN YOUR DOOR', 'WEST'] + ['WAIT'] * 9, 'watson_note')
    check('Without Holmes, Watson leaves his note and goes off map',
          entity(game, 3)['room'] == 0 and entity(game, 26)['room'] == 8)

    game = fresh()
    game.teleport(10)
    reply = run(game, ['SAY TO LESTRADE "WAIT"'], 'lestrade_refusal')
    check('Lestrade refuses WAIT during his native restricted phase',
          'Sorry, I cannot do that now.' in text(reply), response=text(reply))
    run(game, ['WAIT'], 'lestrade_refusal')
    check('Lestrade orders the cabbie and boards the cab',
          entity(game, 2)['parent'] == 30 and
          any(a['actor'] == 31 for row in traces['lestrade_refusal'] for a in row['actions']))

    # Reproduce the player's cab journey with every actor running as in production.
    cab = compare('cab_with_npcs', [
        'OPEN YOUR DOOR', 'WEST', 'DOWN', 'OPEN FRONT DOOR', 'SOUTH',
        'HAIL CAB', 'GET INTO CAB', 'SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"',
        'WAIT', 'WAIT', 'WAIT', 'GET OUT OF CAB', 'PAY 1/- TO CABBIE'])
    check('Cab transport and payment remain usable with Watson and Lestrade active',
          cab.world.room == 28 and any('4d.' in text(row) for row in traces['cab_with_npcs']))

    # Exercise the train dependency and the first exchange of NPC signals naturally.
    game = fresh()
    for _ in range(40):
        row = run(game, ['WAIT'], 'autonomous_world')
        if entity(game, 2)['room'] == 53:
            break
    route = [row['lestrade'] for row in traces['autonomous_world']]
    check('Watson autonomously introduces the murder case',
          any('Well here is a case' in text(row) for row in traces['autonomous_world']))
    check('Lestrade travels by cab, reaches the platform, boards train 42 and arrives at Leatherhead',
          any(x['parent'] == 30 for x in route) and any(x['room'] == 22 for x in route)
          and any(x['parent'] == 42 for x in route) and entity(game, 2)['room'] == 53,
          clock=game.world.clock(), route=route)
    check('Map marker reads Lestrade\'s live arrival position',
          next(c for c in game.characters() if c['id'] == 2)['rooms'] == [53])
    for _ in range(4):
        run(game, ['WAIT'], 'autonomous_world')
    # E7F2 is the first wait for Straker's reply; advancement proves he was scheduled.
    row = next(p for p in range(0x9860, 0x9920, 8) if game.world.m[p] == 2)
    check('Lestrade continues beyond the initial Straker handshake',
          all(any(a['actor'] == 2 and a['id'] == 19 and a['arguments'][0] == obj
                  for turn in traces['autonomous_world'] for a in turn['actions']) for obj in (46, 47)),
          script=f'{word(game.world.m, row + 1):04X}', clock=game.world.clock())

    restarted = fresh()
    check('Restart restores Watson, Lestrade, vehicles, requests and initial clock', restarted.state() == initial)
    return {'passed': True, 'seed': 1, 'scheduler': 'all native actors', 'checks': checks,
            'commands': sum(len(rows) for rows in traces.values()), 'traces': traces,
            'scope': 'Watson, early Lestrade itinerary and interactions; not a full playthrough of every later scene.'}


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project', type=Path, default=Path(__file__).resolve().parents[2])
    ap.add_argument('--output', type=Path, default=Path(__file__).resolve().parent / 'results/web-ai-verification.json')
    args = ap.parse_args()
    result = verify(args.project)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print('OK:', len(result['checks']), 'controlli AI web;', result['commands'], 'comandi.')
