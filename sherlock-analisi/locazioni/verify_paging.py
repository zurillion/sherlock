#!/usr/bin/env python3
"""Produce independent Z80 fixtures for the browser's upper output stream."""
import argparse,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
from native_screen import ScreenStream,opening_screen
from explorer import Game
from extract_locations import extract


def verify(project,output):
    sys.path.insert(0,str(project/'sherlock-analisi/scrolling'))
    from trace_scrolling import ScrollProbe
    p=ScrollProbe(project,boot=True);recorder=ScreenStream();original=p.observe;recording=False
    def observe():
        nonlocal recording
        r,R,m=p.r,p.R,p.m
        if r[R.PC]==0xcc9e and m[0xa036]==0 and r[R.IXh]*256+r[R.IXl]==0x9921:recording=True
        if recording:recorder.observe(m,r,R)
        original()
    p.observe=observe;fixtures=[]
    for command in [None,'WAIT','WAIT','OPEN DOR','LOOK','LOOK. LOOK','PICK THE NOTE UP','EXAMINE ARMCHAIR','YOUR','WAIT','WAIT']:
        phase=p.run(command)
        fixtures.append({'name':phase['phase'],'packets':recorder.drain(),
                         'after':phase['after'],
                         'pages':[e['screen'] for e in phase['events'] if e['event']=='more'],
                         'feeds':sum(e['event']=='linefeed' for e in phase['events'])})
    # The real formatter beside an illustration, including the C306 switch
    # to 36 columns halfway through a word-wrapped paragraph.
    narrow=ScrollProbe(project);nr=ScreenStream();original_narrow=narrow.observe
    def observe_narrow():
        nr.observe(narrow.m,narrow.r,narrow.R);original_narrow()
    narrow.observe=observe_narrow
    narrow.m[0xa027]=0;narrow.m[0x5c3c]=1;narrow.m[0xa025]=0;narrow.m[0xa026]=1;narrow.m[0xa851]=0
    narrow.m[0xa9b5:0xa9b7]=[0x0b,0x5c]
    parts=[narrow.run(call=0xc129)]
    for c in ('The narrow window has eighteen columns. '+'Exactwidthwordhere '+ 'Watson says " Good morning Holmes. " '*20+'\r'):
        parts.append(narrow.run(call=0xa9b7,a=ord(c)))
    native_narrow={'name':'illustrated formatter','packets':nr.drain(),'after':parts[-1]['after'],
                  'pages':[e['screen'] for part in parts for e in part['events'] if e['event']=='more'],
                  'feeds':sum(e['event']=='linefeed' for part in parts for e in part['events'])}
    # The web bridge must preserve exactly the same packet stream, including
    # the reset missing from lexical errors and the single reset for LOOK.LOOK.
    game=Game(project,extract(project));checks=[]
    def check(name,ok):
        assert ok,name
        checks.append(name);print('OK:',name,flush=True)
    check('Cached opening packets match a fresh native boot',list(opening_screen(str(project.resolve())))==fixtures[0]['packets']==game.opening_screen)
    for fixture in fixtures[1:]:
        result=game.command(fixture['name'])
        events=[e for msg in result['messages'] for e in msg.get('screen_events',[])]
        check('Web packets preserve original order: '+fixture['name'],events==fixture['packets'])
    # Transport minute frames unchanged: synchronous and streaming APIs agree.
    a=Game(project,game.data);b=Game(project,game.data)
    synchronous=a.command('WAIT UNTIL 8:10')
    progress=b.start_command('WAIT UNTIL 8:10');messages=[];frames=[]
    while True:
        messages.extend(progress['messages'])
        if not progress['running']:break
        frames.append(progress['clock']['label']);progress=b.continue_command(progress['job'])
    check('Streaming minute batches neither discard nor duplicate presentation packets',
          [e for msg in synchronous['messages'] for e in msg.get('screen_events',[])]==[e for msg in messages for e in msg.get('screen_events',[])])
    check('WAIT UNTIL still reaches 08:10 minute by minute',len(frames)==10 and b.world.clock()['label']=='Mon 08:10am')
    jump=Game(project,game.data);before=jump.world.clock();mapped=jump.teleport(74)
    check('First map visit retains its picture request even with a short native scene',
          any(e=={'op':'picture','room':74} for msg in mapped['messages'] for e in msg.get('screen_events',[]))
          and jump.world.clock()==before)
    output.mkdir(parents=True,exist_ok=True)
    (output/'paging-fixtures.json').write_text(json.dumps({'source_payload_sha256':hashlib.sha256((project/'sherlock-analisi/block-10.bin').read_bytes()).hexdigest(),'fixtures':fixtures,'narrow_fixture':native_narrow},ensure_ascii=False,indent=2)+'\n')
    (output/'paging-bridge-verification.json').write_text(json.dumps({'passed':True,'checks':checks,'clock_frames':frames},ensure_ascii=False,indent=2)+'\n')


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args();verify(a.project,a.output)
