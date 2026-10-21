#!/usr/bin/env python3
"""Prove dei comandi nel gioco completo, con scheduler originale e NPC attivi."""
import argparse,json,sys
from pathlib import Path
from native_world import word

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args()
    sys.path[:0]=[str(a.project/'sherlock-analisi/parser'),str(a.project/'sherlock-analisi/regole')]
    from sherlock_parser import SherlockParser
    from trace_rules import run
    e=SherlockParser(a.project);entities=json.loads((a.project/'sherlock-analisi/entita/results/entities.json').read_text())['entities'];out=[]
    def probe(cmd,state=None,label='prompt originale'):
        result,after=run(e,{'rules':[]},entities,cmd,state)
        m=after[0];room=m[word(m,0x8b70+3*m[0x9860])+15];p=word(m,0x840b+2*room)
        result.update(source=label,room_after=room,room_flags_after=m[p]);out.append(result)
        print(cmd,room,result['clock_after'],repr(result['upper'][-180:]),repr(result['lower'][-100:]),flush=True)
        return after
    state=None
    for cmd in ('LOOK','WEST','OPEN YOUR DOOR','WEST','EAST','WEST','EAST','LOOK'):state=probe(cmd,state,'sequenza continua dal primo prompt')
    for cmd in ('GO TO HALL','GO INTO HALL','GO THROUGH YOUR DOOR','LOOK THROUGH YOUR DOOR'):
        _,opened=run(e,{'rules':[]},entities,'OPEN YOUR DOOR')
        probe(cmd,opened,'dopo OPEN YOUR DOOR originale')
    a.output.mkdir(parents=True,exist_ok=True);(a.output/'full-game-traces.json').write_text(json.dumps(out,ensure_ascii=False,indent=2)+'\n')
if __name__=='__main__':main()
