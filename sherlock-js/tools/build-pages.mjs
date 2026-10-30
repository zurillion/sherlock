// Package only browser runtime assets; offline research/test corpora stay in Git.
import {cp,mkdir,readFile,writeFile,rm,readdir,access,lstat} from 'node:fs/promises';
import {dirname,resolve,join,basename} from 'node:path';
import {fileURLToPath} from 'node:url';
import assert from 'node:assert/strict';
const app=resolve(dirname(fileURLToPath(import.meta.url)),'..'),output=resolve(app,'../_site');
await rm(output,{recursive:true,force:true});await mkdir(output,{recursive:true});
for(const name of ['index.html','style.css','src','data','images'])await cp(join(app,name),join(output,name),{recursive:true,filter:path=>basename(path)!=='.DS_Store'});
await writeFile(join(output,'.nojekyll'),'');
const data=JSON.parse(await readFile(join(output,'data/game.json'),'utf8'));
const picturePaths=[...Object.values(data.pictures||{}),...Object.values(data.spectrum?.pictures||{}),...Object.values(data.spectrum?.pixels||{})].filter(v=>typeof v==='string');
for(const path of picturePaths){if(path.startsWith('data:image/'))continue;assert(!path.startsWith('/')&&!path.includes('..'),'Picture must use a project-relative URL');await access(join(output,path));}
let files=0,bytes=0;
async function inspect(dir){for(const entry of await readdir(dir,{withFileTypes:true})){const path=join(dir,entry.name);assert(!entry.isSymbolicLink(),'Pages cannot contain symlinks');if(entry.isDirectory())await inspect(path);else{const stat=await lstat(path);files++;bytes+=stat.size;if(entry.name.endsWith('.mjs')){const text=await readFile(path,'utf8');for(const match of text.matchAll(/(?:from\s*|import\s*)['"](\.[^'"]+)['"]/g))await access(resolve(dirname(path),match[1]));}}}}
await inspect(output);
for(const path of ['src/memory.html','src/memory-map-data.json','src/app.mjs'])await access(join(output,path));
for(const name of ['test','results','tools','.git','SHERLOCK.TAP'])await assert.rejects(access(join(output,name)));
console.log(`Pages package: ${files} files, ${bytes} bytes → ${output}`);
