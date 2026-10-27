// ZX Printer receives the top eight bitmap scans immediately before scrolling.
// The browser exports that paper; no system printer or dialog is invoked.
export function paperSvg(rows){
 let path='';for(const[row,bytes]of rows.entries())for(let y=0;y<8;y++)for(let x=0;x<256;){if(!(bytes[y*32+(x>>3)]&(128>>(x&7)))){x++;continue;}const start=x;while(x<256&&(bytes[y*32+(x>>3)]&(128>>(x&7))))x++;path+=`M${start} ${row*8+y}h${x-start}v1h-${x-start}z`;}
 return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 ${Math.max(8,rows.length*8)}" width="1024" height="${Math.max(8,rows.length*8)*4}" shape-rendering="crispEdges"><rect width="256" height="100%" fill="white"/><path d="${path}" fill="black"/></svg>`;
}
