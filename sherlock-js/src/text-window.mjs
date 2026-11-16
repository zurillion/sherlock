// Functional C129/C142 window controls. These describe source state, not DOM
// picture preferences. The native graphics profile can use both modes.
export function textWindowControl(narrow,previousCounter){
 return {mode:narrow?1:0,columns:narrow?18:36,cursor:0,remaining:narrow?18:36,counter:narrow?0:previousCounter};
}

// C1A8 starts on byte 1, renders one blank, 11 clock characters and one blank.
export const spectrumClockOrigin=8;
export const spectrumClockAdvance=7;
