#!/usr/bin/env python3
"""Audit non distruttivo del prototipo: partite isolate, nessuna modifica al server.

Distingue esclusioni del ponte, risposte del gioco e prove di sola raggiungibilita.
Le fixture via mappa e le letture del buffer originale sono dichiarate nei risultati.
"""
import argparse,hashlib,json,sys
from pathlib import Path
sys.dont_write_bytecode=True


def audit(project,output):
    project=Path(project).resolve();sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
    from explorer import Game
    from extract_locations import extract
    from native_world import word
    data=extract(project);rows=[];checks=[]
    def fresh():return Game(project,data)
    def execute(g,command,label=None):
        before=g.world.clock();res=g.command(command);a=res['state']['analysis'];messages=res['messages']
        row={'label':label or command,'input':command,'length':len(command),'outcome':a['outcome'],
             'clock_before':before,'clock_after':res['state']['clock'],'room':res['state']['room'],
             'continuation_slot':a.get('continuation_slot'),
             'player_actions':[e for e in a.get('actions',[]) if e['actor'] in (0,1,100)],
             'messages':[{k:v for k,v in m.items() if k!='screen_events'} for m in messages],
             'screen_pictures':[e['room'] for m in messages for e in m.get('screen_events',[]) if e['op']=='picture'],
             'normal_pictures':[m['image_room'] for m in messages if m.get('image_room') is not None],
             'buffer':None if a['outcome']=='tool_limit' else bytes(g.world.m[0x5b00:0x5b82]).split(b'\r')[0].decode('latin1'),
             'guard_pc':a.get('pc'),'game_over':res['state']['game_over']}
        rows.append(row);print(row['label'],row['outcome'],row['player_actions'],flush=True);return row
    for command in ['SAVE','LOAD','PAUSE','PRINT','NOPRINT','QUIT','KILL',
                    'ATTACK WATSON','DRIVE CAB','PICK THE NOTE UP','PICK UP THE NOTE',
                    'LOOK','L','INVENTORY','I','COUNT YOUR MONEY','CARRY LAMP','TAKE LAMP','GET LAMP',
                    'CLOSE YOUR DOOR','OPEN YOUR DOOR','LOCK YOUR DOOR','UNLOCK YOUR DOOR',
                    'CLIMB INTO YOUR ARMCHAIR','GET INTO YOUR ARMCHAIR','SIT IN YOUR ARMCHAIR',
                    'GET OUT OF YOUR ARMCHAIR','ENTER HALL','GO TO HALL','FOLLOW WATSON',
                    'COME WITH WATSON','HAIL CAB','HELLO','TALK TO WATSON',
                    'PAY 6D TO WATSON','QUICKLY COUNT THE MONEY','EXAMINE LAMP CLOSELY',
                    'EXAMINE ALL EXCEPT THE LAMP','OPEN ALL EXCEPT THE PLAIN DOOR',
                    'Z','LOOK'+' '*70,'I '*34]:
        execute(fresh(),command)
    for name,commands in [
        ('objects',['TAKE LAMP','PUT LAMP ON YOUR ARMCHAIR','TAKE LAMP FROM YOUR ARMCHAIR','DROP LAMP IN YOUR ARMCHAIR','TAKE LAMP OUT OF YOUR ARMCHAIR','GIVE LAMP TO WATSON']),
        ('conversation',['SAY TO WATSON "HELLO"','"TELL ME ABOUT LESTRADE"','"WATSON IS INNOCENT"','"BASIL KILLED MRS BROWN"']),
        ('continuation',['OPEN DOOR','YOUR','@']),
        ('repeat',['LOOK','@']),
        ('disguise',['OPEN PLAIN DOOR','NORTH','TAKE DISGUISE','CHINA','WEAR DISGUISE','CHINA','TAKE OFF DISGUISE']),
        ('view',['OPEN YOUR DOOR','LOOK THROUGH YOUR DOOR']),
        ('inspected continuation',['OPEN DOOR','YOUR'])]:
        g=fresh()
        for n,command in enumerate(commands):
            execute(g,command,name+': '+command)
            if name=='inspected continuation' and n==0:g.world.scene();g.state()
    g=fresh();g.teleport(69)
    execute(g,'OPEN DAPHNES DOOR','map fixture room 69: open')
    remote=execute(g,'LOOK THROUGH DAPHNES DOOR','map fixture room 69: look through to 74')
    g=fresh();g.teleport(5);g.command('LOOK');a=g.world.m[0xa019];before=g.world.m[:]
    g.world.scene();after=g.world.m[:]
    changes=[{'address':f'{i:04X}','before':x,'after':y} for i,(x,y) in enumerate(zip(before,after)) if x!=y]
    inspection={'scope':'Direct scene inspection, no input or tick. Register changes excluded.',
                'paging_before':a,'paging_after':g.world.m[0xa019],'memory_changes':changes}
    # Independent original execution: no 70-character API guard, no opcode patch.
    sys.path.insert(0,str(project/'sherlock-analisi/ai'))
    from trace_npc_ai import Probe
    q=Probe(project,1);long_line='LOOK'+' '*70;native=q.command(long_line)
    long_reference={'input_length':len(long_line),'stop':native['stop'],'upper':' '.join(native['upper'].split()),
                    'lower':' '.join(native['lower'].split()),'actions':[e for e in native['events'] if e['event']=='action' and e['actor']==0]}
    def check(name,ok):
        assert ok,name
        checks.append({'check':name,'passed':True})
    output.mkdir(parents=True,exist_ok=True)
    (output/'gameplay-audit-cases.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')
    by_input={r['input']:r for r in rows}
    check('Four service commands are deliberately blocked by the bridge',all(by_input[c]['outcome']=='tool_limit' for c in ['SAVE','PAUSE','PRINT','NOPRINT']))
    check('LOAD is incorrectly classified as QUIT and ends the web game',by_input['LOAD']['game_over']['reason']=='quit')
    check('QUIT already reaches the native terminal branch',by_input['QUIT']['game_over']['reason']=='quit')
    check('ATTACK and DRIVE are unknown to the supplied original dictionary, not missing Python handlers',all(by_input[c]['outcome']=='lexical_error' for c in ['ATTACK WATSON','DRIVE CAB']))
    check('A 74-character input is rejected by the web but executes LOOK in the original',
          by_input[long_line]['outcome']=='tool_limit' and native['stop']=='prompt' and any(e['action']==34 for e in long_reference['actions']))
    check('Long token sequences hit the bridge guard rather than a fabricated syntax error',by_input['I '*34]['outcome']=='tool_limit')
    # Index all models independently of how many successful examples this audit has.
    entities=json.loads((project/'sherlock-analisi/entita/results/entities.json').read_text())
    models=[{'id':int(k),'address':v['address'],'words':[w['stem'] if w else None for w in v['words']]} for k,v in entities['actions'].items()]
    result={'source_payload_sha256':hashlib.sha256((project/'sherlock-analisi/block-10.bin').read_bytes()).hexdigest(),
            'scope':'Reachability audit, not certification of a complete playthrough or all semantic branches. Full native scheduler; new Game per isolated case. Map fixtures explicitly labelled.',
            'passed':True,'checks':checks,'native_action_models':models,'cases':rows,
            'remote_view_probe':remote,'original_long_input_reference':long_reference,'inspection_probe':inspection}
    output.mkdir(parents=True,exist_ok=True)
    (output/'gameplay-audit.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    print('Audit complete:',len(rows),'commands,',len(models),'native models,',len(checks),'checks',flush=True)
    return result

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args();audit(a.project,a.output)
