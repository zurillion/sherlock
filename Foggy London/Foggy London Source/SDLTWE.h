#ifndef SDLTWE_H
#define SDLTWE_H

#include <SDL/SDL.h>

struct TextWindowStruct {
    SDL_Surface *TW_SDL_Surface;
    int PosX;
    int PosY;
    int Width;
    int Heigth;
    int CurrentPrintPosX;
    int CurrentPrintPosY;
};

struct CharSetStruct {
    int Width;
    int Height;
    byte * Bitmap;
    char CharMin;
    char CharMax;
    char CharSubstitute;
};

void SDLTWE_VerticalScrollUpOneLine(struct TextWindowStruct *TW, struct CharSetStruct *CS, color_t paper);
void SDLTWE_SetPixel(SDL_Surface *scr, int x, int y, Uint32 color);
void SDLTWE_DrawTextWindowFrame(struct TextWindowStruct *TW, int InnerWidth, Uint32 InnerColor, int OuterWidth, Uint32 OuterColor);
void SDLTWE_PrintCharTextWindow(struct TextWindowStruct *TW, char a, struct CharSetStruct *CS, Uint32 ink, Uint32 paper);
void SDLTWE_PrintString (struct TextWindowStruct *TW, char *ps, struct CharSetStruct *CS, Uint32 ink, Uint32 paper);
byte *SDLTWE_ReadCharSet(char *CharSetFilename, byte *CharSet);

#endif /* SDLTWE_H */
