import {Game} from './game.mjs';

export const TAB_SESSION_KEY='sherlock-autonomous-tab-v1';

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
