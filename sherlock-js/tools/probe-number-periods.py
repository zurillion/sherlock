"""Offline lexer boundary fixtures for the numeric DB3D period consumer."""
import argparse,json,sys
from pathlib import Path
sys.dont_write_bytecode=True
ap=argparse.ArgumentParser();ap.add_argument('--project',type=Path,required=True);ap.add_argument('--output',type=Path,required=True);a=ap.parse_args()
sys.path.insert(0,str(a.project/'sherlock-analisi/parser'))
from sherlock_parser import SherlockParser
audit=SherlockParser(a.project).audit
cases=['6D. TO WATSON','6D... TO WATSON','6D.LOOK','6D. LOOK',
       '2S. TO WATSON','1/-. TO WATSON','0/6. TO WATSON',
       '`1. TO WATSON','`1...LOOK','9AM. LOOK','9PM.. TO WATSON',
       '9AM.LOOK','9:30. LOOK','9. LOOK','1/6,TO WATSON','6D."LOOK"']
a.output.write_text(json.dumps(dict(scope='One native numeric token and returned input cursor, explicit suffix and delimiter cases; not whole command execution.',cases=[audit.native_lookup(c) for c in cases]),indent=2)+'\n')
print(len(cases),'numeric delimiter cases')
