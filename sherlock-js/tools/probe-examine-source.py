"""Controlled renderer diagnosis from a genuine saved offline oracle prompt."""
import sys,json
from pathlib import Path
sys.dont_write_bytecode=True
p=Path(__file__).resolve().parents[2];sys.path.insert(0,str(p/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word
saved=json.loads(Path('/private/tmp/lestrade-native-state.json').read_text())
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R
m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers=r[:];w.input_stack=m[0x5d00:0x5d80]
writes=[];previous=m[0x5d02];last=None;glyphs=[]
def observer(m,r,R):
 global previous,last
 pc=r[R.PC]
 if m[0x5d02]!=previous:
  previous=m[0x5d02];writes.append(dict(writer=f'{last:04X}'if last else None,value=previous,sp=r[R.SP],hl=r[R.H]*256+r[R.L],de=r[R.D]*256+r[R.E],word=bytes(m[0x5c0b:0x5c30]).decode('latin1')))
 if pc==0xc388:glyphs.append(dict(character=r[R.A],frame=r[R.SP],column=r[R.C],address=r[R.H]*256+r[R.L],word=bytes(m[0x5c0b:0x5c30]).decode('latin1')))
 last=pc
w.observer=observer;rows=[]
for room,command in [(79,'EXAMINE STREAM'),(88,'EXAMINE NOTE'),(8,'EXAMINE LAMP')]:
 g.teleport(room);writes.clear();glyphs.clear();before=list(m[0x5cee:0x5d08]);out=g.command(command)
 row=dict(room=room,command=command,messages=out['messages'],before=before,after=list(m[0x5cee:0x5d08]),writes=list(writes),glyphs=list(glyphs));rows.append(row)
 Path('results/lestrade/examine-source.json').write_text(json.dumps(rows,indent=2)+'\n');print(room,command,'5d02',m[0x5d02],'writes',writes[-5:],flush=True)
