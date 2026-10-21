#!/usr/bin/env python3
"""Regressioni, confronto col percorso reale e prove del parser interattivo."""
from pathlib import Path
import argparse
import hashlib
import json
import subprocess
import sys
from sherlock_parser import SherlockParser,format_result


def check(project,output):
    output.mkdir(parents=True,exist_ok=True)
    engine=SherlockParser(project)
    records=[]
    expected={
      'LOOK':'ok','TAKE BOOK':'ok','TAKE BOOKS':'ok','TAKE THE':'ok',
      'XYZZY':'lexical_error','TAKE XYZZY':'lexical_error','LOOK 60':'lexical_error',
      'TAKE TAKE':'syntax_error','TAKE THE THE BOOK':'syntax_error','THE':'syntax_error',
      'BOOK':'syntax_error','':'empty',
      'LOOK. THE':'syntax_error','LOOK THEN THE':'syntax_error','LOOK, THE':'ok',
      'TAKE BOOK AND DROP GUN':'ok','TAKE BOOK AND GUN':'ok',
      'TAKE ALL BUT BOOK':'ok','TAKE EVERYTHING EXCEPT BOOK':'ok',
      'TAKE BOOK EXCEPT GUN':'syntax_error','ALL':'syntax_error','TAKE ALL ALL':'syntax_error',
      'HE KILLED YOU':'ok','IT IS BOOK':'ok','THEY HAD GUN':'ok',
      'WATSON KILLED YOU':'syntax_error','HE HAD BOOK AND GUN':'ok',
      'HE HAD BOOK THEREFORE IT IS GUN':'ok',
      'TELL WATSON "LOOK"':'ok','TELL WATSON "THE"':'quoted_syntax_error',
      'TELL WATSON "XYZZY"':'lexical_error',
      'TELL WATSON "WATSON KILLED YOU"':'ok',
      'TELL WATSON "WATSON KILLED YOU BECAUSE HE HAD GUN"':'ok',
      'TELL WATSON "WATSON KILLED YOU, THAT HAD GUN"':'ok',
      'TELL WATSON "TAKE BOOK. DROP BOOK"':'ok',
      '"LOOK"':'ok','"TAKE BOOK" "DROP BOOK"':'ok','""':'ok',
      '"LOOK. WATSON KILLED YOU"':'quoted_syntax_error',
      '"WATSON KILLED YOU. LOOK"':'quoted_syntax_error',
      'TELL WATSON "LOOK':'ok',
      'NO':'syntax_error','SAVE':'ok','LOAD':'ok','QUIT':'ok',
      'PAUSE':'ok','PRINT':'ok','NOPRINT':'ok','SAVE LOOK':'ok','LOOK SAVE':'syntax_error',
      'TAKE 12:30':'ok','TAKE £1':'ok',
      'Z':'undetermined','ZZ':'undetermined','è':'tool_limit','A'*71:'tool_limit',
    }
    by={}
    for text,outcome in expected.items():
        engine.reset()
        result=engine.analyse(text)
        assert result['outcome']==outcome,(text,result)
        records.append(result);by[text]=result
    first=lambda t:by[t]['units'][0]['nodes'][0]
    assert first('TAKE BOOKS')['groups'][0]['referent']['word']=='bookcase'
    assert len(by['TAKE BOOK AND DROP GUN']['units'])==2
    assert len(by['TAKE BOOK AND GUN']['units'][0]['nodes'])==2
    assert first('TAKE ALL BUT BOOK')['all']
    assert by['TAKE ALL BUT BOOK']['units'][0]['nodes'][1]['exclusion']
    assert first('HE KILLED YOU')['subject']['he_flag']
    assert first('IT IS BOOK')['subject']['it_they_flag']
    assert first('THEY HAD GUN')['subject']['it_they_flag']
    q=by['TELL WATSON "WATSON KILLED YOU, THAT HAD GUN"']['units'][0]['quotes'][0]
    assert q['mode']==2 and q['nodes'][0]['subject']['referent']['word']=='watson'
    assert q['nodes'][1]['subject']['referent']['word']=='you'
    assert first('"LOOK"')['verb']['word']=='talk'
    assert by['LOOK SAVE']['controls']==[]
    assert first('TAKE £1')['groups'][0]['referent']['pence']==240
    assert 'WHAT ?' in format_result(by['TAKE TAKE'])
    assert 'non conclusa' in format_result(by['ZZ'])
    # Confronto con le 39 prove precedenti: stessa tokenizzazione e prima unità.
    old=json.loads((Path(project)/'sherlock-analisi/parser/results/commands.json').read_text())
    comparison=[]
    for reference in old:
        engine.reset();now=engine.analyse(reference['input'])
        if reference['tokens_before_parser']:
            assert now.get('tokens')==reference['tokens_before_parser'],reference['input']
        if reference['outcome']=='before_semantics':
            assert [n['raw'] for n in now['units'][0]['nodes']]==[n['bytes'] for n in reference['command_nodes']],reference['input']
        if reference['outcome'] in ('lexical_error','syntax_error'):
            assert now['outcome']==reference['outcome'],reference['input']
        comparison.append({'input':reference['input'],'old':reference['outcome'],'new':now['outcome']})
    # Continuazioni: slot +08 / +12, merge non distruttivo e cambio verbo.
    continuation_cases=[
        ('EXAMINE ARMCHAIR','WATSONS',1,'ok'),
        ('GIVE BOOK TO WATSON','HEAVY',2,'ok'),
        ('TAKE HEAVY BOOK','CLOSED',1,'ok'),
        ('TAKE BOOK','GUN',1,'ok'),
        ('TAKE BOOK','LOOK',1,'ok'),
        ('TAKE BOOK','THE THE',1,'syntax_error'),
        ('TAKE BOOK','@',1,'ok'),
    ]
    continuations=[]
    for base,answer,group,outcome in continuation_cases:
        engine.reset();assert engine.analyse(base)['outcome']=='ok'
        r=engine.analyse(answer,group);assert r['outcome']==outcome,(base,r)
        continuations.append(r)
    assert continuations[0]['units'][0]['nodes'][0]['groups'][0]['qualifiers'][0]['word']=='watsons'
    assert continuations[1]['units'][0]['nodes'][0]['groups'][1]['qualifiers'][0]['word']=='heavy'
    assert len(continuations[2]['units'][0]['nodes'][0]['groups'][0]['qualifiers'])==2
    assert continuations[3]['units'][0]['nodes'][0]['groups'][0]['referent']['word']=='book'
    assert continuations[4]['units'][0]['nodes'][0]['verb']['word']=='look'
    assert not continuations[6]['repeated']
    engine.reset();assert engine.analyse('@')['outcome']=='no_context'
    engine.analyse('LOOK');repeat=engine.analyse('@');assert repeat['outcome']=='ok' and repeat['repeated']
    assert repeat['units'][0]['nodes'][0]['verb']['word']=='look'
    assert engine.analyse('@ ')['repeated']
    assert engine.analyse('@ LOOK')['outcome']=='tool_limit'
    engine.reset();assert engine.analyse('WATSONS',1)['outcome']=='no_context'
    # Il contesto non viene sostituito da una riga solo parzialmente valida.
    engine.analyse('EXAMINE ARMCHAIR');engine.analyse('LOOK. THE')
    assert engine.analyse('WATSONS',1)['units'][0]['nodes'][0]['verb']['word']=='examine'
    # Bilancio buffer: una serie di nomi corti non deve sovrascrivere memoria.
    overflow=engine.analyse(' '.join(['I']*34));assert overflow['outcome']=='undetermined',overflow
    # Flusso reale: il mondo viene attraversato SOLO per ottenere la domanda
    # originale; ci fermiamo prima di eseguire la risposta WATSONS.
    sim=engine.new_sim();m,r,R=sim.memory,sim.registers,engine.R
    keys=list(b'EXAMINE ARMCHAIR\r');phase=0;events=[];lower=[]
    for step in range(1_500_000):
        pc=r[R.PC]
        if pc==0xA536:
            if not keys:
                assert phase==0
                assert m[0xA01B]==8
                events.append({'event':'real_question','a01b':m[0xA01B],
                               'lower':''.join(map(chr,lower)),'pending':engine.nodes(sim,engine.word(sim,0x9FF0))})
                engine.audit.save_snapshot(sim,output/'which-armchair.z80')
                keys=list(b'WATSONS\r');phase=1
            r[R.A],r[R.F]=keys.pop(0),0;r[R.PC]=engine.word(sim,r[R.SP]);r[R.SP]+=2;continue
        if pc==0xC415:
            r[R.A],r[R.F]=32,0;r[R.PC]=engine.word(sim,r[R.SP]);r[R.SP]+=2;continue
        if pc==0xB5B6:events.append({'event':'B5B6','a':r[R.A]})
        if pc==0xC1FD:lower.append(r[R.A])
        if pc==0xD7FC and phase==1:
            nodes=engine.nodes(sim,engine.word(sim,0x9FF2))
            assert nodes[0]['raw']==continuations[0]['units'][0]['nodes'][0]['raw']
            events.append({'event':'merged_before_semantics','nodes':nodes});break
        sim.opcodes[m[r[R.PC]]]()
    else:raise AssertionError('Flusso reale non terminato')
    assert 'which armchair' in events[1]['lower'].lower()
    # B8AA chiamato dall'analizzatore vs B86A, consumatore reale della coda.
    quote_comparisons=[]
    for text in ['TELL WATSON "LOOK"','TELL WATSON "THE"','TELL WATSON "WATSON KILLED YOU"']:
        sim=engine.new_sim();log={}
        engine.call(sim,0xD6C1,keys=list(text.encode())+[13]);engine.put(sim,0xD6BD,0x5B81)
        assert not engine.call(sim,0xD6CE)['z']
        engine.call(sim,0xD719);engine.call(sim,0xD780)
        predicted=engine.quotes(sim)[0]
        sim.registers[R.A]=1;engine.call(sim,0xB86A,log=log)
        actual_return=log['parser_returns'][-1]
        assert actual_return['z']==(predicted['outcome']=='ok')
        if actual_return['z']:
            head=engine.word(sim,0x9FEE)
            actual_nodes=engine.nodes(sim,engine.word(sim,head+5))
            assert [n['raw'] for n in actual_nodes]==[n['raw'] for n in predicted['nodes']]
        quote_comparisons.append({'input':text,'actual':actual_return,'predicted':predicted['outcome']})
    def dump(name,obj):(output/name).write_text(json.dumps(obj,ensure_ascii=False,indent=2)+'\n')
    dump('special-cases.json',records);dump('continuations.json',continuations)
    dump('previous-comparison.json',comparison);dump('real-continuation.json',events)
    dump('quote-consumer-comparison.json',quote_comparisons)
    dump('limits.json',{'overflow':overflow,'repeat':repeat})
    summary={'command_cases':len(records),'continuation_cases':len(continuations),
             'previous_cases_compared':len(comparison),'quote_consumer_comparisons':len(quote_comparisons),
             'real_continuation_matches':True,'buffer_limit_checked':True,
             'z_boundary_stopped_before_invalid_record':True,'failures':0,
             'interactive_source_sha256':hashlib.sha256(Path(__file__).with_name('sherlock_parser.py').read_bytes()).hexdigest()}
    dump('verification-special.json',summary)
    subprocess.run([sys.executable,'-B',str(Path(project)/'skoolkit-10.1/sna2img.py'),'-s','3',str(output/'which-armchair.z80'),str(output/'which-armchair.png')],check=True)
    transcript=[]
    engine.reset()
    for text,group in [('EXAMINE ARMCHAIR',None),('WATSONS',1),('TELL WATSON "WATSON KILLED YOU"',None),('LOOK. THE',None)]:
        transcript.extend(['Sherlock> '+(f'/continua {group} ' if group else '')+text,format_result(engine.analyse(text,group)),''])
    (output/'example-session.txt').write_text('\n'.join(transcript))
    print(json.dumps(summary,indent=2))

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    p.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results-special')
    args=p.parse_args();check(args.project,args.output)
