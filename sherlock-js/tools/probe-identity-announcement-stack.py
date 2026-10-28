"""Natural source glyph frames for the identity-removal announcement."""
import sys,json
from pathlib import Path
p=Path(__file__).resolve().parents[2];sys.dont_write_bytecode=True;sys.path[:0]=[str(p/'sherlock-analisi/locazioni'),str(p/'sherlock-js/tools')]
from explorer import Game
from extract_locations import extract
from native_world import word
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;m[0xa011]=0;glyphs=[]
def obs(m,r,R):
 if r[R.PC]==0xc388:
  sp=r[R.SP];glyphs.append(dict(frame=sp,char=r[R.A],descriptor=r[R.D]*256+r[R.E],word=bytes(m[0x5c0b:0x5c38]).split(b'\0')[0].decode('latin1'),stack=[f'{word(m,a):04X}'for a in range(sp,0x5d80,2)]))
for c in (p/'sherlock-js/results/final-solution/major-witness.txt').read_text().splitlines():
 if not c or c.startswith('#'):continue
 if c=='TAKE OFF CHINA MANS DISGUISE':
  w.observer=obs;out=g.command(c);break
 if c.startswith('WAIT UNTIL'):
  out=g.start_command(c)
  while out['running']:out=g.continue_command(out['job'])
 else:out=g.command(c)
root=p/'sherlock-js/results/glyph-flags';root.mkdir(exist_ok=True);root.joinpath('identity-announcement.json').write_text(json.dumps(dict(protocol='Natural seed1 major-witness before its first TAKE OFF CHINA MANS DISGUISE; all actors, graphics off after boot, injected uppercase input and immediate MORE. Glyph entry registers and source return links, no world overlays.',command=c,clock=w.clock(),messages=out['messages'],glyphs=glyphs),separators=(',',':'))+'\n');print(c,w.clock(),len(glyphs))
