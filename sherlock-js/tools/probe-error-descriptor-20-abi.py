"""Controlled ordinary rejection pipeline in a room without description TEXT."""
import sys,json,gzip,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
root=p/'sherlock-js/results/passage-descriptor-20/wide-abi';saved=json.loads(gzip.decompress((p/'sherlock-js/results/murder-ending/brown-native-prompt.json.gz').read_bytes()));data=json.loads((p/'sherlock-js/data/game.json').read_text());g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;dictionary={x['id']:x for x in data['dictionary']};words=sorted({dictionary[e['noun']&4095]['stem'].upper()for e in data['entities']if e['noun']&4095 in dictionary and dictionary[e['noun']&4095]['stem'].isalpha()});commands=['N','S','E','W','NE','NW','SE','SW','U','D']+[v+' '+word for word in words for v in ['EXAMINE','CLOSELY EXAMINE']];rows=[]
for command in commands:
 m[:]=saved['memory'];r[:]=saved['registers'];w.input_registers=saved['input_registers'][:];w.input_stack=saved['input_stack'][:];g.explored=set(saved['explored']);g.last_listed=saved['last_listed'][:];g.last_analysis=saved['last_analysis'];g.opening_pending=False;g.cached_state=None;g.command_job=None;g.job_id=None;w.ended=None;g.ending_messages=[];m[0xcc0b]=10;m[0x5d1a:0x5d28]=[165]*14;w.input_stack[0x1a:0x28]=[165]*14;glyphs=[]
 def observe(m,r,R):
  if r[R.PC]==0xc388 and m[0xa027]==1:glyphs.append(r[R.SP])
 w.observer=observe;out=g.command(command);text=' '.join(x.get('text','')for x in out['messages']).strip();eligible=text.startswith('I SEE NO ')or text.startswith('YOU CANNOT GO ');cells=m[0x5d1a:0x5d28];rows.append(dict(command=command,eligible=eligible,text=text,clock=w.clock(),cells=cells,lower_glyph_frames=sorted(set(glyphs))))
 if eligible:assert cells[:4]==[165]*4,(command,text,cells,w.clock())
(root/'simple-error-abi.json').write_text(json.dumps(dict(protocol='Controlled complete original commands from real Kitchen prompt11:36. Full RAM/register/input state restored per case, all actors retained. Player failure budget explicitly10 to isolate rejection;1A–27 markerA5 also placed in the editor stack copy. Ten directions and all alphabetic initial entity noun stems for EXAMINE/CLOSELY EXAMINE. Only ordinary direction/ISEENO rejections included; other outcomes recorded but not preservation proofs. Null room description, root player, simple unqualified reference. Not natural reachability of every input.',cases=rows),separators=(',',':'))+'\n');print(len(rows),sum(x['eligible']for x in rows))
