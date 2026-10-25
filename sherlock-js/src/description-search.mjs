import {UnsupportedFeature} from './world.mjs';

// Scenery lookup B6FD–B839. The typed search stream is decoded offline from
// compressed TEXT, including the original reader's packed-space quirk. Calls
// have two-byte return records; even released records are observable by RNG.
export function searchDescription(data,world,records,group,actor){
 const start=world.rooms[world.roomOf(actor)].description;if(!start)return false;
 let cursor=parseInt(start,16),head=0,ended=false,steps=0;
 const pop=()=>{if(!head)return false;const p=head;head=records.arena.word(p-2);cursor=records.arena.word(p)+2;records.arena.release(p);return true;};
 const next=()=>{while(++steps<10000){if(ended){ended=false;if(!pop())return null;}
  const t=data.descriptionSearch?.nodes[cursor.toString(16).toUpperCase()];if(!t||t.op==='unavailable')throw new UnsupportedFeature('ricerca nella descrizione della locazione');
  if(t.op==='return'){if(!pop())return null;continue;}
  if(t.op==='jump'){cursor=t.target;continue;}
  if(t.op==='call'){const p=records.arena.allocate(2);records.arena.putWord(p,t.returnPointer);records.arena.putWord(p-2,head);head=p;cursor=t.target;continue;}
  cursor=t.next;if(t.op==='word'){ended=Boolean(t.returnAfter);return t;}
 }throw new UnsupportedFeature('ricerca descrittiva senza termine');};
 const matches=(noun,qualifiers)=>{const [a=0,b=0]=group.qualifiers,[c=0,d=0]=qualifiers,match=(q,v)=>!q||(q&4095)===(v&4095);return (!group.noun||(group.noun&4095)===(noun&4095))&&(match(a,c)&&match(b,d)||match(a,d)&&match(b,c));};
 while(true){let t=next();if(!t)return false;const qualifiers=[];
  if(t.class===96){qualifiers.push(t.id);t=next();if(!t)return false;if(t.class===96){qualifiers.push(t.id);t=next();if(!t)return false;}}
  if(t.class===80&&matches(t.id,qualifiers)){while(pop());return true;}
 }
}
