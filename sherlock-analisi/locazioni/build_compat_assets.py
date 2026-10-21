#!/usr/bin/env python3
"""Estrae caratteri ROM e striscia di Sherlock per il terminale web."""
import argparse,hashlib,json,base64
from pathlib import Path

def build(project,output):
 rom_path=project/'Foggy London/Foggy London Source/SPECTRUM.ROM'
 rom=rom_path.read_bytes();payload=(project/'sherlock-analisi/block-10.bin').read_bytes()
 assert len(rom)==16384
 assert hashlib.sha256(payload).hexdigest()=='c5d48285c0cee5c25cf4734dff0ac8296c0ec0194135e3a72267e49724ac8407','Payload diverso dalla versione analizzata'
 assets={'source':'Caratteri ROM Spectrum fornita con Foggy London; striscia dal payload Sherlock.','rom_sha256':hashlib.sha256(rom).hexdigest(),'payload_sha256':hashlib.sha256(payload).hexdigest(),'first':32,'glyphs':[list(rom[0x3c00+i*8:0x3c00+(i+1)*8]) for i in range(32,128)],'divider':list(payload[0xc190-0x5d80:0xc1a8-0x5d80])}
 assets['pixels']={int(f.name.split('-')[0]):'data:image/png;base64,'+base64.b64encode(f.read_bytes()).decode() for f in sorted((project/'sherlock-analisi/grafica/immagini').glob('[0-9][0-9][0-9]-*-exact.png'))}
 output.write_text(json.dumps(assets,separators=(',',':'))+'\n')
 root=output.parent
 bundle=(root/'spectrum.js').read_text()+'\nconst SPECTRUM_ASSETS='+json.dumps(assets,separators=(',',':'))+';\n'+(root/'explorer-ui.js').read_text()
 (root/'app.js').write_text(bundle);print(output);print(root/'app.js')
if __name__=='__main__':
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'spectrum-assets.json');a=ap.parse_args();build(a.project,a.output)
