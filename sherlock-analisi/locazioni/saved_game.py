"""Portable, checksummed full-machine saves; never pickle or native tape LOAD."""
import base64,binascii,hashlib,json
from copy import deepcopy

FORMAT='sherlock-web-save'
VERSION=1
PAYLOAD='c5d48285c0cee5c25cf4734dff0ac8296c0ec0194135e3a72267e49724ac8407'
FIELDS=('start_mode','explored','last_listed','last_analysis','initial','initial_screen','opening',
        'opening_screen','opening_pending','ending_messages')

def digest(value):
    return hashlib.sha256(json.dumps(value,sort_keys=True,ensure_ascii=True,separators=(',',':')).encode()).hexdigest()

def save(game,presentation=None):
    if game.command_job is not None:raise ValueError('Finish the current command before saving.')
    w=game.world
    state={key:sorted(game.explored) if key=='explored' else deepcopy(getattr(game,key)) for key in FIELDS}
    machine={'memory':base64.b64encode(bytes(w.m)).decode(),'registers':w.sim.registers[:],
             'input_registers':w.input_registers[:],'input_stack':w.input_stack[:],
             'seed':w.seed,'ended':deepcopy(w.ended),
             'active_npcs':None if w.active_npcs is None else sorted(w.active_npcs),
             'frame_duration':w.sim.frame_duration,'int_active':w.sim.int_active}
    body={'format':FORMAT,'version':VERSION,'payload_sha256':PAYLOAD,
          'rom_sha256':hashlib.sha256(bytes(w.m[:16384])).hexdigest(),
          'machine':machine,'game':state,'presentation':presentation}
    return {**body,'sha256':digest(body)}

def integer(value,lo,hi):return type(value)==int and lo<=value<=hi

def registers(value):
    if not isinstance(value,list) or len(value)!=30:raise ValueError('Invalid CPU register count.')
    for i,v in enumerate(value):
        limit=2**53-1 if i==25 else 65535 if i in (12,13,24,29) else 2 if i==27 else 1 if i in (26,28) else 255
        if not integer(v,0,limit):raise ValueError('Invalid CPU register value.')
    return value[:]

def load(project,data,document):
    from explorer import Game
    from native_world import NativeWorld
    if not isinstance(document,dict):raise ValueError('Invalid save file.')
    body={k:v for k,v in document.items() if k!='sha256'}
    if body.get('format')!=FORMAT or type(body.get('version'))!=int or body.get('version')!=VERSION:raise ValueError('Unsupported save format/version.')
    if document.get('sha256')!=digest(body):raise ValueError('Save checksum does not match.')
    if body.get('payload_sha256')!=PAYLOAD:raise ValueError('This save belongs to another game version.')
    try:
        machine=body['machine'];state=body['game'];memory=base64.b64decode(machine['memory'],validate=True)
        if len(memory)!=65536:raise ValueError('Invalid memory size.')
        r=registers(machine['registers']);input_r=registers(machine['input_registers'])
        stack=machine['input_stack']
        if not isinstance(stack,list) or len(stack)!=128 or not all(integer(x,0,255) for x in stack):raise ValueError('Invalid input stack.')
        seed=machine['seed'];active=machine['active_npcs']
        if seed is not None and not integer(seed,0,255):raise ValueError('Invalid initial seed.')
        if active is not None and (not isinstance(active,list) or not all(integer(x,0,109) for x in active)):raise ValueError('Invalid actor selection.')
        if type(machine['ended']) not in (dict,type(None)):raise ValueError('Invalid ending state.')
        if input_r[24]!=0xa536:raise ValueError('The save is not at an input boundary.')
        for key in FIELDS:
            expected=bool if key=='opening_pending' else str if key in ('start_mode','initial','opening') else (dict,type(None)) if key=='last_analysis' else list
            if not isinstance(state[key],expected):raise ValueError('Invalid game metadata: '+key)
        if state['start_mode'] not in ('free','original'):raise ValueError('Invalid startup mode.')
        rooms={row['id'] for row in data['rooms']}
        if not all(type(x)==int and x in rooms for x in state['explored']):raise ValueError('Invalid explored rooms.')
        if not all(integer(x,0,109) for x in state['last_listed']):raise ValueError('Invalid object list.')
        if machine['frame_duration']!=69888 or machine['int_active']!=32:raise ValueError('Unsupported CPU timing profile.')
        if not (memory[0x9fdf]<60 and 1<=memory[0x9fe0]<=12 and memory[0x9fe1]<7 and memory[0x9fe2] in (97,112)):raise ValueError('Invalid game clock.')
        candidate=Game.__new__(Game);candidate.data=data;candidate.world=NativeWorld(project,active_npcs=active)
        w=candidate.world
        if memory[:16384]!=bytes(w.m[:16384]) or body['rom_sha256']!=hashlib.sha256(memory[:16384]).hexdigest():raise ValueError('Spectrum ROM does not match.')
        w.m[:]=memory;w.sim.registers[:]=r;w.input_registers=input_r;w.input_stack=stack[:]
        w.seed=seed;w.ended=deepcopy(machine['ended']);candidate.parser=w.engine
        candidate.rooms={x['id']:x for x in data['rooms']};candidate.entities={x['id']:x for x in data['entities']}
        if w.player_id not in candidate.entities or w.room not in rooms:raise ValueError('Invalid player position.')
        candidate.command_job=None;candidate.job_id=None;candidate.cached_state=None
        for key in FIELDS:setattr(candidate,key,set(state[key]) if key=='explored' else deepcopy(state[key]))
        candidate.state() # Validate read-only derived state before replacing a live session.
        return candidate,deepcopy(body.get('presentation'))
    except (KeyError,IndexError,TypeError,binascii.Error) as exc:
        raise ValueError('Invalid or incomplete save file.') from exc
