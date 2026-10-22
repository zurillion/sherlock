#!/usr/bin/env python3
"""Exercise real HTTP sessions, portable saves, invalid loads and controls."""
import argparse,json
from copy import deepcopy
from http.cookiejar import CookieJar
from pathlib import Path
from urllib.error import HTTPError
from urllib.request import build_opener,HTTPCookieProcessor,Request

def verify(url):
 checks=[]
 def client():
  opener=build_opener(HTTPCookieProcessor(CookieJar()))
  def request(path,body=None,status=200):
   req=Request(url+path,data=None if body is None else json.dumps(body).encode(),headers={} if body is None else {'Content-Type':'application/json'})
   try:response=opener.open(req,timeout=60)
   except HTTPError as exc:response=exc
   result=json.loads(response.read());assert response.code==status,(path,response.code,result);return result
  return request
 def check(name,ok):
  assert ok,name;checks.append({'check':name,'passed':True});print('OK:',name,flush=True)
 first,second=client(),client()
 state=first('/api/reset',{'seed':7,'start_mode':'original'})['state']
 check('HTTP reset chooses seed 7 before native boot and retains the original clock',state['seed']==7 and state['start_mode']=='original' and state['clock']['label']=='Mon 08:01am')
 first('/api/command',{'command':'OPEN DOOR'})
 document=first('/api/save',{})['save']
 check('HTTP save preserves a pending native clarification',document['game']['last_analysis']['outcome']=='clarification')
 before=document['machine']
 for _ in range(3):first('/api/state')
 check('Repeated GET /api/state does not change any machine byte/register',first('/api/save',{})['save']['machine']==before)
 second('/api/load',{'save':document})
 actual=first('/api/command',{'command':'YOUR'});replay=second('/api/command',{'command':'YOUR'})
 check('A fresh cookie session resumes the same clarification, output, RNG and CPU',actual==replay and first('/api/save',{})['save']['machine']==second('/api/save',{})['save']['machine'])
 before=first('/api/save',{})['save'];bad=deepcopy(before);bad['sha256']='bad'
 first('/api/load',{'save':bad},400)
 check('Corrupt save is rejected without replacing the live session',first('/api/save',{})['save']==before)
 for seed in (-1,256,1.5,True,'7'):first('/api/reset',{'seed':seed},400)
 check('Invalid seeds are rejected without resetting the session',first('/api/save',{})['save']==before)
 control=first('/api/command',{'command':'SAVE'})
 check('Standalone SAVE exports a snapshot without a game turn',control['save']['machine']==before['machine'] and control['state']['clock']==actual['state']['clock'])
 control=first('/api/start-command',{'command':'LOAD'})
 check('Standalone LOAD requests a file and never becomes QUIT',control['load_requested'] and not control['running'] and not control['state']['game_over'])
 first('/api/command',{'command':'QUIT'})
 recovered=first('/api/load',{'save':document})
 check('A completed game can load an earlier live state',not recovered['state']['game_over'] and recovered['state']['analysis']['outcome']=='clarification')
 # A separate session models restarting/replacing the in-memory server session.
 fresh=client();loaded=fresh('/api/load',{'save':before})
 check('Portable save recovers the seed/startup profile in a new session',loaded['state']['seed']==7 and loaded['state']['start_mode']=='original')
 return {'passed':True,'checks':checks}
if __name__=='__main__':
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--url',default='http://127.0.0.1:8767');ap.add_argument('--output',type=Path,default=Path(__file__).with_name('results')/'persistence-http-verification.json');a=ap.parse_args();result=verify(a.url);a.output.parent.mkdir(parents=True,exist_ok=True);a.output.write_text(json.dumps(result,indent=2)+'\n')
