#!/usr/bin/env python3
"""Corsa e dialoghi sullo Z80 originale, con tutti gli NPC attivi."""
import argparse,json,sys
from pathlib import Path
from cab import word,unpack_money
sys.dont_write_bytecode=True
class CabProbe:
    def __init__(self,project,seed=1):
        self.project=Path(project);sys.path.insert(0,str(self.project/'sherlock-analisi/ai'))
        from trace_npc_ai import Probe
        self.q=Probe(self.project,seed);self.m=self.q.m
    def state(self):
        m=self.m;result={'tick':word(m,0x9fdd),'calendar':list(m[0x9fdf:0x9fe3]),'entities':{}}
        for i in [0,2,27,28,30,31,32,33,34,35]:
            p=word(m,0x8b70+3*i);obj={'parent':m[p+1],'room':m[p+15],'visible':bool(m[p+5]&128)}
            if m[p+6]&32:obj.update(raw_money=f'{word(m,p+9):04X}',pence=unpack_money(word(m,p+9)))
            result['entities'][str(i)]=obj
        result['cabbies']=[]
        for row in range(0x9860,0x9920,8):
            if m[row] in (31,34):result['cabbies'].append({'id':m[row],'script':f'{word(m,row+1):04X}','saved':list(m[row+3:row+6]),'due':word(m,row+6)})
        return result
    def save(self):return self.m[:],self.q.r[:]
    def restore(self,snapshot):self.m[:]=snapshot[0];self.q.r[:]=snapshot[1]
    def command(self,text):
        encoded=text.replace('£','`')
        if len(encoded)>70 or not encoded.isascii() or any(ord(c)<32 for c in encoded):raise ValueError('Usare al massimo 70 caratteri ASCII stampabili, oppure £.')
        before=self.state();out=self.q.command(encoded)
        events=[e for e in out['events'] if e['actor'] in (0,31,34) and (e['event']!='rule' or e.get('address') in {'9AE1','9AF4','9C41','E08D','E2C7','E370','E3EA','E432','E506','E63E','E654','E66F','E6BC','E6E6','E70E'})]
        return {'command':text,'stop':out['stop'],'steps':out['steps'],'before':before,'after':self.state(),'upper':' '.join(out['upper'].split()).replace('`','£'),'lower':' '.join(out['lower'].split()).replace('`','£'),'events':events}

def run(q,commands):
    rows=[]
    for c in commands:
        r=q.command(c);rows.append(r)
        print(f"{c} [{r['before']['tick']} -> {r['after']['tick']}] {r['upper']} {r['lower']}".rstrip(),flush=True)
        if r['stop']!='prompt':raise RuntimeError(f"{c}: {r['stop']}")
    return rows
NATURAL=['OPEN YOUR DOOR','WEST','DOWN','OPEN FRONT DOOR','SOUTH','HAIL CAB','GET INTO CAB']
def suite(project):
    q=CabProbe(project);rows=run(q,NATURAL+['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3)
    arrival=q.save();cases=[{'label':'natural_arrival','fixture':None,'commands':rows}]
    for label,commands in {
        'exact':['PAY 8D TO CABBIE','GET OUT OF CAB','WAIT'],
        'overpay':['GET OUT OF CAB','PAY 1/- TO CABBIE','WAIT'],
        'underpay':['PAY 4D TO CABBIE','WAIT','PAY 4D TO CABBIE','GET OUT OF CAB','WAIT'],
        'unpaid_wait':['WAIT']*5,
        'unpaid_leave':['GET OUT OF CAB','EAST']+['WAIT']*3,
        'currency_99_literal_rejected':['PAY £99 TO CABBIE'],
    }.items():
        q.restore(arrival);cases.append({'label':label,'fixture':'Ramo dallo stesso arrivo naturale, memoria e registri conservati senza alterazioni.','commands':run(q,commands)})
    q=CabProbe(project);pre=run(q,NATURAL);aboard=q.save()
    for label,commands in {
        'prepay':['PAY 1/- TO CABBIE','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3,
        'pay_in_transit':['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"','PAY 1/- TO CABBIE']+['WAIT']*3,
        'destination_station':['SAY TO CABBIE "GO TO VICTORIA STATION"'],
        'destination_unknown':['SAY TO CABBIE "GO TO XYZZY"'],
        'destination_same':['SAY TO CABBIE "GO TO BAKER STREET"'],
        'take_me':['SAY TO CABBIE "TAKE ME TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3,
        'furiously_wrong_position':['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD FURIOUSLY"']+['WAIT']*3,
        'exit_in_transit':['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"','GET OUT OF CAB']+['WAIT']*3,
    }.items():
        q.restore(aboard);cases.append({'label':label,'fixture':'Ramo dalla salita naturale, memoria e registri conservati.','commands':run(q,commands)})
    q=CabProbe(project);rows=run(q,NATURAL[:-1]+['SAY TO CABBIE "TAKE ME TO BUCKINGHAM PALACE ROAD"','WAIT','WAIT','WAIT'])
    cases.append({'label':'not_aboard','fixture':None,'commands':rows})
    q=CabProbe(project);run(q,NATURAL);aboard=q.save()
    for label,commands in {
        'furious_prefix':['SAY TO CABBIE "FURIOUSLY GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3,
        'furious_inside':['SAY TO CABBIE "GO FURIOUSLY TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3,
        'prepay_refund_requested':['PAY 1/- TO CABBIE','SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*5+['SAY TO CABBIE "PAY 4D TO ME"','GET OUT OF CAB','WAIT'],
        'transit_exact':['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"','PAY 8D TO CABBIE']+['WAIT']*3+['GET OUT OF CAB','WAIT'],
        'insufficient_funds_valid':['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3+['PAY £9 TO CABBIE','PAY 200/- TO CABBIE'],
        'bare_quote':['SAY TO CABBIE "WAIT"','"GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3,
    }.items():
        q.restore(aboard);cases.append({'label':label,'fixture':'Ramo dalla salita naturale','commands':run(q,commands)})
    q.restore(aboard);rows=run(q,['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3+['GET OUT OF CAB','EAST','WAIT','WEST','HAIL CAB','GET INTO CAB','WAIT'])
    cases.append({'label':'meet_again','fixture':None,'commands':rows})
    q=CabProbe(project);rows=run(q,NATURAL+['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3+['GET OUT OF CAB','EAST','WAIT','WEST'])
    q.q.relocate(30,10)
    rows+=run(q,['HAIL CAB','GET INTO CAB','WAIT','SAY TO CABBIE "GO TO BAKER STREET"']+['WAIT']*3)
    cases.append({'label':'same_cabbie_debt','fixture':'Dopo la fuga e il ritorno naturale, solo il cab30 e i suoi figli sono ricollocati in10 per rendere selezionabile soltanto il cab33. Nessuna modifica al cab33, cocchiere34 o conto35.','commands':rows})
    q=CabProbe(project);rows=run(q,NATURAL[:-1]+['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3)
    cases.append({'label':'go_without_boarding','fixture':None,'commands':rows})
    return cases

def write_report(cases,output):
    lines=['# Prove del servizio cab sullo Z80 originale','','Tutti gli attori sono attivi. I rami riprendono memoria e registri dello stesso checkpoint naturale. Un solo scenario ricolloca esplicitamente il cab alternativo: vedere la fixture. Tick e importi in pence. Testo originale con spaziatura normalizzata.','']
    for case in cases:
        lines+=['## '+case['label'],'',case['fixture'] or 'Nessun ricollocamento o modifica al mondo.','', '| Comando | Tick | Holmes: stanza / genitore | Denaro Holmes | Conto cabbie34 |', '|---|---|---|---:|---:|']
        for r in case['commands']:
            st=r['after'];entities=st['entities'];player=entities['0']
            lines.append(f"| `{r['command']}` | {r['before']['tick']} → {st['tick']} | {player['room']} / {player['parent']} | {entities['27']['pence']} | {entities['35']['pence']} |")
        lines+=['']
        for r in case['commands']:
            if r['upper'] and r['upper']!='You wait.':lines+=['`'+r['command']+'`', '', '> '+r['upper'],'']
            if r['lower']:lines+=['Canale inferiore: '+r['lower'],'']
    (output/'PROVE.md').write_text('\n'.join(lines).rstrip()+'\n')

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');ap.add_argument('--suite',action='store_true');ap.add_argument('--interactive',action='store_true');ap.add_argument('--demo',action='store_true',help='Corsa naturale completa con pagamento e resto.');ap.add_argument('--command',action='append',default=[]);a=ap.parse_args();a.output.mkdir(parents=True,exist_ok=True)
    if a.suite:
        rows=suite(a.project);(a.output/'cab-traces.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n');write_report(rows,a.output);return
    if not (a.demo or a.interactive or a.command):ap.error('Scegliere --interactive, --demo, --suite oppure --command.')
    q=CabProbe(a.project);rows=run(q,(NATURAL+['SAY TO CABBIE "GO TO BUCKINGHAM PALACE ROAD"']+['WAIT']*3+['GET OUT OF CAB','PAY 1/- TO CABBIE'] if a.demo else [])+a.command)
    if a.interactive:
        print('Motore Z80 originale, NPC attivi. :state mostra lo stato; :quit esce. Si parte dal prompt originale alle 08:01am. Buon viaggio.')
        while True:
            try:c=input('> ')
            except (EOFError,KeyboardInterrupt):break
            if c==':quit':break
            if c==':state':print(json.dumps(q.state(),ensure_ascii=False,indent=2));continue
            if c.strip():
                try:rows+=run(q,[c])
                except ValueError as exc:print(exc)
    (a.output/'interactive-trace.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n')
if __name__=='__main__':main()
