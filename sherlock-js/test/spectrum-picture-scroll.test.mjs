import assert from 'node:assert/strict';
import test from 'node:test';
import { SpectrumBuffer, SpectrumTerminal } from '../src/spectrum.mjs';

function terminalForPicture() {
  const terminal = Object.create(SpectrumTerminal.prototype);
  const frames = [];
  const pictures = [];
  Object.assign(terminal, {
    active: true,
    epoch: 1,
    delay: 0,
    model: new SpectrumBuffer(),
    pictureMode: 'svg',
    pictures: true,
    urls: { svg: { 6: '006.svg' } },
    render() {
      frames.push({ lines: [...this.model.lines], counter: this.model.counter });
    },
    async loadPicture(room) {
      pictures.push({ room, afterFrames: frames.length });
    },
  });
  terminal.model.lines = Array.from({ length: 18 }, (_, i) => 'Row ' + (i + 1));
  return { terminal, frames, pictures };
}

test('A room picture appears after every line of the previous screen has visibly scrolled', async () => {
  const { terminal, frames, pictures } = terminalForPicture();
  const original = [...terminal.model.lines];
  const transition = terminal.displayEvent({ op: 'picture', room: 6 }, 1);
  await Promise.resolve();
  assert.equal(frames.length, 1);
  assert.deepEqual(pictures, []);

  assert.equal(await transition, true);
  assert.equal(frames.length, 18);
  for (const [index, frame] of frames.entries()) {
    const scrolls = index + 1;
    assert.deepEqual(frame.lines, [...original.slice(scrolls), ...Array(scrolls).fill('')]);
    assert.equal(frame.counter, 0);
  }
  assert.deepEqual(pictures, [{ room: 6, afterFrames: 18 }]);
});

test('Restarting during the scroll prevents the old room picture from appearing', async () => {
  const { terminal, frames, pictures } = terminalForPicture();
  const transition = terminal.displayEvent({ op: 'picture', room: 6 }, 1);
  await Promise.resolve();
  terminal.epoch++;
  assert.equal(await transition, false);
  assert.equal(frames.length, 1);
  assert.deepEqual(pictures, []);
});
