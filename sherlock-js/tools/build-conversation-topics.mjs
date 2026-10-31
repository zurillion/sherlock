// Offline typed extraction of E22A's nested actor/topic table. Not Z80 code.
export function buildConversationTopics(payload,ensure=()=>{}){
 const base=0x5D80,start=0xE22A,limit=0xE28D,byte=a=>{if(a<start||a>=limit||a-base>=payload.length)throw Error('Unterminated TELL table');return payload[a-base];};
 const records=[],topics={};let at=start;
 while(byte(at)!==255){const record={start:at,actor:byte(at++),topics:[]},map={};
  while(byte(at)!==255){const subject=byte(at),pointer=byte(at+1)|(byte(at+2)<<8),text=pointer.toString(16).toUpperCase();if(pointer<0x67F7||pointer>=0x8258)throw Error('TELL text pointer outside prose');record.topics.push({start:at,subject,text});if(map[subject]===undefined)map[subject]=text;ensure(text);at+=3;}
  record.end=++at;records.push(record);if(topics[record.actor]===undefined)topics[record.actor]=map;
 }
 const end=at+1;if(end!==limit)throw Error('Unexpected TELL table boundary');
 const values=[...records.flatMap(r=>[r.actor,...r.topics.flatMap(t=>{const p=parseInt(t.text,16);return[t.subject,p&255,p>>>8];}),255]),255];
 if(values.some((v,i)=>v!==payload[start-base+i]))throw Error('TELL table roundtrip differs');
 return {topics,table:{start,kind:'immutable-conversation-topics',format:'actor byte, topic/text-word triples, FF per actor; FE default actor; final FF',records,values}};
}
