"""Observe renderer ownership while riding: offline evidence, never runtime inputs."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;w.m[0xa011]=0
commands=['OPEN YOUR DOOR','WEST','DOWN','OPEN FRONT DOOR','SOUTH','HAIL CAB','GET INTO CAB','SAY TO CABBIE "GO TO KINGS CROSS ROAD"']+['WAIT']*3+['GET OUT OF CAB','PAY 1/- TO CABBIE']+['NORTHEAST']*4+['WAIT']*8+['GET INTO TRAIN','WAIT']
rows=[];stage='';previous=None;scope=[];last=None
target=next(at for at in range(0x9860,0x9920,8)if w.m[at]==43)+3
previous=w.m[target:target+3]
def observe(m,r,R):
 global previous,last
 if m[target:target+3]!=previous:
  previous=m[target:target+3]
  if word(m,0x9fdd)>=80:scope.append(dict(tick=word(m,0x9fdd),writer=f'{last:04X}',actor=m[0xa036],iy=f'{r[R.IYh]*256+r[R.IYl]:04X}',values=previous,working=list(m[0x9fd6:0x9fd9])))
 last=r[R.PC]
 if r[R.PC]==0xc388:
  buf=bytes(m[0x5c0b:0x5c20]).split(b'\0')[0].decode('latin1')
  if (stage=='WAIT' and w.room==3)or(stage=='NORTHEAST' and w.room==22):
   sp=r[R.SP];row=dict(room=w.room,word=buf,character=r[R.A],sp=f'{sp:04X}',glyph_address=f'{r[R.H]*256+r[R.L]:04X}',shift=r[R.C],remaining=r[R.B],stack=[f'{word(m,at):04X}'for at in range(sp,min(sp+88,0x5d80),2)])
   rows.append(row)
w.observer=observe
for command in commands:stage=command;g.command(command)
Path('results/transport/render-residue.json').write_text(json.dumps(rows,indent=2)+'\n')
Path('results/transport/train-scope.json').write_text(json.dumps(scope,indent=2)+'\n')
print('renderer observations',len(rows))
