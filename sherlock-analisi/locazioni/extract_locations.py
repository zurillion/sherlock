#!/usr/bin/env python3
"""Estrae record delle locazioni e archi, preservando ostacoli e destinazioni zero."""
import argparse,hashlib,json,re,sys
from pathlib import Path
from native_world import word
DIRECTIONS=['','N','S','E','W','NE','NW','SE','SW','UP','DOWN']
def extract(project):
    project=Path(project);sys.path.insert(0,str(project/'sherlock-analisi/decoder'))
    from sherlock_text import Decoder,Context
    payload=(project/'sherlock-analisi/block-10.bin').read_bytes();m=bytes(0x5d80)+payload
    decoder=Decoder.load(project/'sherlock-analisi/block-10.bin')
    entities=json.loads((project/'sherlock-analisi/entita/results/entities.json').read_text())['entities']
    coordsfile=project/'Foggy London/Foggy London Source/MapCoordinates.h'
    coords={int(a,16):[int(x),int(y)] for a,x,y in re.findall(r'\{0x([0-9A-Fa-f]+),\s*(\d+),\s*(\d+)\}',coordsfile.read_text())}
    rooms=decoder.locations();edges=[]
    for room in rooms:
        ident=room['id'];p=int(room['record'],16);q=p+9;room.update(flags=m[p],visited_initial=bool(m[p]&64),light_flag=bool(m[p]&128),relation_index=(m[p]&14)//2,coordinates=coords.get(ident),exits=[])
        while m[q]!=255:
            direction,gate,target=m[q:q+3]
            edge={'source':ident,'target':target,'direction_id':direction,'direction':DIRECTIONS[direction] if direction<len(DIRECTIONS) else f'code-{direction}','gate':gate,'gate_name':entities[gate]['name'] if gate else None,'address':f'{q:04X}','destination_zero':target==0}
            edges.append(edge);room['exits'].append(edge);q+=3
            if q-p>300:raise ValueError('Record senza terminatore')
        room['raw']=m[p:q+1].hex(' ');room['size']=q+1-p
        room['description_by_time']={str(t):decoder.render(int(room['description'],16),Context(subject=0,other=0,time_class=t))['text'] for t in range(1,6)} if room['description'] else {}
    return {'source_sha256':hashlib.sha256(payload).hexdigest(),'rooms':rooms,'edges':edges,'entities':entities,'coordinate_source':'Foggy London MapCoordinates.h; solo disposizione grafica, topologia dai byte originali'}
def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args();a.output.mkdir(parents=True,exist_ok=True)
    data=extract(a.project);(a.output/'locations.json').write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n');print(len(data['rooms']),'slot,',len(data['edges']),'archi')
if __name__=='__main__':main()
