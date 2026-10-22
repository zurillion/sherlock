"""Presentation taps: word buffer and control writes, before Spectrum wrapping.

The browser replays A9B7/AA14/C2BA with its selected image mode. In particular
we never infer CRs from stripped prose or forward native soft wraps twice.
"""
from functools import lru_cache
from pathlib import Path
from types import SimpleNamespace


def word(m,p):return m[p]+256*m[p+1]


class ScreenStream:
    def __init__(self):self.events=[]

    def observe(self,m,r,R):
        pc=r[R.PC]
        if pc in (0xd71a,0xa29c):
            self.events.append({'op':'counter','value':r[R.A],'source':f'{pc:04X}'})
        elif pc==0xc129:
            self.events.append({'op':'narrow'})
        elif pc==0xc142 and word(m,r[R.SP])!=0xc314:
            # C314 belongs to native MORE, which the browser computes itself.
            self.events.append({'op':'wide'})
        elif pc==0xa277 and not m[0xa027] and m[0x5c3c]:
            self.events.append({'op':'picture','room':r[R.A]})
        elif pc==0xa9df and not m[0xa027] and m[0x5c3c]:
            end=r[R.H]*256+r[R.L]
            if not 0x5c0b<=end<=0x5c8a:raise ValueError('Invalid original word buffer')
            self.events.append({'op':'word','text':''.join('£' if c==96 else chr(c) for c in m[0x5c0b:end]),
                                'delimiter':chr(r[R.A]),'capitalize':bool(m[0xa026]),'force':bool(m[0xa851])})

    def drain(self):
        events,self.events=self.events,[]
        return events


@lru_cache(maxsize=16)
def boot_state(project,seed=None,graphics=False):
    """Immutable first-prompt state. Inject A immediately before LD (A037),A.

    None preserves the historical, reproducible snapshot boot for research.
    Browser sessions pass an explicit byte; graphics is a fixed native profile,
    independent of SVG/pixel/hidden presentation in the browser.
    """
    import sys
    project=Path(project);sys.path.insert(0,str(project/'sherlock-analisi/parser'))
    from sherlock_parser import SherlockParser
    e=SherlockParser(project);R=e.R
    s=e.audit.from_snapshot(e.audit.Simulator,e.audit.entry)
    s.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255))
    m,r=s.memory,s.registers;stream=ScreenStream();recording=False
    for _ in range(3000000):
        pc=r[R.PC]
        if pc==0xa536:return bytes(m),tuple(r),tuple(stream.drain())
        if pc==0xc415:
            initial=word(m,r[R.SP])==0xa051
            r[R.A],r[R.PC]=ord('Y' if graphics and initial else 'N'),0xc41e
        if pc==0xa061 and seed is not None:r[R.A]=seed
        if pc==0xcc9e and m[0xa036]==0 and r[R.IXh]*256+r[R.IXl]==0x9921:
            recording=True
        if recording:stream.observe(m,r,R)
        s.opcodes[m[r[R.PC]]]()
    raise RuntimeError('Original opening did not reach the first prompt')


def opening_screen(project):return boot_state(project)[2]
