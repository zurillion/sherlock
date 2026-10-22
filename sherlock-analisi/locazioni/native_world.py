"""Ponte al codice originale con turni NPC selezionabili e prompt persistente."""
import sys,re
from pathlib import Path
sys.dont_write_bytecode=True
from native_screen import ScreenStream

def word(m,p):return m[p]+256*m[p+1]

class NativeWorld:
    def __init__(self,project,active_npcs=()):
        self.active_npcs=None if active_npcs is None else frozenset(active_npcs)
        self.project=Path(project)
        sys.path.insert(0,str(self.project/'sherlock-analisi/parser'))
        from sherlock_parser import SherlockParser
        self.engine=SherlockParser(self.project);self.sim=self.engine.new_sim();self.m=self.sim.memory;self.R=self.engine.R
        self.input_registers=self.sim.registers[:];self.input_stack=self.m[0x5d00:0x5d80]
        self.m[0xa011]=0 # grafica disabilitata: testo conservato
        self.ended=None;self.interrupt_wait=False;self.phase_budget=9000000
        self.prepare()
    def call(self,address,a=None,b=None,budget=1800000):
        e,s,R=self.engine,self.sim,self.R;m,r=s.memory,s.registers
        r[R.SP],r[R.PC]=0x5d7e,address;e.put(s,0x5d7e,8)
        if a is not None:r[R.A]=a
        if b is not None:r[R.B]=b
        text=[];listed=[];events=[];screen=ScreenStream()
        for step in range(budget):
            pc=r[R.PC]
            if pc==8:
                value=''.join(text).replace('\x08','')
                value=re.sub(r'[ \t]+',' ',value)
                return {'text':value.strip(),'screen_events':screen.drain(),'a':r[R.A],'z':bool(r[R.F]&64),'carry':bool(r[R.F]&1),'listed':listed,'events':events,'steps':step,'cost':word(m,0xa01f)}
            if pc in (0xa536,0xb191,0xc040,0xc0df,0x04c2,0x0556):raise RuntimeError(f'Routine fuori ambito: {pc:04X}')
            if pc==0xc415:
                r[R.A],r[R.F]=32,0;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
            if pc==0xaa28 and r[R.A]==32:text.append(' ') # spazio soppresso soltanto dall'impaginazione Spectrum
            if pc==0xaa6e:
                c=r[R.A];wrap=word(m,r[R.SP])==0xa9f4
                if c==13:text.append(' ' if wrap else '\n')
                elif c>=32:text.append('£' if c==96 else chr(c))
            if pc==0xd531:listed.append(m[r[R.IXh]*256+r[R.IXl]])
            if pc in (0xd102,0xd1b2,0xd078,0xdcD2,0xdd35,0xca9e):events.append({'pc':f'{pc:04X}','a':r[R.A]})
            screen.observe(m,r,R)
            s.opcodes[m[pc]]()
        raise RuntimeError(f'Budget esaurito a {r[R.PC]:04X}')
    def prepare(self):
        self.m[0xa036]=self.player_id;self.call(0xcc29);self.call(0xd045);self.m[0x5c3c]=1;self.m[0xa027]=0
        self.engine.put(self.sim,0xa01f,0)
    @property
    def player_id(self):return self.m[0x9860]
    @property
    def room(self):return self.m[word(self.m,0x8b70+3*self.player_id)+15]
    def teleport(self,room):
        self.prepare()
        # Map travel detaches the player from a chair/vehicle, then moves inventory.
        self.m[0xa033:0xa036]=[128,self.player_id,room]
        self.call(0xc4d1);self.prepare()
        # L'esplorazione via mappa non usa le porte e non consuma tempo.
        return self.call(0xca9e)
    def scene(self,full=True):
        self.prepare();return self.call(0xd102 if full else 0xd1b2,a=self.room)
    def action(self,action,arg=255):
        self.prepare();self.m[0xa033:0xa036]=[action,arg,255]
        return self.call(0xc4d1)
    def visible(self):
        self.prepare();result=[]
        for ident in range(110):
            if not self.call(0xc821,a=ident)['z']:result.append(ident)
        return result
    def advance(self,cost):
        if not cost:return
        due=(word(self.m,0x9866)+cost)&65535
        self.engine.put(self.sim,0x9866,due)
        target=max(word(self.m,0x9fdd)+1,due)
        for _ in range(target-word(self.m,0x9fdd)):self.call(0xbfd9)
    def clock(self):
        minute,hour,day,period=self.m[0x9fdf:0x9fe3]
        return {'tick':word(self.m,0x9fdd),'due':word(self.m,0x9866),'minute':minute,'hour':hour,'day':day,'period':'am' if period==97 else 'pm','label':f"{['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][day%7]} {hour:02d}:{minute:02d}{'am' if period==97 else 'pm'}"}

    def submit(self,text,explored):
        """Synchronous research interface; the web consumes iter_submit minute by minute."""
        messages=[]
        for part in self.iter_submit(text,explored):
            messages.extend(part.get("messages",[]))
        return {**part,"messages":messages}

    def iter_submit(self,text,explored):
        """Esegue editor/parser/semantica e scheduler originali, abilitando gli NPC selezionati.

        Conserva il punto d'attesa e lo stack fra risposte, incluso A01B/9FF0.
        Le chiamate di ispezione possono usare i registri senza perdere quel punto.
        """
        text=text.replace('£','`')
        if not text.isascii() or any(ord(c)<32 for c in text) or len(text)>70:
            yield {'complete':True,'messages':[{'kind':'system','text':'Input limit: 70 printable ASCII characters (or £).'}],'analysis':{'input':text,'outcome':'tool_limit','units':[]}};return
        if self.ended:
            yield {'complete':True,'messages':[],'analysis':{'input':text,'outcome':'game_over','units':[]},'game_over':self.ended};return
        self.interrupt_wait=False
        m,r,R=self.m,self.sim.registers,self.R
        backup=(m[:],r[:],self.input_registers[:],self.input_stack[:],set(explored))
        r[:]=self.input_registers;m[0x5d00:0x5d80]=self.input_stack;m[0xa027]=1
        keys=[64] if text.strip()=='@' and not m[0xa01b] else list(text.upper().encode())+[13];messages=[];buf=[];channel=None;editing=True;actions=[];units=[];outcome='ok';listed=[];scene=False;terminal=None;phase_steps=0;screen=ScreenStream()
        def flush():
            nonlocal buf
            value=''.join(buf).replace('\x08','');value=re.sub(r'[ \t]+',' ',value).strip()
            display=screen.drain()
            if value or display:messages.append({'kind':channel or 'narrative','text':value,'screen_events':display})
            buf=[]
        def emit(kind,c):
            nonlocal channel
            if channel!=kind:flush();channel=kind
            if c==13:buf.append('\n')
            elif c>=32:buf.append('£' if c==96 else chr(c))
        try:
            step=0
            while True:
                step+=1;phase_steps+=1
                if phase_steps>self.phase_budget:raise RuntimeError(f'The original code made no clock or input progress (PC {r[R.PC]:04X}).')
                pc=r[R.PC]
                if pc==0xb0a6:terminal={'entry':'B0A6','reason':'quit'}
                if pc==0x9e74:
                    terminal={'entry':'9E74','reason':'story','text_pointer':f'{r[R.H]*256+r[R.L]:04X}'}
                if pc==0xb0ac and terminal:
                    flush();self.ended=terminal
                    yield {'complete':True,'messages':messages,'analysis':{'input':text,'outcome':'game_over','units':units,'actions':actions},'steps':step,'listed':listed,'scene':scene,'game_over':terminal};return
                if pc==0xa074:
                    flush();batch=messages;messages=[];phase_steps=0
                    yield {'complete':False,'messages':batch,'clock':self.clock(),'steps':step}
                if pc==0xc41f and m[0x9863]==50:
                    # A07F polls ENTER once per minute. A full Spectrum would
                    # resume HALT via its interrupt; this input bridge supplies
                    # the poll result instead of executing hardware waiting.
                    r[R.A],r[R.F]=(0x8d if self.interrupt_wait else 0),0
                    self.interrupt_wait=False;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
                if pc==0xa536:
                    if not keys:
                        flush();self.input_registers=r[:];self.input_stack=m[0x5d00:0x5d80]
                        yield {'complete':True,'messages':messages,'analysis':{'input':text,'normalised':text,'outcome':'clarification' if m[0xa01b] else outcome,'continuation_slot':m[0xa01b],'units':units,'actions':actions},'steps':step,'listed':listed,'scene':scene};return
                    r[R.A],r[R.F]=keys.pop(0),0;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
                if pc==0xc415:
                    r[R.A],r[R.F]=32,0;r[R.PC]=word(m,r[R.SP]);r[R.SP]+=2;continue
                if pc==0xd6c1:editing=True
                if pc==0xd6ce:editing=False
                if pc==0xd6e5:outcome='lexical_error'
                if pc==0xd791 and r[R.A]==1:outcome='syntax_error'
                if pc==0xd7fc:
                    units.append({'mode':m[0xa024],'nodes':self.engine.nodes(self.sim,word(m,0x9ff2))})
                if pc==0xc1fd and not editing:
                    c=r[R.A];emit('error',c-32 if 97<=c<=122 else c)
                if pc==0xaa28 and r[R.A]==32 and not editing and not m[0xa027] and m[0x5c3c]:emit('narrative',32)
                if pc==0xaa6e and not editing and not m[0xa027] and m[0x5c3c]:
                    c=r[R.A];emit('narrative',32 if c==13 and word(m,r[R.SP])==0xa9f4 else c)
                if pc in (0xd102,0xd1b2) and not m[0xd0dc]:
                    room=self.room;scene=True;listed=[]
                    if pc==0xd102 and (room not in explored or m[0xa033]==34):
                        flush();messages.append({'kind':'narrative','text':'','image_room':room,'screen_events':[]})
                    explored.add(room)
                if pc==0xd531:listed.append(m[r[R.IXh]*256+r[R.IXl]])
                if pc==0xc4d1:actions.append({'actor':m[0xa036],'id':m[0xa033],'arguments':list(m[0xa034:0xa036])})
                if pc==0xa097:
                    row=r[R.IYh]*256+r[R.IYl]
                    if row!=0x9860 and m[row]!=255 and self.active_npcs is not None and m[row] not in self.active_npcs:r[R.PC]=0xa0d1;continue
                if pc in (0xb0ac,0xb0c9,0xb09d,0xb002,0xb00e,0xc040,0xc0df,0x04c2,0x0556):
                    raise RuntimeError('Tape, printing and control commands are not available in this explorer.')
                if pc==0xd9f5 and not 0x5dc0<=r[R.D]*256+r[R.E]<0x67b6:
                    raise RuntimeError('The original dictionary scan left its valid range.')
                if pc==0xd73c:
                    pos=r[R.IYh]*256+r[R.IYl];kind=r[R.A];size=3 if kind<128 or kind in (0x90,0xe0,0xf0) else 1
                    if pos+size>0x5be1:raise RuntimeError('The original token buffer is full.')
                screen.observe(m,r,R)
                self.sim.opcodes[m[pc]]()
        except (RuntimeError,IndexError,ValueError) as exc:
            failed_pc=f'{r[R.PC]:04X}';failed_clock=self.clock()
            m[:],r[:],self.input_registers,self.input_stack=backup[:4];explored.clear();explored.update(backup[4])
            yield {'complete':True,'messages':[{'kind':'system','text':str(exc)}],'analysis':{'input':text,'outcome':'tool_limit','units':units,'pc':failed_pc,'clock_at_failure':failed_clock}}
