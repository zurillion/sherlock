// A static file server only. All gameplay runs in the browser JavaScript.
import {createServer} from 'node:http';
import {readFile,stat} from 'node:fs/promises';
import {resolve,dirname,extname,sep} from 'node:path';
import {fileURLToPath} from 'node:url';
const root=resolve(dirname(fileURLToPath(import.meta.url)),'..'),port=Number(process.argv[process.argv.indexOf('--port')+1])||8768;
const mime={'.html':'text/html; charset=utf-8','.js':'text/javascript; charset=utf-8','.mjs':'text/javascript; charset=utf-8','.json':'application/json; charset=utf-8','.svg':'image/svg+xml','.css':'text/css; charset=utf-8','.png':'image/png','.md':'text/plain; charset=utf-8'};
const server=createServer(async(req,res)=>{
 try{
  if(req.method!=='GET'&&req.method!=='HEAD'){res.writeHead(405);res.end('Static files only');return;}
  const pathname=decodeURIComponent(new URL(req.url,'http://127.0.0.1').pathname),path=resolve(root,'.'+(pathname==='/'?'/index.html':pathname));
  if(!path.startsWith(root+sep)||!['/index.html','/style.css'].includes(pathname)&&!['src','data','images'].some(p=>path.startsWith(resolve(root,p)+sep))&&pathname!=='/'){res.writeHead(404);res.end('Not found');return;}
  if(!(await stat(path)).isFile())throw Error('Not a file');const body=await readFile(path);res.writeHead(200,{'Content-Type':mime[extname(path)]||'application/octet-stream','Content-Length':body.length,'Cache-Control':'no-store','X-Content-Type-Options':'nosniff'});res.end(req.method==='HEAD'?undefined:body);
 }catch{res.writeHead(404);res.end('Not found');}
});
server.listen(port,'127.0.0.1',()=>console.log(`Sherlock JavaScript autonomo: http://127.0.0.1:${server.address().port}/`));
