import test from'node:test';import assert from'node:assert/strict';import{graphConnections,cornerPoint,NODE_W,NODE_H}from'../src/location-graph.mjs';
const rooms=new Map([[1,{layout:[0,0]}],[2,{layout:[300,0]}],[3,{layout:[400,300]}]]),edge=(source,target,direction,gate=0)=>({source,target,direction,gate});
test('Obvious reciprocal exits become one undirected visual connection without mutating exits',()=>{const edges=[edge(1,2,'E'),edge(2,1,'W')],before=structuredClone(edges),links=graphConnections(edges,rooms);assert.equal(links.length,1);assert.equal(links[0].source,1);assert.equal(links[0].target,2);assert.equal(links[0].reverse,edges[1]);assert.deepEqual(edges,before);const diagonal=graphConnections([edge(1,3,'SE'),edge(3,1,'NW')],rooms);assert.equal(diagonal.length,1);assert(diagonal[0].reverse);});
test('A one-way exit remains directed, including the reversed input order',()=>{for(const e of[edge(1,2,'E'),edge(2,1,'W')]){const links=graphConnections([e],rooms);assert.equal(links.length,1);assert.equal(links[0].reverse,null);assert.equal(links[0].source,e.source);}});
test('Non-obvious reciprocal directions remain separate explicit arrows',()=>{for(const edges of[[edge(1,2,'N'),edge(2,1,'S')],[edge(1,2,'E'),edge(2,1,'N')]]){const links=graphConnections(edges,rooms);assert.equal(links.length,2);assert(links.every(e=>e.reverse===null));}});
test('Parallel exits are paired once; unusual alternatives and gate metadata survive',()=>{const edges=[edge(1,2,'E',21),edge(1,2,'UP'),edge(2,1,'W',50),edge(1,2,'E')],links=graphConnections(edges,rooms);assert.equal(links.length,3);assert.equal(links.filter(e=>e.reverse).length,1);assert.equal(links.find(e=>e.reverse).gate,21);assert.equal(links.find(e=>e.reverse).reverse.gate,50);assert.deepEqual(links.filter(e=>!e.reverse).map(e=>e.direction),['UP','E']);assert.equal(links.reduce((n,e)=>n+(e.reverse?2:1),0),edges.length);assert.equal(graphConnections([edge(0,1,'E'),edge(1,99,'E')],rooms).length,0);});

test('Reciprocal UP/DOWN share one labelled line in either order, with or without an obstacle',()=>{for(const directions of[['UP','DOWN'],['DOWN','UP']])for(const gate of[0,21]){const edges=[edge(1,3,directions[0],gate),edge(3,1,directions[1],gate)],before=structuredClone(edges),links=graphConnections(edges,rooms);assert.equal(links.length,1);assert.equal(links[0].label,'DOWN/UP');assert.equal(links[0].reverse,edges[1]);assert.equal(Boolean(links[0].gate||links[0].reverse.gate),Boolean(gate));assert.deepEqual(edges,before);}});
test('A lone vertical exit or an unmatched vertical direction retains its arrow',()=>{assert.equal(graphConnections([edge(1,3,'UP')],rooms)[0].reverse,null);const unmatched=graphConnections([edge(1,3,'UP'),edge(3,1,'N')],rooms);assert.equal(unmatched.length,2);assert(unmatched.every(e=>!e.reverse&&!e.label));});

test('Steep and shallow reciprocal diagonals connect the corresponding corners',()=>{
 for(const [dx,dy,dir,back]of [[92,118,'SE','NW'],[300,30,'SE','NW'],[-92,-118,'NW','SE'],[92,-118,'NE','SW'],[-92,118,'SW','NE']]){
 const r=new Map([[1,{layout:[0,0]}],[2,{layout:[dx,dy]}]]),edges=[edge(1,2,dir,21),edge(2,1,back)],links=graphConnections(edges,r);
 assert.equal(links.length,1);assert.equal(links[0].cornerDirection,dir);assert.equal(links[0].label,null);assert.equal(links[0].gate,21);
 const [x,y]=cornerPoint(0,0,dir);assert.equal(Math.abs(x),NODE_W/2+3);assert.equal(Math.abs(y),NODE_H/2+3);
 }
});
test('Diagonals in the wrong quadrant, mismatched reverses and one-way exits stay explicit',()=>{
 const r=new Map([[1,{layout:[0,0]}],[2,{layout:[92,118]}]]);
 for(const dirs of [['NE','SW'],['SE','W']])assert(graphConnections([edge(1,2,dirs[0]),edge(2,1,dirs[1])],r).every(e=>!e.reverse));
 assert.equal(graphConnections([edge(1,2,'SE')],r)[0].reverse,null);
});
