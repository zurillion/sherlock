'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),path=require('node:path');
global.document={addEventListener(){}};global.window={devicePixelRatio:1};
const {SpectrumTerminal}=require('./spectrum.js');
function terminal(){const input={value:'',addEventListener(){},setAttribute(){},focus(){}},canvas={dataset:{},setAttribute(){},parentElement:{addEventListener(){}}};const t=new SpectrumTerminal({canvas,input,upper:{},lower:{},status:{},onCommand(){}});clearInterval(t.blink);t.active=true;t.resumeSession();t.delay=0;return t;}
(async()=>{
 const root=process.argv[2]||path.join(__dirname,'results'),data=JSON.parse(fs.readFileSync(path.join(root,'paging-fixtures.json'))),fixtures=[...data.fixtures,data.narrow_fixture];
 let t=terminal();const checks=[];let pages=[];
 t.pause=async function(reason){assert.equal(reason,undefined);pages.push({rows:this.model.lines.map(s=>s.trimEnd()),counter:this.model.counter,width:this.model.columns});this.wide();this.model.more();return true;};
 for(const fixture of fixtures){
  if(fixture.name==='illustrated formatter')t.model.clear();
  pages=[];const before=t.model.scrolls;
  await t.writeMessages([{kind:'narrative',text:'Not used for native presentation',screen_events:fixture.packets}]);
  assert.deepEqual(t.model.lines,fixture.after.rows,fixture.name+' screen');
  assert.equal(t.model.counter,fixture.after.counter,fixture.name+' counter');
  assert.equal(t.model.columns,fixture.after.width,fixture.name+' width');
  assert.equal(t.model.remaining,fixture.after.columns_left,fixture.name+' remaining columns');
  assert.deepEqual(pages,fixture.pages.map(p=>({rows:p.rows,counter:p.counter,width:p.width})),fixture.name+' MORE positions');
  assert.equal(t.model.scrolls-before,fixture.feeds,fixture.name+' actual scrolls');
  checks.push(fixture.name+': native screen, MORE positions, counter, width, remaining columns and scroll count');
 }
 fs.writeFileSync(path.join(root,'paging-browser-verification.json'),JSON.stringify({passed:true,checks},null,2)+'\n');
 console.log('OK:',checks.length,'confronti completi con il renderer Z80.');
})().catch(e=>{console.error(e);process.exitCode=1;});
