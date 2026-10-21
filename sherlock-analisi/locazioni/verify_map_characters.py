#!/usr/bin/env python3
"""Verifica orologio inglese e posizioni vive dei segnaposti dei personaggi."""
import argparse,json,sys
from pathlib import Path
from native_world import word

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args()
 from explorer import Game
 from extract_locations import extract
 g=Game(a.project,extract(a.project));clock_bytes=g.world.m[0x9fdf:0x9fe3];clocks=[]
 for day,label in enumerate(('Mon','Tue','Wed','Thu','Fri','Sat','Sun')):
  for hour,period in ((8,97),(12,112)):
   g.world.m[0x9fdf:0x9fe3]=[5,hour,day,period];s=g.world.clock();assert s['label']==f'{label} {hour:02d}:05'+('am' if period==97 else 'pm');clocks.append(s['label'])
 g.world.m[0x9fdf:0x9fe3]=clock_bytes
 def people():return {p['key']:p for p in g.state()['characters']}
 initial=people();assert initial['player']['rooms']==[8] and initial['3']['rooms']==[8]
 assert initial['2']['rooms']==[10] # dal prompt, non la posizione iniziale 11 del payload
 assert initial['3']['parent_id']==24
 assert initial['7']['rooms']==[] and initial['13']['rooms']==[]
 assert len({p['badge'] for p in initial.values()})==len(initial)
 g.command('OPEN YOUR DOOR');g.command('WEST');moved=people();assert moved['player']['rooms']==[7] and moved['3']['rooms']==[8]
 g.teleport(9);g.command('TAKE CHINA MANS DISGUISE');g.command('WEAR CHINA MANS DISGUISE');masked=people()
 assert masked['player']['id']==1 and masked['player']['badge']=='SH' and masked['player']['rooms']==[9]
 assert len([p for p in masked.values() if p['is_player']])==1 and not any(p['id'] in (0,100) for p in masked.values())
 g.teleport(74);assert people()['player']['rooms']==[74]
 # Fixture dichiarata: simula la variazione del campo posizione di un NPC.
 p=word(g.world.m,0x8b70+3*3);g.world.m[p+15]=67;assert people()['3']['rooms']==[67]
 report={'clock_labels':clocks,'logical_characters':len(initial),'initially_mapped':sum(bool(p['rooms']) for p in initial.values()),'player_movement_and_disguise_tracked':True,'watson_parent_preserved':True,'npc_room_change_reflected':True,'off_map_not_fabricated':True,'all_passed':True}
 a.output.mkdir(parents=True,exist_ok=True);(a.output/'map-characters-verification.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n');print(json.dumps(report))
if __name__=='__main__':main()
