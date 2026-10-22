#!/usr/bin/env python3
"""Ricostruisce l'avvio Z80 e verifica il saluto iniziale di Watson nella pagina."""
import argparse
import json
import re
from pathlib import Path
from types import SimpleNamespace

from explorer import Game
from extract_locations import extract
from native_world import NativeWorld, word


def verify(project):
    data=extract(project);game=Game(project,data);e=game.parser;R=e.R
    sim=e.audit.from_snapshot(e.audit.Simulator,e.audit.entry)
    sim.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255))
    m,r=sim.memory,sim.registers;output=[];events=[];recording=False;soft_wrap=False
    for step in range(3000000):
        pc=r[R.PC];ix=r[R.IXh]*256+r[R.IXl]
        if pc==0xc415:r[R.A],r[R.PC]=ord('N'),0xc41e
        if pc==0xa536:break
        if pc==0xcc9e:
            if m[0xa036]==0 and ix==0x9921:recording=True
            if ix in (0x9921,0xe72f,0xe732,0xe737,0xe79c):
                events.append({'event':'bytecode','actor':m[0xa036],'address':f'{ix:04X}',
                               'tick':word(m,0x9fdd),'step':step})
        if pc==0xa59f and r[R.H]*256+r[R.L]==0x6deb:
            events.append({'event':'greeting_text','actor':m[0xa036],'address':'6DEB','step':step})
        if recording and not m[0xa027] and m[0x5c3c]:
            if pc==0xaa28 and r[R.A]==32:output.append(' ')
            if pc==0xaa6e and r[R.A]==13:soft_wrap=word(m,r[R.SP])==0xa9f4
            if pc==0xc2ba:
                c=r[R.A]
                if c==13:output.append(' ' if soft_wrap else '\n');soft_wrap=False
                elif c>=32:output.append('£' if c==96 else chr(c))
        sim.opcodes[m[r[R.PC]]]()
    else:raise AssertionError('Original boot did not reach the first prompt')
    native='\n'.join(re.sub(r'[ \t]+',' ',line).strip() for line in ''.join(output).replace('\x08','').split('\n')).strip()
    checks=[]
    def check(name,ok):
        assert ok,name
        checks.append({'check':name,'passed':True});print('OK:',name,flush=True)
    greeting=e.audit.decoder.render(0x6deb)['text'].strip()
    check('Original boot runs LOOK before Watson opcode 06 at E72F and text 6DEB',
          [v['address'] for v in events if v['event']=='bytecode'][:2]==['9921','E72F']
          and any(v['event']=='greeting_text' and v['actor']==3 for v in events))
    check('Web opening matches the full native narrative from LOOK to the first prompt',game.opening==native)
    check('Description and Watson greeting have exactly one newline between them',
          native.endswith(game.initial+'\n'+greeting) and '\n\n' not in native)
    raw=NativeWorld(project,active_npcs=None)
    check('Saved prompt has already advanced Watson beyond the greeting',
          word(raw.m,0x9871)==word(m,0x9871)==0xe79f and word(raw.m,0x9fdd)==2)
    # Reading and decoding presentation must not touch VM memory or registers.
    before=(game.world.m[:],game.world.sim.registers[:])
    e.audit.decoder.render(word(game.world.m,0xe730))
    check('Reconstructing the greeting does not repeat the actor turn or alter the VM',
          before==(game.world.m,game.world.sim.registers)
          and game.world.clock()['label']=='Mon 08:00am')
    result=game.command('WAIT');text=' '.join(v['text'] for v in result['messages'])
    check('First WAIT still lasts five minutes and never repeats the greeting',
          result['state']['clock']['label']=='Mon 08:05am' and greeting not in text
          and result['state']['opening'] is None)
    result=game.command('LOOK')
    check('LOOK and later state reloads contain the scene without the startup greeting',
          result['state']['opening'] is None and greeting not in result['state']['initial'])
    fresh=Game(project,data)
    check('Restart restores the opening once, at the free 08:00 clock',
          fresh.state()['opening']==native and fresh.world.clock()['label']=='Mon 08:00am')
    fresh.teleport(5)
    check('Map travel discards startup presentation for later scene reloads',fresh.state()['opening'] is None)
    return {'passed':True,'checks':checks,'events':events,'native_opening':native,
            'native_prompt_clock':[m[a] for a in range(0x9fdf,0x9fe3)],
            'native_watson_script':f'{word(m,0x9871):04X}','greeting':greeting,
            'text_pointer':'6DEB','script_address':'E72F'}


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results/opening-verification.json')
    args=ap.parse_args();result=verify(args.project);args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
