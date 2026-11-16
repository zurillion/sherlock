// Physical upper window in regular scanline order. The Spectrum's interleaved
// addressing is translated by RandomDisplay.read at the boundary.
const stride = 32;
const scanlines = 18 * 8;
const pixelBytes = scanlines * stride;
const attributeBytes = 18 * stride;

export function newPictureWindow() {
  return { pixels: Array(pixelBytes).fill(0), attributes: Array(attributeBytes).fill(0x38), drawn: false };
}

export function validPictureWindow(window) {
  const valid = (values, length) => Array.isArray(values) && values.length === length &&
    values.every(value => Number.isInteger(value) && value >= 0 && value <= 255);
  return Boolean(window && typeof window.drawn === 'boolean' && valid(window.pixels, pixelBytes) && valid(window.attributes, attributeBytes));
}

export function paintGlyph({ pixels }, glyph, column) {
  const x = 2 + column * 7;
  const shift = x & 7;
  const at = (scanlines - 8) * stride + (x >>> 3);
  for (let line = 0; line < 8; line++) {
    const i = at + line * stride;
    pixels[i] = (pixels[i] & (0xFF ^ (0xFF >>> shift))) | (glyph[line] >>> shift);
    if (shift) {
      const mask = (0xFF << (8 - shift)) & 0xFF;
      pixels[i + 1] = (pixels[i + 1] & (0xFF ^ mask)) | ((glyph[line] << (8 - shift)) & 0xFF);
    }
  }
}

export function scrollPictureWindow(window, narrow) {
  const { pixels, attributes } = window;
  const width = narrow ? 16 : stride;
  for (let y = 0; y < scanlines - 8; y++) {
    const row = y * stride;
    pixels.copyWithin(row, row + 8 * stride, row + 8 * stride + width);
  }
  if (!narrow) attributes.copyWithin(0, stride);
  // C374 clears with glyphs, so the two-pixel left margin remains intact.
  for (let y = scanlines - 8; y < scanlines; y++) {
    const row = y * stride;
    pixels[row] &= 0xC0;
    const last = row + 31;
    if (narrow) {
      pixels.fill(0, row + 1, row + 16);
      pixels[row + 16] &= 0x7F; // Column 18's final pixel crosses the midpoint.
    } else {
      pixels.fill(0, row + 1, last);
      pixels[last] &= 1; // Column 36's glyph stops at x=254.
    }
  }
}

export function applyRoomPicture(window, encoded) {
  const picture = atob(encoded);
  if (picture.length !== (scanlines + 18) * 16) return false;
  const parts = [window.pixels, window.attributes];
  for (const [part, values] of parts.entries()) {
    const blank = part === 0 ? 0 : 0x38;
    for (let row = 16; row < values.length; row += stride) {
      for (let column = 0; column < 16; column++) {
        if (values[row + column] !== blank) return false;
      }
    }
  }
  let at = 0;
  for (const values of parts) {
    for (let row = 16; row < values.length; row += stride) {
      for (let column = 0; column < 16; column++) values[row + column] = picture.charCodeAt(at++);
    }
  }
  window.drawn = true;
  return true;
}
