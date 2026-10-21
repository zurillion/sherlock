#!/usr/bin/env python3
"""Prove differenziali di percezione, descrizioni, movimento e prototipo."""
import argparse,json
from pathlib import Path
from native_world import NativeWorld,word
from extract_locations import extract
from explorer import Game,perceived

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args();a.output.mkdir(parents=True,exist_ok=True)
    data=extract(a.project);rooms=data['rooms'];edges=data['edges'];assert len(rooms)==106 and len(edges)==206
    assert all(e['target']<106 and 1<=e['direction_id']<=10 and e['gate']<110 for e in edges)
    traces=[];w=NativeWorld(a.project)
    def record(label,result):traces.append({'case':label,'room':w.room,'clock':w.clock(),'room_flag':w.m[int(rooms[w.room]['record'],16)],**result})
    for label,act,arg in [('LOOK iniziale',34,255),('ovest porta chiusa',4,255),('apri porta',36,21),('ovest nuovo',4,255),('est primo rientro',3,255),('ovest rivisita',4,255),('est rivisita',3,255),('LOOK dopo rivisita',34,255)]:
        out=w.action(act,arg);record(label,out)
    assert traces[1]['z'] and traces[1]['room']==8
    assert any(x['pc']=='D102' for x in traces[3]['events'])
    assert any(x['pc']=='D1B2' for x in traces[5]['events'])
    assert 'sun streams' not in traces[6]['text'] and 'sun streams' in traces[7]['text']
    assert set(traces[7]['listed'])=={22,23,24,3,25}
    # LOOK non imposta da solo il bit di visita: lo fa il percorso di ingresso.
    assert traces[0]['room_flag']&64==0 and traces[4]['room_flag']&64
    checks=0;visibility=[]
    for room in (8,7,9,47,61,74):
        w.teleport(room)
        py=[i for i in range(110) if perceived(w.m,i)];native=w.visible();assert py==native,(room,py,native);checks+=110
        visibility.append({'fixture':'teletrasporto sintetico','room':room,'visible':native})
    # Contenitore aperto/chiuso/invisibile: Watson dentro la poltrona 24.
    for flags in (0,128,160,136):
        w=NativeWorld(a.project);p=word(w.m,0x8b70+3*24);w.m[p+5]=flags
        py=[i for i in range(110) if perceived(w.m,i)];assert py==w.visible();checks+=110
        visibility.append({'fixture':'flag poltrona Watson sintetico','flags':flags,'visible':py})
    scenes=[]
    for room in range(1,106):
        w=NativeWorld(a.project);out=w.teleport(room)
        scenes.append({'room':room,'fixture':'Holmes trasferito; mondo fermo al primo prompt','text':out['text'],'listed':out['listed'],'events':out['events']})
    # Buio: notte in un esterno, senza lampada posseduta.
    w=NativeWorld(a.project);w.teleport(5);w.m[0x9fe0]=10;w.m[0x9fe2]=ord('p');out=w.action(34);record('LOOK esterno notte senza luce',out);assert out['z']
    # Input originale: errori isolati e sequenza di movimento con stato persistente.
    app=[]
    for command in ('OPEN DOR','PICK THE NOTE UP','WEST','SAVE'):
        game=Game(a.project,data);before=game.state();res=game.command(command);after=res['state']
        assert before['clock']==after['clock'] and before['room']==after['room']
        app.append({'command':command,'room_before':before['room'],'room_after':after['room'],'clock_before':before['clock'],'clock_after':after['clock'],'messages':res['messages'],'outcome':after['analysis']['outcome']})
    game=Game(a.project,data)
    for command in ('OPEN YOUR DOOR','WEST','EAST','WEST','EAST','LOOK','WAIT','GO INTO HALL','GO THROUGH YOUR DOOR','LOOK. N'):
        before=game.state();res=game.command(command);after=res['state'];app.append({'command':command,'room_before':before['room'],'room_after':after['room'],'clock_before':before['clock'],'clock_after':after['clock'],'messages':res['messages'],'outcome':after['analysis']['outcome']})
    assert app[4]['room_after']==8 and app[5]['room_after']==7 and app[6]['room_after']==8
    assert app[11]['room_after']==7 and app[12]['room_after']==8
    old=game.world.clock();res=game.teleport(74);assert game.world.clock()==old and game.world.room==74
    ticks=game.world.clock();res=game.command('LOOK');assert game.world.clock()['tick']>ticks['tick']
    report={'room_slots':len(rooms),'directed_edges':len(edges),'destination_zero_edges':sum(e['target']==0 for e in edges),'room_scenes_verified':len(scenes),'perception_comparisons':checks,'native_cases':len(traces),'app_commands':len(app),'all_passed':True}
    for name,value in [('verification.json',report),('native-traces.json',traces),('visibility-traces.json',visibility),('scene-samples.json',scenes),('app-traces.json',app)]:
        (a.output/name).write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(report))
if __name__=='__main__':main()
