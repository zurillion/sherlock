export function canonical(value){if(Array.isArray(value))return '['+value.map(canonical).join(',')+']';if(value&&typeof value==='object')return '{'+Object.keys(value).sort().map(key=>JSON.stringify(key)+':'+canonical(value[key])).join(',')+'}';return JSON.stringify(value);}
export async function checksum(value){const bytes=new TextEncoder().encode(canonical(value)),hash=await crypto.subtle.digest('SHA-256',bytes);return [...new Uint8Array(hash)].map(b=>b.toString(16).padStart(2,'0')).join('');}
// Hash the representation actually written to disk. An error analysis may have
// optional undefined fields, which JSON omits; hashing those breaks later LOAD.
export async function seal(snapshot,presentation=null){const body=JSON.parse(JSON.stringify({...snapshot,presentation}));return {...body,sha256:await checksum(body)};}
export async function verify(document){if(!document||typeof document!=='object')throw Error('File di salvataggio non valido.');const {sha256,...body}=document;if(sha256!==await checksum(body))throw Error('Il controllo di integrità del salvataggio non corrisponde.');return body;}
