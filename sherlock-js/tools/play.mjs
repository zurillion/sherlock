import {readFile,writeFile} from 'node:fs/promises';
import {createInterface} from 'node:readline/promises';
import {stdin,stdout} from 'node:process';
import {Game} from '../src/game.mjs';
import {seal,verify} from '../src/save.mjs';
const data=JSON.parse(await readFile(new URL('../data/game.json',import.meta.url),'utf8'));
let game=new Game(data);console.log('SHERLOCK · motore JavaScript autonomo, prima fase\nAI, cab, treni e storia ancora da tradurre. Nessun codice Z80 eseguito.\n');console.log(game.opening);
const io=createInterface({input:stdin,output:stdout});
try{while(true){const command=await io.question('> ');if(command===':exit')break;
 try{if(command.startsWith(':save ')){await writeFile(command.slice(6),JSON.stringify(await seal(game.dump()),null,2)+'\n');console.log('Salvato.');continue;}if(command.startsWith(':load ')){game=Game.load(data,await verify(JSON.parse(await readFile(command.slice(6),'utf8'))));console.log('Caricato.',game.world.clock().label);continue;}
  const out=game.submit(command);for(const m of out.messages)console.log(m.kind==='system'?'[Motore JS] '+m.text:m.text);console.log('['+out.state.clock.label+']');
 }catch(error){console.error(error.message);}
}}finally{io.close();}
