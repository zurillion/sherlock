import {UnsupportedFeature} from './world.mjs';

// The shared TELL body (E1D8–E229). It deliberately does not substitute facts,
// object descriptions or a guessed response when a table entry is absent.
export class Conversation {
 constructor(data,text){this.topics=data.conversationTopics;this.text=text;}
 topic(actor,subject){
  if(!this.topics)throw new UnsupportedFeature('tabella degli argomenti TELL');
  const table=this.topics[actor]??this.topics[254];
  return table?.[subject]??'761D';
 }
 tell(actor,recipient,subject,context={}){
  return this.text.render('6830',{...context,actor,object:recipient,textArguments:[this.topic(actor,subject)]});
 }
}
