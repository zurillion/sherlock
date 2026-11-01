"""Natural raw-word provenance at5C13, including identical A9D7 stores."""
import sys,json,gzip,hashlib
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;root=p/'sherlock-js/results/murder-ending';restore=json.loads(gzip.decompress((root/'talk-native-prompt.json.gz').read_bytes()));assert restore['payload_sha256']==hashlib.sha256((p/'sherlock-analisi/block-10.bin').read_bytes()).hexdigest();m[:]=restore['memory'];w.sim.registers[:]=restore['registers'];w.input_registers=restore['input_registers'];w.input_stack=restore['input_stack'];g.explored=set(restore['explored']);g.last_listed=restore['last_listed'];g.last_analysis=restore['last_analysis'];g.opening_pending=False;g.cached_state=None
commands=(root/'to-brown-clues.txt').read_text().splitlines()+['WAIT UNTIL 11PM'];writer=None;pending=None;found=None;old=None;previous=None;unclassified=[];stores=[]
def observe(m,r,R):
 global writer,pending,found,old,previous
 pc=r[R.PC];written=False
 if pending:
  writer={**pending,'value':m[0x5c13],'raw_word':m[0x5c0b:0x5c14]};stores.append(writer);pending=None;written=True
 if old is not None and m[0x5c13]!=old and not written:unclassified.append(dict(pc=previous,before=old,after=m[0x5c13],clock=w.clock()))
 old=m[0x5c13]
 if pc==0xa9d7 and r[R.H]*256+r[R.L]==0x5c13:pending=dict(pc='A9D7',clock=w.clock(),actor=m[0xa036],character=r[R.A],dictionary_ref=m[0xa022]+256*m[0xa023],visible=m[0x5c3c],channel=m[0xa027])
 if found is None and pc in(0xd2cb,0xd2d0)and(r[R.IXh]*256+r[R.IXl]+int(pc==0xd2d0))&65535==0x5c13:
  found=dict(clock=w.clock(),actor=m[0xa036],value=m[0x5c13],last_store=writer,buffer=m[0x5c0b:0x5c2b]);print('READ',found,flush=True)
 previous=f'{pc:04X}'
for i,c in enumerate(commands):
 if i==20:w.observer=observe
 out=g.start_command(c)if c.startswith('WAIT UNTIL')else g.command(c)
 while out.get('running')and found is None:out=g.continue_command(out['job'])
 if found is not None:break
assert found is not None
(p/'sherlock-js/results/word-buffer-13/natural-writer.json').write_text(json.dumps(dict(protocol='Resume complete unmodified original Jones-confession prompt; replay ordinary DROP and cab commands. Observer enabled from command20 (south into Tricias Lounge). Earlier play and full prompt restore are unmodified; no claim for writers outside this observation window. Track every identical or changing A9D7 store; unrelated transitions stay explicit. Research only, no native state is imported into JS.',read=found,stores=stores,unclassified_transitions=unclassified),indent=2)+'\n')
