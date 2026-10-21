#!/usr/bin/env python3
"""Analisi sintattica interattiva di Sherlock tramite il parser Z80 originale.

Non esegue azioni del mondo: editor, lexer e parser girano in una macchina
isolata. Richiede la distribuzione SkoolKit e i dati già presenti nel progetto.
"""
from __future__ import annotations
import argparse
import json
from pathlib import Path
import sys
from types import SimpleNamespace
sys.dont_write_bytecode = True

class ProbeLimit(RuntimeError):
    pass

class SherlockParser:
    def __init__(self, project=None):
        self.project = Path(project) if project else Path(__file__).resolve().parents[2]
        self.folder = self.project / 'sherlock-analisi/parser'
        sys.path.insert(0, str(self.folder))
        from parser_audit import Audit
        self.audit = Audit(self.project)
        self.audit.prompt = self.audit.Snapshot.get(str(self.folder / 'results/prompt.z80'))
        from skoolkit import simutils
        self.R = simutils
        self.last_buffer = None
        self.context = None
        self.context_text = None

    def new_sim(self, state=None):
        sim = self.audit.new_sim()
        if state:
            sim.memory[:] = state[0]
            sim.registers[:] = state[1]
        # IN printer: nessuna stampante presente (bit6=1); nessuna I/O esterna.
        sim.set_tracer(SimpleNamespace(border=7, outfe=7, read_port=lambda *args: 255))
        return sim

    @staticmethod
    def freeze(sim):
        return (sim.memory[:], sim.registers[:])

    def word(self, sim, address):
        return self.audit.word(sim.memory, address)

    @staticmethod
    def put(sim, address, value):
        sim.memory[address:address+2] = [value & 255, value >> 8]

    def call(self, sim, address, keys=None, log=None, budget=1_500_000):
        R = self.R
        m, r = sim.memory, sim.registers
        log = log if log is not None else {}
        r[R.SP], r[R.PC] = 0x5D7E, address
        self.put(sim, 0x5D7E, 8)
        watched_controls = {0xB0AC: 'LOAD/QUIT', 0xB0C9: 'SAVE', 0xB09D: 'PAUSE',
                            0xB002: 'PRINT', 0xB00E: 'NOPRINT'}
        for step in range(budget):
            pc = r[R.PC]
            if pc == 8:
                return {'a': r[R.A], 'z': bool(r[R.F] & 64), 'steps': step}
            if pc in (0xB191, 0xC040, 0xC0DF, 0x04C2, 0x0556):
                raise ProbeLimit(f'Confine estraneo al parser raggiunto: ${pc:04X}')
            if pc == 0xA536:
                if not keys:
                    raise ProbeLimit('L’editor attende altri tasti: nessun comando completo disponibile.')
                r[R.A], r[R.F] = keys.pop(0), 0
                r[R.PC] = self.word(sim, r[R.SP]); r[R.SP] += 2
                continue
            if pc == 0xC415:
                # PAUSE/pausa dello schermo: sola attesa simulata, senza hardware.
                r[R.A], r[R.F] = 32, 0
                r[R.PC] = self.word(sim, r[R.SP]); r[R.SP] += 2
                continue
            if pc in watched_controls:
                log.setdefault('controls', []).append(watched_controls[pc])
            if pc == 0xD6D4:
                start = self.word(sim, 0xA029)
                end = r[R.H] * 256 + r[R.L]
                val = r[R.B] * 256 + r[R.C]
                log.setdefault('lexemes', []).append({
                    'start': start-0x5B00, 'end': end-0x5B00,
                    'text': bytes(m[start:end]).decode('latin1'),
                    'type': f'{r[R.A]:02X}', 'value': f'{val:04X}',
                    'canonical': self.reference(val) if r[R.A] not in (0xD0,0xC0) else None,
                })
            if pc == 0xD9F5 and not 0x5DC0 <= r[R.D]*256+r[R.E] < 0x67B6:
                raise ProbeLimit('La scansione originale esce dai record del dizionario (caso Z o iniziale non alfabetica): risultato non affidabile.')
            if pc == 0xD73C:
                iy = r[R.IYh]*256 + r[R.IYl]
                kind = r[R.A]
                size = 3 if kind < 0x80 or kind in (0x90,0xE0,0xF0) else 1
                if iy + size > 0x5BE1:
                    raise ProbeLimit('Troppi token per il buffer originale: analisi interrotta prima di scrivere oltre il limite.')
            if pc == 0xC1FD:
                c = r[R.A]
                log.setdefault('lower', []).append(c-32 if 97<=c<=122 else c)
            if pc in (0xD791, 0xB8C1):
                log.setdefault('parser_returns', []).append({
                    'site': f'{pc:04X}', 'a': r[R.A], 'z': bool(r[R.F]&64),
                    'mode': m[0xA024], 'cursor': f'{self.word(sim,0xA02B):04X}',
                    'last_token': f'{self.word(sim,0xA029):04X}',
                })
            sim.opcodes[m[r[R.PC]]]()
        raise ProbeLimit(f'Limite di {budget} istruzioni raggiunto a ${r[R.PC]:04X}; esito non determinato, non errore sintattico.')

    def reference(self, value):
        if not value:
            return None
        w = self.audit.decoder.words.get(value & 0xFFF)
        if value & 0x8000:
            # Nei campi nominali: orario (bit7 del byte basso=0) o valuta.
            high, low = value >> 8, value & 255
            if low & 128:
                pence = ((high & 127) << 7) | (low & 127)
                return {'raw': f'{value:04X}', 'literal': 'money', 'pence': pence,
                        'pounds': pence//240, 'shillings': pence%240//12, 'remaining_pence': pence%12}
            return {'raw': f'{value:04X}', 'literal': 'time', 'hour': high & 63,
                    'minute': low & 63, 'period': 'AM' if high&64 else 'PM' if low&64 else 'unspecified'}
        return {'raw': f'{value:04X}', 'offset': f'{value & 0xFFF:04X}',
                'word': w.stem if w else None, 'unresolved_bits': f'{value & 0xF000:04X}'}

    def node(self, sim, p):
        w = lambda n:self.word(sim,p+n)
        def group(base):
            return {'relations': [self.reference(w(i)) for i in (base,base+2) if w(i)],
                    'referent': self.reference(w(base+4)),
                    'qualifiers': [self.reference(w(i)) for i in (base+6,base+8) if w(i)]}
        return {'address': f'{p:04X}', 'raw': bytes(sim.memory[p:p+30]).hex(' '),
                'verb': self.reference(w(0) & 0x3FFF),
                'verb_modifier': self.reference(w(2)),
                'all': bool(w(0)&0x8000), 'exclusion': bool(w(0)&0x4000),
                'groups': [group(4), group(14)],
                'subject': {'referent': self.reference(w(24)&0x3FFF),
                            'qualifiers': [self.reference(w(i)) for i in (26,28) if w(i)],
                            'he_flag': bool(w(24)&0x8000), 'it_they_flag': bool(w(24)&0x4000)}}

    def nodes(self, sim, head):
        items, seen = [], set()
        p = head
        while p:
            if p in seen or len(items)>=40 or not 0x9000<=p<0xA000:
                raise ProbeLimit(f'Lista di comandi non valida a ${p:04X}')
            seen.add(p);items.append(self.node(sim,p));p=self.word(sim,p-2)
        return items

    def quotes(self, sim):
        # Il parser esterno ha accodato indirizzi di token a 9FEC.
        p = self.word(sim,0x9FEC)
        sources, seen = [], set()
        while p:
            if p in seen or len(sources)>=16:
                raise ProbeLimit('Lista delle citazioni non valida')
            seen.add(p);sources.append(self.word(sim,p));p=self.word(sim,p-2)
        result=[]
        for start in sources:
            raw_tokens=[]
            pos=start
            for _ in range(96):
                kind=sim.memory[pos]
                if kind==0xC0:break
                size=3 if kind<0x80 or kind in (0x90,0xE0,0xF0) else 1
                raw_tokens.append({'address':f'{pos:04X}','bytes':bytes(sim.memory[pos:pos+size]).hex(' ')})
                pos+=size
            child=self.new_sim(self.freeze(sim))
            self.put(child,0xB868,start)
            log={}
            ret=self.call(child,0xB8AA,log=log)
            head=self.word(child,0x9FEE)
            item={'token_start':f'{start:04X}', 'token_end':f'{pos:04X}', 'tokens':raw_tokens, 'deferred_in_game':True,
                  'outcome':'ok' if ret['z'] else 'syntax_error',
                  'parser_returns':log.get('parser_returns',[]), 'controls':log.get('controls',[]),
                  'mode':child.memory[0xA024], 'nodes':[]}
            if ret['z']:
                item['nodes']=self.nodes(child,self.word(child,head+5))
            result.append(item)
        return result

    def reset(self):
        self.context=self.context_text=self.last_buffer=None

    def analyse(self, text, continue_group=None):
        result={'input':text, 'outcome':None, 'units':[], 'controls':[],
                'scope':'syntax_only_original_z80', 'semantic_checks_performed':False}
        original_text=text
        # £ nel charset Spectrum ha il codice 60 (backtick ASCII).
        text=text.replace('£','`')
        if not text.isascii() or any(ord(c)<32 for c in text) or len(text)>70:
            return dict(result,outcome='tool_limit',message='Usare al massimo 70 caratteri ASCII stampabili (oppure £).')
        if text.startswith('@'):
            if text.rstrip()!='@':
                return dict(result,outcome='tool_limit',message='Usare @ da solo: la ripetizione termina immediatamente la lettura del comando.')
            text='@'
        if continue_group not in (None,1,2):
            return dict(result,outcome='tool_limit',message='Gruppo di continuazione: 1 oppure 2.')
        if continue_group and not self.context:
            return dict(result,outcome='no_context',message='Manca un comando precedente valido da completare.')
        if text=='@' and self.last_buffer is None:
            return dict(result,outcome='no_context',message='Nessun comando precedente da ripetere.')
        sim=self.new_sim(self.context if continue_group else None)
        m=sim.memory;R=self.R
        if self.last_buffer is not None:
            m[0x5B00:0x5B81]=self.last_buffer
        log={}
        pending_context=None
        try:
            if continue_group:
                result['continuation']={'group':continue_group,'base_command':self.context_text,
                                        'synthetic_context':True,'a01b':f'{8 if continue_group==1 else 18:02X}'}
                sim.registers[R.A]=8 if continue_group==1 else 18
                result['continuation']['before_nodes']=self.nodes(sim,self.word(sim,0x9FF2))
                self.call(sim,0xB5B6,log=log)
            self.call(sim,0xD6C1,keys=list(text.upper().encode())+[13],log=log)
            self.last_buffer=m[0x5B00:0x5B81]
            result['normalised']=bytes(self.last_buffer).split(b'\r')[0].decode('latin1')
            if text=='@':
                result['repeated']=not bool(continue_group)
                if continue_group:result['editor_note']='@ viene ignorato durante una continuazione; rimane il solo Invio.'
            self.put(sim,0xD6BD,0x5B81)
            ret=self.call(sim,0xD6CE,log=log)
            result['lexemes']=log.get('lexemes',[])
            if ret['z']:
                self.call(sim,0xD6E5,log=log)
                result['outcome']='lexical_error'
            else:
                self.call(sim,0xD719,log=log)
                result['tokens']=self.audit.tokens(m[0x5B81:0x5BE1])
                for _ in range(40):
                    start=self.word(sim,0xD6BD)
                    if m[start]==0xC0:break
                    unit_log={}
                    ret=self.call(sim,0xD780,log=unit_log)
                    end=self.word(sim,0xD6BD)
                    returns=unit_log.get('parser_returns',[])
                    code=returns[-1]['a'] if returns else None
                    nodes=self.nodes(sim,self.word(sim,0x9FF2))
                    unit={'start':f'{start:04X}','next':f'{end:04X}','mode':m[0xA024],
                          'parser_code':code,'nodes':nodes,'controls':unit_log.get('controls',[]),
                          'parser_returns':returns,'quotes':[]}
                    result['units'].append(unit)
                    result['controls']+=unit['controls']
                    log.setdefault('lower',[]).extend(unit_log.get('lower',[]))
                    if code==1:
                        result['outcome']='syntax_error';break
                    unit['quotes']=self.quotes(sim)
                    if any(q['outcome']!='ok' for q in unit['quotes']):
                        result['outcome']='quoted_syntax_error';break
                    # Libera la lista degli indirizzi di citazione, non i token.
                    sim.registers[R.IXh]=self.word(sim,0x9FEC)>>8
                    sim.registers[R.IXl]=self.word(sim,0x9FEC)&255
                    self.call(sim,0xA1AF)
                    self.put(sim,0x9FEC,0)
                    if nodes:
                        pending_context=self.freeze(sim)
                    # Lista osservata e poi liberata; nessuna azione del mondo.
                    self.call(sim,0xD88A)
                    if end<=start:
                        raise ProbeLimit('Il parser non avanza al token successivo')
                else:raise ProbeLimit('Troppe unità sintattiche')
                if result['outcome'] is None:
                    result['outcome']='ok' if any(u['nodes'] or u['controls'] for u in result['units']) else 'empty'
        except (ProbeLimit,IndexError,ValueError) as exc:
            result['outcome']='undetermined';result['message']=str(exc)
        if result['outcome']=='ok' and pending_context:
            self.context=pending_context
            self.context_text=result.get('normalised',original_text)
        result['lower_output']=''.join(map(chr,log.get('lower',[])))
        result['controls']+=log.get('controls',[])
        return result

CLASS_NAMES = {'00':'modificatore verbale','10':'relazione','20':'direzione',
               '30':'verbo','40':'verbo di movimento','50':'nome/referente',
               '60':'qualificatore','70':'preposizione','80':'articolo/ausiliare',
               '90':'speciale','A0':'coordinazione','B0':'fine frase',
               'C0':'fine riga','D0':'sconosciuto','E0':'verbo di affermazione',
               'F0':'orario/denaro'}

def describe_ref(ref):
    if not ref:return '—'
    if ref.get('literal')=='time':
        suffix='' if ref['period']=='unspecified' else ' '+ref['period']
        return f"orario {ref['hour']:02d}:{ref['minute']:02d}{suffix}"
    if ref.get('literal')=='money':
        return f"£{ref['pounds']} {ref['shillings']}s {ref['remaining_pence']}d ({ref['pence']} pence)"
    return ref.get('word','').upper() if ref.get('word') else '$'+ref['raw']+' (riferimento non identificato)'

def describe_node(node, indent='  ', details=False):
    title='Esclusione' if node['exclusion'] else 'Verbo/predicato: '+describe_ref(node['verb'])
    lines=[indent+title+(' — ALL (insieme da risolvere nel gioco)' if node['all'] else '')]
    if node['verb_modifier']:
        lines.append(indent+'  Modificatore verbale: '+describe_ref(node['verb_modifier']))
    subject=node['subject']
    if subject['he_flag'] or subject['it_they_flag'] or subject['referent'] or subject['qualifiers']:
        label='HE (referente da risolvere)' if subject['he_flag'] else 'IT/THEY (referente da risolvere)' if subject['it_they_flag'] else describe_ref(subject['referent'])
        if subject['qualifiers']:label+='; qualificatori: '+', '.join(map(describe_ref,subject['qualifiers']))
        lines.append(indent+'  Soggetto: '+label)
    for i,group in enumerate(node['groups'],1):
        if not any(group.values()):continue
        label=describe_ref(group['referent'])
        if group['relations']:label=' '.join(map(describe_ref,group['relations']))+' '+label
        if group['qualifiers']:label+='; qualificatori: '+', '.join(map(describe_ref,group['qualifiers']))
        lines.append(indent+f'  Gruppo nominale {i}: '+label)
    if details:lines.append(indent+'  Nodo $'+node['address']+': '+node['raw'])
    return lines

def format_result(result, details=False):
    outcome=result['outcome']
    headers={'ok':'Sintassi accettata. Nessuna azione del gioco eseguita.',
             'lexical_error':'Errore lessicale: parola o literal non riconosciuto.',
             'syntax_error':'Errore sintattico: WHAT ?',
             'quoted_syntax_error':'Errore sintattico nel contenuto di una citazione.',
             'empty':'Riga vuota o senza una nuova azione.',
             'undetermined':'Analisi non conclusa.', 'tool_limit':'Limite dello strumento.',
             'no_context':'Contesto non disponibile.'}
    lines=[headers.get(outcome,outcome)]
    if result.get('message'):lines.append(result['message'])
    if 'normalised' in result:lines.append('Riga normalizzata: '+result['normalised'])
    if result.get('editor_note'):lines.append(result['editor_note'])
    if result.get('repeated'):lines.append('Ripetizione tramite @ della riga precedente.')
    if result.get('continuation'):
        c=result['continuation'];lines.append(f"Continuazione simulata del gruppo {c['group']} di: {c['base_command']}")
    lexemes=result.get('lexemes',[])
    if lexemes:
        lines.append('Riconoscimento:')
        for x in lexemes:
            if x['type']=='C0':continue
            canonical=x['canonical']
            desc=describe_ref(canonical) if canonical else ('$'+x['value'] if x['type']=='F0' else '—')
            label=CLASS_NAMES.get(x['type'],x['type'])
            lines.append(f"  {x['text']!r} → {desc} [{label}]"+(f" tipo ${x['type']}, valore ${x['value']}" if details else ''))
    if outcome=='lexical_error':
        original=result.get('lower_output','')
        pos=original.find('I DO NOT KNOW THE WORD')
        if pos>=0:lines.append('Messaggio originale: '+original[pos:].split('\r')[0])
    for i,unit in enumerate(result.get('units',[]),1):
        lines.append(f"Unità {i}: modo finale {unit['mode']} ({'affermazioni' if unit['mode']==2 else 'comandi'}), esito parser {unit['parser_code']}.")
        if unit['parser_code']==1:
            lines.append('  WHAT ? — questa unità non è accettata.')
        for node in unit['nodes']:lines+=describe_node(node,details=details)
        for j,quote in enumerate(unit['quotes'],1):
            lines.append(f"  Citazione {j}: {'accettata' if quote['outcome']=='ok' else 'errore'}, modo finale {quote['mode']}.")
            lines.append('    Verifica anticipata del contenuto che il gioco analizza in seguito.')
            for node in quote['nodes']:lines+=describe_node(node,'    ',details)
            if quote.get('controls'):lines.append('    Handler di controllo nel contenuto: '+', '.join(quote['controls'])+' (solo nella macchina isolata).')
            if quote['outcome']!='ok':lines.append('    Il parser della citazione restituisce errore; il comando esterno da solo era valido.')
    if result.get('controls'):
        lines.append('Handler di controllo attraversati: '+', '.join(result['controls'])+'. Effetti confinati alla macchina di analisi; nessun nastro/file/stampante.')
    if outcome=='ok':
        c=result.get('continuation')
        nodes=[n for u in result['units'] for n in u['nodes']]
        if c and nodes and c['before_nodes'] and nodes[0]['raw']==c['before_nodes'][0]['raw']:
            lines.append('La risposta non ha cambiato il nodo: i campi già valorizzati sono stati conservati.')
        lines.append('Da risolvere nel gioco: identità degli oggetti/pronomi, disponibilità, destinatari e possibilità di eseguire l’azione.')
    elif any(u['nodes'] for u in result.get('units',[])):
        lines.append('Le strutture mostrate prima dell’errore sono risultati parziali; non è stata eseguita alcuna azione.')
    return '\n'.join(lines)

HELP = '''Scrivi un comando di Sherlock, per esempio:
  GIVE BOOK TO WATSON
  TELL WATSON "WATSON KILLED YOU"
  TAKE ALL BUT BOOK

Comandi dello strumento:
  /continua 1 WATSONS   completa il gruppo 1 del precedente comando valido
  /continua 2 HEAVY     completa il gruppo 2 (contesto di domanda simulato)
  /dettagli            mostra/nasconde tipi, offset e byte dei nodi
  /json                mostra l'ultima analisi completa in JSON
  /reset               dimentica contesto e riga ripetibile
  /aiuto               mostra questo testo
  /esci                termina (QUIT resta un comando del gioco da analizzare)

@ ripete la riga precedente. Max 70 caratteri; £ è supportato.
Il programma usa lo Z80 originale tramite SkoolKit. Non esegue il mondo di gioco.
'''

def main():
    cli=argparse.ArgumentParser(description=__doc__)
    cli.add_argument('--project',type=Path,help='Cartella Sherlock rebuild')
    cli.add_argument('--command',help='Analizza un comando ed esce; altrimenti apre il prompt')
    cli.add_argument('--base',help='Comando base per una continuazione in modalità non interattiva')
    cli.add_argument('--continue-group',type=int,choices=(1,2))
    cli.add_argument('--json',action='store_true',help='Output JSON per --command')
    cli.add_argument('--details',action='store_true')
    args=cli.parse_args()
    if args.continue_group and (args.command is None or not args.base):
        cli.error('--continue-group richiede --base e --command')
    if args.json and args.command is None:cli.error('--json richiede --command; nel prompt usare /json')
    try:engine=SherlockParser(args.project)
    except (OSError,ValueError,ImportError) as exc:
        cli.exit(2,f'Impossibile caricare progetto/SkoolKit: {exc}\nUsare --project con la cartella Sherlock rebuild.\n')
    if args.base:
        base=engine.analyse(args.base)
        if base['outcome']!='ok':cli.exit(2,'Il comando base non è valido:\n'+format_result(base)+'\n')
    if args.command is not None:
        result=engine.analyse(args.command,args.continue_group)
        print(json.dumps(result,ensure_ascii=False,indent=2) if args.json else format_result(result,args.details))
        return
    print('Sherlock — laboratorio del parser\n'+HELP)
    last=None;details=args.details
    while True:
        try:line=input('Sherlock> ')
        except (EOFError,KeyboardInterrupt):print();break
        if line=='/esci':break
        if line=='/aiuto':print(HELP);continue
        if line=='/reset':engine.reset();last=None;print('Contesto azzerato.');continue
        if line=='/dettagli':details=not details;print('Dettagli '+('attivi.' if details else 'disattivati.'));continue
        if line=='/json':print(json.dumps(last,ensure_ascii=False,indent=2) if last else 'Nessuna analisi.');continue
        group=None
        if line.startswith('/continua '):
            fields=line.split(' ',2)
            if len(fields)!=3 or fields[1] not in ('1','2'):
                print('Uso: /continua 1 RISPOSTA oppure /continua 2 RISPOSTA');continue
            group=int(fields[1]);line=fields[2]
        elif line.startswith('/'):
            print('Comando dello strumento sconosciuto; usare /aiuto.');continue
        try:last=engine.analyse(line,group)
        except KeyboardInterrupt:print('\nAnalisi interrotta.');continue
        print(format_result(last,details)+'\n')

if __name__=='__main__':main()
