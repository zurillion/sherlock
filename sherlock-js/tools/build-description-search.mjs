// Offline decoding of the data reader B77F. It differs from the display
// decoder: even a literal space is consumed as a packed run. Preserve that
// behaviour as typed text-search data, without executing native instructions.
export function buildDescriptionSearch(payload,rooms){
 const byte=p=>payload[p-0x5d80],word=p=>byte(p)|byte(p+1)<<8;
 const frequent=Array.from({length:32},(_,i)=>word(0x67b7+2*i)),nodes={},queue=rooms.filter(r=>r.description).map(r=>parseInt(r.description,16));
 while(queue.length){const p=queue.pop(),key=p.toString(16).toUpperCase();if(nodes[key])continue;
  if(p<0x67f7||p>=0x8258){nodes[key]={op:'unavailable'};continue;}
  const b=byte(p);let t;
  if(b>=128){const id=(b&15)<<8|byte(p+1);t={op:'word',id,class:byte(0x5dbf+id)&240,next:p+2,returnAfter:[32,48,96].includes(b&112)};}
  else if(b>=96){const id=frequent[b-96];t={op:'word',id,class:byte(0x5dbf+id)&240,next:p+1};}
  else if(b>=32)t={op:'skip',next:p+1+Math.ceil(((b&31)+1)*5/8)};
  else if(b===2)t={op:'jump',target:(p+word(p+1))&65535};
  else if(b===11)t={op:'call',returnPointer:p+1,target:(p+word(p+1))&65535,next:p+3};
  else if(b>=29)t={op:'return'};
  else t={op:'skip',next:p+1};
  nodes[key]=t;for(const q of [t.next,t.target])if(q!==undefined)queue.push(q);
 }
 return {version:1,nodes};
}
