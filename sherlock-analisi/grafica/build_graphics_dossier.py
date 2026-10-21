"""Rigenera listing Z80, istruzioni decodificate, galleria e verifica contorni."""
from pathlib import Path
import sys,json,html
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[1]
sys.path.insert(0,str(HERE));sys.path.insert(0,str(ROOT/'skoolkit-10.1'));sys.dont_write_bytecode=True
from sherlock_graphics import Decoder,catalog,Exact,region_contours,rasterize_loops,vector_loops
from skoolkit.traceutils import disassemble
from skoolkit.z80 import Assembler
from PIL import Image,ImageDraw

COMMENTS={
0xA25D:'Cerca l’immagine della locazione A. Flag Z: grafica disabilitata, tabella assente o ID non trovato.',
0xA265:'Puntatore alla tabella di triple: inizialmente $F60C.',
0xA277:'Mostra l’immagine: salva registri, cerca locazione, prepara lo schermo, chiama interprete.',
0xA296:'Invia 18 carriage return tramite il canale testuale.',
0xC129:'Attiva il canale di testo stretto: 18 colonne.',
0xD34E:'Cerca A in una lista di record da 3 byte, terminatore ID=$FF. Ritorna IX al record.',
0xF3C2:'Interprete grafico. HL=stream. Salva IY/HL/DE/BC; IY diventa il puntatore corrente.',
0xF3CA:'Cursore iniziale D=127,E=63 (i disegni reali iniziano tutti con MOVE).',
0xF3D4:'Dispatch. Il byte zero termina senza incrementare IY.',
0xF3DD:'$08: MOVE assoluto; SET 7,D impone la meta destra dello schermo.',
0xF3EF:'Bit7: segmento di due byte. C=ottante; B=periodo; L=numero di pixel.',
0xF40E:'B=1+((opcode>>1)&$3C)+(argomento>>6). L=1+(argomento&$3F).',
0xF414:'Bit6 (e bit7=0): fill; bit0..2 colore INK; seguono x,y.',
0xF427:'Il fill non cambia il cursore dei segmenti: DE viene ripristinato.',
0xF42E:'Bit5 (bit7/6=0): cammino sulla memoria attributi. Altri opcode ignorati.',
0xF43C:'Indirizzo iniziale: byte alto diretto; al byte basso si somma $10 senza riporto.',
0xF449:'Ogni run attributi: FF termina; direzione=byte&3; lunghezza=1+(byte>>2).',
0xF45D:'Mantiene INK (oppure lo complementa se uguale al nuovo PAPER), azzera BRIGHT/FLASH.',
0xF488:'Uscita dell’interprete e ripristino registri.',
0xF490:'Fill scanline: scrive colore corrente, salva registri, inserisce sentinella y=$B0.',
0xF499:'Da un seed si cammina a sinistra finche si trova un bit acceso o il margine.',
0xF4A5:'Ripassa anche il pixel di bordo gia acceso, cambiandone l’attributo INK.',
0xF4AB:'Reset dei due flag: un seed per ciascuna corsa vuota sulle righe adiacenti.',
0xF4B1:'Controlla riga y+1; accoda sullo stack CPU il primo pixel di ogni corsa vuota.',
0xF4D0:'Stesso controllo per riga y-1.',
0xF4EF:'Accende il pixel e prosegue a destra.',
0xF4FC:'Ripassa anche il bordo destro.',
0xF4FF:'Estrae un altro seed; y=$B0 segnala fine del fill.',
0xF505:'Dopo ogni fill il colore corrente torna a zero (nero).',
0xF50D:'Test bitmap: Z se pixel spento. DE contiene x,y.',
0xF514:'Attributi: su, HL-=32. Rifiuta pagina alta $57.',
0xF525:'Attributi: giu, HL+=32. Rifiuta pagina alta $5A.',
0xF52E:'JR NZ $F532 entra nel SECONDO byte ($52=LD D,D) di SBC HL,DE. Voluto dal binario.',
0xF536:'Attributi: sinistra, HL-=1; blocca pagina $57.',
0xF540:'Attributi: destra, HL+=1; blocca pagina $5A.',
0xF54A:'Pixel: y++; limite 175. Ritorna Z se il movimento non avviene.',
0xF555:'Pixel: y--; limite zero.',
0xF55E:'Pixel: x++; limite 255.',
0xF565:'Pixel: x--; limite 128.',
0xF56E:'Segmento a gradini. C bit0=asse maggiore; bit1=y negativo; bit2=x negativo.',
0xF574:'Caso asse maggiore x: plot, passo x, ogni B passi anche passo y; ripeti L volte.',
0xF59A:'Ripristina B dal valore iniziale senza perdere il cursore DE.',
0xF5A2:'Caso asse maggiore y, simmetrico.',
0xF5D2:'Plot: set bit bitmap + imposta INK nella cella 8x8; conserva PAPER.',
0xF5EE:'Se INK==PAPER, usa INK complementare (colore XOR 7).',
0xF5FB:'Converte DE=x,y in HL=indirizzo bitmap e A=maschera del bit.',
0xF5FE:'ROM $22AA: usa B=y, C=x. Riga fisica dall’alto=175-y.',
}

def main():
 d=Decoder.load(ROOT/'SHERLOCK.TAP');m=d.mem;assembler=Assembler();count=0;size=0
 lines=['; Sherlock v2.0: routine grafiche. Ogni istruzione ri-assemblata e confrontata col TAP.',
        '; Estratti non contigui: ORG espliciti. $F48E/F48F e $F60B sono dati, non istruzioni.']
 for start,end in [(0xA25D,0xA2AA),(0xC129,0xC142),(0xD34E,0xD36A),(0xF3C2,0xF48E),(0xF490,0xF60B)]:
  lines.append(f'\n    ORG ${start:04X}');a=start
  while a<end:
   op,n=disassemble(m,a);raw=bytes(m[a:a+n]);assert bytes(assembler.assemble(op,a))==raw
   if a in COMMENTS:lines.extend(['',f'; {COMMENTS[a]}'])
   lines.append(f'    {op:<24} ; ${a:04X}  {raw.hex(" ").upper()}');a+=n;count+=1;size+=n
  assert a==end
 for a,n,label in [(0xA0D8,2,'Puntatore little-endian alla tabella immagini'),(0xF48E,2,'Flag scanline fill'),(0xF60B,1,'Colore corrente iniziale (valore originale $38)')]:
  lines.extend([f'\n; {label}',f'    ORG ${a:04X}','    DEFB '+','.join(f'${v:02X}' for v in m[a:a+n])])
 (HERE/'graphics.asm').write_text('\n'.join(lines)+'\n')
 (HERE/'listing-verification.json').write_text(json.dumps(dict(instructions=count,code_bytes_verified=size,match=True),indent=2)+'\n')
 rows=catalog(d);listing=[];reports=[];out=HERE/'immagini';out.mkdir(exist_ok=True)
 sheet=Image.new('RGB',(1100,7*306),'#eeeeee');draw=ImageDraw.Draw(sheet)
 cards=[]
 for i,r in enumerate(sorted(rows,key=lambda r:r['location'])):
  listing.append(f"\n=== {r['location']:03} {r['name']} | ${r['start']:04X}..${r['end']-1:04X} ===")
  for c in r['commands']:
   k=c['kind'];detail=''
   if k in ('move','fill'):detail=f"x={c['x']-128} (video {c['x']}), y={c['y']} (riga {175-c['y']})"
   if k=='fill':detail+=f", INK={c['colour']}"
   if k=='line':detail=f"direzione={c['direction']}, periodo={c['period']}, pixel={c['length']}"
   if k=='paper':detail=f"PAPER={c['colour']}, indirizzo=${c['attribute_address']:04X}, run="+' '.join(f"{v['direction']}:{v['length']}" for v in c['runs'])
   listing.append(f"${c['address']:04X}  {c['raw']:<34} {k.upper():<8} {detail}")
  e=Exact(d.mem).execute(r['commands'])
  (out/f"{r['location']:03}.scr").write_bytes(e.mem[0x4000:0x5B00])
  points=[(x,y) for y in range(176) for x in range(128,256) if e.get(x,y)]
  original_contours=region_contours(points);mask=rasterize_loops(original_contours,2)
  errors=sum((mask.getpixel((2*x+1,2*y+1))!=0)!=e.get(x+128,175-y) for y in range(176) for x in range(128))
  assert errors==0,(r['location'],errors)
  reports.append(dict(location=r['location'],original_contours=len(original_contours),exact_contour_roundtrip_errors=errors,
                      original_vertices=sum(len(p)-1 for p in original_contours),simplified_vertices=sum(len(p)-1 for p in vector_loops(e))))
  name=f"{r['location']:03}-{r['name'].replace(' ','-')}";x=(i%2)*550;y=(i//2)*306
  draw.text((x+10,y+8),f"{r['location']:03} - {r['name']}",fill='#111111')
  draw.text((x+10,y+26),'Originale (pixel)',fill='#444444');draw.text((x+285,y+26),'SVG con linee rette',fill='#444444')
  for j,mode in enumerate(('exact','straight')):
   im=Image.open(out/f'{name}-{mode}.png');im=im.crop((0,0,im.width,im.width)).resize((256,256),Image.Resampling.NEAREST if mode=='exact' else Image.Resampling.LANCZOS)
   sheet.paste(im,(x+10+j*275,y+45))
  label=html.escape(r['name']);cmds=len(r['commands'])
  cards.append(f'''<article><h2>{r['location']:03} · {label}</h2><p>${r['start']:04X} · {r['end']-r['start']} byte · {cmds} comandi</p><div class="pair"><figure><div class="crop"><img class="pixel" src="{name}-exact.png" alt="Originale {label}"></div><figcaption>Originale 128 × 176</figcaption></figure><figure><div class="crop"><img src="{name}-straight.png" alt="Linee rette {label}"></div><figcaption>Linee rette · 1024 × 1408</figcaption></figure></div><p><a href="{name}-straight.svg">SVG con linee rette</a> · <a href="{name}-straight.png">PNG con linee rette</a> · <a href="{name}-smooth.svg">SVG con contorni semplificati</a> · <a href="{name}-smooth.png">PNG con contorni semplificati</a> · <a href="{name}-exact.png">Originale completo</a></p></article>''')
 sheet.save(out/'confronto.png')
 (HERE/'instructions.txt').write_text('\n'.join(listing)+'\n')
 (HERE/'contour-verification.json').write_text(json.dumps(dict(method='Contorni prima della semplificazione: rasterizzazione 2x e confronto dei centri di tutti i 22528 pixel per locazione.',results=reports),indent=2)+'\n')
 page='''<!doctype html><html lang="it"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Sherlock — grafica ricostruita</title><style>body{margin:0;background:#101722;color:#edf1f6;font:16px system-ui}main{max-width:1300px;margin:auto;padding:36px 24px}h1{font-size:38px}p{line-height:1.6;color:#bdc8d7}a{color:#92ccff}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(470px,1fr));gap:24px}article{background:#1b2636;padding:22px;border-radius:12px}h2{margin:0;font-size:23px}.pair{display:flex;gap:16px}figure{margin:0;flex:1;min-width:0}img{width:100%;display:block}.pixel{image-rendering:pixelated}.crop{aspect-ratio:1;overflow:hidden;background:#ccc}figcaption{font-size:13px;margin-top:9px;color:#bdc8d7}button{padding:10px;border:0;border-radius:6px;background:#d8e9ff;cursor:pointer;margin-bottom:24px}.full .crop{aspect-ratio:128/176}@media(max-width:550px){.grid{display:block}article{margin-bottom:20px;padding:12px}main{padding:18px 10px}}</style><main><h1>Sherlock: dai byte alle immagini</h1><p>14 locazioni, 13 disegni distinti, 2.496 byte di istruzioni grafiche. La versione Python fedele coincide con bitmap e attributi dello Z80. La nuova versione con linee rette ricava la geometria dai segmenti del gioco e mantiene le regioni del fill e le celle colore dello Spectrum. È una reinterpretazione, non nuovi dettagli recuperati. La variante precedente a contorni semplificati resta disponibile nei link; i suoi PNG sono stati corretti per usare la stessa regola di riempimento degli SVG.</p><p>Le anteprime mostrano il riquadro superiore 128 × 128. I file completi mantengono l’area 128 × 176; due locazioni hanno pochi pixel anche sulla riga 128.</p><button onclick="document.body.classList.toggle('full');this.textContent=document.body.classList.contains('full')?'Mostra riquadro superiore':'Mostra area completa'">Mostra area completa</button><div class="grid">'''+''.join(cards)+'</div></main></html>'
 (out/'index.html').write_text(page)
 print(json.dumps(dict(listing_instructions=count,verified_bytes=size,contour_checks=len(reports),gallery=str(out/'index.html'))))

if __name__=='__main__':main()
