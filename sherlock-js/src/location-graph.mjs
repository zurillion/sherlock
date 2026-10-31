// Presentation of location exits; never changes the directed gameplay graph.
export const NODE_W=142,NODE_H=104;
export const OPPOSITE={N:'S',S:'N',E:'W',W:'E',NE:'SW',SW:'NE',NW:'SE',SE:'NW'};
export function portDirection(dx,dy){
 const x=Math.abs(dx)/(NODE_W/2+3),y=Math.abs(dy)/(NODE_H/2+3);
 if(x>=.78&&y>=.78)return (dy<0?'N':'S')+(dx<0?'W':'E');
 return x>y?(dx<0?'W':'E'):(dy<0?'N':'S');
}
export function boundary(x,y,dx,dy){const t=Math.min((NODE_W/2+3)/(Math.abs(dx)||1e-9),(NODE_H/2+3)/(Math.abs(dy)||1e-9));return [x+dx*t,y+dy*t];}
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
  const reverse=obvious(edge,rooms)?visible.findIndex((r,j)=>!used.has(j)&&r.source===edge.target&&r.target===edge.source&&obvious(r,rooms)):-1;
  if(reverse>=0){used.add(reverse);result.push({...edge,reverse:visible[reverse]});}
  else result.push({...edge,reverse:null});
 }
 return result;
}
