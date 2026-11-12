"""Controlled passage routine D60B from two naturally reached entry frames."""
import sys,json,gzip
from pathlib import Path
sys.dont_write_bytecode=True;p=Path(__file__).resolve().parents[2];sys.path[:0]=[str(p/'sherlock-analisi/locazioni')]
from explorer import Game
from extract_locations import extract
ending = '--through-5d30' in sys.argv[1:]
wide = ending or '--through-5d29' in sys.argv[1:]
end = 0x5d31 if ending else 0x5d2a if wide else 0x5d28
marker = [165] * (end - 0x5d1a)
root = p / ('sherlock-js/results/brown-to-ending/wide-abi' if ending else
            'sherlock-js/results/passage-caller-c-22/wide-abi' if wide else
            'sherlock-js/results/passage-descriptor-20/wide-abi')
root.mkdir(parents=True, exist_ok=True)
g=Game(p,extract(p),seed=1,active_npcs=None);w=g.world;m=w.m;r=w.sim.registers;R=w.R;cases=[]
for mode in ['arrival','look']:
 saved=json.loads(gzip.decompress((p/'sherlock-js/results/list-stack-1c'/('entry-'+mode+'.json.gz')).read_bytes()));frame=saved['registers'][R.SP]
 for spacing in [0,1]:
  for kind in [0,1,2,3,8]:
   for column in range(36):
    m[:]=saved['memory'];r[:]=saved['registers'];ptr=m[0x8b70+50*3]+256*m[0x8b71+50*3];noun=(m[ptr+7]+256*m[ptr+8])&4095;value=noun|(kind<<12);m[ptr+7:ptr+9]=[value&255,value>>8]
    m[0xa024]=spacing;m[0xa025]=spacing;m[0xa026]=0;m[0xa027]=0;m[0x5c3c]=1;m[0xa2aa]=0;m[0xa019]=0;m[0xc128]=0;m[0xa9b5:0xa9b7]=[11,92];m[0x5d1a:end]=marker;x=2+7*column;at=0x5020+x//8;m[0xc1f8:0xc1fa]=[at&255,at>>8];m[0xc1fa]=x&7;m[0xc1f5]=36-column;entered=[];glyphs=[]
    def observe(m,r,R):
     if not entered:r[R.SP]=frame;m[frame:frame+2]=[8,0];entered.append(True)
     if r[R.PC]==0xc388:glyphs.append(dict(frame=r[R.SP],char=r[R.A],descriptor=r[R.D]*256+r[R.E],column_shift=r[R.C],caller_b=r[R.B]))
    w.observer=observe;out=w.call(0xd60b);cases.append(dict(mode=mode,spacing=spacing,frame=frame,column=column,noun=value,gate=50,text=out['text'],cells={str(a):m[a]for a in range(0x5d1a,end)},glyphs=glyphs))
(root/'passage-abi.json').write_text(json.dumps(dict(protocol='Controlled original D60B calls from real arrival/LOOK entry snapshots. A0270,A2AA0,empty word buffer,wide window,counter0,A024/A025consistent spacing0/1,A0260,36columns,four article classes plus proper noun flag; gate50 qualifier unchanged. Synthetic return0008,not natural reachability of all setups. Low cells markedA5 to distinguish ownership.',cases=cases),separators=(',',':'))+'\n');print(len(cases))
