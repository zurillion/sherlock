/****************************************************************************\
*                                                                            *
*                                Spectrum                                    *
*                                                                            *
* Spectrum specific subroutines for the FL project.                          *
*                                                                            *
* (c) 2012 by CH                                                             *
*                                                                            *
* V 1.02 - 20130423                                                          *
*                                                                            *
\****************************************************************************/



/*** INCLUDES ***************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <SDL/SDL.h>

#include "SPECTRUM.h"
#include "FL.h"
#include "SDLTWE.h"
#include "Z80/Z80.h"


/*** GLOBAL VARIABLES *******************************************************/
#define EXTERN extern
#include "GLOBAL_VARS.h"

color_t ColorTable[] =
{ SC_BLACK, SC_BLUE, SC_RED, SC_MAGENTA, SC_GREEN, SC_CYAN, SC_YELLOW, SC_WHITE,
    SC_BRBLACK, SC_BRBLUE, SC_BRRED, SC_BRMAGENTA, SC_BRGREEN, SC_BRCYAN, SC_BRYELLOW, SC_BRWHITE
};

enum SHRP shrp[] =  // Spectrum half row port addresses
{ SHRP_cV, SHRP_AG, SHRP_QT, SHRP_15, SHRP_06, SHRP_PY, SHRP_eH, SHRP_sB };


/****************************************************************************\
* SetQuadPixel                                                               *
*                                                                            *
\****************************************************************************/
void SetQuadPixel(SDL_Surface *scr, int x, int y, color_t color)
{
    Uint32 *pixmem32;

    pixmem32 = (Uint32 *)scr->pixels + 2 * (y * scr->pitch / (COLORDEPTH / 8)) + 2 * x;
    *pixmem32++ = color;
    *pixmem32 = color;

    if (NoScanLines)
    {
        pixmem32 += scr->pitch / (COLORDEPTH / 8);
        *pixmem32-- = color;
        *pixmem32 = color;
    }
}


/****************************************************************************\
* WriteScreenByte                                                            *
*                                                                            *
\****************************************************************************/
void WriteScreenByte(word address, byte v)
{
    int i;
    byte xx, yy, mask, attr, BRIGHT;
    color_t ColI, ColP;

    if (address < SL_SCREENSTART || address > SL_SCREENEND)
        return;

    xx = (byte) (address & 0x001F);
    yy = (byte) (((address & 0x1800) >> 5) | ((address & 0x0700) >> 8) | ((address & 0x00E0) >> 2));
    attr = mem[SL_ATTRIBUTESTART + xx + ((yy & 0xF8) << 2)];
    BRIGHT = (attr & 0x40) >> 3;
    ColI = ColorTable[(attr & 0x07) + BRIGHT];
    ColP = ColorTable[((attr & 0x38) >> 3) + BRIGHT];

    mask = 0x80;
    for (i = 0; i <= 7; i++, mask >>= 1)
    {
        SetQuadPixel(screen, GAMEWINPOSX / 2 + (xx << 3) + i, GAMEWINPOSY / 2 + yy, (v & mask) ? ColI : ColP);
    }
}


/****************************************************************************\
* WriteAttributeByte                                                         *
*                                                                            *
\****************************************************************************/
void WriteAttributeByte(word address, byte v)
{
    word i, base_adr;
    word x, y;

    if (address < SL_ATTRIBUTESTART || address > SL_ATTRIBUTEEND)
        return;

    y = ((address - SL_ATTRIBUTESTART) / 32) * 8;
    x = (address - SL_ATTRIBUTESTART) % 32;
    base_adr = SL_SCREENSTART + (((y & 0xC0) << 5) | ((y & 0x38) << 2) | ((y & 0x03) << 8));
    base_adr = (base_adr + x) & 0xF8FF;

    for (i = 0; i <= 0x700; i += 0x100)
        WriteScreenByte(base_adr + i, mem[base_adr + i]);
}


/****************************************************************************\
* RdZ80                                                                      *
*                                                                            *
\****************************************************************************/
byte RdZ80(word A)
{
    return (mem[A]);
}


/****************************************************************************\
* WrZ80                                                                      *
*                                                                            *
\****************************************************************************/
void WrZ80(word A, byte v)
{
    if (A <= SL_ROMEND)
        return;
    mem[A] = v;
    if (A <= SL_SCREENEND)
    {
        WriteScreenByte(A, v);
        return;
    }
    if (A <= SL_ATTRIBUTEEND)
    {
        WriteAttributeByte(A, v);
        return;
    }
}


#pragma optimize(none)
/****************************************************************************\
* InZ80                                                                      *
*                                                                            *
* Simulates a basic keyboard interface.                                      *
*                                                                            *
* In Pelles C 6.50.8 optimiziation 'time' causes a hard to detect optimi-    *
* zation-error. Therefore optimizition is turned off for this section with   *
* the privat #pragma optimize(none) instruction!                             *
\****************************************************************************/
byte InZ80(word P)
{
    if ((P & 0xFF) != 0xFE) // we only support the keyboard port 0xFE
    {
        printf("Spectrum.c: InZ80() tried to read from unsupported port %04X.\n", P);
        return (0xFF);
    }


    if (P == 0x00FE)    // all keyboard rows at once (the upper 8 bit select the half row)
    {
        if (CurrentPressedKey)
        {
            switch (CurrentPressedKey)
            {
                case 'a':
                case 'q':
                case '1':
                case '0':
                case 'p':
                case SDLK_RETURN:
                case ' ':
                    return (0xFF - 0x01);
                case 'z':
                case 's':
                case 'w':
                case '2':
                case '9':
                case 'o':
                case 'l':
                    return (0xFF - 0x02);
                case 'x':
                case 'd':
                case 'e':
                case '3':
                case '8':
                case 'i':
                case 'k':
                case 'm':
                    return (0xFF - 0x04);
                case 'c':
                case 'f':
                case 'r':
                case '4':
                case '7':
                case 'u':
                case 'j':
                case 'n':
                    return (0xFF - 0x08);
                case 'v':
                case 'g':
                case 't':
                case '5':
                case '6':
                case 'y':
                case 'h':
                case 'b':
                    return (0xFF - 0x10);

                default:
                    return (0xFF);
            }
        }

        else

        {
            return (0xFF);  //no key pressed
        }
    }


    P >>= 8;

    switch (CurrentPressedKey)
    {
        case 'z':
            if (P == SHRP_cV)
                return (0xFF - 0x02);
            break;
        case ':':
            if (P == SHRP_cV)
                return (0xFF - 0x02);
            if (P == SHRP_sB)
                return (0xFF - 0x02);
            break;
        case 'x':
            if (P == SHRP_cV)
                return (0xFF - 0x04);
            break;
        case '$':
            if (P == SHRP_cV)
                return (0xFF - 0x04);
            if (P == SHRP_sB)
                return (0xFF - 0x02);
            break;
        case 'c':
            if (P == SHRP_cV)
                return (0xFF - 0x08);
            break;
        case 'v':
            if (P == SHRP_cV)
                return (0xFF - 0x10);
            break;
        case '/':
            if (P == SHRP_cV)
                return (0xFF - 0x10);
            if (P == SHRP_sB)
                return (0xFF - 0x02);
            break;

        case 'a':
            if (P == SHRP_AG)
                return (0xFF - 0x01);
            break;
        case 's':
            if (P == SHRP_AG)
                return (0xFF - 0x02);
            break;
        case 'd':
            if (P == SHRP_AG)
                return (0xFF - 0x04);
            break;
        case 'f':
            if (P == SHRP_AG)
                return (0xFF - 0x08);
            break;
        case 'g':
            if (P == SHRP_AG)
                return (0xFF - 0x10);
            break;

        case 'q':
            if (P == SHRP_QT)
                return (0xFF - 0x01);
            break;
        case 'w':
            if (P == SHRP_QT)
                return (0xFF - 0x02);
            break;
        case 'e':
            if (P == SHRP_QT)
                return (0xFF - 0x04);
            break;
        case 'r':
            if (P == SHRP_QT)
                return (0xFF - 0x08);
            break;
        case 't':
            if (P == SHRP_QT)
                return (0xFF - 0x10);
            break;

        case '1':
            if (P == SHRP_15)
                return (0xFF - 0x01);
            break;
        case '2':
            if (P == SHRP_15)
                return (0xFF - 0x02);
            break;
        case '@':
            if (P == SHRP_15)
                return (0xFF - 0x02);
            if (P == SHRP_sB)
                return (0xFF - 0x02);
            break;
        case '3':
            if (P == SHRP_15)
                return (0xFF - 0x04);
            break;
        case '4':
            if (P == SHRP_15)
                return (0xFF - 0x08);
            break;
        case '5':
            if (P == SHRP_15)
                return (0xFF - 0x10);
            break;

        case '0':
            if (P == SHRP_06)
                return (0xFF - 0x01);
            break;
        case SDLK_BACKSPACE:
            if (P == SHRP_06)
                return (0xFF - 0x01);
            if (P == SHRP_cV)
                return (0xFF - 0x01);
            break;
        case '9':
            if (P == SHRP_06)
                return (0xFF - 0x02);
            break;
        case '8':
            if (P == SHRP_06)
                return (0xFF - 0x04);
            break;
        case '7':
            if (P == SHRP_06)
                return (0xFF - 0x08);
            break;
        case '6':
            if (P == SHRP_06)
                return (0xFF - 0x10);
            break;

        case 'p':
            if (P == SHRP_PY)
                return (0xFF - 0x01);
            break;
        case '"':
            if (P == SHRP_PY)
                return (0xFF - 0x01);
            if (P == SHRP_sB)
                return (0xFF - 0x02);
            break;
        case 'o':
            if (P == SHRP_PY)
                return (0xFF - 0x02);
            break;
        case 'i':
            if (P == SHRP_PY)
                return (0xFF - 0x04);
            break;
        case 'u':
            if (P == SHRP_PY)
                return (0xFF - 0x08);
            break;
        case 'y':
            if (P == SHRP_PY)
                return (0xFF - 0x10);
            break;

        case SDLK_RETURN:
            if (P == SHRP_eH)
                return (0xFF - 0x01);
            break;
        case 'l':
            if (P == SHRP_eH)
                return (0xFF - 0x02);
            break;
        case 'k':
            if (P == SHRP_eH)
                return (0xFF - 0x04);
            break;
        case 'j':
            if (P == SHRP_eH)
                return (0xFF - 0x08);
            break;
        case '-':
            if (P == SHRP_eH)
                return (0xFF - 0x08);
            if (P == SHRP_sB)
                return (0xFF - 0x02);
            break;
        case 'h':
            if (P == SHRP_eH)
                return (0xFF - 0x10);
            break;

        case ' ':
            if (P == SHRP_sB)
                return (0xFF - 0x01);
            break;
        case 'm':
            if (P == SHRP_sB)
                return (0xFF - 0x04);
            break;
        case '.':
            if (P == SHRP_sB)
                return (0xFF - 0x04 - 0x02);
            break;
        case 'n':
            if (P == SHRP_sB)
                return (0xFF - 0x08);
            break;
        case ',':
            if (P == SHRP_sB)
                return (0xFF - 0x08 - 0x02);
            break;
        case 'b':
            if (P == SHRP_sB)
                return (0xFF - 0x10);
            break;

        printf("%02X  ", CurrentPressedKey);
        default:
            return (0xFF);
    }

    return (0xFF);
}
#pragma optimize(time)


/****************************************************************************\
* OutZ80                                                                     *
*                                                                            *
\****************************************************************************/
void OutZ80(word P, byte v)
{
    return;
}


/****************************************************************************\
* LoopZ80                                                                    *
*                                                                            *
\****************************************************************************/
word LoopZ80(register Z80 *R)
{
    return 0;
}


/****************************************************************************\
* PatchZ80                                                                   *
*                                                                            *
\****************************************************************************/
void PatchZ80(register Z80 *R)
{
    return;
}


/****************************************************************************\
* PrintObjNrActingAnimal                                                     *
*                                                                            *
\****************************************************************************/
void PrintObjNrActingAnimal (byte onaa)
{
char aa[20];

    strcpy(aa, "[");
    sprintf(aa+1, "%02X", onaa);
    strcat(aa,"]:");

    SDLTWE_PrintString(&LogWin, aa, &CharSet, SC_BLACK, SC_WHITE);
}


void LockScreen(SDL_Surface *LSscreen);
void UnLockScreen(SDL_Surface *LSscreen);

/****************************************************************************\
* JumpZ80                                                                    *
*                                                                            *
\****************************************************************************/
void JumpZ80(word PC)
{
    static char LastChar = 0;
    static char WordBuffer[30];
    byte SUBJECT;


    switch (SV) // to make this fast...
    {

        case V10:
        case V20:
            if (PC == 0xA9B7)
            {
                if (!mem[L_PRINT_DICT_WORDS])
                {
                    if (!VerboseLevel)
                        break;
                    SUBJECT = mem[L_SUBJECT];
                    if (VerboseLevel == 1 && (SUBJECT >= 0x24 && SUBJECT <= 0x2B))  // steam trains
                        break;
                    if (z80.AF.B.h >= 'A' && z80.AF.B.h <= 'Z')
                        z80.AF.B.h |= 0x20;                         // convert to lower case
                    WordBuffer[0] = z80.AF.B.h;
                    WordBuffer[1] = 0;
                    SDLTWE_PrintString(&LogWin, WordBuffer, &CharSet, SC_BLACK, SC_WHITE);
                    if (z80.AF.B.h == 0x0D)
                        SDLTWE_PrintString(&LogWin, WordBuffer, &CharSet, SC_BLACK, SC_WHITE);
                }
            }

            if (PC == 0xFFFF)
            {
                if (LastChar == 0x0D)
                {
                    LastChar = 0;
                    PrintObjNrActingAnimal(mem[L_ACTING_ANIMAL_V10]);
                }

                SDLTWE_PrintCharTextWindow(&LogWin, z80.AF.B.h, &CharSet, SC_BLACK, SC_WHITE);
                LastChar = z80.AF.B.h;
            }
            break;
    }
}


