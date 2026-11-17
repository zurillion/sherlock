"""Record original video hashes and random reads through the first investigation in Leatherhead."""
import argparse
import hashlib
import json
import sys
from pathlib import Path
sys.dont_write_bytecode=True
root=Path(__file__).resolve().parents[1]
project=root.parent
sys.path.insert(0,str(project/'sherlock-analisi/locazioni'))
from explorer import Game
from extract_locations import extract
from native_world import word

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('output', type=Path)
parser.add_argument('--route', type=Path)
parser.add_argument('--seed', type=int, choices=range(256), default=1)
args = parser.parse_args()
if args.route:
    route = [line for line in args.route.read_text().splitlines() if line and not line.startswith('#')]
else:
    route = (root/'results/victory-route/victoria-full-route.txt').read_text().splitlines()[:80]
    route.insert(14, 'LOOK')
game = Game(project,extract(project),seed=args.seed,active_npcs=None)
world=game.world
assert world.m[0xA011]==1
pending=None
draws=[]
steps=[]
frames=[]
active_picture=None
def picture(m):
    bitmap=bytearray()
    for y in range(144):
        start=0x4000|((y&192)<<5)|((y&7)<<8)|((y&56)<<2)
        bitmap.extend(m[start:start+32])
    bitmap.extend(m[0x5800:0x5A40])
    return hashlib.sha256(bitmap).hexdigest()

def observe(m,r,R):
    global pending, active_picture
    pc=r[R.PC]
    if pc == 0xA277:
        active_picture = dict(room=r[R.A], entry=r[R.SP], minimum=r[R.SP])
    if active_picture is not None:
        active_picture['minimum'] = min(active_picture['minimum'], r[R.SP])
        if pc == 0xF3C2:
            active_picture['draw_entry'] = r[R.SP]
        elif pc == 0xA295:
            if 'draw_entry' in active_picture:
                frames.append(dict(command=command, **active_picture))
            active_picture = None
    if pc==0xD2AD:
        pending=dict(actor=m[0xA036],width=r[R.A],mixOffset=(r[R.D]<<8)|r[R.E],
                     seed=m[0xA037],cursor=word(m,0xA039),reads=[],
                     video=picture(m),counter=m[0xA019],narrow=m[0xC128])
    elif pending is not None and pc in (0xD2CB,0xD2D0):
        address=(((r[R.IXh]<<8)|r[R.IXl])+(pc==0xD2D0))&0xFFFF
        pending['reads'].append(dict(address=address,value=m[address]))
    elif pending is not None and pc==0xD2EC:
        v=r[R.A]
        pending.update(result=abs(v if v<128 else v-256),
                       next_seed=m[0xA037],next_cursor=word(m,0xA039))
        draws.append(pending)
        pending=None

world.observer=observe
def record(command, out):
    steps.append(dict(command=command, clock=world.clock(), room=world.room,
                      outcome=out.get('state', {}).get('analysis', {}).get('outcome'),
                      video=picture(world.m), counter=world.m[0xA019],
                      narrow=world.m[0xC128], draws=draws[:], ending=world.ended,
                      running=bool(out.get('running'))))
    draws.clear()

for command in route:
    if command.startswith('WAIT UNTIL'):
        out = game.start_command(command)
        record(command,out)
        while out['running']:
            out = game.continue_command(out['job'])
            record(None,out)
    else:
        out = game.command(command)
        record(command,out)
    print(command,world.clock()['label'],world.room,world.ended,flush=True)
    if world.ended or out['state']['analysis']['outcome']=='tool_limit':
        break

report = dict(protocol='Graphics enabled from boot, free initial LOOK and all 24 actors. Hash covers row-major upper pixels (144 x 32) then 18 x 32 attributes.', seed=args.seed, steps=steps, picture_frames=frames)
args.output.write_text(json.dumps(report,separators=(',',':'))+'\n')
