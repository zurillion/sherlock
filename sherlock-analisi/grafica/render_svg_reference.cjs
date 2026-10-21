// Verifica opzionale: richiede Node e Sharp (librsvg). Non serve per il decoder Python.
const sharp = require(process.env.SHERLOCK_SHARP_MODULE || 'sharp');
const fs = require('node:fs');
const path = require('node:path');
(async()=>{
for(const file of process.argv.slice(2)){
 await sharp(fs.readFileSync(file),{density:72}).png().toFile(file.replace(/\.svg$/,'-reference.png'));
 console.log(path.basename(file));
}
})();
