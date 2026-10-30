// Keep the game at the site root and publish tracked project sources under archivio/.
import {cp,mkdir,readFile,writeFile,rm,readdir,access,lstat} from 'node:fs/promises';
import {dirname,resolve,join,basename} from 'node:path';
import {fileURLToPath} from 'node:url';
import assert from 'node:assert/strict';
import {execFile} from 'node:child_process';
import {promisify} from 'node:util';
import {createHash} from 'node:crypto';
const app=resolve(dirname(fileURLToPath(import.meta.url)),'..'),repo=resolve(app,'..'),output=join(repo,'_site');
await rm(output,{recursive:true,force:true});await mkdir(output,{recursive:true});
for(const name of ['index.html','style.css','src','data','images'])await cp(join(app,name),join(output,name),{recursive:true,filter:path=>basename(path)!=='.DS_Store'});
await writeFile(join(output,'.nojekyll'),'');
const data=JSON.parse(await readFile(join(output,'data/game.json'),'utf8'));
const picturePaths=[...Object.values(data.pictures||{}),...Object.values(data.spectrum?.pictures||{}),...Object.values(data.spectrum?.pixels||{})].filter(v=>typeof v==='string');
for(const path of picturePaths){if(path.startsWith('data:image/'))continue;assert(!path.startsWith('/')&&!path.includes('..'),'Picture must use a project-relative URL');await access(join(output,path));}
// Use Git's allowlist, never a recursive copy of the working directory: ignored
// caches, local credentials and the output directory must not enter the archive.
const {stdout}=await promisify(execFile)('git',['ls-files','-z'],{cwd:repo,maxBuffer:16*1024*1024});
const archive=join(output,'archivio'),entries=[];
await mkdir(archive,{recursive:true});
for(const path of stdout.split('\0').filter(Boolean).sort()){
 if(path==='.gitignore'||path.startsWith('.github/'))continue;
 assert(!path.startsWith('/')&&!path.split('/').includes('..'),'Archive path must remain inside the repository');
 const source=join(repo,path),destination=join(archive,path),stat=await lstat(source);
 assert(stat.isFile(),`Archive requires regular tracked files: ${path}`);
 await mkdir(dirname(destination),{recursive:true});await cp(source,destination);
 const body=await readFile(destination);
 entries.push({path,url:path.split('/').map(encodeURIComponent).join('/'),bytes:body.length,sha256:createHash('sha256').update(body).digest('hex')});
}
await writeFile(join(archive,'manifest.json'),JSON.stringify({format:1,files:entries},null,2)+'\n');
let files=0,bytes=0;
async function inspect(dir,validateImports=true){for(const entry of await readdir(dir,{withFileTypes:true})){const path=join(dir,entry.name);assert(!entry.isSymbolicLink(),'Pages cannot contain symlinks');if(entry.isDirectory())await inspect(path,validateImports&&path!==archive);else{const stat=await lstat(path);files++;bytes+=stat.size;if(validateImports&&entry.name.endsWith('.mjs')){const text=await readFile(path,'utf8');for(const match of text.matchAll(/(?:from\s*|import\s*)['"](\.[^'"]+)['"]/g))await access(resolve(dirname(path),match[1]));}}}}
await inspect(output);
for(const path of ['src/memory.html','src/memory-map-data.json','src/app.mjs'])await access(join(output,path));
for(const name of ['test','results','tools','.git','SHERLOCK.TAP'])await assert.rejects(access(join(output,name)));
console.log(`Pages package: ${files} files, ${bytes} bytes → ${output}; archive: ${entries.length} tracked project files`);
