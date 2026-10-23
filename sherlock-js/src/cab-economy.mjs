// The original account is a signed 15-bit quantity. Low bit 7 is literal metadata.
export function decodeMoney(word){const high=word>>>8;return (high<128?high:high-256)*128+(word&127);}
export function encodeMoney(pence){if(!Number.isInteger(pence)||pence< -16384||pence>16383)throw Error('Money outside original signed field');return (pence&127)|((pence<<1)&65280);}
export const wrapMoney=pence=>((pence+16384)%32768+32768)%32768-16384;
export function account(world,actor){return world.entities.find(e=>e.parent===actor&&(e.noun&4095)===0x575)||null;}
export function balance(world,actor){return account(world,actor)?.pence??null;}
export function transferMoney(world,sender,recipient,pence){
 if(!Number.isInteger(pence)||pence<0||pence>16383)throw Error('Invalid payment literal');
 const from=account(world,sender),to=account(world,recipient);
 // Native funds comparison is unsigned at 16 bits, even for a negative account.
 if(!from||(from.pence&65535)<pence)return false;
 from.pence=wrapMoney(from.pence-pence);if(to)to.pence=wrapMoney(to.pence+pence);return true;
}
export class CabRoutes {
 constructor(routes){this.routes=routes.map(r=>({source:r.source,target:r.target,duration:r.duration}));}
 find(source,target,{furiously=false}={}){
  const r=this.routes.find(r=>r.source===source&&r.target===target||r.target===source&&r.source===target);if(!r)return null;
  return {source,target,cost:furiously?(r.duration-2)&255:r.duration,fare:(Math.floor(r.duration/5)+1)*(furiously?6:2)};
 }
}
