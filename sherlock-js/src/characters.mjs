// Presentation identities, independent of AI, random inputs and saved state.
const BADGES={2:'IL',3:'W',4:'CS',5:'DS',6:'BP',7:'PF',8:'G',9:'CK',10:'MD',11:'P1',12:'P2',13:'TF',31:'C1',34:'C2',94:'MB',95:'MJ',104:'GA'};
export function characterBadge(character,player){
 if(character.id===player)return 'SH';
 return BADGES[character.id]??(character.name.split(/\s+/).filter(word=>/^[a-z]/i.test(word)).slice(0,2).map(word=>word[0]).join('').toUpperCase()||'NPC');
}
