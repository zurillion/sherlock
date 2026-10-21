#!/usr/bin/env python3
"""Sherlock Spectrum v2.0: decoder nativo del dizionario e dei testi.

Solo libreria standard. Non esegue/emula istruzioni Z80. I comandi che
richiedono lo stato del gioco vengono rappresentati con segnaposto espliciti.
"""
from __future__ import annotations
import argparse
from dataclasses import dataclass, asdict
import hashlib
import json
from pathlib import Path

TEXT_START, TEXT_END = 0x67F7, 0x8258
BASE = 0x5DBF
EXPECTED_PAYLOAD_SHA256 = 'c5d48285c0cee5c25cf4734dff0ac8296c0ec0194135e3a72267e49724ac8407'

class DecodeError(ValueError):
    pass

def number(s):
    return int(s[1:],16) if s.startswith('$') else int(s,0)

@dataclass(frozen=True)
class Word:
    offset:int
    address:int
    stem:str
    flags:int
    descriptor:int
    extra:bytes
    next_address:int

@dataclass(frozen=True)
class Token:
    address:int
    end:int
    kind:str
    value:object=None
    context:int=0
    terminal:bool=False

@dataclass
class Context:
    subject:int|None=None     # contenuto $A034, NON una definizione grammaticale
    other:int|None=None       # contenuto $A036
    capitalize:bool=True
    width:int|None=None
    time_class:int|None=None # classi restituite da $C00C (1-5)

class Formatter:
    """Equivalente testuale di A9B7/AA14: buffer, spazi, backspace, maiuscole.

    width=None produce paragrafi senza la larghezza video; width=36 riproduce
    l'a capo del canale superiore. Scrolling e pixel non sono necessari.
    """
    def __init__(self, capitalize=True, width=None):
        self.pending=[];self.output=[];self.started=False
        self.capitalize=capitalize;self.force_upper=False
        self.width=width;self.remaining=width
    def raw_emit(self,c):
        self.output.append(c)
        if c=='\r':self.remaining=self.width
        elif self.width:
            self.remaining-=1
            if self.remaining==0:
                self.output.append('\r');self.remaining=self.width
    def formatted(self,c):
        if 'A'<=c<='Z':c=c.lower()
        if not self.started and c==' ':return
        self.started=True
        if c=='\r':self.started=False
        elif c=='"':self.raw_emit(' ');self.capitalize=True
        elif c=='.':self.capitalize=True
        elif 'a'<=c<='z' and (self.capitalize or self.force_upper):
            c=c.upper();self.capitalize=False
        self.raw_emit(c)
    def feed(self,text):
        for c in text:
            if c=='\b':
                if not self.pending:raise DecodeError('Backspace oltre inizio buffer')
                self.pending.pop()
            elif c in ' \r"':
                if self.pending:
                    n=len(self.pending);exact=self.width is not None and self.remaining==n
                    if self.width and self.remaining<n:self.formatted('\r')
                    for p in self.pending:self.formatted(p)
                    self.pending=[]
                    if exact:self.started=False
                self.formatted(c)
            else:self.pending.append(c)
    def annotation(self,text):
        # Separazione editoriale, non un carattere presente nell'originale.
        self.feed(' ')
        self.output.append('⟦'+text+'⟧')
        self.started=True
    def result(self):
        # Un delimitatore virtuale espone la parola finale, senza aggiungerlo al testo.
        if self.pending:
            if self.width and self.remaining<len(self.pending):self.formatted('\r')
            for c in self.pending:self.formatted(c)
            self.pending=[]
        return ''.join(self.output).replace('\r','\n')

class Decoder:
    def __init__(self,memory,source='memory'):
        if len(memory)!=65536:raise DecodeError('Attesi 65536 byte di memoria')
        self.mem=bytes(memory);self.source=source
        self.words=self._dictionary()
        self.frequent=[self.word16(0x67B7+i*2) for i in range(32)]
        self.suffixes=[self.mem[0xA85C+4*i:0xA860+4*i].split(b'\0')[0].decode('ascii') for i in range(9)]
        for off in self.frequent:
            if off not in self.words:raise DecodeError('Tabella parole frequenti non valida')
    @classmethod
    def load(cls,path):
        path=Path(path);data=path.read_bytes()
        if path.suffix.lower()=='.tap':
            blocks=[];p=0
            while p<len(data):
                if p+2>len(data):raise DecodeError('Lunghezza TAP troncata')
                n=int.from_bytes(data[p:p+2],'little');p+=2
                block=data[p:p+n];p+=n
                if len(block)!=n or n<2:raise DecodeError('Blocco TAP troncato')
                checksum=0
                for b in block:checksum^=b
                if checksum:raise DecodeError('Checksum TAP errato')
                blocks.append(block)
            matches=[]
            for h,b in zip(blocks,blocks[1:]):
                if len(h)==19 and h[:2]==b'\x00\x03' and b[0]==255:
                    size=int.from_bytes(h[12:14],'little');org=int.from_bytes(h[14:16],'little')
                    if org==0x5D80 and size==41600 and len(b)==size+2:matches.append(b[1:-1])
            if len(matches)!=1:raise DecodeError('Blocco principale $5D80 non univoco o assente')
            data=matches[0]
        if len(data)==41600:
            if hashlib.sha256(data).hexdigest()!=EXPECTED_PAYLOAD_SHA256:
                raise DecodeError('Versione del payload diversa da quella verificata; indirizzi non garantiti')
            data=bytes(0x5D80)+data
        else:raise DecodeError('Usare SHERLOCK.TAP oppure il payload block-10.bin della versione verificata')
        return cls(data,str(path))
    def word16(self,a):
        if not 0<=a<65535:raise DecodeError(f'Word fuori memoria: ${a:04X}')
        return self.mem[a]|self.mem[a+1]<<8
    def packed(self,p,count):
        size=(count*5+7)//8
        if p+size>65536:raise DecodeError('Testo a 5 bit troncato')
        bits=int.from_bytes(self.mem[p:p+size],'big')
        text=''.join(chr(0x60+((bits>>(size*8-5*(i+1)))&31)) for i in range(count))
        return text,p+size
    def _dictionary(self):
        groups={self.word16(0x5D80+2*i):chr(96+i) for i in range(1,27)}
        p=BASE+1;end=BASE+self.word16(0x5DBE)-1;previous='';initial='';words={}
        if end!=0x67B6:raise DecodeError('Limite del dizionario inatteso')
        while p<end:
            offset=p-BASE
            if offset in groups:initial=groups[offset];previous=''
            flags,desc=self.mem[p:p+2];prefix=(desc>>4)&7;n=desc&15
            start=p+2+(2 if desc&128 else 0)
            if not initial or prefix>len(previous):raise DecodeError(f'Prefisso non valido a ${p:04X}')
            tail,nxt=self.packed(start,n)
            if nxt>end:raise DecodeError('Record oltre il dizionario')
            stem=previous[:prefix]+tail
            words[offset]=Word(offset,p,initial+stem,flags,desc,self.mem[p+2:start],nxt)
            previous=stem;p=nxt
        return words
    def inflected(self,word):
        n=word.flags&15
        if n==15:return word.stem
        if n>8:raise DecodeError(f'Suffisso non documentato {n}')
        value=word.stem
        for c in self.suffixes[n]:value=value[:-1] if c=='\b' else value+c.lower()
        return value
    def word_form(self,offset,context,ctx):
        try:w=self.words[offset]
        except KeyError:raise DecodeError(f'Riferimento dizionario non valido: ${offset:03X}') from None
        if context==0x50:return w.stem,False
        state=1 if context==0x40 else ctx.subject if context==0x10 else ctx.other
        variant=self.inflected(w)
        if state is None and variant!=w.stem:return (w.stem,variant),True
        return variant if state else w.stem,False
    def token(self,p):
        if not 0<=p<65536:raise DecodeError('Token fuori memoria')
        b=self.mem[p]
        if b>=128:
            if p==65535:raise DecodeError('Riferimento troncato')
            off=((b&15)<<8)|self.mem[p+1];context=b&0x70
            if off not in self.words and off!=0:raise DecodeError(f'Offset ${off:03X} non valido a ${p:04X}')
            return Token(p,p+2,'word',off,context,context in (0x20,0x30,0x60))
        if b>=96:return Token(p,p+1,'word',self.frequent[b-96],0x50)
        if b>=64:
            value,end=self.packed(p+1,(b&31)+1)
            return Token(p,end,'literal',value)
        if b>=32:return Token(p,p+1,'literal',chr(b))
        if b in (2,11):return Token(p,p+3,'jump' if b==2 else 'call',(p+self.word16(p+1))&65535,terminal=b==2)
        if b==10:
            if p==65535:raise DecodeError('Scelta troncata')
            count=self.mem[p+1]
            if not 1<=count<=32:raise DecodeError(f'Numero alternative sospetto a ${p:04X}')
            options=[];end=p+2
            for _ in range(count):
                t=self.token(end);options.append(t);end=t.end
            return Token(p,end,'choice',options)
        if b in (15,20,21,22,23):
            following=self.token(p+1)
            return Token(p,following.end,'conditional',{'time_class':{15:5,20:4,21:3,22:2,23:1}[b],'token':following})
        return Token(p,p+1,'command',b,terminal=b in (29,30,31,26))
    def fragment(self,address,max_tokens=4096):
        tokens=[];p=address
        for _ in range(max_tokens):
            t=self.token(p)
            if t.end<=p or t.end>65536:raise DecodeError('Estensione token non valida')
            tokens.append(t);p=t.end
            if t.terminal:return tokens,p
        raise DecodeError('Nessuna terminazione entro il limite di token')
    def render(self,address,ctx=None,expand=True):
        ctx=ctx or Context();f=Formatter(ctx.capitalize,ctx.width)
        unresolved=[];visited=[];last_word=None;steps=0
        names={0:'nome da argomento stack',1:'parola da argomento stack',3:'parola da $A00D',
               4:'nome/parola da argomento stack',5:'relazione da argomento stack',
               6:'nome referente $A036',7:'nome referente $A034',9:'nome referente $A035',
               12:'his/your secondo $A036',14:'his/your secondo $A034',
               16:'nome $A036 + is/are',17:'nome $A034 + is/are',
               18:'ripetizione DE (contratto da verificare)',19:'nome da argomento + is/are',
               24:'composizione da $A360',25:'testo da argomento stack',26:'salto a testo da argomento stack'}
        def mark(s,t):
            f.annotation(s);unresolved.append({'address':f'{t.address:04X}','reason':s})
        def emit(t,stack):
            nonlocal last_word,steps
            steps+=1
            if steps>12000:raise DecodeError('Espansione eccessiva')
            visited.append(t.address)
            if t.kind=='word':
                last_word=t
                if t.value:
                    f.feed(' ') # A89A: svuota la parola precedente PRIMA di impostare A026
                    if t.context==0x70:f.capitalize=True
                    value,ambiguous=self.word_form(t.value,t.context,ctx)
                    if ambiguous:mark(f'{value[0]} | {value[1]}: dipende da ${"A034" if t.context==0x10 else "A036"}',t)
                    else:f.feed(value)
                if t.context==0x30:f.feed('.\r')
                elif t.context==0x60:f.feed('\r')
            elif t.kind=='literal':f.feed(t.value)
            elif t.kind in ('call','jump'):
                if expand:walk(t.value,stack)
                else:mark(f'{t.kind} ${t.value:04X}',t)
            elif t.kind=='choice':
                # Alternative annotate; non scegliamo un risultato pseudo-casuale.
                options=[]
                for option in t.value:
                    if option.kind=='word':
                        value,amb=self.word_form(option.value,option.context,ctx)
                        options.append('/'.join(value) if amb else value)
                    elif option.kind=='literal':options.append(option.value)
                    else:options.append(f'{option.kind} @${option.address:04X}')
                mark('scelta: '+' / '.join(options),t)
            elif t.kind=='conditional':
                if ctx.time_class is not None:
                    if ctx.time_class==t.value['time_class']:
                        return emit(t.value['token'],stack)
                    return False
                mark(f"se classe temporale={t.value['time_class']}",t)
                emit(t.value['token'],stack)
                mark('fine condizione',t)
            else:
                op=t.value
                if op==8:
                    try:f.feed('\b')
                    except DecodeError:mark('backspace senza parola locale',t)
                elif op==13:f.feed('\r')
                elif op==27:f.force_upper=not f.force_upper
                elif op==28:pass
                elif op==29:f.feed('\r')
                elif op==30:f.feed('.\r')
                elif op==31:pass
                else:mark(names.get(op,f'comando ${op:02X} non risolto'),t)
            return t.terminal
        def walk(start,stack):
            if start in stack or len(stack)>24:raise DecodeError(f'Ciclo/richiamo profondo a ${start:04X}')
            if not TEXT_START<=start<TEXT_END:raise DecodeError(f'Richiamo fuori area testo documentata: ${start:04X}')
            tokens,end=self.fragment(start)
            if end>TEXT_END:raise DecodeError(f'Frammento oltre area testo: ${start:04X}')
            for t in tokens:
                if emit(t,(*stack,start)):break
        walk(address,())
        return {'address':f'{address:04X}','text':f.result(),'unresolved':unresolved,
                'token_addresses':[f'{p:04X}' for p in visited],
                'status':'symbolic' if unresolved else 'decoded'}
    def bank(self):
        fragments=[];p=TEXT_START
        while p<TEXT_END:
            start=p;tokens,p=self.fragment(p)
            if p>TEXT_END:raise DecodeError(f'Fine area superata da ${start:04X}')
            fragments.append((start,p,tokens))
        return fragments
    def plain(self,address,limit=1024):
        """Formato C1CB: bit 7 sull'ultimo carattere, nessuna compressione."""
        chars=[]
        for p in range(address,min(address+limit,65536)):
            b=self.mem[p];c=b&127
            if c!=13 and not 32<=c<=126:
                raise DecodeError(f'Carattere non testuale a ${p:04X}')
            chars.append(chr(c))
            if b&128:return ''.join(chars).replace('\r','\n')
        raise DecodeError('Stringa semplice senza terminatore entro il limite')
    def locations(self):
        # D224: tabella $840B. D113: campo +7/+8 passato ad A59F via D182.
        # D3A9 esclude ID $6A; slot $6A punta alla lista oggetti, non a una locazione.
        result=[]
        for ident in range(0x6A):
            record=self.word16(0x840B+2*ident)
            description=self.word16(record+7)
            parts=[]
            for displacement in (3,5,1):
                ref=self.word16(record+displacement);off=ref&0xFFF
                if off in self.words:parts.append(self.words[off].stem)
            result.append({'id':ident,'record':f'{record:04X}',
                           'name_hint':' '.join(parts),'name_note':'basi lessicali dei campi; articolo e grammatica non ricostruiti',
                           'description':f'{description:04X}' if description else None,
                           'evidence':'$D224 -> tabella $840B; $D16B legge +7/+8; $D182 -> $A59F'})
        return result

def export(decoder,out,ctx):
    out.mkdir(parents=True,exist_ok=True)
    fragments=decoder.bank();results=[];issues=[]
    starts={a for a,_,_ in fragments}
    # Richiami possono entrare nel mezzo di un frammento condiviso.
    def collect(tokens):
        for t in tokens:
            if t.kind in ('call','jump'):starts.add(t.value)
            elif t.kind=='choice':collect(t.value)
            elif t.kind=='conditional':collect([t.value['token']])
    for _,_,tokens in fragments:collect(tokens)
    locations=decoder.locations()
    for loc in locations:
        if loc['description']:starts.add(int(loc['description'],16))
    for address in sorted(starts):
        try:results.append(decoder.render(address,ctx))
        except DecodeError as exc:issues.append({'address':f'{address:04X}','error':str(exc)})
    by_address={r['address']:r for r in results}
    for loc in locations:
        if loc['description']:loc['decoded']=by_address.get(loc['description'])
    (out/'texts.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n')
    (out/'texts.txt').write_text('SHERLOCK — testi e frammenti. ⟦...⟧ = annotazione del decoder, non testo originale.\n'
                               'Contiene spoiler. Non è una trascrizione di una partita.\n\n'+
                               '\n\n'.join(f"[${r['address']}] {r['status']}\n{r['text']}" for r in results)+'\n')
    (out/'locations.json').write_text(json.dumps(locations,ensure_ascii=False,indent=2)+'\n')
    (out/'locations.txt').write_text('LOCAZIONI: campi +7/+8 dei record; nomi indicativi da basi lessicali.\n\n'+
       '\n\n'.join(f"ID {loc['id']} — {loc['name_hint']} — record ${loc['record']} — testo ${loc['description']}\n"+
          (loc.get('decoded') or {}).get('text','Nessuna descrizione decodificata') for loc in locations if loc['description'])+'\n')
    service=[{'address':f'{a:04X}','text':decoder.plain(a),'format':'C1CB: bit 7 finale'} for a in (0xC0A5,0xC0B1,0xC0BC)]
    (out/'service-texts.json').write_text(json.dumps(service,ensure_ascii=False,indent=2)+'\n')
    manifest={'source':decoder.source,'payload_sha256':hashlib.sha256(decoder.mem[0x5D80:]).hexdigest(),
              'dictionary_records':len(decoder.words),'bank_start':f'{TEXT_START:04X}','bank_end_exclusive':f'{TEXT_END:04X}',
              'sequential_fragments':len(fragments),'decoded_entry_points':len(results),
              'fully_static':sum(r['status']=='decoded' for r in results),'symbolic':sum(r['status']=='symbolic' for r in results),
              'location_records':len(locations),'location_description_pointers':sum(bool(r['description']) for r in locations),
              'context':asdict(ctx),'issues':issues,
              'coverage_note':'Area contigua documentata, richiami interni e puntatori di descrizione. Non prova completezza di tutti i testi nel gioco.'}
    (out/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
    print(json.dumps(manifest,ensure_ascii=False,indent=2))

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source',type=Path,default=Path(__file__).resolve().parents[2]/'SHERLOCK.TAP')
    parser.add_argument('--subject',type=number,help='Valore della cella $A034; omesso = simbolico')
    parser.add_argument('--other',type=number,help='Valore della cella $A036; omesso = simbolico')
    parser.add_argument('--width',type=int,help='Colonne; omesso = paragrafi senza a capo video')
    parser.add_argument('--time-class',type=int,choices=range(1,6),help='Classe temporale: 1 notte, 2 tramonto, 3 pomeriggio, 4 mattina, 5 alba')
    sub=parser.add_subparsers(dest='command',required=True)
    one=sub.add_parser('decode');one.add_argument('address',type=number);one.add_argument('--json',action='store_true')
    ex=sub.add_parser('extract');ex.add_argument('--out',type=Path,default=Path(__file__).resolve().parent/'estratti')
    word=sub.add_parser('word');word.add_argument('reference',type=number)
    plain=sub.add_parser('plain');plain.add_argument('address',type=number)
    args=parser.parse_args()
    try:
        if args.width is not None and args.width<1:raise DecodeError('Larghezza non valida')
        for v in (args.subject,args.other):
            if v is not None and not 0<=v<=255:raise DecodeError('Le celle di stato sono byte 0-255')
        decoder=Decoder.load(args.source);ctx=Context(args.subject,args.other,True,args.width,args.time_class)
        if args.command=='extract':export(decoder,args.out,ctx)
        elif args.command=='plain':print(decoder.plain(args.address))
        elif args.command=='word':
            value,ambiguous=decoder.word_form(args.reference&0xFFF,(args.reference>>8)&0xF0,ctx)
            print(' / '.join(value) if ambiguous else value)
        else:
            result=decoder.render(args.address,ctx)
            print(json.dumps(result,ensure_ascii=False,indent=2) if args.json else result['text'])
    except (DecodeError,OSError) as exc:parser.exit(2,f'Errore: {exc}\n')

if __name__=='__main__':main()
