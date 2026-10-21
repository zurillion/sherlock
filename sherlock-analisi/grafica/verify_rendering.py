"""Regressioni del rasterizzatore e controllo PNG/SVG indipendente opzionale."""
from pathlib import Path
import argparse,hashlib,json
from PIL import Image,ImageChops,ImageFilter
from sherlock_graphics import (HERE,ROOT,Decoder,catalog,Exact,region_contours,
    rasterize_loops,straight_loops)


def reference_difference(actual,reference):
    actual=actual.convert('RGB');reference=reference.convert('RGB')
    assert actual.size==reference.size
    def maximum_channels(im):
        r,g,b=im.split();return ImageChops.lighter(ImageChops.lighter(r,g),b)
    diff=maximum_channels(ImageChops.difference(actual,reference))
    # Differenze di antialias entro 3 pixel dal bordo del rendering indipendente
    # sono ammesse. Una linea inventata in un'area piatta non lo e.
    boundary=maximum_channels(ImageChops.difference(reference.filter(ImageFilter.MaxFilter(7)),reference.filter(ImageFilter.MinFilter(7))))
    boundary=boundary.point(lambda v:255 if v else 0)
    significant=diff.point(lambda v:255 if v>8 else 0)
    unexpected=ImageChops.subtract(significant,boundary)
    return dict(pixels_different_over_8=significant.histogram()[255],
                pixels_different_away_from_edges=unexpected.histogram()[255],max_channel_difference=diff.getextrema()[1])


def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--reference-dir',type=Path,help='PNG prodotti indipendentemente dagli SVG (es. librsvg/sharp)')
    args=p.parse_args();rect=[(2,2),(14,2),(14,14),(2,14),(2,2)]
    # Un percorso percorso due volte si annulla in evenodd, indipendentemente
    # dall'orientamento. Prima il PNG lasciava un riempimento o un bordo spurio.
    for other in (rect,list(reversed(rect))):
        assert rasterize_loops([rect,other],4).getbbox() is None
    hole=[(5,5),(5,11),(11,11),(11,5),(5,5)]
    mask=rasterize_loops([rect,hole],4)
    assert mask.getpixel((3*4+2,3*4+2))==255
    assert mask.getpixel((7*4+2,7*4+2))==0
    # La regola evenodd deve essere indipendente dall'orientamento e dall'ordine.
    assert mask.tobytes()==rasterize_loops([list(reversed(hole)),list(reversed(rect))],4).tobytes()
    # Due regioni adiacenti non devono lasciare una cucitura sul bordo condiviso.
    a=[(2,2),(8,2),(8,14),(2,14),(2,2)]
    b=[(8,2),(14,2),(14,14),(8,14),(8,2)]
    assert rasterize_loops([a,b],4).tobytes()==rasterize_loops([rect],4).tobytes()
    d=Decoder.load(ROOT/'SHERLOCK.TAP');rows=catalog(d)
    prior=json.loads((HERE/'verification.json').read_text())
    hashes={r['location']:r['screen_sha256'] for r in prior['results']}
    report=dict(evenodd_regressions_passed=True,reference_renderer='librsvg via sharp' if args.reference_dir else None,images=[])
    for r in rows:
        e=Exact(d.mem).execute(r['commands'])
        assert hashlib.sha256(e.mem[0x4000:0x5B00]).hexdigest()==hashes[r['location']]
        cells=[(x,y) for y in range(176) for x in range(128,256) if e.get(x,y)]
        assert rasterize_loops(region_contours(cells),1).tobytes()==e.mask().tobytes()
        loops=straight_loops(e)
        assert all(len(p)>=4 and p[0]==p[-1] for p in loops)
        result=dict(location=r['location'],exact_screen_unchanged=True,native_contour_roundtrip=True,straight_contours=len(loops))
        if args.reference_dir:
            for mode in ('smooth','straight'):
                stem=f"{r['location']:03}-{r['name'].replace(' ','-')}-{mode}"
                with Image.open(HERE/'immagini'/f'{stem}.png') as actual, Image.open(args.reference_dir/f'{stem}-reference.png') as reference:
                    result[mode]=reference_difference(actual,reference)
                    assert result[mode]['pixels_different_away_from_edges']==0,(stem,result[mode])
        report['images'].append(result)
    # Segmento isolato 45 gradi: una sezione della penna deve restare unita,
    # anche quando i pixel originali si toccano soltanto agli angoli.
    e=Exact(d.mem).execute([dict(address=1,kind='move',x=140,y=100),dict(address=2,kind='line',direction=0,period=1,length=32)])
    mask=rasterize_loops(straight_loops(e),8)
    for k in range(8,32*8-8):
        assert mask.getpixel((12*8+4+k,75*8+4-k))==255
    report['isolated_diagonal_continuous']=True
    (HERE/'rendering-verification.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(dict(images=len(rows),exact_screen_hashes='unchanged',evenodd='passed',independent_comparisons=28 if args.reference_dir else 0)))

if __name__=='__main__':main()
