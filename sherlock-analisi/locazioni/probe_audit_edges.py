#!/usr/bin/env python3
"""Confronti mirati con lo Z80 indipendente: esclusioni e vista attraverso una porta."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True

def probe(project,output):
    project=Path(project).resolve();sys.path[:0]=[str(project/'sherlock-analisi/locazioni'),str(project/'sherlock-analisi/ai')]
    from explorer import Game
    from extract_locations import extract
    from trace_npc_ai import Probe
    data=extract(project);cases=[]
    def norm(text):return ' '.join(text.upper().replace('`','£').split())
    for command in ['EXAMINE ALL EXCEPT THE LAMP','OPEN ALL EXCEPT THE PLAIN DOOR']:
        g=Game(project,data);got=g.command(command)
        q=Probe(project,1);ref=q.command(command)
        up=' '.join(m['text'] for m in got['messages'] if m['kind']=='narrative');low=' '.join(m['text'] for m in got['messages'] if m['kind']=='error')
        row={'command':command,'native_upper':ref['upper'],'native_lower':ref['lower'],'web_upper':up,'web_lower':low,
             'native_stop':ref['stop'],'same_upper':norm(up)==norm(ref['upper']),'same_lower':norm(low)==norm(ref['lower'])}
        assert row['same_upper'] and row['same_lower'],row
        cases.append(row);print(command,'same native behaviour',flush=True)
    g=Game(project,data);g.teleport(69);g.command('OPEN DAPHNES DOOR');got=g.command('LOOK THROUGH DAPHNES DOOR')
    q=Probe(project,1);q.relocate(0,69);q.m[0xa011]=1;q.command('OPEN DAPHNES DOOR');ref=q.command('LOOK THROUGH DAPHNES DOOR')
    up=' '.join(m['text'] for m in got['messages'] if m['kind']=='narrative');low=' '.join(m['text'] for m in got['messages'] if m['kind']=='error')
    row={'command':'LOOK THROUGH DAPHNES DOOR','fixture':'Map/relocate Holmes and children to 69; OPEN DAPHNES DOOR; native graphics enabled',
         'native_upper':ref['upper'],'native_lower':ref['lower'],'web_upper':up,'web_lower':low,
         'native_stop':ref['stop'],'same_upper':norm(up)==norm(ref['upper']),'same_lower':norm(low)==norm(ref['lower'])}
    assert row['same_upper'] and row['same_lower'],row
    cases.append(row);print('LOOK THROUGH: same output with graphics enabled in original',flush=True)
    result={'passed':True,'scope':'Targeted comparisons of observed output; first two use snapshot clock 08:01 vs free web 08:00; remote view uses declared placement fixture. No complete playthrough is claimed.','cases':cases}
    output.parent.mkdir(parents=True,exist_ok=True);output.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    return result

if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results/gameplay-edge-comparisons.json');a=ap.parse_args();probe(a.project,a.output)
