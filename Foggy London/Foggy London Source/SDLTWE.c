/****************************************************************************\
*                                                                            *
*                                SDLTWE.c                                    *
*                                                                            *
* SDL Text Windows Engine                                                    *
*                                                                            *
* (c) 2012 by CH                                                             *
*                                                                            *
* V 1.02 - 20120720                                                          *
\****************************************************************************/


#include <stdio.h>
#include <SDL/SDL.h>

#include "FL.h"
#include "SDLTWE.h"



/****************************************************************************\
* SDLTWE_VerticalScrollUpOneLine                                             *
*                                                                            *
\****************************************************************************/
void SDLTWE_VerticalScrollUpOneLine(struct TextWindowStruct *TW, struct CharSetStruct *CS, color_t paper)
{
    int x, y;

    SDL_Rect src, dest;

    src.x = TW->PosX;
    src.y = TW->PosY + CS->Height;
    src.w = TW->Width;
    src.h = TW->Heigth - CS->Height;

    dest.x = TW->PosX;
    dest.y = TW->PosY;
    dest.w = 0;
    dest.h = 0;

    SDL_BlitSurface(TW->TW_SDL_Surface, &src, TW->TW_SDL_Surface, &dest);

    for (y = 0; y < CS->Height; y++)
        for (x = 0; x < TW->Width; x++)
            SDLTWE_SetPixel(TW->TW_SDL_Surface, TW->PosX + x, TW->PosY + TW->Heigth - CS->Height + y, paper);

    SDL_Flip(TW->TW_SDL_Surface);
}


/****************************************************************************\
* SDLTWE_Setpix                                                              *
*                                                                            *
\****************************************************************************/
void SDLTWE_SetPixel(SDL_Surface *scr, int x, int y, color_t color)
{
    Uint32 *pixmem32;

    pixmem32 = (Uint32 *)scr->pixels + y * scr->pitch / (COLORDEPTH / 8) + x;
    *pixmem32 = color;
}


/****************************************************************************\
* SDLTWE_DrawTextWindowFrame                                                 *
*                                                                            *
* Draw a double frame around a text window.                                  *
* The caller is responsible for sensible values!                             *
\****************************************************************************/
void SDLTWE_DrawTextWindowFrame(struct TextWindowStruct *TW, int InnerWidth, color_t InnerColor, int OuterWidth, color_t OuterColor)
{
    int x, y;

    // inner frame
    for (y = 0; y < InnerWidth; y++)    // N
        for (x = TW->PosX - InnerWidth; x <= TW->PosX + TW->Width - 1 + InnerWidth; x++)
            SDLTWE_SetPixel(TW->TW_SDL_Surface, x, TW->PosY - y - 1, InnerColor);
    for (y = 0; y < InnerWidth; y++)    // S
        for (x = TW->PosX - InnerWidth; x <= TW->PosX + TW->Width - 1 + InnerWidth; x++)
            SDLTWE_SetPixel(TW->TW_SDL_Surface, x, TW->PosY + TW->Heigth + y, InnerColor);
    for (x = 0; x < InnerWidth; x++)    // W
        for (y = TW->PosY - InnerWidth; y <= TW->PosY + TW->Heigth - 1 + InnerWidth; y++)
            SDLTWE_SetPixel(TW->TW_SDL_Surface, TW->PosX - 1 - x, y, InnerColor);
    for (x = 0; x < InnerWidth; x++)    // E
        for (y = TW->PosY - InnerWidth; y <= TW->PosY + TW->Heigth - 1 + InnerWidth; y++)
            SDLTWE_SetPixel(TW->TW_SDL_Surface, TW->PosX + TW->Width + x, y, InnerColor);
    // outer frame
    for (y = 0; y < OuterWidth; y++)    // N
        for (x = TW->PosX - OuterWidth - InnerWidth; x <= TW->PosX + TW->Width - 1 + InnerWidth + OuterWidth; x++)
            SDLTWE_SetPixel(TW->TW_SDL_Surface, x, TW->PosY - y - 1 - InnerWidth, OuterColor);
    for (y = 0; y < OuterWidth; y++)    // S
        for (x = TW->PosX - OuterWidth - InnerWidth; x <= TW->PosX + TW->Width - 1 + InnerWidth + OuterWidth; x++)
            SDLTWE_SetPixel(TW->TW_SDL_Surface, x, TW->PosY + TW->Heigth + y + InnerWidth, OuterColor);
    for (x = 0; x < OuterWidth; x++)    // W
        for (y = TW->PosY - OuterWidth - InnerWidth; y <= TW->PosY + TW->Heigth - 1 + InnerWidth + OuterWidth; y++)
            SDLTWE_SetPixel(TW->TW_SDL_Surface, TW->PosX - 1 - x - InnerWidth, y, OuterColor);
    for (x = 0; x < OuterWidth; x++)    // E
        for (y = TW->PosY - OuterWidth - InnerWidth; y <= TW->PosY + TW->Heigth - 1 + InnerWidth + OuterWidth; y++)
            SDLTWE_SetPixel(TW->TW_SDL_Surface, TW->PosX + TW->Width + x + InnerWidth, y, OuterColor);
}


/****************************************************************************\
* SDLTWE_PrintCharTextWindow                                                 *
*                                                                            *
* Prints a character to a text window. The print coordinates are updated and *
* a vertical scroll is performed if necessary.                               *
* The following control characters are processed:                            *
*   \n \c (both used as Newline, ie CR/LF)                                   *
*   \f    (used as CLS)                                                      *
\****************************************************************************/
void SDLTWE_PrintCharTextWindow(struct TextWindowStruct *TW, char a, struct CharSetStruct *CS, color_t ink, color_t paper)
{
    int i, j;
    int CharIndex;
    byte mask;
    int ymul;
    Uint32 *pixm;

    if (FL_DEBUG)
    {
        if ((CS->Width != 8) || (CS->Height != 8))
        {
            fprintf(stderr, "SDLTWE: ERROR in PrintCharTextWindow. Only 8x8 pixel charsets are supported.\n");
            return;
        }
    }

    if (a == '\f')
    {
        for (i = 0; i < (TW->Heigth / CS->Height); i++)
                    SDLTWE_VerticalScrollUpOneLine(TW, CS, paper);
        TW->CurrentPrintPosX = 0;
        TW->CurrentPrintPosY = 0;
        return;
    }


    if (TW->CurrentPrintPosY >= TW->Heigth)
    {
        SDLTWE_VerticalScrollUpOneLine(TW, CS, paper);
        TW->CurrentPrintPosX = 0;
        TW->CurrentPrintPosY -= CS->Height;
    }


    if (a == '\n' || a == 0x0D)
    {
        TW->CurrentPrintPosX = 0;
        TW->CurrentPrintPosY += CS->Height;
        return;
    }


    // if required substitute characters not contained in the character set
    if ((a < CS->CharMin) || (a > CS->CharMax))
    {
        if (CS->CharSubstitute)
            a = CS->CharSubstitute;
        else
            return;
    }

    ymul = TW->TW_SDL_Surface->pitch / (COLORDEPTH / 8);
    for (i = 0; i <= 7; i++)
    {
        mask = 0x80;
        CharIndex = (a - CS->CharMin) * CS->Height;
        for (j = 0; j <= 7; j++, mask >>= 1)
        {
            pixm = (Uint32 *) (TW->TW_SDL_Surface->pixels) + (TW->PosY + TW->CurrentPrintPosY + i) * ymul + TW->PosX + TW->CurrentPrintPosX + j;
            if (CS->Bitmap[CharIndex + i] & mask)
                *pixm = ink;
            else
                *pixm = paper;
        }
    }

    TW->CurrentPrintPosX += CS->Width;
    if (TW->CurrentPrintPosX >= TW->Width)
    {
        TW->CurrentPrintPosX = 0;
        TW->CurrentPrintPosY += CS->Height;
    }
}


/****************************************************************************\
* SDLTWE_PrintString                                                         *
*                                                                            *
\****************************************************************************/
void SDLTWE_PrintString(struct TextWindowStruct *TW, char *ps, struct CharSetStruct *CS, color_t ink, color_t paper)
{
    while (*ps)
        SDLTWE_PrintCharTextWindow(TW, *ps++, CS, ink, paper);
}


/****************************************************************************\
* SDLTWE_ReadCharSet                                                         *
*                                                                            *
* Reads a binary character set.                                              *
*                                                                            *
* INPUT:  CharSetFilename = Filename (incl. path) of data to load            *
*         CharSet = a place to store the data                                *
* RETURN: pointer to data read OR NULL if error occured                      *
\****************************************************************************/
byte *SDLTWE_ReadCharSet(char *CharSetFilename, byte *CharSet)
{
    FILE *fp;
    long int FileLength;
    size_t BytesRead;

    fp = fopen(CharSetFilename, "rb");
    if (!fp)
    {
        fprintf(stderr, "ERROR in SDLWTE.c: can't open character set file '%s'\n", CharSetFilename);
        return (NULL);
    }

    fseek(fp, 0, SEEK_END);
    FileLength = ftell(fp);
    fseek(fp, 0, SEEK_SET);

    if (FL_DEBUG)
    {
        printf("SDLWTE: Reading character set with %i byte from %s ... ", FileLength, CharSetFilename);
    }

    BytesRead = fread(CharSet, 1, FileLength, fp);

    fclose(fp);

    if (FileLength != BytesRead)
    {
        if (FL_DEBUG)
            printf("ERROR!\n");
        return (NULL);
    }
    else
    {
        if (FL_DEBUG)
            printf("read!\n");
        return (CharSet);
    }
}
