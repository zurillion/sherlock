// Functional formatter state. These are character/data operations, not CPU execution.
export function capitalKind(c){return /^[A-Za-z]$/.test(c)?0:c==='.'||c==='"'?1:-1;}
export function normalizedCapital(value,c){const kind=capitalKind(c);return kind<0?value??null:kind;}
export function nameCapital(value,proper){return value==null?null:value|Number(proper);}
export function moneyClearsCapital(pence){const value=pence&16383,remainder=value%240;if(value>=240&&!remainder)return false;return remainder<12||remainder%12===0;}
