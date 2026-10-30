import {Game} from './game.mjs';

export const TAB_SESSION_KEY='sherlock-autonomous-tab-v1';

export function capturePresentation(terminal,{transcript,history,view,textTranscript,allowIncomplete=false,inProgress=false}){
 const base={version:1,compatibility:terminal.active,transcript:transcript.slice(-200),history:history.slice(-200),view:[...view],...(textTranscript?{textTranscript:structuredClone(textTranscript)}:{})};
 if(allowIncomplete&&(inProgress||terminal.processing||terminal.waiting))return {...base,spectrum:null,redraw:true,pictures:terminal.pictures,pictureMode:terminal.pictureMode};
 return {...base,spectrum:terminal.snapshot()};
}

// On return, redraw only the last response. This never submits a command again
// or repeats its effects; the complete logical game state is saved separately.
export function lastResponse(transcript){
 let start=0;for(let i=0;i<transcript.length;i++)if(transcript[i].kind==='command')start=i+1;
 return transcript.slice(start).filter(row=>['narrative','error'].includes(row.kind));
}

// The two engines do not convert or share game state. This checkpoint belongs
// only to the autonomous engine, in this browser tab and origin.
export function rememberTab(storage,game,presentation){
 storage.setItem(TAB_SESSION_KEY,JSON.stringify({engine:'javascript-autonomous',game:game.dump(),presentation}));
}

export function recallTab(storage,data,validatePresentation){
 const text=storage.getItem(TAB_SESSION_KEY);if(!text)return null;
 const saved=JSON.parse(text);
 if(saved.engine!=='javascript-autonomous')throw Error('Sessione di un altro motore.');
 validatePresentation(saved.presentation);
 return {game:Game.load(data,saved.game),presentation:saved.presentation};
}
