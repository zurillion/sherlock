import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {runInNewContext} from 'node:vm';
const html=await readFile(new URL('../index.html',import.meta.url),'utf8');
const source=html.match(/<script>([\s\S]*?)<\/script>/)[1];
function selector(href,{cancel=false}={}){
 const listeners={},original={disabled:false},hint={textContent:''},navigations=[],events=[];
 const picker={value:'javascript',querySelector:()=>original,addEventListener:(type,fn)=>{listeners[type]=fn;}};
 const document={getElementById:id=>id==='engine-select'?picker:hint};
 const window={location:{href,hostname:new URL(href).hostname,assign:url=>navigations.push(url)},addEventListener:()=>{},dispatchEvent:e=>{events.push(e);return !cancel;}};
 runInNewContext(source,{document,window,URL,CustomEvent:class{constructor(type,options){this.type=type;Object.assign(this,options);}}});
 return {original,hint,navigations,events,change(){picker.value='original';listeners.change();return picker.value;}};
}
test('GitHub Pages offers standalone JS without navigating to a local-only port',()=>{
 const page=selector('https://zurillion.github.io/sherlock/');assert.equal(page.original.disabled,true);assert.match(page.hint.textContent,/Versione web/);assert.equal(page.change(),'javascript');assert.deepEqual(page.navigations,[]);assert.deepEqual(page.events,[]);
});
test('The localhost page retains the original engine and its separate server',()=>{
 const page=selector('http://127.0.0.1:8768/');assert.equal(page.original.disabled,false);assert.equal(page.change(),'original');assert.deepEqual(page.navigations,['http://127.0.0.1:8766/']);assert.equal(page.events[0].detail.engine,'original');
});
test('A cancelled local switch preserves the selected engine without navigation',()=>{
 const page=selector('http://localhost:8768/',{cancel:true});assert.equal(page.change(),'javascript');assert.deepEqual(page.navigations,[]);
});
