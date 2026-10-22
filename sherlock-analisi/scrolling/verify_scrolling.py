#!/usr/bin/env python3
"""Verifica la paginazione e le copie bitmap usando il codice Z80 originale."""
import argparse
import json
from pathlib import Path

from trace_scrolling import ScrollProbe


def bitmap_address(xbyte,y):return 0x4000+((y&0xc0)<<5)+((y&7)<<8)+((y&0x38)<<2)+xbyte


def verify(project,output):
    output=Path(output);data=json.loads((output/'scroll-traces.json').read_text());checks=[]
    def check(name,condition,**details):
        assert condition,(name,details)
        checks.append({'check':name,'passed':True,**details});print('OK:',name,flush=True)
    phases=data['phases'];boot=phases[0];page=next(e for e in boot['events'] if e['event']=='more')
    check('First MORE has 15 text rows, counter 15, 15 completed scrolls and the 16th linefeed pending',
          sum(bool(s) for s in page['screen']['rows'])==15 and page['counter']==15
          and page['feeds']==16 and page['scrolls']==15)
    check('The initial blank CR contributes to the counter before any narrative text',
          next(e for e in boot['events'] if e['event']=='linefeed')['screen']['rows']==['']*18)
    check('MORE precedes the greeting terminal CR; the empty bottom row appears only after acknowledgement',
          page['screen']['rows'][-1]=='says " Good morning Holmes. "'
          and boot['after']['rows'][-1]=='' and boot['after']['counter']==0)
    cr=data['repeated_cr_fixture']['events'];pages=[e['feeds'] for e in cr if e['event']=='more']
    check('Without resets, MORE fires at requests 16, 32 and 48, independently of text or commands',pages==[16,32,48])
    check('Filling exactly 36 columns scrolls automatically; an extra CR counts an empty row',
          data['exact_width_fixture']['after_36_characters']['counter']==1
          and data['exact_width_fixture']['after_extra_CR']['counter']==2)
    for phase in phases:
        count=phase['before']['counter']
        for e in phase['events']:
            assert e['counter']==count,(phase['phase'],e,count)
            if e['event']=='counter_store':count=e['value']
            elif e['event']=='counter_increment':
                assert e['value']==(0 if count==15 else count+1),(phase['phase'],e)
                count=e['value']
            elif e['event']=='more':assert count==15
            assert e['event']!='other_counter_write',e
        assert count==phase['after']['counter']
    check('Every counter observation in the full gameplay traces matches the inferred state machine',True,
          phases=len(phases),linefeeds=sum(e['event']=='linefeed' for p in phases for e in p['events']))
    waits=[p for p in phases if p['phase']=='WAIT']
    check('Separate WAIT inputs reset the parser counter instead of accumulating previous command output',
          all(any(e['event']=='counter_store' and e['pc']=='D71A' and e['value']==0 for e in p['events']) for p in waits)
          and waits[0]['after']['counter']==waits[1]['after']['counter']==2)
    lexical=next(p for p in phases if p['phase']=='OPEN DOR')
    check('An unknown word fails before the reset and lower-pane text does not increment the counter',
          lexical['before']['counter']==lexical['after']['counter']==2
          and not any(e['event'] in ('counter_store','linefeed') for e in lexical['events']))
    syntax=next(p for p in phases if p['phase']=='PICK THE NOTE UP')
    check('A syntactic rejection after lexical preflight does reset the counter',
          syntax['after']['counter']==0 and any(e['event']=='counter_store' and e['pc']=='D71A' for e in syntax['events']))
    multi=next(p for p in phases if p['phase']=='LOOK. LOOK')
    check('LOOK. LOOK shares one reset and crosses MORE inside the second action',
          sum(e['event']=='counter_store' and e['pc']=='D71A' for e in multi['events'])==1
          and sum(e['event']=='linefeed' for e in multi['events'])==28
          and sum(e['event']=='more' for e in multi['events'])==1)
    npc=next(e for p in waits for e in p['events'] if e['event']=='more')
    check('Watson narrative uses the shared counter during a player WAIT',npc['actor']==3)
    idle=next(p for p in phases if p['phase']=='timeout')
    check('The actual 3000-poll inactivity timeout preserves the accumulated counter',
          idle['before']['counter']==2 and idle['after']['counter']==4
          and any(e['event']=='timeout_start' and e['keyboard_counter']==3000 for e in idle['events'])
          and not any(e['event']=='counter_store' and e['pc']=='D71A' for e in idle['events']))
    wide,narrow,clear,full_clear=data['mode_fixtures']
    check('C142 preserves the counter; C129 resets it and selects 18 columns',
          wide['before']['counter']==wide['after']['counter']==7
          and narrow['after']['counter']==0 and narrow['after']['width']==18)
    narrow_events=data['narrow_fixture'];page_index=next(i for i,e in enumerate(narrow_events) if e['event']=='more')
    check('Narrow MORE returns to 36 columns before the pending scroll is performed',
          narrow_events[page_index]['width']==18
          and next(e for e in narrow_events[page_index:] if e['event']=='scroll')['width']==36)
    check('Clear emits 18 CR with per-row resets; a pre-existing 15 can trigger MORE on its first CR',
          sum(e['event']=='linefeed' for e in clear['events'])==18
          and not any(e['event']=='more' for e in clear['events'])
          and sum(e['event']=='more' for e in full_clear['events'])==1
          and clear['after']['counter']==full_clear['after']['counter']==0)
    check('The native MORE enables FLASH on the last status cell',int(page['flash_attribute'],16)&128!=0,
          attribute_address='5A5F',attribute_value=page['flash_attribute'])
    for narrow_mode in (False,True):
        q=ScrollProbe(project);m=q.m;m[0xa008]=0;m[0xc128]=int(narrow_mode)
        # Declared display fixture: distinguish every source byte, with a solid
        # bottom row so the actual space-glyph clearing span can be measured.
        for address in range(0x4000,0x5800):m[address]=(address*13+(address//32))&255
        for y in range(136,144):
            for x in range(32):m[bitmap_address(x,y)]=255
        for address in range(0x5800,0x5b00):m[address]=(address*7)&127
        before=m[:];counter=m[0xa019];q.run(call=0xc316)
        width=16 if narrow_mode else 32
        assert all(m[bitmap_address(x,y)]==before[bitmap_address(x,y+8)] for y in range(136) for x in range(width))
        assert all(m[bitmap_address(x,y)]==before[bitmap_address(x,y)] for y in range(136) for x in range(width,32))
        assert m[0x5800:0x5a20]==(before[0x5800:0x5a20] if narrow_mode else before[0x5820:0x5a40])
        assert all(m[bitmap_address(x,y)]==before[bitmap_address(x,y)] for y in range(144,192) for x in range(32))
        assert m[0x5a40:0x5b00]==before[0x5a40:0x5b00]
        assert m[0xa019]==counter
        cleared=[x for x in range(256) if not m[bitmap_address(x//8,136)]&(128>>(x&7))]
        assert cleared==list(range(2,129 if narrow_mode else 255)),cleared
        check(('Narrow' if narrow_mode else 'Wide')+' physical scroll copies 17 rows of 8 pixels and preserves status/input areas',True,
              copied_bytes_per_scanline=width,bitmap_rows=18,cleared_bottom_x_inclusive=[cleared[0],cleared[-1]],
              counter_unchanged=True,attributes_scrolled=not narrow_mode)
    report={'passed':True,'checks':checks,'scope':'Original code; routine display fixtures are explicitly separate from full gameplay traces.'}
    (output/'verification.json').write_text(json.dumps(report,indent=2)+'\n');return report


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2])
    ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results')
    args=ap.parse_args();report=verify(args.project,args.output);print('OK:',len(report['checks']),'controlli.')
