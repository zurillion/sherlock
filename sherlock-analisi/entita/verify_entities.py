#!/usr/bin/env python3
"""Verifiche differenziali su routine Z80 originali, in macchine isolate."""
import argparse,json,sys
from pathlib import Path
from sherlock_entities import catalog

def main():
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--output',type=Path,default=Path(__file__).resolve().parent/'results');args=ap.parse_args()
 sys.path.insert(0,str(args.project/'sherlock-analisi/parser'))
 from sherlock_parser import SherlockParser
 e=SherlockParser(args.project);R=e.R;data=catalog(args.project);entries=data['entities'];s=e.new_sim();m,r=s.memory,s.registers
 checks=[];deltas=[];rule_count=0
 for obj in entries:
  ident=obj['id'];p=int(obj['record'],16)
  r[R.A]=ident;e.call(s,0xd237);assert r[R.IXh]*256+r[R.IXl]==p
  r[R.A]=ident;ret=e.call(s,0xc8be);assert (not ret['z'])==bool(m[p+5]&64)
  r[R.A]=ident;ret=e.call(s,0xd495);assert ret['a']==(m[p+15] if m[p]==1 else 255)
  # La struttura della coda è verificata sul payload, prima delle mutazioni iniziali.
  raw=bytes.fromhex(obj['raw']);m[p:p+len(raw)]=raw
  marked=bool(obj['rules'] and obj['rules'][0]['action_id']==0)
  for rule in obj['rules']:
   r[R.IXh],r[R.IXl]=p>>8,p&255
   r[R.A]=0 if marked else rule['action_id'];e.call(s,0xd1dc)
   assert r[R.F]&1,rule
   if marked:
    r[R.A]=rule['action_id'];e.call(s,0xd349)
   actual=r[R.IXh]*256+r[R.IXl];assert actual==int(rule['address'],16)
   rule_count+=1
  checks.append({'id':ident,'lookup':'ok','person_bit':'ok','location':'ok','local_rules':len(obj['rules'])})
 # Matching di nomi: dizionario, qualificatori scambiabili e wildcard.
 # A4E0 non consulta né le posizioni né l'azione: testiamo separatamente questa routine.
 queries=[[0x7e,0,0],[0x7e,0x975,0],[0x26e,0x3ed,0x5e8],[0x26e,0x5e8,0x3ed],[0x26e,0,0],[0x846,0,0],[0,0x9f2,0],[0x1370,0,0],[0,0,0]]
 comparisons=[]
 for q in queries:
  for k,v in enumerate(q):e.put(s,0x5b00+2*k,v)
  actual=[];expected=[]
  for obj in entries:
   p=int(obj['record'],16);v=[int(x,16) for x in obj['name_words_raw']]
   match=lambda a,b:a==0 or a&0xfff==b&0xfff
   ok=match(q[0],v[0]) and ((match(q[1],v[1]) and match(q[2],v[2])) or (match(q[1],v[2]) and match(q[2],v[1])))
   if ok:expected.append(obj['id'])
   r[R.H],r[R.L]=0x5b,0;r[R.IYh],r[R.IYl]=(p+7)>>8,(p+7)&255
   ret=e.call(s,0xa4e0)
   if ret['z']:actual.append(obj['id'])
  assert actual==expected,(q,actual,expected)
  comparisons.append({'query_words':[f'{v:04X}' for v in q],'matched_ids':actual})
 # Importi: routine aritmetica originale E39C, anche valori sintetici con segno.
 cash=[]
 for value in (0,1,127,128,1248,8192,16383,-1,-1248,-16384):
  packed=((value//128)&255)*256+(value&127);e.put(s,0x5b09,packed);r[R.IXh],r[R.IXl]=0x5b,0
  e.call(s,0xe39c);decoded=r[R.H]*256+r[R.L];decoded=decoded-65536 if decoded>=32768 else decoded
  assert decoded==value,(value,decoded);cash.append({'packed':f'{packed:04X}','pence':decoded})
 # Confronto payload / snapshot al prompt, senza mescolare le due sorgenti.
 prompt=e.new_sim().memory
 for obj in entries:
  p=int(obj['record'],16);raw=bytes.fromhex(obj['raw'])
  changes=[{'offset':f'{i:02X}','payload':v,'prompt':prompt[p+i]} for i,v in enumerate(raw) if v!=prompt[p+i]]
  if changes:deltas.append({'id':obj['id'],'name':obj['name'],'changes':changes})
 # Il manuale descrive capacità; queste prove restano rigorosamente sintattiche.
 phrases=['PICK THE NOTE UP','QUICKLY COUNT THE MONEY','ATTACK WATSON','DRIVE CAB','SAY TO WATSON "TELL ME ABOUT THE CASE"','OPEN DOOR','TAKE ALL EXCEPT THE LAMP','GO THROUGH THE DOOR AND NORTH','TAKE BEER IN BOTTLE','OPEN DOR']
 manual=[]
 for text in phrases:
  e.reset();out=e.analyse(text);manual.append(out)
 args.output.mkdir(parents=True,exist_ok=True)
 result={'lookup_cases':len(checks),'rule_cases':rule_count,'matching_cases':len(queries)*len(entries),'cash_cases':cash,'record_checks':checks,'matching':comparisons,'payload_vs_prompt':deltas}
 (args.output/'verification.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
 (args.output/'manual-probes.json').write_text(json.dumps(manual,ensure_ascii=False,indent=2)+'\n')
 print(f"OK: {len(checks)} lookup/classificazioni/posizioni; {rule_count} accessi regole; {len(queries)*len(entries)} confronti nominali; {len(cash)} importi")
 print([(x['input'],x['outcome']) for x in manual])
if __name__=='__main__':main()
