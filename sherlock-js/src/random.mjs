// Arithmetic part of the original random source, expressed as pure game logic.
// Its input provider is explicit. A full world-dependent entropy model has NOT
// yet been reconstructed, so this component is not wired to invented NPC AI.
export class RandomInputsUnavailable extends Error {
 constructor(message,{address=null}={}){super(message);this.address=address;}
}
const byte=n=>Number.isInteger(n)&&n>=0&&n<=255;

export class OriginalRandom {
 constructor({seed=1,cursor=0}={}){if(!byte(seed)||!Number.isInteger(cursor)||cursor<0||cursor>65535)throw Error('Invalid random state');this.seed=seed;this.cursor=cursor;}
 draw(width,{mixOffset=0,inputs,maxAttempts=65536}={}){
  if(!byte(width)||!Number.isInteger(mixOffset)||mixOffset<0||mixOffset>65535)throw Error('Invalid random arguments');
  if(typeof inputs!=='function')throw new RandomInputsUnavailable('Il modello degli ingressi casuali del mondo non è ancora ricostruito.');
  const before=this.dump();let carry=width>=128?1:0;
  try{
   const ceiling=Math.min(width*2,255);
   for(let attempt=0;attempt<maxAttempts;attempt++){
    let low=this.cursor&255,high=((this.cursor>>>8)+1)&255;if(high===0)low=(low+1)&255;
    this.cursor=(high<<8)|low;
    const pair=inputs({cursor:this.cursor,mixOffset,attempt});
    if(!pair||!byte(pair.first)||!byte(pair.second))throw new RandomInputsUnavailable('Ingressi casuali non disponibili per questo contesto.');
    const mixed=((this.seed+pair.first+carry)&255)^pair.second;
    if(mixed===this.seed){carry=0;continue;}
    this.seed=mixed;let result=mixed;while(result>ceiling)result>>>=1;
    return (result-width)&255;
   }
   throw new RandomInputsUnavailable('La sorgente non ha prodotto un nuovo valore.');
  }catch(error){this.seed=before.seed;this.cursor=before.cursor;throw error;}
 }
 signed(width,context){const value=this.draw(width,context);return value>=128?value-256:value;}
 absolute(width,context){return Math.abs(this.signed(width,context));}
 percent(context){return this.absolute(99,context)+1;}
 // The text selector counts down from count and compares against abs(draw)+1.
 // A zero draw selects the LAST alternative, not the first.
 chooseIndex(count,context){
  if(!Number.isInteger(count)||count<1||count>255)throw Error('Invalid text alternative count');
  return count-1-this.absolute(count-1,context);
 }
 dump(){return {seed:this.seed,cursor:this.cursor};}
}
