import {UnsupportedFeature} from './world.mjs';

export const objectRuleFor=(entity,action)=>({takeBurningNote:'object.takeNote',openSafe:'object.openSafe','untranslated:E0A0':'object.inspectStream','untranslated:E0E0':'object.inspectTrash','untranslated:E0F2':'object.inspectDrawer','untranslated:E104':'object.inspectBookcase'})[entity.rules.find(r=>r.action===action)?.rule]??(action===20?'object.inspectClosely':null);

// Bodies of the object's named rules. Header validation and deferred turns
// belong to the common domain host, so discoveries occur at the source stage.
export function specialObjectBody(host,name,args,context,messages){
 const g=host.game,w=host.w,actor=context.actor,[first,second]=args,yes=(cost=0)=>({success:true,cost}),no=()=>({success:false,cost:0});
 switch(name){
  case 'object.take':w.entity(first).parent=actor;return yes(1);
  case 'object.quenchNote':if(host.state.burningNoteTicks){host.state.burningNoteTicks=255;const e=w.entity(first);e.qualifiers[0]=0x7D5;e.name='singed note';}return yes();
  case 'object.open':{const e=w.entity(first);if(e.attributes&1||e.attributes&32){messages.push(g.error(w.name(first).toUpperCase()+(e.attributes&1?' IS LOCKED':' IS OPEN')));return no();}e.attributes|=32;return yes(1);}
  case 'object.safeEvent':if(first===89&&Math.floor(w.minutes/1440)%256===0){const text=w.roomOf(6)===w.roomOf(actor)?'75D2':'759C';host.print(text,actor,{},messages,{force:true});g.ended={entry:'9E74',reason:'story',text_pointer:text};
   // 9E74/A29C empties the upper window with eighteen unconditional CRs.
   // The story has already been printed; the end checkpoint is the cleared
   // screen awaiting the original restart interaction, with no new prompt.
   for(let i=0;i<18;i++){g.sourceDisplay.state.counter=0;g.sourceDisplay.feed('\n');}messages.push({kind:'narrative',text:'',screen_clear:true});return {success:true,cost:0,ended:true};}return yes(15);
  case 'object.streamClue':if(actor===0&&w.roomOf(actor)===88&&Math.floor(w.minutes/1440)%256===1){const e=w.entity(second);e.attributes|=128;e.status|=128;e.parent=first;e.rooms=[88];host.print('7B5A',actor,{},messages);}return yes();
  case 'object.revealNote':w.entity(81).attributes|=128;return yes();
  case 'object.revealBottom':w.entity(63).attributes|=128;return yes();
  case 'object.inspectBookcase':if(actor===0){const start=host.inspect(first,actor,messages),e=w.entity(first);if(!(e.attributes&32)){e.attributes|=32;e.description='7BF7';host.print('7C13',actor,{},messages);host.finishObjectLine(messages,start);}}return yes(6);
  case 'object.inspectClosely':if(actor===0){const start=host.inspect(first,actor,messages),text={76:'7BC2',102:'7BD7',57:'7C9E',62:'7CE7',46:'7C4A'}[first];if(text)host.print(text,actor,{object:first},messages);host.finishObjectLine(messages,start);}return yes(5);
  default:throw new UnsupportedFeature('corpo della regola oggetto '+name);
 }
}
