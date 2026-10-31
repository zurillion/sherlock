// Presentation of location exits; never changes the directed gameplay graph.
export const NODE_W=142,NODE_H=104;
export const OPPOSITE={N:'S',S:'N',E:'W',W:'E',NE:'SW',SW:'NE',NW:'SE',SE:'NW'};
export function portDirection(dx,dy){
 const x=Math.abs(dx)/(NODE_W/2+3),y=Math.abs(dy)/(NODE_H/2+3);
 if(x>=.78&&y>=.78)return (dy<0?'N':'S')+(dx<0?'W':'E');
 return x>y?(dx<0?'W':'E'):(dy<0?'N':'S');
}
export function boundary(x,y,dx,dy){const t=Math.min((NODE_W/2+3)/(Math.abs(dx)||1e-9),(NODE_H/2+3)/(Math.abs(dy)||1e-9));return [x+dx*t,y+dy*t];}
export function cornerPoint(x,y,direction){return [x+(direction.includes('E')?1:-1)*(NODE_W/2+3),y+(direction.includes('S')?1:-1)*(NODE_H/2+3)];}
function diagonalFits(edge,rooms){
 if(!/^(NE|NW|SE|SW)$/.test(edge.direction))return false;
 const [x,y]=rooms.get(edge.source).layout,[tx,ty]=rooms.get(edge.target).layout;
 return (edge.direction.includes('E')?tx>x:tx<x)&&(edge.direction.includes('S')?ty>y:ty<y);
}
function obvious(edge,rooms){
 const [x,y]=rooms.get(edge.source).layout,[tx,ty]=rooms.get(edge.target).layout;
 if(x===tx&&y===ty)return false;
 const [sx,sy]=boundary(x,y,tx-x,ty-y),[ex,ey]=boundary(tx,ty,x-tx,y-ty);
 return edge.direction===portDirection(sx-x,sy-y)&&OPPOSITE[edge.direction]===portDirection(ex-tx,ey-ty);
}
export function graphConnections(edges,rooms){
 const visible=edges.filter(e=>e.source&&e.target&&rooms.has(e.source)&&rooms.has(e.target)),used=new Set(),result=[];
 for(const [i,edge]of visible.entries()){
  if(used.has(i))continue;used.add(i);
  const vertical=edge.direction==='UP'||edge.direction==='DOWN',opposite=edge.direction==='UP'?'DOWN':'UP';
  const diagonal=diagonalFits(edge,rooms);
  const reverse=vertical||diagonal||obvious(edge,rooms)?visible.findIndex((r,j)=>!used.has(j)&&r.source===edge.target&&r.target===edge.source&&(vertical?r.direction===opposite:diagonal?r.direction===OPPOSITE[edge.direction]&&diagonalFits(r,rooms):obvious(r,rooms))):-1;
  if(reverse>=0){used.add(reverse);result.push({...edge,reverse:visible[reverse],label:vertical?'DOWN/UP':null,cornerDirection:diagonal?edge.direction:null});}
  else result.push({...edge,reverse:null});
 }
 return result;
}

// UI geography: weak components of static exits, with Leatherhead subdivisions.
// These labels and colours never participate in world state or random inputs.
export function graphZones(roomList,edges){
 const rooms=new Map(roomList.filter(r=>r.id).map(r=>[r.id,r])),adj=new Map([...rooms.keys()].map(id=>[id,new Set()]));
 for(const e of edges)if(adj.has(e.source)&&adj.has(e.target)){adj.get(e.source).add(e.target);adj.get(e.target).add(e.source);}
 const unseen=new Set([...rooms.keys()].sort((a,b)=>a-b)),zones=new Map(),byRoom=new Map();
 const names={1:'Hansom cab',2:'Steam train 1',3:'Steam train 2',4:'Steam train 3',5:'Baker Street',10:'Scotland Yard',12:'Slater Street',14:'Aldergate',18:"King’s Cross",24:'Paddington',28:'Victoria',32:'Basil · Camden Street',40:'Sidmouth Street',45:'Casa di Tricia',50:'Leatherhead · esterni e giardini',103:'Old Mill Road',105:'Police cab'};
 function zone(key,name){if(!zones.has(key)){const hue=(zones.size*137.508+35)%360;zones.set(key,{key,name,colour:`hsl(${hue.toFixed(2)} 58% 91%)`,visitedColour:`hsl(${hue.toFixed(2)} 43% 76%)`});}return zones.get(key);}
 while(unseen.size){const root=unseen.values().next().value,queue=[root];unseen.delete(root);
  for(const id of queue){for(const next of adj.get(id))if(unseen.delete(next))queue.push(next);
   let key=`component-${root}`,name=names[root]||rooms.get(root).name_hint||rooms.get(root).name||`Zona ${root}`;
   if(root===50){if(id>=53&&id<=55){key='leatherhead-station';name='Leatherhead · stazione';}
    else if(id>=56&&id<=61){key='leatherhead-basil';name='Leatherhead · casa di Basil';}
    else if(id>=64&&id<=75){key='leatherhead-brown';name='Leatherhead · casa Brown';}
    else if(id>=94&&id<=101){key='leatherhead-jones';name='Leatherhead · casa Jones';}}
   byRoom.set(id,zone(key,name));
  }
 }
 return {zones:[...zones.values()],byRoom};
}
