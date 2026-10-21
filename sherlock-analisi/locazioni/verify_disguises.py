#!/usr/bin/env python3
"""Regression: player identity changes when wearing/removing either disguise."""
import argparse,json,sys
from pathlib import Path
from native_world import word

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args()
 sys.path[:0]=[str(a.project/'sherlock-analisi/parser'),str(a.project/'sherlock-analisi/entita'),str(a.project/'sherlock-analisi/regole')]
 from explorer import Game,perceived
 from extract_locations import extract
 from sherlock_parser import SherlockParser
 from trace_semantics import probe
 from trace_rules import fixture
 data=extract(a.project);traces=[];comparisons=0
 for label,identity,commands in [
  ('china continuation',1,['TAKE DISGUISE','CHINA','WEAR DISGUISE','CHINA','LOOK','INVENTORY','OPEN DOOR','SOUTH','TAKE OFF DISGUISE','LOOK']),
  ('old man',100,['TAKE OLD MANS DISGUISE','WEAR OLD MANS DISGUISE','LOOK','INVENTORY','OPEN DOOR','SOUTH','TAKE OFF DISGUISE','LOOK'])]:
  game=Game(a.project,data);game.teleport(9);e=SherlockParser(a.project);original=fixture(e,9);switched=False;restored=False
  for cmd in commands:
   ref,original=probe(e,cmd,original);out=game.command(cmd);state=out['state'];m=game.world.m
   expected_id=original[0][0x9860];expected_room=original[0][word(original[0],0x8b70+3*expected_id)+15]
   assert state['analysis']['outcome']!='tool_limit',(label,cmd,out['messages'])
   assert (state['player_id'],state['room'],state['clock']['tick'])==(expected_id,expected_room,word(original[0],0x9fdd)),(cmd,state['clock'],word(original[0],0x9fdd))
   if cmd=='CHINA' and expected_id==identity:switched=True
   if cmd.startswith('WEAR OLD'):switched=expected_id==identity
   if cmd.startswith('TAKE OFF'):restored=expected_id==0
   # Compare Python visibility against the original predicate under this identity.
   py=[i for i in range(110) if perceived(m,i)];native=game.world.visible();assert py==native,(label,cmd,py,native);comparisons+=110
   assert expected_id not in [v['id'] for v in state['visible']]
   traces.append({'case':label,'command':cmd,'messages':out['messages'],'player_id':state['player_id'],'room':state['room'],'tick':state['clock']['tick'],'reference_player_id':expected_id,'reference_room':expected_room,'reference_tick':word(original[0],0x9fdd),'reference_lower':ref['lower'],'reference_upper':ref['upper']})
  assert switched and restored,label
 # Teleport, state inspection and another command must also use the disguise identity.
 for name,identity in [('CHINA MANS',1),('OLD MANS',100)]:
  game=Game(a.project,data);game.teleport(9);game.command(f'TAKE {name} DISGUISE');game.command(f'WEAR {name} DISGUISE')
  before=game.world.clock();out=game.teleport(74);assert out['state']['player_id']==identity and out['state']['room']==74 and game.world.clock()==before
  money=word(game.world.m,0x8b70+3*27);assert game.world.m[money+1]==identity and game.world.m[money+15]==74
  out=game.command('LOOK');assert out['state']['analysis']['outcome']!='tool_limit' and out['state']['player_id']==identity and out['state']['room']==74
  assert all(v['id']!=identity for v in out['state']['visible'])
 a.output.mkdir(parents=True,exist_ok=True)
 (a.output/'disguise-traces.json').write_text(json.dumps(traces,ensure_ascii=False,indent=2)+'\n')
 report={'commands_compared_with_full_game':len(traces),'active_identities':[0,1,100],'visibility_comparisons':comparisons,'disguised_teleport_cases':2,'wear_and_take_off_complete':True,'all_passed':True}
 (a.output/'disguise-verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report))
if __name__=='__main__':main()
