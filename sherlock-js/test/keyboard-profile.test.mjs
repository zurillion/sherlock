import test from'node:test';import assert from'node:assert/strict';import{readFile}from'node:fs/promises';import{bootstrapKeyboard}from'../src/keyboard-profile.mjs';
const cases=JSON.parse(await readFile(new URL('fixtures/keyboard-profile-reference.json',import.meta.url)));
test('Boot RETURN and release ageing: exact ROM scanner results across eight protocols',()=>{assert.equal(cases.length,8);for(const row of cases)assert.deepEqual(bootstrapKeyboard({releaseScans:row.releaseScans}),row.bytes);});
