"""Stato del prototipo: parser originale, azioni selezionate, nessun turno NPC."""
from native_world import NativeWorld,word

def perceived(m,ident,actor=None):
    if actor is None:actor=m[0x9860]
    def record(i):return word(m,0x8b70+3*i)
    def barrier(i):
        p=record(i);seen=set()
        while m[p+1]!=255:
            i=m[p+1]
            if i in seen:raise ValueError('Ciclo nel contenimento')
            seen.add(i);p=record(i)
            if not m[p+5]&128 or not m[p+5]&40:return i
        return 255
    a=barrier(actor)
    if a==ident:return True
    p=record(ident)
    if not m[p+5]&128:return False
    b=barrier(ident)
    if b==actor:return True
    if b!=a:return False
    if b!=255:return True
    room=m[record(actor)+15]
    return room in m[p+15:p+15+m[p]]

class Game:
    def __init__(self,project,data):
        self.data=data;self.world=NativeWorld(project);self.parser=self.world.engine
        self.rooms={x['id']:x for x in data['rooms']};self.entities={x['id']:x for x in data['entities']}
        self.explored={8};self.last_listed=[];self.last_analysis=None
        scene=self.world.scene();self.last_listed=scene['listed'];self.initial=scene['text']
    def characters(self):
        """Posizioni vive dei personaggi; le identita alternative di Holmes sono un solo segnaposto."""
        m=self.world.m;player=self.world.player_id;characters=[]
        badges={0:'SH',1:'SH',100:'SH',2:'IL',3:'W',4:'CS',5:'DS',6:'BP',7:'PF',8:'G',9:'CK',10:'M',11:'P1',12:'P2',13:'TF',31:'C1',34:'C2',94:'MB',95:'MJ',104:'GA'}
        for ident,obj in self.entities.items():
            if not obj['person_flag'] and ident!=player:continue
            if ident in (0,1,100) and ident!=player:continue
            p=int(obj['record'],16);locations=list(dict.fromkeys(m[p+15:p+15+m[p]]))
            locations=[room for room in locations if room in self.rooms and room!=0]
            name='Sherlock Holmes' if ident==player else obj['name'].title()
            if ident==player and ident!=0:name+=' ('+obj['name'].title()+')'
            characters.append({'id':ident,'key':'player' if ident==player else str(ident),'name':name,'badge':badges.get(ident,str(ident)),'rooms':locations,'parent_id':None if m[p+1]==255 else m[p+1],'is_player':ident==player,'visible_flag':bool(m[p+5]&128)})
        return characters
    def state(self):
        w=self.world;m=w.m;room=self.rooms[w.room];exits=[];dark=w.call(0xd078)['carry']
        for edge in room['exits']:
            gate=edge['gate'];p=int(self.entities[gate]['record'],16) if gate else None
            status='senza destinazione' if not edge['target'] else 'libera' if not gate else 'aperta / attraversabile' if m[p+5]&40 else 'chiusa / ostacolo'
            exits.append({**edge,'target_name':self.rooms[edge['target']]['name_hint'],'status':status})
        return {'characters':self.characters(),'player_id':w.player_id,'room':w.room,'name':room['name_hint'],'clock':w.clock(),'visited':sorted(self.explored),'native_seen':[i for i,r in self.rooms.items() if m[int(r['record'],16)]&64],'exits':exits,'objects':[{'id':i,'name':self.entities[i]['name']} for i in self.last_listed],'dark':dark,'visible':[{'id':i,'name':o['name']} for i,o in self.entities.items() if not dark and i!=w.player_id and perceived(m,i)],'initial':self.initial,'analysis':self.last_analysis}
    def result(self,messages,**extra):return {'state':self.state(),'messages':messages,**extra}
    def teleport(self,ident):
        if type(ident)!=int or ident not in self.rooms or ident==0:raise ValueError('Locazione non esplorabile')
        first_visit=ident not in self.explored
        if self.world.m[0xa01b]:
            self.world.call(0xd87d);self.world.call(0xd88a)
            self.world.m[0xa01b]=0;self.world.m[0xd7e0]=0;self.world.m[0xd6b8]=0
        scene=self.world.teleport(ident);self.explored.add(ident);self.last_listed=scene['listed']
        return self.result([{'kind':'narrative','text':scene['text'],'image_room':ident if first_visit else None}])
    def command(self,text):
        out=self.world.submit(text,self.explored)
        self.last_analysis=out['analysis']
        if out.get('scene'):self.last_listed=out['listed']
        return self.result(out['messages'])
