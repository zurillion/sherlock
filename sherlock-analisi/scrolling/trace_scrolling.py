#!/usr/bin/env python3
"""Osserva contatore, CR, scroll e MORE nel renderer Z80 originale di Sherlock."""
import argparse
import hashlib
import json
import struct
import sys
import zlib
from pathlib import Path
from types import SimpleNamespace

sys.dont_write_bytecode=True


def word(m,p):return m[p]+256*m[p+1]


def write_screen(memory,path,scale=3,flash=False):
    """Rende la bitmap/attributi osservati, senza ridisegnare font o testo."""
    normal=(0,205);bright=(0,255);rows=[]
    for y in range(192):
        scan=bytearray()
        for x in range(256):
            attr=memory[0x5800+(y//8)*32+x//8]
            ink=bool(memory[0x4000+((y&0xc0)<<5)+((y&7)<<8)+((y&0x38)<<2)+x//8]&(128>>(x&7)))
            if flash and attr&128:ink=not ink
            colour=(attr&7) if ink else ((attr>>3)&7)
            palette=bright if attr&64 else normal
            rgb=bytes([palette[(colour>>1)&1],palette[(colour>>2)&1],palette[colour&1]])
            scan.extend(rgb*scale)
        rows.extend([b'\0'+bytes(scan)]*scale)
    def chunk(kind,data):return struct.pack('>I',len(data))+kind+data+struct.pack('>I',zlib.crc32(kind+data)&0xffffffff)
    png=b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>2I5B',256*scale,192*scale,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(b''.join(rows)))+chunk(b'IEND',b'')
    path.write_bytes(png)


class ScrollProbe:
    def __init__(self,project,boot=False,output=None):
        self.project=Path(project);sys.path.insert(0,str(self.project/'sherlock-analisi/parser'))
        from sherlock_parser import SherlockParser
        self.engine=SherlockParser(self.project);self.R=self.engine.R
        self.sim=self.engine.audit.from_snapshot(self.engine.audit.Simulator,self.engine.audit.entry) if boot else self.engine.new_sim()
        self.sim.set_tracer(SimpleNamespace(border=7,outfe=7,read_port=lambda *args:255))
        self.m,self.r=self.sim.memory,self.sim.registers
        self.events=[];self.label='';self.total_feeds=0;self.total_scrolls=0;self.total_pages=0;self.step=0
        self.grid=[[' ']*36 for _ in range(18)];self.output=Path(output) if output else None
        self.last_text=None;self.pending_feed=None
    def screen(self):
        return {'rows':[''.join(row).rstrip() for row in self.grid],
                'counter':self.m[0xa019],'width':18 if self.m[0xc128] else 36,
                'columns_left':self.m[0xc1f5],'cursor_bitmap':f'{word(self.m,0xc1f8):04X}',
                'cursor_bits':self.m[0xc1fa],'tick':word(self.m,0x9fdd),
                'calendar':list(self.m[0x9fdf:0x9fe3])}
    def event(self,kind,**fields):
        value={'event':kind,'phase':self.label,'step':self.step,'actor':self.m[0xa036],
               'counter':self.m[0xa019],'feeds':self.total_feeds,'scrolls':self.total_scrolls,
               'width':18 if self.m[0xc128] else 36,**fields}
        self.events.append(value);return value
    def observe(self):
        m,r,R=self.m,self.r,self.R;pc=r[R.PC]
        if pc==0xa59f:self.last_text=f'{r[R.H]*256+r[R.L]:04X}'
        if pc in (0xc12a,0xa29c,0xd71a):
            self.event('counter_store',pc=f'{pc:04X}',value=r[R.A])
        if pc==0xc142:self.event('wide_mode',caller=f'{word(m,r[R.SP]):04X}')
        if pc==0xc2ca:
            self.total_feeds+=1
            self.pending_feed=self.event('linefeed',cause='CR' if r[R.A]==13 else 'column_exhausted',
                                         text_pointer=self.last_text,screen=self.screen())
        if pc==0xc2d7:
            self.event('counter_increment',value=r[R.A])
        if pc==0xc306:
            self.total_pages+=1
            row=self.event('more',number=self.total_pages,screen=self.screen(),text_pointer=self.last_text)
            if self.output and self.total_pages<=3:
                name=self.label.replace(' ','-').replace('.','-')+f'-more-{self.total_pages:02d}.png'
                write_screen(m,self.output/name);row['screenshot']=name
        if pc==0xc316:
            self.total_scrolls+=1;self.event('scroll',feed=self.total_feeds)
            width=18 if m[0xc128] else 36
            for y in range(17):self.grid[y][:width]=self.grid[y+1][:width]
            self.grid[17][:width]=[' ']*width
        if pc==0xc388 and word(m,r[R.SP])==0xc2f1:
            address=r[R.H]*256+r[R.L]
            y=((address&0x1800)>>5)|((address&0xe0)>>2)|((address>>8)&7)
            x=(address&31)*8+r[R.C];col=(x-2)//7
            if 0<=y//8<18 and 0<=col<36:self.grid[y//8][col]=chr(r[R.A]) if r[R.A]>=32 else '?'
    def run(self,command=None,call=None,a=None,timeout=False,budget=12000000):
        m,r,R=self.m,self.r,self.R;start=len(self.events);self.label=command or ('timeout' if timeout else 'boot' if call is None else f'call-{call:04X}')
        before=self.screen();keys=list(command.upper().encode())+[13] if command is not None else []
        timeout_started=False
        if call is not None:
            r[R.SP]=0x5d7e;m[0x5d7e:0x5d80]=[8,0];r[R.PC]=call
            if a is not None:r[R.A]=a
        for step in range(budget):
            self.step+=1;pc=r[R.PC]
            if pc==8 and call is not None:break
            if pc==0xa536:
                if keys:
                    r[R.A],r[R.F]=keys.pop(0),0;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
                if timeout and not timeout_started:
                    timeout_started=True;self.event('timeout_start',keyboard_counter=word(m,0xa03b))
                else:break
            if pc==0xc415:
                caller=word(m,r[R.SP]);self.event('key_wait',caller=f'{caller:04X}')
                if caller==0xc30f and self.output and self.total_pages<=3:
                    page=next(e for e in reversed(self.events) if e['event']=='more')
                    page['flash_attribute']=f'{m[0x5a5f]:02X}'
                    write_screen(m,self.output/page['screenshot'],flash=True)
                r[R.A],r[R.PC]=(ord('N') if caller==0xa051 else 32),0xc41e
            if pc in (0xc040,0xc0df):raise RuntimeError(f'Tape boundary {pc:04X}')
            self.observe();old=m[0xa019];old_pc=r[R.PC]
            if m[old_pc]==0x76 and r[26] and r[R.T]%self.sim.frame_duration>=self.sim.int_active:
                skipped=max(0,(self.sim.frame_duration-r[R.T]%self.sim.frame_duration-1)//4)
                r[R.T]+=4*skipped;r[15]=(r[15]&128)|((r[15]+skipped)&127)
            self.sim.opcodes[m[old_pc]]()
            if r[26] and r[R.T]%self.sim.frame_duration<self.sim.int_active:self.sim.accept_interrupt(r,m,old_pc)
            if old!=m[0xa019] and old_pc not in (0xc12a,0xa29c,0xd71a,0xc2d7):
                self.event('other_counter_write',pc=f'{old_pc:04X}',before=old,after=m[0xa019])
        else:raise RuntimeError(f'Execution budget at {r[R.PC]:04X}')
        return {'phase':self.label,'before':before,'after':self.screen(),'steps':step,
                'events':self.events[start:]}


def trace(project,output):
    output.mkdir(parents=True,exist_ok=True)
    q=ScrollProbe(project,boot=True,output=output)
    phases=[q.run()]
    for command in ['WAIT','WAIT','OPEN DOR','LOOK','LOOK. LOOK','PICK THE NOTE UP','EXAMINE ARMCHAIR','YOUR','WAIT','WAIT']:
        phases.append(q.run(command))
    phases.append(q.run(timeout=True))
    # A controlled display fixture, separate from gameplay: retain real memory,
    # call the real renderer once for each CR, and vary no Z80 instruction.
    f=ScrollProbe(project);f.m[0xa019]=0;feeds=[]
    for _ in range(49):feeds.append(f.run(call=0xc2ba,a=13))
    # Narrow mode and clear-screen entry points are isolated routine fixtures.
    modes=ScrollProbe(project);modes.m[0xa019]=7;modes.m[0xa027]=0;modes.m[0x5c3c]=1
    mode_cases=[modes.run(call=0xc142),modes.run(call=0xc129)]
    modes.m[0xa019]=0;mode_cases.append(modes.run(call=0xa296))
    modes.m[0xa019]=15;mode_cases.append(modes.run(call=0xa296))
    narrow=ScrollProbe(project);narrow.run(call=0xc129)
    for _ in range(16):narrow.run(call=0xc2ba,a=13)
    exact=ScrollProbe(project);exact.m[0xa019]=0;exact.run(call=0xc142)
    for _ in range(36):exact.run(call=0xc2ba,a=65)
    exact_after_wrap=exact.screen();exact.run(call=0xc2ba,a=13)
    payload=(Path(project)/'sherlock-analisi/block-10.bin').read_bytes()
    result={'source_payload_sha256':hashlib.sha256(payload).hexdigest(),'phases':phases,
            'repeated_cr_fixture':{'description':'49 direct CR calls to C2BA, initial A019=0; no parser between calls',
                                   'events':f.events},
            'mode_fixtures':mode_cases,'narrow_fixture':narrow.events,
            'exact_width_fixture':{'after_36_characters':exact_after_wrap,'after_extra_CR':exact.screen(),'events':exact.events}}
    (output/'scroll-traces.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
    return result


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results')
    args=ap.parse_args();result=trace(args.project,args.output)
    for phase in result['phases']:
        print(phase['phase'], 'counter',phase['before']['counter'],'->',phase['after']['counter'],
              'CR',sum(e['event']=='linefeed' for e in phase['events']),
              'MORE',sum(e['event']=='more' for e in phase['events']),flush=True)
