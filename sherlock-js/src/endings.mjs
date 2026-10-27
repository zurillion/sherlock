// The common story ending has a visible acknowledgement BEFORE clearing the
// upper window. Domain execution stops here; the browser releases these display
// operations in order. No actor/callback may run after the selected ending.
export function finishStory(host,text,actor,messages,{reason='story',entry='9E74'}={}){
 const g=host.game;host.print(text,actor,{},messages,{force:true});
 g.ended={entry,reason,text_pointer:text};
 messages.push({kind:'narrative',text:'',screen_ack:true});
 for(let i=0;i<18;i++){g.sourceDisplay.feed('\n');g.sourceDisplay.state.counter=0;}
 messages.push({kind:'narrative',text:'',screen_clear:true});
 return {success:true,cost:0,ended:true};
}
