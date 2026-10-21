// Exercise the production geometry/label functions without a browser or UI mocks beyond SVG construction.
const fs=require('fs'),path=require('path'),assert=require('assert');
const root=__dirname,source=fs.readFileSync(path.join(root,'app.js'),'utf8');
const code=source.slice(source.indexOf('const NODE_W='),source.indexOf('function characterColour('));
const labels=[],edges=[];
const svg=(tag,attrs={})=>({tag,attrs,children:[],append(...children){this.children.push(...children);}});
const $=id=>({append(node){labels.push(node);}});
const {portDirection,addDirectionLabel}=Function('svg','$','edgeEls',code+';return {portDirection,addDirectionLabel};')(svg,$,edges);
const ports={N:[0,-55],S:[0,55],E:[74,0],W:[-74,0],NE:[74,-55],NW:[-74,-55],SE:[74,55],SW:[-74,55]};
let implicit=0,explicit=0;
for(const [direction,[sx,sy]] of Object.entries(ports)){
 assert.equal(portDirection(sx,sy),direction);
 const tx=sx*5,ty=sy*5,geometry={x:0,y:0,tx,ty,sx,sy,ex:tx-sx,ey:ty-sy,cx:tx/2,cy:ty/2,parallelCount:1,parallelIndex:0};
 const before=labels.length;addDirectionLabel({source:1,target:2,direction},geometry);assert.equal(labels.length,before);implicit++;
 const mismatch=direction==='N'?'E':'N';addDirectionLabel({source:1,target:2,direction:mismatch},geometry);assert.equal(labels.length,before+1);assert.equal(labels.at(-1).attrs['data-direction'],mismatch);explicit++;
}
for(const direction of ['UP','DOWN']){
 const before=labels.length;addDirectionLabel({source:1,target:2,direction},{x:0,y:0,tx:0,ty:300,sx:0,sy:55,ex:0,ey:245,cx:10,cy:150,parallelCount:1,parallelIndex:0});assert.equal(labels.length,before+1);explicit++;
}
const before=labels.length;addDirectionLabel({source:1,target:2,direction:'E'},{x:0,y:0,tx:300,ty:0,sx:74,sy:0,ex:226,ey:0,cx:150,cy:20,parallelCount:2,parallelIndex:1});assert.equal(labels.length,before+1);explicit++;
const report={implicit_directions_checked:implicit,explicit_exceptions_checked:explicit,parallel_exit_label_preserved:true,all_passed:true};
fs.mkdirSync(path.join(root,'results'),{recursive:true});fs.writeFileSync(path.join(root,'results/edge-labels-verification.json'),JSON.stringify(report,null,2)+'\n');console.log(report);
