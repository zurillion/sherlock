// DDD4–DE6E: choose the next occurrence on the original 12-hour clock.
// The lexer accepts byte-sized numeric hours; DE48's DJNZ treats zero as 256.
export function waitUntilCost(literal,{hour,minute,period}){
 const h=(literal>>>8)&63,m=literal&63;
 const target=(h===12?0:(h||256)*60)+m,current=(hour===12?0:hour*60)+minute;
 let requested=literal&16384?'am':literal&64?'pm':target<=current?(period==='am'?'pm':'am'):period;
 let cost=(target-current)&65535;
 if(target<=current){cost=(cost+720)&65535;if(requested===period)cost=(cost+720)&65535;}
 else if(requested!==period)cost=(cost+720)&65535;
 return cost;
}
