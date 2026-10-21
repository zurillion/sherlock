#!/usr/bin/env python3
"""Regressioni: disambiguazione originale, continuazioni, messaggi e grafica SVG."""
import argparse,json,sys,xml.etree.ElementTree as ET
from pathlib import Path

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args()
 sys.path[:0]=[str(a.project/'sherlock-analisi/locazioni'),str(a.project/'sherlock-analisi/entita'),str(a.project/'sherlock-analisi/parser')]
 # Preferisce i moduli accanto a questo script, anche durante la preparazione.
 sys.path.insert(0,str(Path(__file__).resolve().parent))
 from explorer import Game
 from extract_locations import extract
 from trace_semantics import probe
 from sherlock_parser import SherlockParser
 data=extract(a.project);cases=[]
 for reply in ('YOUR','YOUR DOOR'):
  original=SherlockParser(a.project);question,state=probe(original,'OPEN DOOR');answer,state=probe(original,reply,state)
  g=Game(a.project,data);q=g.command('OPEN DOOR');r=g.command(reply)
  qtext='\n'.join(m['text'] for m in q['messages']);rtext='\n'.join(m['text'] for m in r['messages'])
  assert qtext=='WHICH DOOR ?' and q['state']['analysis']['continuation_slot']==8
  assert rtext=='You open your door.' and r['state']['analysis']['continuation_slot']==0
  assert 'WHICH DOOR ?' in question['lower'].upper() and 'You open your door.' in answer['upper']
  door=int(data['entities'][21]['record'],16);assert g.world.m[door+5]&32 and state[0][door+5]&32
  assert g.world.clock()['tick']==3 and g.world.room==8
  cases.append({'reply':reply,'prototype_question':qtext,'prototype_answer':rtext,'original_lower':question['lower'],'original_upper':answer['upper'],'tick':g.world.clock()['tick']})
 g=Game(a.project,data)
 commands=['OPEN DOOR','LOOK','GO TO HALL','WEST','OPEN YOUR DOOR','WEST','EAST','OPEN DOOR','PLAIN','NORTH','SOUTH','LOOK','OPEN DOR','PICK THE NOTE UP','TAKE LAMP','INVENTORY','WAIT']
 for command in commands:
  r=g.command(command);text='\n'.join(m['text'] for m in r['messages']);cases.append({'input':command,'output':text,'analysis':g.last_analysis,'room':g.world.room,'tick':g.world.clock()['tick']})
  assert not any('Quale passaggio' in m['text'] or 'Sintassi riconosciuta' in m['text'] or 'Spostamento' in m['text'] for m in r['messages'])
 by={x['input']:x for x in cases if 'input' in x}
 assert 'You are' in by['LOOK']['output'] or 'sun streams' in by['LOOK']['output']
 assert 'I SEE NO HALL THAT YOU CAN GO TO' in by['GO TO HALL']['output']
 assert 'I DO NOT KNOW THE WORD' in by['OPEN DOR']['output']
 assert 'WHAT ?' in by['PICK THE NOTE UP']['output']
 assert 'You take the oil lamp.' in by['TAKE LAMP']['output']
 # La mappa annulla una domanda in sospeso senza lasciare nodi pendenti.
 g=Game(a.project,data);g.command('OPEN DOOR');g.teleport(74);r=g.command('LOOK');assert g.world.m[0xa01b]==0 and g.world.room==74
 # Prima visita, ritorno e LOOK mantengono gli eventi delle immagini.
 def images(r):return [m['image_room'] for m in r['messages'] if m.get('image_room') is not None]
 g=Game(a.project,data);assert images(g.teleport(74))==[74];g.teleport(8);assert images(g.teleport(74))==[];assert images(g.command('LOOK'))==[74]
 # Verifica colore/struttura: le celle sono unite in <=16 regioni colore per SVG.
 svgdir=Path(__file__).resolve().parent/'svg'
 if not svgdir.exists():svgdir=a.project/'sherlock-analisi/grafica/immagini'
 svgs=list(svgdir.glob('*-straight.svg'))+list(svgdir.glob('*-smooth.svg'));assert len(svgs)==28
 for file in svgs:
  root=ET.fromstring(file.read_text());paths=root.findall('.//{http://www.w3.org/2000/svg}g/{http://www.w3.org/2000/svg}path');assert len(paths)<=16
  assert all(p.attrib.get('shape-rendering')=='crispEdges' for p in paths)
 a.output.mkdir(parents=True,exist_ok=True);(a.output/'refinement-traces.json').write_text(json.dumps(cases,ensure_ascii=False,indent=2)+'\n');report={'original_continuations_verified':2,'additional_commands':len(commands),'pending_cancel_on_map':True,'picture_events_preserved':True,'svg_files_without_individual_tiles':len(svgs),'all_passed':True};(a.output/'refinement-verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
if __name__=='__main__':main()
