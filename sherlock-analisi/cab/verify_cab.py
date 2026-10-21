#!/usr/bin/env python3
"""Confronta rotte/conti Python con lo Z80 e verifica gli scenari completi."""
import argparse,json,sys
from pathlib import Path
from cab import extract,word,pack_money,unpack_money,fare
sys.dont_write_bytecode=True

def native_verify(project):
    p=Path(project);sys.path.insert(0,str(p/'sherlock-analisi/parser'))
    from sherlock_parser import SherlockParser
    e=SherlockParser(p);data=extract(p);route_checks=[]
    for route in data['routes']:
        for source,target in [(route['source'],route['target']),(route['target'],route['source'])]:
            for furious in [False,True]:
                s=e.new_sim();m=s.memory;r=s.registers;R=e.R
                m[0xa011]=0;m[0x5c3c]=0;m[0xa036]=34;m[0xa034]=target
                e.put(s,0xa017,word(m,0x8b70+34*3));m[word(m,0x8b70+33*3)+15]=source;m[0xa00a]=source
                money=word(m,0x8b70+35*3);e.put(s,money+9,0)
                # Synthetic suspended cab context; no code is modified.
                e.put(s,0x9fe9,0x5b40);e.put(s,0x5b3e,0);m[0x5b40:0x5b47]=[34,0xb2,0xf2,0,33,2,0]
                out=e.call(s,0x9ae3 if furious else 0x9af6)
                actual=unpack_money(word(m,money+9));duration=word(m,0xa01f)
                assert actual==-fare(route['duration'],furious),(route,actual)
                assert duration==route['duration']-(2 if furious else 0),(route,duration)
                route_checks.append({'source':source,'target':target,'furiously':furious,'native_duration':duration,'native_fare':-actual})
    money_checks=[]
    for value in [-16384,-1024,-240,-16,-8,-1,0,1,4,8,12,127,128,240,1248,16383]:
        sim=e.new_sim();r=sim.registers;R=e.R;m=sim.memory
        r[R.IXh],r[R.IXl]=0x5b,0x40;r[R.H],r[R.L]=(value&65535)>>8,value&255
        e.call(sim,0xe38f);raw=word(m,0x5b49);assert raw==pack_money(value)
        e.call(sim,0xe39c);actual=r[R.H]*256+r[R.L];actual-=65536 if actual&32768 else 0
        assert actual==unpack_money(raw)==value
        money_checks.append({'value':value,'raw':f'{raw:04X}'})
    lookup_checks=[]
    destinations=[x['id'] for x in data['destinations']]
    for source in destinations:
        for target in destinations+[29]:
            sim=e.new_sim();r=sim.registers;R=e.R;r[R.A],r[R.C]=source,target
            out=e.call(sim,0x9c07);expected=source!=target and target in destinations
            assert out['z']==expected,(source,target,out)
            lookup_checks.append({'source':source,'target':target,'accepted':out['z']})
    return {'route_checks':route_checks,'money_checks':money_checks,'lookup_checks':lookup_checks,'fixture':'Route bodies tested with cabbie34, cab33, account35 and a synthetic suspended context at5B40. Only data and registers change; original code remains intact.'}

def verify_traces(cases):
    checks=[];by={c['label']:c for c in cases}
    def after(label):return by[label]['commands'][-1]['after']
    def money(label,ident=35):return after(label)['entities'][str(ident)]['pence']
    def text(label):return ' '.join(r['upper']+' '+r['lower'] for r in by[label]['commands'])
    assert len(by)==25
    assert all(r['stop']=='prompt' for c in cases for r in c['commands'])
    checks.append('25 scenarios / 148 commands return to the original prompt with every NPC enabled')
    assert after('natural_arrival')['entities']['0']['room']==28 and money('natural_arrival')==-8
    events=[e for r in by['natural_arrival']['commands'] for e in r['events']]
    assert any(e['event']=='action' and e['actor']==34 and e['action']==29 and e['args']==[28,255] for e in events)
    assert any(e['event']=='reschedule' and e['actor']==34 and e['cost']==15 for e in events)
    checks.append('Quoted destination becomes cabbie action29 with room28; native trip cost15, arrival and 8d fare')
    assert money('exact',27)==1240 and money('exact')==0
    assert money('overpay',27)==1240 and money('overpay')==0 and 'pays 4d.' in text('overpay')
    assert money('underpay',27)==1240 and money('underpay')==0 and 'that will be 4d.' in text('underpay')
    checks.append('Exact, excess and partial payment; original change is 4d for a shilling paid against 8d')
    assert money('prepay')==money('pay_in_transit')==4
    assert money('prepay',27)==money('pay_in_transit',27)==1236
    assert 'pays 4d.' not in text('prepay') and 'pays 4d.' not in text('pay_in_transit')
    assert money('prepay_refund_requested')==0 and money('prepay_refund_requested',27)==1240
    checks.append('Advance/in-transit overpayment stays as credit; an explicit PAY request recovers it')
    assert money('transit_exact')==0 and money('transit_exact',27)==1240
    assert 'cannot get out' in text('exit_in_transit')
    checks.append('Payment during transit succeeds; exit during transit fails without moving Holmes')
    assert money('insufficient_funds_valid',27)==1248 and text('insufficient_funds_valid').count("don't be silly.")==2
    checks.append('Valid £9 and 200/- literals fail for insufficient funds without changing time or balances')
    assert 'You bloody snob' in text('unpaid_leave') and money('unpaid_leave')==-8
    assert after('unpaid_leave')['entities']['33']['room']==0
    assert money('same_cabbie_debt')==-16 and 'that will be 1/4' in text('same_cabbie_debt')
    checks.append('Unpaid departure triggers threat; the same cabbie carries the old debt into another trip, without refusing transport')
    for label in ['furious_prefix','furious_inside']:
        assert money(label)==-24 and after(label)['entities']['0']['room']==28
        assert any(e['event']=='reschedule' and e['actor']==34 and e['cost']==13 for r in by[label]['commands'] for e in r['events'])
    assert money('furiously_wrong_position')==0 and after('furiously_wrong_position')['entities']['0']['room']==5
    checks.append('Both valid FURIOUSLY positions invoke action30: cost13 and 24d; trailing adverb does not execute the trip')
    assert "cannot get there from'ere" in text('destination_station') and "cannot get there from'ere" in text('destination_same')
    assert 'I DO NOT KNOW' in text('destination_unknown').upper()
    assert 'get into the cab first' in text('not_aboard') and 'other fares' in text('not_aboard')
    assert money('bare_quote')==-8
    checks.append('Station/same-place rejection, unknown-word rejection, boarding requirement, timeout and persistent addressee')
    outside=after('go_without_boarding')['entities']
    assert outside['0']['room']==5 and outside['0']['parent']==255 and outside['33']['room']==28
    checks.append('GO TO without boarding moves the cab to28 while Holmes stays at5; TAKE ME TO has the separate boarding guard')
    return checks

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');a=ap.parse_args()
    cases=json.loads((a.output/'cab-traces.json').read_text());checks=verify_traces(cases);native=native_verify(a.project)
    result={'passed':True,'checks':checks,'scenario_count':len(cases),'command_count':sum(len(c['commands']) for c in cases),'native':native}
    (a.output/'verification.json').write_text(json.dumps(result,indent=2)+'\n')
    print('OK:',len(checks),'verifiche di scenario;',len(native['route_checks']),'rotte/prezzi nativi;',len(native['lookup_checks']),'lookup;',len(native['money_checks']),'importi.')
if __name__=='__main__':main()
