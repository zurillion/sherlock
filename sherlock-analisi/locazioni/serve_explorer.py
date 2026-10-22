#!/usr/bin/env python3
"""Avvia l'esploratore locale HTML + parser Z80. Solo 127.0.0.1."""
import argparse,json,secrets
from http.server import HTTPServer,BaseHTTPRequestHandler
from http.cookies import SimpleCookie
from pathlib import Path
from urllib.parse import urlparse
from explorer import Game
from extract_locations import extract

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--project',type=Path,default=Path(__file__).resolve().parents[2]);ap.add_argument('--port',type=int,default=8766);a=ap.parse_args()
    root=Path(__file__).resolve().parent;data=extract(a.project);sessions={}
    pictures={int(f.name.split('-')[0]):f for f in (a.project/'sherlock-analisi/grafica/immagini').glob('[0-9][0-9][0-9]-*-straight.svg')}
    picture_routes={f'/images/{ident:03d}.svg':f for ident,f in pictures.items()}
    public={'rooms':[{k:r[k] for k in ('id','record','name_hint','coordinates','exits','description')} for r in data['rooms']],'edges':data['edges'],'pictures':{ident:f'/images/{ident:03d}.svg' for ident in pictures}}
    class Handler(BaseHTTPRequestHandler):
        def log_message(self,*args):pass
        def reply(self,status,body,kind='application/json; charset=utf-8',cookie=None):
            if not isinstance(body,bytes):body=json.dumps(body,ensure_ascii=False).encode()
            self.send_response(status);self.send_header('Content-Type',kind);self.send_header('Content-Length',str(len(body)));self.send_header('Cache-Control','no-store');self.send_header('X-Content-Type-Options','nosniff')
            if cookie:self.send_header('Set-Cookie',f'sherlock={cookie}; Path=/; HttpOnly; SameSite=Strict')
            self.end_headers();self.wfile.write(body)
        def game(self):
            cookies=SimpleCookie();cookies.load(self.headers.get('Cookie',''));token=cookies['sherlock'].value if 'sherlock' in cookies else None
            if token not in sessions:
                if len(sessions)>=24:sessions.pop(next(iter(sessions)))
                token=secrets.token_urlsafe(24);sessions[token]=Game(a.project,data)
            return token,sessions[token]
        def do_GET(self):
            path=urlparse(self.path).path
            if path in picture_routes:return self.reply(200,picture_routes[path].read_bytes(),'image/svg+xml')
            if path=='/api/data':return self.reply(200,public)
            if path=='/api/state':
                token,game=self.game()
                if game.command_job is None and not game.world.ended:
                    scene=game.world.scene(full=not game.world.call(0xd078)['carry'])
                    game.initial=scene['text'];game.last_listed=scene['listed']
                return self.reply(200,game.state(),cookie=token)
            files={'/':('index.html','text/html; charset=utf-8'),'/index.html':('index.html','text/html; charset=utf-8'),'/style.css':('style.css','text/css; charset=utf-8'),'/app.js':('app.js','text/javascript; charset=utf-8')}
            if path not in files:return self.reply(404,{'error':'Not found'})
            file,kind=files[path];self.reply(200,(root/file).read_bytes(),kind)
        def do_POST(self):
            origin=self.headers.get('Origin')
            if origin and origin!=f'http://{self.headers.get("Host")}':return self.reply(403,{'error':'Origin not allowed'})
            try:
                length=int(self.headers.get('Content-Length','0'))
                if not 0<length<=4096:return self.reply(413,{'error':'Request too large'})
                body=json.loads(self.rfile.read(length));token,game=self.game()
                if self.path=='/api/command':
                    if not isinstance(body.get('command'),str):raise ValueError('Missing command')
                    result=game.command(body['command'])
                elif self.path=='/api/start-command':
                    if not isinstance(body.get('command'),str):raise ValueError('Missing command')
                    result=game.start_command(body['command'])
                elif self.path=='/api/continue-command':
                    result=game.continue_command(body.get('job'),body.get('interrupt') is True)
                elif self.path=='/api/teleport':result=game.teleport(body.get('room'))
                elif self.path=='/api/reset':
                    game=Game(a.project,data);sessions[token]=game;result=game.result([{'kind':'narrative','text':game.opening,'image_room':game.world.room}])
                else:return self.reply(404,{'error':'Not found'})
                self.reply(200,result,cookie=token)
            except (ValueError,TypeError) as exc:self.reply(400,{'error':str(exc)})
            except Exception as exc:
                print('Errore richiesta:',repr(exc),flush=True);self.reply(500,{'error':'Analysis could not be completed: '+str(exc)})
    server=HTTPServer(('127.0.0.1',a.port),Handler)
    print(f'Esploratore Sherlock: http://127.0.0.1:{server.server_port}/',flush=True)
    try:server.serve_forever()
    except KeyboardInterrupt:pass
    finally:server.server_close()
if __name__=='__main__':main()
