#!/usr/bin/env python3
"""Verifica avvio gratuito, costi nativi e ripristino completo della partita web."""
import argparse,json
from pathlib import Path
from explorer import Game
from native_world import NativeWorld,word
from extract_locations import extract

def verify(project):
    data=extract(project);game=Game(project,data);checks=[]
    initial=game.state()
    assert initial['clock']['label']=='Mon 08:00am'
    game.world.scene();assert game.state()['clock']==initial['clock']
    checks.append('Initial description and state inspection leave the clock at Mon 08:00am')
    baseline=NativeWorld(project,active_npcs=None);visited={8};sequence=[]
    baseline.engine.put(baseline.sim,0x9fdd,1)
    for row in range(0x9860,0x9920,8):baseline.engine.put(baseline.sim,row+6,max(0,word(baseline.m,row+6)-1))
    baseline.m[0x9fdf:0x9fe3]=[0,8,0,97];baseline.engine.put(baseline.sim,0x9866,1)
    for command in ['LOOK','WAIT','XYZZY','OPEN DOOR','YOUR']:
        result=game.command(command);reference=baseline.submit(command,visited)
        actual=game.world.clock();original=baseline.clock()
        assert actual['tick']==original['tick']
        assert actual['due']==original['due']
        assert actual['minute']==original['minute']
        assert result['messages']==reference['messages']
        sequence.append({'command':command,'clock':actual,'reference_clock':original})
    assert sequence[0]['clock']['label']=='Mon 08:01am'
    assert sequence[2]['clock']==sequence[1]['clock']==sequence[3]['clock']
    checks.append('Native action costs and responses remain identical, with the same explicit free-start normalization; syntax and clarification are free')
    game.teleport(5);game.command('OPEN DOOR')
    fresh=Game(project,data)
    assert fresh.state()==initial
    checks.append('New session restores room, explored locations, entity positions, parser state and clock')
    return {'passed':True,'checks':checks,'sequence':sequence}

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results/restart-verification.json')
    a=ap.parse_args();result=verify(a.project);a.output.parent.mkdir(parents=True,exist_ok=True)
    a.output.write_text(json.dumps(result,indent=2)+'\n');print('OK:',len(result['checks']),'controlli di avvio e riavvio.')
