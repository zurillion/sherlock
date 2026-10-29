import {finishStory} from './endings.mjs';
// Functional bodies for the late NPC branches. Source labels identify
// reconstructed rules, never instructions dispatched by a CPU interpreter.
export class AdvancedNpcs {
 constructor(host){this.host=host;}
 get w(){return this.host.w;}
 describe(id,qualifier,kind,person){
  const e=this.w.entity(id),dictionary=this.host.game.dictionary;e.qualifiers[0]=qualifier;e.noun=(e.noun&4095)|(kind<<8);
  e.attributes=person?e.attributes|64:e.attributes&~64;e.person=Boolean(e.attributes&64);
  const adjectives=e.qualifiers.filter(q=>q&&!(q&32768)).map(q=>dictionary.word(q&4095).form),noun=dictionary.word(e.noun&4095).stem;e.name=[...adjectives,noun].join(' ');
 }
 sleep(actor){
  const w=this.w,state=this.host.state,rest=state.nightRest??(state.nightRest={5:0,8:0,9:0}),row=w.scheduler.actor(actor),room=rest[actor];
  if(room){rest[actor]=0;w.entity(actor).rooms=[room];w.entity(actor).parent=null;this.describe(actor,0,actor===5?128:0,true);return;}
  const clock=w.clock();if(clock.period!=='pm'||clock.hour!==9)return;
  const draw=this.host.game.runtimeRandom.absolute(30,{actor,mixOffset:504,purpose:'npc-night-rest'});
  // 9F06 adds into E without a carry into D. Preserve the discontinuity.
  row.due=(row.due+(256|((248+draw)&255)))&65535;rest[actor]=w.roomOf(actor);w.entity(actor).rooms=[actor===5?74:0];w.entity(actor).parent=null;this.describe(actor,0x7F0,16,false);
 }
 finish(text,actor,messages,{reason='story',entry='9E74'}={}){
  return finishStory(this.host,text,actor,messages,{reason,entry});
 }
 policeTravel(actor,target,furious,messages,other=255){
  const h=this.host,w=this.w,source=w.roomOf(actor),duration=source===103&&target===50?112:source===50&&target===103?114:source===50&&target===18?94:null;
  if(duration===null)return {success:false,cost:0};
  h.temporaryCost(duration-(furious?20:0));const before=w.roomOf();w.entity(109).attributes&=127;w.rooms[105].flags&=~64;const lost=h.relocate(109,105,messages,{actor,sceneSource:'cab-departure'});
  return {success:true,cost:duration-(furious?20:0),defer:'F3AD',args:[target,other],scopeOwner:lost||before===105&&!w.perceived(actor)?w.player:actor};
 }
 body(name,args,context,messages){
  const w=this.w,h=this.host,actor=context.actor,yes=()=>({success:true,cost:0});
  switch(name){
   case 'unimplemented.9A99':return this.policeTravel(actor,args[0],false,messages,args[1]);
   case 'unimplemented.9ACB':return this.policeTravel(actor,args[0],true,messages,args[1]);
   case 'unimplemented.F1A8':this.describe(11,0x910,32,false);h.print('6D5D',actor,{},messages);return yes();
   case 'unimplemented.ED39':this.describe(11,0x50B,16,true);h.print('6D6A',actor,{},messages);return yes();
   case 'unimplemented.EFB3':this.describe(actor,0x7F0,16,false);return yes();
   case 'unimplemented.EFC7':if([33,34,35,36,37,38,39].includes(w.roomOf()))return this.finish(w.roomOf(6)===w.roomOf()?'75D2':'759C',actor,messages);this.describe(actor,0,128,true);return yes();
   case 'unimplemented.F103':h.state.facts.find(f=>f.start===0x9965).terms[3]|=0x200;return yes();
   case 'unimplemented.EF9C':h.print('75E8',actor,{},messages,{force:true});return yes();
   case 'unimplemented.EFAC':h.print('7603',actor,{},messages,{force:true});return yes();
   case 'unimplemented.9E6A':if(!h.state.flags.strakerMet)return this.finish('693A',actor,messages);return yes();
   case 'unimplemented.9E85':if(h.state.flags.caseReady)return yes();h.print('6975',actor,{},messages);return this.finish(w.roomOf()===w.roomOf(actor)?'69BF':'6A26',actor,messages);
   case 'ending.case':return this.finish(w.roomOf(3)!==w.roomOf()||w.roomOf(2)!==w.roomOf()?'6B79':'6AF3',actor,messages);
   case 'ending.arrest':return this.finish(h.state.facts.find(f=>f.start===0x9973).flags&2&&h.state.facts.find(f=>f.start===0x9981).flags&2?'6ABD':'6A33',actor,messages);
   case 'ending.quit':return this.finish(w.roomOf(6)===w.roomOf()?'75D2':'759C',actor,messages);
  }
  return null;
 }
}
