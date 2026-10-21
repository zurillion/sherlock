#!/usr/bin/env python3
"""Confronta le regioni SVG unite con i tasselli degli SVG precedenti."""
import json,re,hashlib,argparse,xml.etree.ElementTree as ET
from pathlib import Path
ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--svg-dir',type=Path);args=ap.parse_args()
NEW=args.svg_dir or args.project/'sherlock-analisi/grafica/immagini';reference=json.loads((Path(__file__).resolve().parent/'results/svg-reference.json').read_text());NS={'s':'http://www.w3.org/2000/svg'}
def inside(x,y,d):
    crossings=0
    for sub in d.split(' Z'):
        pts=[tuple(map(float,v)) for v in re.findall(r'(-?[\d.]+),(-?[\d.]+)',sub)]
        if not pts:continue
        for (ax,ay),(bx,by) in zip(pts,pts[1:]+pts[:1]):
            if (ay>y)!=(by>y) and x<(bx-ax)*(y-ay)/(by-ay)+ax:crossings+=1
    return crossings%2==1
checks=0
for name,expected in reference.items():
    f=NEW/name;new=ET.fromstring(f.read_text())
    assert hashlib.sha256(new.find('.//s:clipPath/s:path',NS).get('d').encode()).hexdigest()==expected['ink_clip_sha256']
    for tiles,newg in zip(expected['layers'],new.findall('s:g',NS)):
        regions=newg.findall('s:path',NS)
        for x,y,fill in tiles:
            matches=[r.get('fill') for r in regions if inside(x+4,y+4,r.get('d'))]
            assert matches==[fill],(name,x,y,matches,fill)
            checks+=1
p=Path(__file__).resolve().parent/'results/svg-union-verification.json';p.parent.mkdir(exist_ok=True);p.write_text(json.dumps({'files':28,'attribute_cell_centres_compared':checks,'clip_paths_identical':True,'all_passed':True},indent=2)+'\n');print(checks,'centri celle verificati; contorni ink invariati.')
