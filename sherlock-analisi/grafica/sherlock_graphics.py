#!/usr/bin/env python3
"""Decodifica la grafica Sherlock v2.0; Python nativo, nessuna CPU emulata.

Il motore Exact traduce F3C2/F490/F56E/F5D2. Il renderer smooth ridisegna
contorni vettoriali alla risoluzione richiesta: e una reinterpretazione,
non una pretesa ricostruzione di dettagli assenti nei dati originali.
La variante straight rettifica i bordi usando le primitive LINE originali.
"""
from __future__ import annotations
import argparse
import json
from pathlib import Path
import sys

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
sys.path.insert(0,str(HERE.parent/'decoder'))
from sherlock_text import Decoder, number
WIDTH, HEIGHT = 128, 176
PALETTE=[(0,0,0),(0,0,205),(205,0,0),(205,0,205),(0,205,0),(0,205,205),(205,205,0),(205,205,205)]


def catalog(decoder):
    names={r['id']:r['name_hint'] for r in decoder.locations()}
    p=decoder.word16(0xA0D8);rows=[]
    while decoder.mem[p]!=255:
        loc=decoder.mem[p];start=decoder.word16(p+1)
        commands=decode(decoder.mem,start)
        rows.append(dict(location=loc,name=names.get(loc,''),table_address=p,
                         start=start,end=commands[-1]['end'],commands=commands))
        p+=3
        if len(rows)>106:raise ValueError('Tabella grafica senza terminatore')
    return rows


def decode(mem,start):
    """I campi address/end sono indirizzi CPU; end e esclusivo (anche 65536)."""
    p=start;out=[]
    def take():
        nonlocal p
        if p>=65536:raise ValueError('Stream grafico non terminato')
        value=mem[p];p+=1;return value
    while True:
        a=p;op=take();c=dict(address=a,opcode=op)
        if op==0:c['kind']='end'
        elif op==8:c.update(kind='move',x=take()|128,y=take())
        elif op&128:
            q=take();c.update(kind='line',direction=op&7,
                            period=1+((op>>1)&60)+(q>>6),length=1+(q&63))
        elif op&64:c.update(kind='fill',colour=op&7,x=take()|128,y=take())
        elif op&32:
            hi=take();lo=take();runs=[]
            while (q:=take())!=255:
                runs.append(dict(byte=q,direction=q&3,length=1+(q>>2)))
            c.update(kind='paper',colour=op&7,attribute_address=(hi<<8)|((lo+16)&255),runs=runs)
        else:c['kind']='ignored'
        c.update(end=p,raw=bytes(mem[a:p]).hex(' '));out.append(c)
        if op==0:return out


def bitmap_address(x,y):
    # $22AA: B=y, C=x, origine BASIC in basso a sinistra (y=175 in alto).
    row=175-y
    return 0x4000|((row&192)<<5)|((row&7)<<8)|((row&56)<<2)|(x>>3)


def attribute_address(x,y):return 0x5800+((175-y)//8)*32+x//8

def rotate3(a):return ((a<<3)|(a>>5))&255

def unrotate3(a):return ((a>>3)|(a<<5))&255


class Exact:
    """Stesso bitmap e stessi attributi dell'interprete originale.

    Lo schermo iniziale e bianco, INK nero, BRIGHT/FLASH spenti. Si puo
    passare una memoria iniziale per verifiche indipendenti con lo Z80.
    """
    def __init__(self,mem,clear=True):
        self.mem=bytearray(mem)
        if clear:
            self.mem[0x4000:0x5800]=bytes(6144)
            self.mem[0x5800:0x5B00]=bytes([0x38])*768
        self.ink=self.mem[0xF60B]
        self.cursor=(127,63)
        self.traces=[]
        self.touched=[]

    def get(self,x,y):return bool(self.mem[bitmap_address(x,y)]&(128>>(x&7)))

    def plot(self,x,y):
        attr=attribute_address(x,y);paper=self.mem[attr]&56
        ink=rotate3(self.ink)
        if ink==paper:ink^=56
        self.mem[attr]=unrotate3(ink)|paper
        self.mem[bitmap_address(x,y)]|=128>>(x&7)
        self.touched.append((x,y))

    @staticmethod
    def move(x,y,axis,delta):
        nx,ny=(x+delta,y) if axis==0 else (x,y+delta)
        return (nx,ny,True) if 128<=nx<=255 and 0<=ny<=175 else (x,y,False)

    def line(self,c):
        x,y=self.cursor;points=[];d=c['direction'];major=d&1
        signs=(-1 if d&4 else 1,-1 if d&2 else 1);counter=c['period']
        for _ in range(c['length']):
            points.append((x,y));self.plot(x,y)
            x,y,ok=self.move(x,y,major,signs[major])
            if not ok:break
            counter-=1
            if counter==0:
                x,y,ok=self.move(x,y,1-major,signs[1-major])
                if not ok:break
                counter=c['period']
        self.cursor=(x,y)
        return points

    def fill(self,x,y,colour):
        # Scanline + stack LIFO. Anche i bordi gia accesi vengono ripassati:
        # non cambia il bit, ma cambia INK nella cella 8x8.
        self.ink=colour;stack=[(x,y)];steps=0
        while stack:
            x,y=stack.pop()
            while not self.get(x,y):
                if x==128:break
                x-=1
            else:
                self.plot(x,y);x=min(255,x+1)
            above=below=False
            while True:
                if y<175 and not self.get(x,y+1):
                    if not above:stack.append((x,y+1))
                    above=True
                else:above=False
                if y>0 and not self.get(x,y-1):
                    if not below:stack.append((x,y-1))
                    below=True
                else:below=False
                self.plot(x,y);steps+=1
                if steps>2000000:raise ValueError('Fill non terminante')
                if x==255:break
                x+=1
                if self.get(x,y):self.plot(x,y);break
        self.ink=0

    def paper(self,c):
        a=c['attribute_address'];paper=c['colour']<<3
        for run in c['runs']:
            for _ in range(run['length']):
                ink=(self.mem[a]&7)<<3
                if ink==paper:ink^=56
                self.mem[a]=(ink>>3)|paper
                delta=(-32,1,32,-1)[run['direction']];candidate=a+delta
                # F514/F525/F536/F540 controllano solo la pagina alta.
                limit=0x57 if delta<0 else 0x5A
                if candidate>>8!=limit:a=candidate

    def execute(self,commands):
        for c in commands:
            self.touched=[];kind=c['kind'];trace=dict(address=c['address'],kind=kind)
            if kind=='move':self.cursor=(c['x'],c['y'])
            elif kind=='line':trace['points']=self.line(c)
            elif kind=='fill':
                trace['seed_was_set']=self.get(c['x'],c['y'])
                self.fill(c['x'],c['y'],c['colour'])
                trace['touched']=self.touched[:]
            elif kind=='paper':self.paper(c)
            trace['cursor']=self.cursor;self.traces.append(trace)
        self.mem[0xF60B]=self.ink
        return self

    def mask(self):
        from PIL import Image
        im=Image.new('L',(WIDTH,HEIGHT));im.putdata([
            255 if self.get(x+128,175-y) else 0 for y in range(HEIGHT) for x in range(WIDTH)])
        return im

    def colour_image(self,mask,scale):
        from PIL import Image
        ink=Image.new('RGB',(16,22));paper=Image.new('RGB',(16,22));inks=[];papers=[]
        for y in range(22):
            for x in range(16):
                a=self.mem[0x5800+y*32+x+16]
                palette=PALETTE if not a&64 else [(255 if r else 0,255 if g else 0,255 if b else 0) for r,g,b in PALETTE]
                inks.append(palette[a&7]);papers.append(palette[(a>>3)&7])
        ink.putdata(inks);paper.putdata(papers)
        size=(WIDTH*scale,HEIGHT*scale)
        return Image.composite(ink.resize(size,Image.Resampling.NEAREST),paper.resize(size,Image.Resampling.NEAREST),mask)


def region_contours(points):
    """Contorni orientati della regione visitata dal fill; coordinate locali top-down.

    Segue i bordi fra pixel accesi/spenti, mantenendo separate le componenti
    che si toccano solo in un vertice. I buchi hanno orientamento opposto.
    """
    cells={(x-128,175-y) for x,y in points};edges={}
    def edge(a,b):edges.setdefault(a,set()).add(b)
    for x,y in cells:
        if (x,y-1) not in cells:edge((x,y),(x+1,y))
        if (x+1,y) not in cells:edge((x+1,y),(x+1,y+1))
        if (x,y+1) not in cells:edge((x+1,y+1),(x,y+1))
        if (x-1,y) not in cells:edge((x,y+1),(x,y))
    dirs={(1,0):0,(0,1):1,(-1,0):2,(0,-1):3};loops=[]
    while edges:
        start=min(edges);a=start;b=min(edges[a]);path=[a]
        while True:
            edges[a].remove(b)
            if not edges[a]:del edges[a]
            path.append(b)
            if b==start:break
            direction=dirs[(b[0]-a[0],b[1]-a[1])]
            candidates=edges[b]
            rank={1:0,0:1,3:2,2:3}
            following=min(candidates,key=lambda c:rank[(dirs[(c[0]-b[0],c[1]-b[1])]-direction)%4])
            a,b=b,following
        loops.append(path)
    return loops


def simplify_open(points,epsilon):
    if len(points)<3:return points
    a,b=points[0],points[-1];dx=b[0]-a[0];dy=b[1]-a[1];den=dx*dx+dy*dy
    def distance(p):
        u=max(0,min(1,((p[0]-a[0])*dx+(p[1]-a[1])*dy)/den)) if den else 0
        return (p[0]-a[0]-u*dx)**2+(p[1]-a[1]-u*dy)**2
    i=max(range(1,len(points)-1),key=lambda i:distance(points[i]))
    if distance(points[i])<=epsilon*epsilon:return [a,b]
    return simplify_open(points[:i+1],epsilon)[:-1]+simplify_open(points[i:],epsilon)


def simplify_loop(points,epsilon=0.85):
    k=max(range(1,len(points)-1),key=lambda i:(points[i][0]-points[0][0])**2+(points[i][1]-points[0][1])**2)
    result=simplify_open(points[:k+1],epsilon)[:-1]+simplify_open(points[k:],epsilon)
    return result if len(set(result))>=3 else points


def vector_loops(exact,epsilon=0.85):
    cells=[(x,y) for y in range(HEIGHT) for x in range(128,256) if exact.get(x,y)]
    return [simplify_loop(loop,epsilon) for loop in region_contours(cells)]


def polygon_area(p):return sum(a[0]*b[1]-b[0]*a[1] for a,b in zip(p,p[1:]))


def rasterize_loops(loops,scale):
    """Regola pari/dispari identica al clip SVG; campiona i centri dei pixel.

    Non sovrappone poligoni bianchi/neri: i bordi inclusivi di ImageDraw
    lasciavano sottili righe spurie tra contorni coincidenti e buchi.
    """
    from math import ceil
    from PIL import Image
    width,height=WIDTH*scale,HEIGHT*scale
    crossings=[[] for _ in range(height)]
    for loop in loops:
        for (x0,y0),(x1,y1) in zip(loop,loop[1:]):
            if y0==y1:continue
            if y0>y1:x0,y0,x1,y1=x1,y1,x0,y0
            first=max(0,ceil(y0*scale-0.5));last=min(height,ceil(y1*scale-0.5))
            slope=(x1-x0)/(y1-y0)
            for row in range(first,last):
                crossings[row].append((x0+((row+0.5)/scale-y0)*slope)*scale)
    data=bytearray(width*height)
    for row,xs in enumerate(crossings):
        xs.sort()
        if len(xs)%2:raise ValueError('Contorno aperto nella rasterizzazione')
        for left,right in zip(xs[::2],xs[1::2]):
            a=max(0,min(width,ceil(left-0.5)));b=max(0,min(width,ceil(right-0.5)))
            if b>a:data[row*width+a:row*width+b]=bytes([255])*(b-a)
    return Image.frombytes('L',(width,height),bytes(data))


def straight_loops(exact):
    """Rettifica i bordi usando le primitive LINE, mantenendo i contorni del fill.

    Ogni pixel tracciato e associato al comando che lo ha generato. I bordi
    appartenenti allo stesso segmento vengono proiettati sui lati della
    sua penna geometrica larga 1. I vertici sono intersezioni fra questi
    lati; giunti e capi molto piccoli restano limitati entro 2 pixel.
    """
    import math
    owners={};segments={}
    for t in exact.traces:
        if t['kind']!='line':continue
        pts=t['points'];a=pts[0];b=pts[-1]
        start=(a[0]-127.5,175.5-a[1]);end=(b[0]-127.5,175.5-b[1])
        dx=end[0]-start[0];dy=end[1]-start[1];length=math.hypot(dx,dy)
        if not length:continue
        key=t['address'];segments[key]=(start,end,dx/length,dy/length,length)
        for x,y in pts:owners.setdefault((x-128,175-y),[]).append(key)
    cells=[(x,y) for y in range(HEIGHT) for x in range(128,256) if exact.get(x,y)]
    result=[]
    for loop in region_contours(cells):
        groups=[]
        for a,b in zip(loop,loop[1:]):
            dx=b[0]-a[0];dy=b[1]-a[1];mx=(a[0]+b[0])/2;my=(a[1]+b[1])/2
            pixel=(math.floor(mx-dy/2),math.floor(my+dx/2));out=(dy,-dx)
            choices=owners.get(pixel,[])
            if choices:
                # A incroci e giunti scegli il segmento che passa piu vicino
                # al centro del pixel. Il tie-break per indirizzo e stabile.
                px,py=pixel[0]+0.5,pixel[1]+0.5
                def distance(key):
                    start,end,ux,uy,length=segments[key]
                    q=max(0,min(length,(px-start[0])*ux+(py-start[1])*uy))
                    return ((px-start[0]-q*ux)**2+(py-start[1]-q*uy)**2,key)
                key=min(choices,key=distance);start,end,ux,uy,length=segments[key]
                along=(mx-start[0])*ux+(my-start[1])*uy;facing=out[0]*ux+out[1]*uy
                if along<=0.01 and facing<-0.5:
                    normal=(-ux,-uy);offset=normal[0]*start[0]+normal[1]*start[1]+0.5;side='start'
                elif along>=length-0.01 and facing>0.5:
                    normal=(ux,uy);offset=normal[0]*end[0]+normal[1]*end[1]+0.5;side='end'
                else:
                    sign=1 if (-uy*out[0]+ux*out[1])>=0 else -1
                    normal=(-uy*sign,ux*sign);offset=normal[0]*start[0]+normal[1]*start[1]+0.5;side=sign
                group_key=(key,side)
            else:
                normal=out;offset=normal[0]*mx+normal[1]*my;group_key=('edge',normal,offset)
            item=dict(key=group_key,n=normal,k=offset,start=a,end=b)
            if groups and groups[-1]['key']==group_key:groups[-1]['end']=b
            else:groups.append(item)
        if len(groups)>1 and groups[0]['key']==groups[-1]['key']:
            groups[0]['start']=groups[-1]['start'];groups.pop()
        points=[]
        for i,current in enumerate(groups):
            prev=groups[i-1];vertex=current['start'];a,b=prev['n'];c,d=current['n'];det=a*d-b*c
            if abs(det)>1e-9:
                p=((prev['k']*d-b*current['k'])/det,(a*current['k']-prev['k']*c)/det)
                if math.hypot(p[0]-vertex[0],p[1]-vertex[1])<=2:
                    points.append(p);continue
            for g in (prev,current):
                nx,ny=g['n'];distance=g['k']-nx*vertex[0]-ny*vertex[1]
                points.append((vertex[0]+nx*distance,vertex[1]+ny*distance))
        clean=[]
        for p in points:
            if not clean or math.dist(clean[-1],p)>1e-8:clean.append(p)
        if len(clean)<3:result.append(loop);continue
        if math.dist(clean[-1],clean[0])>1e-8:clean.append(clean[0])
        result.append(clean)
    return result


def svg(exact,loops,scale=8,height=176,mode="smooth"):
    """SVG realmente vettoriale: contorni e celle colore, nessuna immagine incorporata."""
    fmt=lambda v: f'{v:.6f}'.rstrip('0').rstrip('.') if v else '0'
    path=' '.join('M'+' L'.join(f'{fmt(x)},{fmt(y)}' for x,y in p[:-1])+' Z' for p in loops)
    description=('Lati rettilinei ricavati dalle primitive LINE; regioni e colori del motore originale.' if mode=='straight' else 'Fill risolto sulla griglia originale; contorni semplificati entro 0.85 pixel. Colori Spectrum per celle 8x8.')
    parts=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{128*scale}" height="{height*scale}" viewBox="0 0 128 {height}">',
        '<title>Sherlock: contorni ricostruiti dalle istruzioni grafiche</title>',
        f'<desc>{description}</desc>',
        f'<defs><clipPath id="ink"><path d="{path}" clip-rule="evenodd"/></clipPath></defs>']
    for layer in ('paper','ink'):
        parts.append('<g'+(' clip-path="url(#ink)"' if layer=='ink' else '')+'>')
        colours={}
        for y in range((height+7)//8):
            for x in range(16):
                a=exact.mem[0x5800+y*32+x+16];colour=(a&7) if layer=='ink' else ((a>>3)&7)
                rgb=PALETTE[colour]
                if a&64:rgb=tuple(255 if v else 0 for v in rgb)
                colours.setdefault(rgb,set()).add((x,y))
        # Unisce le celle adiacenti: niente bordi antialiasati fra tasselli
        # dello stesso colore. Il clip vettoriale delle linee resta indipendente.
        for rgb,cells in colours.items():
            contours=region_contours([(128+x,175-y) for x,y in cells])
            d=' '.join('M'+' L'.join(f'{x*8},{y*8}' for x,y in loop[:-1])+' Z' for loop in contours)
            fill='#'+''.join(f'{v:02x}' for v in rgb)
            parts.append(f'<path fill="{fill}" shape-rendering="crispEdges" d="{d}"/>')
        parts.append('</g>')
    return '\n'.join(parts+['</svg>'])+'\n'


def render(row,mem,scale=8,mode='smooth',height=176):
    from PIL import Image
    exact=Exact(mem).execute(row['commands'])
    if mode=='exact':
        im=exact.colour_image(exact.mask(),1).crop((0,0,128,height))
        return im.resize((128*scale,height*scale),Image.Resampling.NEAREST),[]
    # Antialias prodotto ridisegnando a una risoluzione doppia, non ingrandendo bitmap.
    factor=scale*2
    loops=straight_loops(exact) if mode=='straight' else vector_loops(exact)
    mask=rasterize_loops(loops,factor)
    im=exact.colour_image(mask,factor).crop((0,0,128*factor,height*factor))
    return im.resize((128*scale,height*scale),Image.Resampling.LANCZOS),[]


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--source',type=Path,default=ROOT/'SHERLOCK.TAP')
    p.add_argument('--list',action='store_true',help='Elenca le 14 locazioni illustrate')
    p.add_argument('--location',type=number,help='ID numerico della locazione')
    p.add_argument('--scale',type=int,default=8,help='Fattore di risoluzione: 8 => 1024x1408')
    p.add_argument('--mode',choices=('smooth','straight','exact'),default='smooth')
    p.add_argument('--crop-picture',action='store_true',help='Ritaglia il riquadro superiore 128x128; omette anche 6 pixel marginali in due locazioni')
    p.add_argument('-o','--output',type=Path,help='Directory di destinazione')
    args=p.parse_args()
    if not 1<=args.scale<=32:p.error('--scale deve essere compreso tra 1 e 32')
    d=Decoder.load(args.source);rows=catalog(d)
    if args.list:
        for r in rows:print(f"{r['location']:3}  ${r['start']:04X}  {r['end']-r['start']:3} byte  {r['name']}")
        return
    if args.location is not None:
        rows=[r for r in rows if r['location']==args.location]
        if not rows:p.error('Questa locazione non ha un’immagine nella tabella')
    out=args.output or HERE/'immagini';out.mkdir(parents=True,exist_ok=True)
    results=[]
    for r in rows:
        im,notes=render(r,d.mem,args.scale,args.mode,128 if args.crop_picture else 176)
        filename=f"{r['location']:03}-{r['name'].replace(' ','-')}-{args.mode}.png"
        im.save(out/filename)
        if args.mode!='exact':
            exact=Exact(d.mem).execute(r['commands'])
            (out/filename.replace('.png','.svg')).write_text(svg(exact,straight_loops(exact) if args.mode=='straight' else vector_loops(exact),args.scale,128 if args.crop_picture else 176,args.mode))
        results.append(dict(location=r['location'],name=r['name'],file=filename,size=im.size,notes=notes))
        print(f"{r['location']:3} {r['name']}: {im.width}x{im.height} -> {out/filename}")
    (out/f'manifest-{args.mode}.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n')
    (out/'instructions.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')

if __name__=='__main__':main()
