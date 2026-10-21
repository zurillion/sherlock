/****************************************************************************\
*                                                                            *
*                                   FL                                       *
*                                                                            *
* Foogy London - A Sherlock Environment                                      *
*                                                                            *
* (c) 2013 by CH. Contact: wilderland@aon.at                                 *
*                                                                            *
* Simple Direct Media Layer library (SDL 1.2) from www.libsdl.org (LGPL)     *
* Z80 emulator based on Marat Fayzullin's work from 2007 (fms.komkon.org)    *
* ZX Spectrum ROM (c) by Amstrad, Public Domain for emulators                *
*                                                                            *
* Compiler: Pelles C for Windows 6.5.80 with 'Microsoft Extensions' enabled  *
*                                                                            *
* V 1.01 - 20131208                                                          *
*                                                                            *
* This work is based on the WILDERLAND Hobbit emulator by the same author.   *
* Therefor some code and comments might exist, which are leftovers and may   *
* be safely ignored.                                                         *
*                                                                            *
\****************************************************************************/


/*** INCLUDES ***************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <SDL/SDL.h>

#include "FL.h"
#include "SDLTWE.h"
#include "SPECTRUM.h"
#include "Z80/Z80.h"
#include "MapCoordinates.h"



/*** GLOBAL VARIABLES *******************************************************/
#define EXTERN
#include "GLOBAL_VARS.h"

extern color_t ColorTable[];    //defined in Spectrum.c

struct TimetableStruct Timetable[] = {
{0x00, "HOLM"}, {0x02, "LEST"}, {0x03, "WATS"}, {0x04, "STRA"}, {0x05, "DAPH"},
{0x06, "BASI"}, {0x68, "AGEN"}, {0x07, "FFOU"}, {0x08, "GARD"}, {0x09, "COOK"},
{0x0A, "MAID"}, {0x0B, "LPM1"}, {0x0C, "LPM2"}, {0x0D, "TRIC"}, {0x1F, "CAB1"},
{0x22, "CAB2"}, {0x24, "TRA1"}, {0x25, "TRA2"}, {0x26, "TRA3"}, {0x27, "TRA4"},
{0x28, "TRA5"}, {0x29, "TRA6"}, {0x2A, "TRA7"}, {0x2B, "TRA8"}
};

struct CharacterLocationStruct CharacterLocation[] = {
    {OBJNR_SHERLOCK,      1, "SH", 0xFF},
    {OBJNR_CHINAMAN,      1, "CM", 0xFF},
    {OBJNR_OLDMAN,        1, "OM", 0xFF},
    {OBJNR_WATSON,        1, "WA", 0xFF},
    {OBJNR_LESTRADE,      2, "LE", 0xFF},
    {OBJNR_STRAKER,       2, "ST", 0xFF},
    {OBJNR_POLICEMAN1,    2, "P1", 0xFF},
    {OBJNR_POLICEMAN2,    2, "P2", 0xFF},
    {OBJNR_DAPHNE,        3, "DA", 0xFF},
    {OBJNR_BASIL,         3, "BA", 0xFF},
    {OBJNR_FFOULKES,      3, "FF", 0xFF},
    {OBJNR_TRICIA,        3, "TR", 0xFF},
    {OBJNR_GARDENER,      4, "GA", 0xFF},
    {OBJNR_COOK,          4, "CK", 0xFF},
    {OBJNR_MAID,          4, "MD", 0xFF},
    {OBJNR_AGENT,         5, "AG", 0xFF},
    {OBJNR_MRSBROWN,      5, "MB", 0xFF},
    {OBJNR_MRSJONES,      5, "MJ", 0xFF},
    {OBJNR_CABBIE1,       6, "C1", 0xFF},
    {OBJNR_CABBIE2,       6, "C2", 0xFF},
    {OBJNR_POLICECAB,     6, "PC", 0xFF},
    {OBJNR_STEAMTRAIN_24, 7, "T1", 0xFF},
    {OBJNR_STEAMTRAIN_25, 7, "T2", 0xFF},
    {OBJNR_STEAMTRAIN_26, 8, "T3", 0xFF},
    {OBJNR_STEAMTRAIN_27, 8, "T4", 0xFF},
    {OBJNR_STEAMTRAIN_28, 9, "T5", 0xFF},
    {OBJNR_STEAMTRAIN_29, 9, "T6", 0xFF},
    {OBJNR_STEAMTRAIN_2A,10, "T7", 0xFF},
    {OBJNR_STEAMTRAIN_2B,10, "T8", 0xFF}
};



/****************************************************************************\
* InitSpectrum                                                               *
*                                                                            *
\****************************************************************************/
int InitSpectrum(void)
{
    FILE *fp;
    long int FileLength;
    size_t BytesRead;

    // SDLTWE needs the character set and the game needs some ROM subroutines
    fp = fopen(SPECTRUMROM_FILEPATH, "rb");
    if (!fp)
    {
        fprintf(stderr, "ERROR in FL.c: can't open Spectrum ROM file '%s'\n", SPECTRUMROM_FILEPATH);
        return (1);
    }
    fseek(fp, 0, SEEK_END);
    FileLength = ftell(fp);
    fseek(fp, 0, SEEK_SET);
    if (FL_DEBUG)
    {
        printf("FL: Reading Spectrum ROM with %i byte from %s ... ", FileLength, SPECTRUMROM_FILEPATH);
    }
    BytesRead = fread(mem, 1, FileLength, fp);
    fclose(fp);
    if (FL_DEBUG)
    {
        if (FileLength != BytesRead)
            printf("ERROR!\n");
        else
            printf("read!\n");
    }

    GameWin.PosX = GAMEWINPOSX;
    GameWin.PosY = GAMEWINPOSY;

    return (0);
}


/****************************************************************************\
* InitGame                                                                   *
*                                                                            *
\****************************************************************************/
int InitGame(int sv)
{
    char GameFileName[100];
    word GameStartAdr, GameLength;
    FILE *fp;
    word FileLength, BytesRead;

    switch (sv)
    {
        case V10:
            strcpy(GameFileName, FN_V10);
            GameStartAdr = STARTADR_V10;
            GameLength = LENGTH_V10;
            DictionaryIndexAdr = DICTIONARY_INDEX_V10;
            DictionaryStartAdr = DICTIONARY_INDEX_V10 + DICTIONARY_START_OFFSET_V10;
            ObjectsIndexAdr = OBJECTS_INDEX_V10;
            ObjectsStartAdr = OBJECTS_V10;
            break;
        case V20:
            strcpy(GameFileName, FN_V20);   // all labels are the same as V1
            GameStartAdr = STARTADR_V10;
            GameLength = LENGTH_V10;
            DictionaryIndexAdr = DICTIONARY_INDEX_V10;
            DictionaryStartAdr = DICTIONARY_INDEX_V10 + DICTIONARY_START_OFFSET_V10;
            ObjectsIndexAdr = OBJECTS_INDEX_V10;
            ObjectsStartAdr = OBJECTS_V10;
            break;
        default:
            fprintf(stderr, "FL: ERROR in 'InitGame'. Unknown version %d.\n", sv);
            return (-1);
    }

    fp = fopen(GameFileName, "rb");
    if (!fp)
    {
        fprintf(stderr, "FL: ERROR in 'InitGame'. Can't open game file '%s'\n", GameFileName);
        return (-1);
    }

    fseek(fp, 0, SEEK_END);
    FileLength = ftell(fp);
    fseek(fp, 0, SEEK_SET);

    if (FL_DEBUG)
    {
        printf("FL: Reading game file '%s' with %i byte ... \n", GameFileName, FileLength);
    }

    BytesRead = fread(mem + GameStartAdr, 1, FileLength, fp);
    fclose(fp);

    if (BytesRead != GameLength)
    {
        printf("FL: ERROR in 'InitGame'. Number of bytes read doesn't match filelength.\n");
        return (-1);
    }

    return 0;
}


/****************************************************************************\
* InitGraphicsSystem                                                         *
*                                                                            *
* The global variable  SDL_Surface *screen  must be defined!                 *
\****************************************************************************/
int InitGraphicsSystem(Uint32 WinMode, byte LogMode)
{
    SDL_Surface *temp;

    if (SDL_Init(SDL_INIT_VIDEO) < 0)
        return 1;

    if (!(screen = SDL_SetVideoMode(MAINWINWIDTH, MAINWINHEIGTH, COLORDEPTH, WinMode | SDL_HWSURFACE)))
    {
        SDL_Quit();
        return 1;
    }

    CharSet.Bitmap = malloc(SDLTWE_CHARSETLENGTH);
    if (!(CharSet.Bitmap))
    {
        fprintf(stderr, "FL: ERROR in allocationg memory for character set.\n");
        return 1;
    }
    if (!SDLTWE_ReadCharSet(SDLTWE_CHARSETFILEPATH, CharSet.Bitmap))
    {
        fprintf(stderr, "FL: ERROR while reading character set.\n");
        return 1;
    }

    //Load Game Map
    if (LogMode == MODE_MAP)
    {
        temp = SDL_LoadBMP("GameMap.bmp");
        if (temp == NULL)
        {
            printf("WL: ERROR in 'InitGraphicsSystem'. Unable to load GameMap.bmp\n");
            return (-1);
        }
        GameMap = SDL_DisplayFormat(temp);
        SDL_FreeSurface(temp);
    }

    CharSet.Height = 8;
    CharSet.Width = 8;
    CharSet.CharMin = '\x20';
    CharSet.CharMax = '\x7F';
    CharSet.CharSubstitute = '?';

    GameWin.TW_SDL_Surface = screen;        //screen is the global SDL surface
    GameWin.PosX = GAMEWINPOSX;
    GameWin.PosY = GAMEWINPOSY;
    GameWin.Width = GAMEWINWIDTH;
    GameWin.Heigth = GAMEWINHEIGTH;
    GameWin.CurrentPrintPosX = 0;
    GameWin.CurrentPrintPosY = 0;

    LogWin.TW_SDL_Surface = screen;         //screen is the global SDL surface
    LogWin.PosX = LOGWINPOSX;
    LogWin.PosY = LOGWINPOSY;
    LogWin.Width = LOGWINWIDTH;
    LogWin.Heigth = LOGWINHEIGTH;
    LogWin.CurrentPrintPosX = 0;
    LogWin.CurrentPrintPosY = 0;

    ObjWin.TW_SDL_Surface = screen;         //screen is the global SDL surface
    ObjWin.PosX = OBJWINPOSX;
    ObjWin.PosY = OBJWINPOSY;
    ObjWin.Width = OBJWINWIDTH;
    ObjWin.Heigth = OBJWINHEIGTH;
    ObjWin.CurrentPrintPosX = 0;
    ObjWin.CurrentPrintPosY = 0;

    HelpWin.TW_SDL_Surface = screen;        //screen is the global SDL surface
    HelpWin.PosX = HELPWINPOSX;
    HelpWin.PosY = HELPWINPOSY;
    HelpWin.Width = HELPWINWIDTH;
    HelpWin.Heigth = HELPWINHEIGTH;
    HelpWin.CurrentPrintPosX = 0;
    HelpWin.CurrentPrintPosY = 0;

    if (LogMode == MODE_TABLES)
    {
        LLWin.TW_SDL_Surface = screen;      //screen is the global SDL surface
        LLWin.PosX = LLWINPOSX;
        LLWin.PosY = LLWINPOSY;
        LLWin.Width = LLWINWIDTH;
        LLWin.Heigth = LLWINHEIGTH;
        LLWin.CurrentPrintPosX = 0;
        LLWin.CurrentPrintPosY = 0;
    }

    return 0;
}


/****************************************************************************\
* LockScreen                                                                 *
*                                                                            *
\****************************************************************************/
void LockScreen(SDL_Surface *LSscreen)
{
    LockLevel++;

    if (LockLevel != 1)
        return;

    if (SDL_MUSTLOCK(LSscreen))
    {
        if (SDL_LockSurface(LSscreen) < 0)
            fprintf(stderr, "FL: ERROR in LockScreen().\n");
    }
}


/****************************************************************************\
* UnLockScreen                                                               *
*                                                                            *
\****************************************************************************/
void UnLockScreen(SDL_Surface *ULSscreen)
{

    if (LockLevel-- >= 2)
    {
        SDL_Flip(screen);
        return;
    }

    if (LockLevel != 1)
    {
        SDL_Flip(screen);
        return;
    }

    if (SDL_MUSTLOCK(ULSscreen))
        SDL_UnlockSurface(ULSscreen);

    SDL_Flip(screen);
}


/****************************************************************************\
* Timeoffset2String                                                          *
*                                                                            *
\****************************************************************************/
void Timeoffset2String(char *buffer, word TO)
{
    byte Days, Hours, Minutes;
    char *Weekday[] = { "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun" };
    char StringBuffer[20];

    if (TO > (7 * 24 * 60))
    {
        strcpy(buffer, "invalid");
        return;
    }

    TO += (8 * 60); // we start at Monday 8:00 AM

    Days = TO / (24 * 60);
    Hours = (TO - Days * (24 * 60)) / 60;
    Minutes = TO - Days * (24 * 60) - Hours * 60;

    strcpy(buffer, Weekday[Days]);

    sprintf(StringBuffer, " %02d:%02d", Hours, Minutes);
    strcat(buffer, StringBuffer);
}


/****************************************************************************\
* Setpixel                                                                   *
*                                                                            *
\****************************************************************************/
void SetPixel(SDL_Surface *scr, int x, int y, color_t color)
{
    Uint32 *pixmem32;

    pixmem32 = (Uint32 *)scr->pixels + y * scr->pitch / (COLORDEPTH / 8) + x;
    *pixmem32 = color;
}


/****************************************************************************\
* PrintChar                                                                  *
*                                                                            *
\****************************************************************************/
void PrintChar(SDL_Surface *scr, struct CharSetStruct *cs, char a, int x, int y, color_t ink, color_t paper)
{
    int i, j;
    int CharIndex;
    byte mask;
    int ymul;
    Uint32 *pixm;

    if (FL_DEBUG)
    {
        if ((cs->Width != 8) || (cs->Height != 8))
        {
            fprintf(stderr, "FL: ERROR in PrintChar. Only 8x8 pixel charsets are supported.\n");
            return;
        }
    }


    ymul = scr->pitch / (COLORDEPTH / 8);
    for (i = 0; i <= 7; i++)
    {
        mask = 0x80;
        CharIndex = (a - cs->CharMin) * cs->Height;
        for (j = 0; j <= 7; j++, mask >>= 1)
        {
            pixm = (Uint32 *) (scr->pixels) + (y + i) * ymul + x + j;
            if (cs->Bitmap[CharIndex + i] & mask)
                *pixm = ink;
            else
                *pixm = paper;
        }
    }
}


/****************************************************************************\
* PrintString                                                                *
*                                                                            *
\****************************************************************************/
void PrintString(SDL_Surface *scr, struct CharSetStruct *cs, char *ps, int x, int y, color_t ink, color_t paper)
{
    while (*ps)
    {
        PrintChar(scr, cs, *ps++, x, y, ink, paper);
        x += cs->Width;
    }
}


/****************************************************************************\
* DrawLineRelative                                                           *
*                                                                            *
\****************************************************************************/
void DrawLineRelative(SDL_Surface *scr, int x, int y, int dx, int dy, int rx, int ry, color_t color)
{
    int x1, y1, sx, sy;

    if (rx == 0 || ry == 0)
        return;

    sx = (dx > 0) ? 1 : -1;
    dx *= sx;

    sy = (dy > 0) ? 1 : -1;
    dy *= sy;

    while (rx > 1 || ry > 1)
    {
        if (rx > 1)
            rx--;
        if (ry > 1)
            ry--;
        if (dx > dy)
            for (x1 = 0; x1 < dx; x1++)
                SetPixel(scr, x + sx * (x1 + (rx - 1)), sy * (y + ((int)(dy * x1 / dx)) + (ry - 1)), color);
        else
            for (y1 = 0; y1 < dy; y1++)
                SetPixel(scr, x + sx * (((int)(dx * y1 / dy)) + (rx - 1)), y + sy * (y1 + (ry - 1)), color);
    }
}


/****************************************************************************\
* Info                                                                       *
*                                                                            *
\****************************************************************************/
void Info(struct TextWindowStruct *TW, struct CharSetStruct *CS)
{
    LockScreen(TW->TW_SDL_Surface);

    SDLTWE_PrintString(TW, "\n   FOGGY LONDON - A Sherlock Environment (c) 2013 by CH\n\n", CS, SC_BRMAGENTA, SC_BRBLACK);
    SDLTWE_PrintString(TW, "\"Sherlock\" (c) Melbourne House, 1984 (Philip Mitchell)\n", CS, SC_BRWHITE, SC_BRBLACK);
    SDLTWE_PrintString(TW, "Simple Direct Media Layer library from www.libsdl.org\n", CS, SC_WHITE, SC_BLACK);
    SDLTWE_PrintString(TW, "Z80 emulator based on Marat Fayzullin's work(fms.komkon.org)", CS, SC_WHITE, SC_BLACK);
    SDLTWE_PrintString(TW, "ZX Spectrum ROM (c) by Amstrad, Public Domain for emulators\n\n", CS, SC_WHITE, SC_BLACK);
    SDLTWE_PrintString(TW, "You are not allowed to distribute 'FOGGY LONDON' with Sher-\nlock binaries included!\n\n", CS, SC_BRWHITE, SC_BRBLACK);
    SDLTWE_PrintString(TW, "Contact: wilderland@aon.at\n\n", CS, SC_WHITE, SC_BLACK);

    UnLockScreen(TW->TW_SDL_Surface);
}


/****************************************************************************\
* HelpInfo                                                                   *
*                                                                            *
\****************************************************************************/
void HelpInfo(struct TextWindowStruct *TW, struct CharSetStruct *CS)
{
    char LineBuffer[100];

    LockScreen(TW->TW_SDL_Surface);

    SDLTWE_PrintString(TW, "\n             FOGGY LONDON - A Sherlock Environment\n\n", CS, SC_BRWHITE, SC_BRBLACK);
    SDLTWE_PrintString(TW, "                     V 1.01 (c) 2013 by CH\n\n\n", CS, SC_WHITE, SC_BLACK);
    SDLTWE_PrintString(TW, " a-z.,@0[BS] -> play              ATTRIBUTES\n", CS, SC_BRMAGENTA, SC_BRBLACK);
    SDLTWE_PrintString(TW, " S-ave  H-elp  G-o       v_isible  A_nimal  o_pen   *_light\n", CS, SC_BRCYAN, SC_BRBLACK);
    //SDLTWE_PrintString(TW, " L-oad  I-nfo  P-oke     b_roken   f_ull    F_luid  l_ocked\n", CS, SC_BRCYAN, SC_BRBLACK);
    SDLTWE_PrintString(TW, " L-oad  I-nfo            b_roken   f_ull    F_luid  l_ocked\n", CS, SC_BRCYAN, SC_BRBLACK);
    sprintf(LineBuffer, " V-erbose=%d\n", VerboseLevel);
    SDLTWE_PrintString(TW, LineBuffer, CS, SC_BRCYAN, SC_BRBLACK);
    SDLTWE_PrintString(TW, " Q-uit\n\n", CS, SC_BRWHITE, SC_BRBLACK);
    SDLTWE_PrintString(TW, " Press 'n' as first key to play without graphics.\n", CS, SC_RED, SC_BLACK);

    UnLockScreen(TW->TW_SDL_Surface);
}


/****************************************************************************\
* Build_Dictionary                                                           *
*                                                                            *
* Fill the 'DictEntry' structure.                                            *
*                                                                            *
* Used globals: mem, DictionaryIndexAdr, DictionaryStartAdr, DictEntry       *
\****************************************************************************/
void Build_Dictionary(void)
{
/*
    TTTT.FFFF
    S.PPP.CCCC
     [SL]
     [SH]
    [aaaaa.bbb]
    [bb.ccccc.d]
    [dddd.eeee]
    [e.fffff.gg]
    [ggg.hhhhh]

    TTTT: word type (noun, verb,...)
    FFFF: flection
    S:    synonyme pointer follows
    PPP:  number of letters from previous entry to use
    CCCC: number of current letters to follow
    aaaaa, bbbbb,...: letters coded as 5 bit values
*/

    word adr;
    int i;
    char CurrentLetter;
    char *current_wordentry_pointer;
    int SynonymeBit;
    int LettersPrevious, LettersCurrent;
    word w, BitOffset;
    word CurrentDictIndex;


    // ========== read dictionary index ==========
    adr = DictionaryIndexAdr;
    for (i = 0; i < 32; i++)
    {
        DictIndex[i].LETTER = ('A' - 1) + i;
        DictIndex[i].LETTER_START_ADR = mem[adr] + 0x100 * mem[adr + 1];
        adr += 2;
    }


    // ============= read dictionary =============
    adr = DictionaryStartAdr;
    CurrentLetter = 'A';
    CurrentDictIndex = 0;

    while (adr <= DICTIONARY_END_V10)
    {
        // check if we have reached the next letter
        // this methodes needs at least one word for each starting letter, which is the case ("XLE")
        if (DictIndex[CurrentLetter - ('A' - 1) + 1].LETTER_START_ADR == (adr - (DictionaryStartAdr - 1)))
        {
            CurrentLetter++;
            continue;
        }

        current_wordentry_pointer = DictEntry[CurrentDictIndex].WORD;

        // store first letter
        *current_wordentry_pointer = CurrentLetter;
        current_wordentry_pointer++;

        DictEntry[CurrentDictIndex].ADR = adr;
        DictEntry[CurrentDictIndex].BYTE1 = mem[adr];
        DictEntry[CurrentDictIndex].TYPE = (mem[adr] & 0xF0) >> 4;
        DictEntry[CurrentDictIndex].FLECTION = mem[adr] & 0x0F;
        adr++;
        DictEntry[CurrentDictIndex].BYTE2 = mem[adr];
        SynonymeBit = (mem[adr] & 0x80) >> 7;
        LettersPrevious = (mem[adr] & 0x70) >> 4;
        LettersCurrent = (mem[adr] & 0x0f);
        adr++;

        if (SynonymeBit)
        {
            DictEntry[CurrentDictIndex].SYNONYME = mem[adr] + 0x100 * mem[adr + 1] + DictionaryStartAdr - 1;
            adr += 2;
        }
        else
        {
            DictEntry[CurrentDictIndex].SYNONYME = 0;
        }

        for (i = 0; i < LettersPrevious; i++)
        {
            *current_wordentry_pointer = DictEntry[CurrentDictIndex - 1].WORD[i + 1];
            current_wordentry_pointer++;
        }

        BitOffset = 0;
        for (i = 0; i < LettersCurrent; i++)
        {
            if (BitOffset >= 8)
            {
                BitOffset -= 8;
                adr++;
            }
            w = 0x100 * mem[adr] + mem[adr + 1];
            w <<= BitOffset;
            w &= 0xF800;
            w >>= 11;
            *current_wordentry_pointer = ((byte)w) + ('A' - 1);
            current_wordentry_pointer++;
            BitOffset += 5;
        }
        if (LettersCurrent >= 1)
            adr++;
        if (BitOffset >= (4 + 5))
            adr++;

        *current_wordentry_pointer = '\0';

        CurrentDictIndex++;
    }
}


/****************************************************************************\
* DisplayGameMap                                                             *
*                                                                            *
\****************************************************************************/
void DisplayGameMap(void)
{
    SDL_Rect src, dest;

    src.x = 0;
    src.y = 0;
    src.w = GAMEMAPWIDTH;
    src.h = GAMEMAPHEIGTH;

    dest.x = 0;
    dest.y = (MAINWINHEIGTH - GAMEMAPHEIGTH - 1);
    dest.w = GAMEMAPWIDTH;
    dest.h = GAMEMAPHEIGTH;

    SDL_BlitSurface(GameMap, &src, screen, &dest);
}


/****************************************************************************\
* GetHexByte                                                                 *
*                                                                            *
\****************************************************************************/
void GetHexByte(byte *b, struct TextWindowStruct *TW, struct CharSetStruct *CS, color_t ink, color_t paper)
{
    Uint16 a;
    SDL_Event event;
    int nibble_count = 0;

    *b = 0;

    while (1)
    {
        if (SDL_PollEvent(&event))
        {
            switch (event.type)
            {
                case SDL_KEYDOWN:
                    a = event.key.keysym.unicode;
                    if (a >= '0' && a <= '9')
                    {
                        if (nibble_count >= 2)
                            break;
                        *b <<= 4;
                        *b += (a - '0');
                        nibble_count++;
                        LockScreen(screen);
                        SDLTWE_PrintCharTextWindow(TW, a, CS, ink, paper);
                        UnLockScreen(screen);
                        break;
                    }
                    if ((a >= 'a' && a <= 'f') || (a >= 'A' && a <= 'F'))
                    {
                        if (nibble_count >= 2)
                            break;
                        a |= 0x20;
                        *b <<= 4;
                        *b += (a - 'a' + 0x0a);
                        nibble_count++;
                        LockScreen(screen);
                        SDLTWE_PrintCharTextWindow(TW, a, CS, ink, paper);
                        UnLockScreen(screen);
                        break;
                    }
                    if (a == SDLK_BACKSPACE)
                        break;
                    if (a == SDLK_RETURN)
                    {
                        return;
                    }
                case SDL_KEYUP:
                    a = 0;
                    break;
            }
        }
    }
}


/****************************************************************************\
* GetFileName                                                                *
*                                                                            *
\****************************************************************************/
void GetFileName(char *fnstr, struct TextWindowStruct *TW, struct CharSetStruct *CS, color_t ink, color_t paper)
{
    Uint16 a;
    SDL_Event event;

    LockScreen(screen);
    SDLTWE_PrintString(TW, "\n\nFilename: ", CS, ink, paper);
    UnLockScreen(screen);

    while (1)
    {
        if (SDL_PollEvent(&event))
        {
            switch (event.type)
            {
                case SDL_KEYDOWN:
                    a = event.key.keysym.unicode;
                    if ((a >= 'a' && a <= 'z') || (a >= '0' && a <= '9') || a == '.' || a == '_')
                    {
                        *fnstr = a;
                        fnstr++;
                        LockScreen(screen);
                        SDLTWE_PrintCharTextWindow(TW, a, CS, ink, paper);
                        UnLockScreen(screen);
                        break;
                    }
                    if (a == SDLK_BACKSPACE)
                        break;
                    if (a == SDLK_RETURN)
                    {
                        *fnstr = 0;
                        return;
                    }
                case SDL_KEYUP:
                    a = 0;
                    break;
            }
        }
    }
}


/****************************************************************************\
* Poke                                                                       *
*                                                                            *
\****************************************************************************/
void Poke(struct TextWindowStruct *TW, struct CharSetStruct *CS, int hv, color_t ink, color_t paper)
{
    LockScreen(screen);
    SDLTWE_PrintString(TW, "\n\nEnter \"address, value\" (ddd/0xhh): ", CS, ink, paper);
    UnLockScreen(screen);


}


/****************************************************************************\
* SaveGame                                                                   *
*                                                                            *
\****************************************************************************/
void SaveGame(struct TextWindowStruct *TW, struct CharSetStruct *CS, int hv, color_t ink, color_t paper)
{
    char fn[100];
    FILE *f;
    int i;

    GetFileName(fn, TW, CS, ink, paper);

    f = fopen(fn, "wb");
    if (!f)
    {
        fprintf(stderr, "FL: ERROR - Can't open file '%s' for saving game.\n", fn);
        return;
    }

    fprintf(f, "GAMEVERSION=%i\r\n", hv);
    fprintf(f, "FILEVERSION=1\r\n");
    fprintf(f, "SIZE(Z80)=%02X\r\n", sizeof(z80));
    fprintf(f, "PC=%04X\r\n", z80.PC.W);

    fprintf(f, "***Z80***");
    for (i = 0; i < sizeof(z80); i++)
        fprintf(f, "%c", *((byte *) & z80 + i));

    fprintf(f, "***MEMORY***");
    for (i = 0; i <= 0xFFFF; i++)
        fprintf(f, "%c", mem[i]);

    fclose(f);

    LockScreen(screen);
    SDLTWE_PrintString(TW, " saved.\n\n", CS, ink, paper);
    UnLockScreen(screen);
}


/****************************************************************************\
* LoadGame                                                                   *
*                                                                            *
\****************************************************************************/
void LoadGame(struct TextWindowStruct *TW, struct CharSetStruct *CS, int hv, color_t ink, color_t paper)
{
    char fn[100];
    FILE *f;
    int i, gameversion, fileversion, SizeOfZ80;

    GetFileName(fn, TW, CS, ink, paper);

    f = fopen(fn, "rb");
    if (!f)
    {
        fprintf(stderr, "FL: ERROR - Can't open file '%s' for loading game.\n", fn);
        LockScreen(screen);
        SDLTWE_PrintString(TW, " not found!\n\n", CS, ink, paper);
        UnLockScreen(screen);
        return;
    }

    if (fscanf(f, "GAMEVERSION=%i\r\n", &gameversion) != 1)
    {
        LockScreen(screen);
        SDLTWE_PrintString(TW, "\nError. Data does not match format.\n\n", CS, ink, paper);
        UnLockScreen(screen);
        return;
    }

    if (gameversion != hv)
    {
        LockScreen(screen);
        SDLTWE_PrintString(TW, "\nWrong game version.\n\n", CS, ink, paper);
        UnLockScreen(screen);
        return;
    }

    fscanf(f, "FILEVERSION=%i\r\n", &fileversion);
    fscanf(f, "SIZE(Z80)=%02X\r\n", &SizeOfZ80);

    if (SizeOfZ80 != sizeof(z80))
    {
        LockScreen(screen);
        SDLTWE_PrintString(TW, "\nZ80-structure sizes do not match.\n\n", CS, ink, paper);
        UnLockScreen(screen);
        return;
    }

    if (fileversion == 1)
    {
        fscanf(f, "PC=%04X\r\n", &fileversion);
        fscanf(f, "***Z80***");
        for (i = 0; i < sizeof(z80); i++)
            fscanf(f, "%c", ((byte *) & z80 + i));
        fscanf(f, "***MEMORY***");
        for (i = 0; i <= 0xFFFF; i++)
            fscanf(f, "%c", mem + i);
        fclose(f);
    }
    else
    {
        LockScreen(screen);
        SDLTWE_PrintString(TW, "\nThis game fiel version is not supported!\n\n", CS, ink, paper);
        UnLockScreen(screen);
        return;
    }

    LockScreen(screen);
    SDLTWE_PrintString(TW, " loaded.\n\n", CS, ink, paper);
    UnLockScreen(screen);

    for (i = SL_SCREENSTART; i <= SL_ATTRIBUTEEND; i++)
        WrZ80(i, mem[i]);

    // ignore PRINT_DICT_WORDS variable
    mem[0xA88B] = 0;
}


/****************************************************************************\
* Go                                                                         *
*                                                                            *
\****************************************************************************/
void Go(struct TextWindowStruct *TW, struct CharSetStruct *CS, int sv, color_t ink, color_t paper)
{
    byte rn;

    LockScreen(screen);
    SDLTWE_PrintString(TW, "\n\nEnter room number 0x", CS, ink, paper);
    UnLockScreen(screen);

    GetHexByte(&rn, TW, CS, ink, paper);

    if (rn < 1 || rn > ROOMS_NROF_V10)
    {
        LockScreen(screen);
        SDLTWE_PrintString(TW, ". ERROR, invalid room number.\n", CS, ink, paper);
        UnLockScreen(screen);
        return;
    }

    switch (sv)
    {
        case V10:
        case V20:
            mem[L_YOU_OBJ_POSITION_V10] = rn;
            break;
        default:
            fprintf(stderr, "ERROR in FL/Go: unknown game version.\n");
            return;
    }

    LockScreen(screen);
    SDLTWE_PrintString(TW, ". OK, you are now in this room.\n", CS, ink, paper);
    UnLockScreen(screen);
}


/****************************************************************************\
* sbinprintf                                                                 *
*                                                                            *
\****************************************************************************/
void sbinprintf(char *buf, byte b)
{
    int i;
    byte mask = 0x80;

    for (i = 0; i < 8; i++, mask >>= 1)
    {
        *buf++ = '0' + ((b & mask) != 0);
        if (i == 3)
            *buf++ = '.';
    }
    *buf = 0;
}


/****************************************************************************\
* SearchByteWordTable                                                        *
*                                                                            *
* Returns pointer value or 0 if not found.                                   *
\****************************************************************************/
word SearchByteWordTable(byte a, word address)
{
    while (mem[address] != 0xFF)
    {
        if (mem[address] == a)
            return (mem[address + 1] + 0x100 * mem[address + 2]);
        else
            address += 3;
    }
    return (0);
}


/****************************************************************************\
* GetDictWord                                                                *
*                                                                            *
\****************************************************************************/
void GetDictWord(word wa, char *buf)
{
    int i;

    if (!wa)
    {
        *buf = 0;
        return;
    }

    wa += DictionaryStartAdr - 1;

    for (i = 1; i < DICT_ENTRIES_NROF_MAX; i++)
    {
        if (DictEntry[i].ADR == wa)
        {
            strcpy(buf, (DictEntry[i].WORD));
            return;
        }
    }

    strcpy(buf, "??? UNKNOWN WORD ???");
}


/****************************************************************************\
* GetObjectAttributePointer                                                  *
*                                                                            *
* Returns pointer value or 0 if not found.                                   *
\****************************************************************************/
word GetObjectAttributePointer(byte a, byte attributeoffset)
{
    word OAP;

    OAP = SearchByteWordTable(a, ObjectsIndexAdr);
    if (OAP)
        return (OAP + attributeoffset);
    else
        return (0);
}


/****************************************************************************\
* GetCharacterLocation                                                       *
*                                                                            *
\****************************************************************************/
void GetCharacterLocation(void)
{
    int i;
    word OAP;

    for (i = 0; i < CHARACTERS_NROF; i++)
    {
        OAP = GetObjectAttributePointer(CharacterLocation[i].ObjNr, 0);
        CharacterLocation[i].Position1 = mem[OAP + FIRST_OCCURRENCE];
        if (CharacterLocation[i].Position1 == ROOMNR_CAB && mem[OAP + MO_OFF] == 0x21)      // cab #2
            CharacterLocation[i].Position1 = 0x6A;                                          // dummy room
    }
}


/****************************************************************************\
* GetObjectFullName                                                          *
*                                                                            *
* +09/0A: ADJECTIVE1, +0B/0C: ADJECTIVE2, +07/08: NOUN                       *
\****************************************************************************/
void GetObjectFullName(word oa, char *OFN)
{
    word wa;
    char StringBuffer[50], StringBufferNoun[50], StringBufferMoney[50];
    byte P, s, d;   //  pound, shilling, pence
    char *sign;

    strcpy(StringBuffer, "invalid");
    strcpy(StringBufferNoun, "invalid");
    strcpy(StringBufferMoney, "invalid");


    wa = mem[oa + 0x07] + 0x100 * mem[oa + 0x08];   // noun
    if (wa & 0x0FFF)
    {
        GetDictWord(wa & 0x0FFF, StringBufferNoun);
    }

    if (!strcmp(StringBufferNoun, "MONEY"))
    {
        wa = mem[oa + 0x0B] + 0x100 * mem[oa + 0x0C];   // adjective 2
        if (wa)
        {
            GetDictWord(wa, StringBuffer);
            strcat(OFN, StringBuffer);
            strcat(OFN, " ");
        }

        strcat(OFN, StringBufferNoun);

        wa = (mem[oa + 0x09] & 0x7F) + 0x80 * (mem[oa + 0x0A] & 0x7F);  // amount of money in pence
        sign = "";
        if (wa > 0x2000)
        {
            wa = 0x4000 - wa;
            sign = "-";
        }
        P = wa / SHILLINGSperPOUND / PENCEperSHILLING;  // Bit 15 and 7 are always set
        s = (wa - P * SHILLINGSperPOUND * PENCEperSHILLING) / PENCEperSHILLING;
        d = (wa - P * SHILLINGSperPOUND * PENCEperSHILLING - s * PENCEperSHILLING);
        sprintf(StringBufferMoney, "(%s%iP %i/%i) ", sign, P, s, d);
        strcat(OFN, StringBufferMoney);
        return;
    }

    else

    {
        wa = mem[oa + 0x09] + 0x100 * mem[oa + 0x0A];   // adjective 1
        if (wa)
        {
            GetDictWord(wa, StringBuffer);
            strcat(OFN, StringBuffer);
            strcat(OFN, " ");
        }

        wa = mem[oa + 0x0B] + 0x100 * mem[oa + 0x0C];   // adjective 2
        if (wa)
        {
            GetDictWord(wa, StringBuffer);
            strcat(OFN, StringBuffer);
            strcat(OFN, " ");
        }

        strcat(OFN, StringBufferNoun);
        return;
    }

    strcpy(OFN, "***InvalidObjectName***");
}


/****************************************************************************\
* DrawGroupPositon                                                           *
*                                                                            *
\****************************************************************************/
void DrawGroupPosition(SDL_Surface *scr, struct CharSetStruct *cs, byte groupnr, word x, word y, byte objectoffset)
{
    char initials[50];

    DrawLineRelative(scr, x, y + (objectoffset - 1)* 10, 6, -8, 4, 1, SC_BRRED);

    strcpy(initials, GroupedCharacters[groupnr].CharacterString);
    PrintString(scr, cs, initials, x + 6, y + (objectoffset-1) * 10 - 13, SC_BRGREEN, SC_BLACK);
    if (initials[0] == 'S' && initials[1] == 'H')
        PrintString(scr, cs, "SH", x + 6, y + (objectoffset-1) * 10 - 13, SC_BRRED, SC_BLACK);
}


/****************************************************************************\
* DisplayCharacterPositions                                                  *
*                                                                            *
* Required Gloabal: CharacterLocation                                        *
\****************************************************************************/
void DisplayCharacterPositions(SDL_Surface *scr, struct CharSetStruct *cs)
{
    byte GroupsPerRoom[ROOMS_NROF_MAX + 1];     //+ dummy cab
    byte RoomNr;
    int i, j;


    for (i = 0; i < CHARACTERS_NROF; i++)
    {
        GroupedCharacters[i].RoomNr = 0xFF;
        GroupedCharacters[i].CharacterString[0] = '\0';
    }

    for (i = 0; i < (ROOMS_NROF_MAX + 1); i++)
        GroupsPerRoom[i] = 0;

    GetCharacterLocation();

    for (i = 0; i < CHARACTERS_NROF; i++)   // go through the global CharacterLocation array
    {
        for (j = 0; j < CHARACTERS_NROF; j++)
        {
            if (GroupedCharacters[j].RoomNr == CharacterLocation[i].Position1 && GroupedCharacters[j].Group == CharacterLocation[i].Group)
            {
                strcat(GroupedCharacters[j].CharacterString, CharacterLocation[i].Initials);
                strcat(GroupedCharacters[j].CharacterString, ",");
                goto DCP1;
            }
        }

        // find correct entry in GroupedCharactersList
        j = 0;
        do
        {
            if (GroupedCharacters[j].RoomNr == 0xFF)
                break;
            j++;
        } while (j < CHARACTERS_NROF);
        if (j == CHARACTERS_NROF)
        {
            printf("Error1 in filling GroupedCharacters list\n");
            return;
        }
        GroupedCharacters[j].RoomNr = CharacterLocation[i].Position1;
        GroupedCharacters[j].Group  = CharacterLocation[i].Group;
        strcat(GroupedCharacters[j].CharacterString, CharacterLocation[i].Initials);
        strcat(GroupedCharacters[j].CharacterString, ",");
        DCP1:
        ;
    }

    for (i = 0; i < CHARACTERS_NROF; i++)
        GroupsPerRoom[GroupedCharacters[i].RoomNr]++;

    for (i = (CHARACTERS_NROF - 1); i >= 0 ; i--)
    {
        if (GroupedCharacters[i].RoomNr != 0xFF)
        {
            RoomNr = GroupedCharacters[i].RoomNr;
            if (RoomNr)
            {
                GroupedCharacters[i].CharacterString[strlen(GroupedCharacters[i].CharacterString) - 1] = '\0';  // remove last comma
                DrawGroupPosition(scr, cs, i, MapCoordinates[RoomNr].X - INDICATOROFFSET, MapCoordinates[RoomNr].Y + (MAINWINHEIGTH - GAMEMAPHEIGTH) + INDICATOROFFSET, GroupsPerRoom[RoomNr]--);
            }
        }
    }

}


/****************************************************************************\
* PrintObject                                                                *
*                                                                            *
\****************************************************************************/
void PrintObject(word ai, struct TextWindowStruct *OW, struct CharSetStruct *CS, color_t ink, color_t paper)
{
    word oa;
    byte ObjectNumber;
    char ObjectPrintLine[100];
    char ObjectStringBuffer[100];

    ObjectNumber = mem[ai++];
    sprintf(ObjectPrintLine, "%02X ", ObjectNumber);

    oa = mem[ai] + 0x100 * mem[ai + 1];
    // object name
    *ObjectStringBuffer = 0;
    GetObjectFullName(oa, ObjectStringBuffer);
    strcat(ObjectStringBuffer, "                              ");
    ObjectStringBuffer[21] = 0;
    strcat(ObjectPrintLine, ObjectStringBuffer);
    // nr of occurences
    sprintf(ObjectStringBuffer, "%1X ", mem[oa + OCC_OFF]);
    strcat(ObjectPrintLine, ObjectStringBuffer);
    // 1st occurence
    sprintf(ObjectStringBuffer, "%02X ", mem[oa + FIRST_OCCURRENCE]);
    strcat(ObjectPrintLine, ObjectStringBuffer);
    // mother object
    sprintf(ObjectStringBuffer, "%02X ", mem[oa + MO_OFF]);
    strcat(ObjectPrintLine, ObjectStringBuffer);
    // +02
    sprintf(ObjectStringBuffer, "%02X ", mem[oa + 2]);
    strcat(ObjectPrintLine, ObjectStringBuffer);
    // +03
    sprintf(ObjectStringBuffer, "%02X ", mem[oa + 3]);
    strcat(ObjectPrintLine, ObjectStringBuffer);
    // +04
    sprintf(ObjectStringBuffer, "%02X ", mem[oa + 4]);
    strcat(ObjectPrintLine, ObjectStringBuffer);
    // ATTRIBUTE5
    sbinprintf(ObjectStringBuffer, mem[oa + ATTRIBUTE5_OFF]);
    strcat(ObjectPrintLine, ObjectStringBuffer);
    strcat(ObjectPrintLine, " ");
    // ATTRIBUTE6
    sbinprintf(ObjectStringBuffer, mem[oa + ATTRIBUTE6_OFF]);
    strcat(ObjectPrintLine, ObjectStringBuffer);
    strcat(ObjectPrintLine, "");    // spaces if needed

    if (ObjectNumber == 0x00 || ObjectNumber == 0x02 || ObjectNumber == 0x03)
        SDLTWE_PrintString(OW, ObjectPrintLine, CS, SC_BRRED, paper);
    else
    {
        if (mem[oa + FIRST_OCCURRENCE] == mem[GetObjectAttributePointer(OBJNR_YOU, FIRST_OCCURRENCE)])
            SDLTWE_PrintString(OW, ObjectPrintLine, CS, paper, ((ObjectNumber >= 0x1E && ObjectNumber <= 0x2B) ? SC_BRWHITE : ink));
        else
            SDLTWE_PrintString(OW, ObjectPrintLine, CS, ((ObjectNumber >= 0x1E && ObjectNumber <= 0x2B) ? SC_BRWHITE : ink), paper);
    }
}


/****************************************************************************\
* PrintObjectsList                                                           *
*                                                                            *
\****************************************************************************/
void PrintObjectsList(word OIA, word OA, struct TextWindowStruct *OW, struct CharSetStruct *CS, color_t ink, color_t paper)
{
    word ai;
    OW->CurrentPrintPosX = 0;
    OW->CurrentPrintPosY = 0;
    SDLTWE_PrintString(OW, "Nr Name                 # 1L MO +2 +3 +4 vAo*.bfLl ?X$?.????", CS, ink, paper);
    SDLTWE_PrintString(OW, "------------------------------------------------------------", CS, ink, paper);
    ai = OIA;
    while (mem[ai] < OBJECTS_NROF_MAX)
    {
        PrintObject(ai, OW, CS, ink, paper - (mem[ai] % 2 ? 0x00000040ul : 0));
        ai += 3;
    }
}


/****************************************************************************\
* PrintStatus                                                                *
*                                                                            *
\****************************************************************************/
void PrintStatus(int VerboseLevel, struct TextWindowStruct *LW, struct CharSetStruct *CS, color_t ink, color_t paper)
{
    char StatusStringBuffer[100];
    char StatusPrintLine[100];
    int i;
    word TTAdr;
    word TimeOffset;

return;

    LW->CurrentPrintPosX = 0;
    LW->CurrentPrintPosY = 0;

    SDLTWE_PrintString(LW, "\f", CS, ink, paper);

    for (i = 0; i < CHARACTERS_NROF; i++)
    {
        *StatusPrintLine = 0;
        sprintf(StatusStringBuffer, "%02X ", GroupedCharacters[i].RoomNr);
        strcat(StatusPrintLine, StatusStringBuffer);
        sprintf(StatusStringBuffer, "%s", GroupedCharacters[i].CharacterString);
        strcat(StatusPrintLine, StatusStringBuffer);
        strcat(StatusPrintLine, "\n");
        SDLTWE_PrintString(LW, StatusPrintLine, CS, ink, paper);
    }

return;

    sprintf(StatusStringBuffer, "Verbose: %d\n", VerboseLevel);
    SDLTWE_PrintString(LW, StatusStringBuffer, CS, ink, paper);
    SDLTWE_PrintString(LW, "------------------\n", CS, ink, paper);

    for (i = 0; i < TIMETABLE_NUMBEROFENTRIES; i++)
    {
        *StatusPrintLine = 0;
        sprintf(StatusStringBuffer, "%s ", Timetable[i].ObjShortName);
        strcat(StatusPrintLine, StatusStringBuffer);
        TTAdr = TIMETABLE_START + 8 * i + 6;
        TimeOffset = mem[TTAdr] + 0x100 * mem[TTAdr + 1];
        Timeoffset2String(StatusStringBuffer, TimeOffset);
        strcat(StatusPrintLine, StatusStringBuffer);
        strcat(StatusPrintLine, "\n");
        SDLTWE_PrintString(LW, StatusPrintLine, CS, ink, paper);
    }
}


/****************************************************************************\
*                                   main                                     *
*                                                                            *
\****************************************************************************/
int main(int argc, char *argv[])
{
    SDL_Event event;
    int i;
    int RunMainLoop;
    byte b;
    FILE *f;
    Uint32 WinMode = 0; // window mode (vs. full screen);
    int SeedRND = 0;
    int MaxSpeed = 0;
    Uint32 msTimer = 0;
    Sint32 DeltaT = 0;
    int FrameCount = 0;
    byte LogMode = MODE_MAP;
    //byte LogMode = MODE_TABLES;

    SV = -1;    // Sherlock version (global variable)

    // Help line
    if (argc == 1)
    {
        printf("Use: FL -V10 | -V20 [-FULLSCREEN] [-MAXSPEED] [-NOSCANLINES] [-SEEDRND]\n");
        exit(-1);
    }

    // process command line arguments
    for (i = 1; i < argc; i++)
    {
        if (!strcmp(argv[i], "-v10") || !strcmp(argv[i], "-V10"))
            SV = V10;
        if (!strcmp(argv[i], "-v20") || !strcmp(argv[i], "-V20"))
            SV = V20;
        if (!strcmp(argv[i], "-fullscreen") || !strcmp(argv[i], "-FULLSCREEN"))
            WinMode = SDL_FULLSCREEN;
        if (!strcmp(argv[i], "-maxspeed") || !strcmp(argv[i], "-MAXSPEED"))
            MaxSpeed = 1;
        if (!strcmp(argv[i], "-noscanlines") || !strcmp(argv[i], "-NOSCANLINES"))
            NoScanLines = 1;
        if (!strcmp(argv[i], "-seedrnd") || !strcmp(argv[i], "-SEEDRND"))
            SeedRND = 1;
    }


    if (SV == -1)
    {
        fprintf(stderr, "FL: ERROR Unknown game version. Program aborted.\n");
        exit(-1);
    }

    if (InitSpectrum())
    {
        fprintf(stderr, "FL: ERROR initializing spectrum. Program aborted.\n");
        exit(-1);
    }

    if (InitGraphicsSystem(WinMode, LogMode))
    {
        fprintf(stderr, "FL: ERROR initializing graphic system. Program aborted.\n");
        exit(-1);
    }


    LockScreen(screen);

    SDLTWE_DrawTextWindowFrame(&GameWin, 4, 0x00404040ul, 4, SC_CYAN);
    SDLTWE_DrawTextWindowFrame(&HelpWin, 4, 0x00404040ul, 4, SC_CYAN);
    SDLTWE_DrawTextWindowFrame(&ObjWin, 4, 0x00404040ul, 4, SC_CYAN);   //should be after HelpWin because of frame
    SDLTWE_DrawTextWindowFrame(&LogWin, 4, 0x00404040ul, 4, SC_CYAN);
    SDLTWE_PrintCharTextWindow(&LogWin, '\f', &CharSet, SC_BLACK, SC_WHITE);    //clear window with form-feed


    // title screen
    f = fopen("SHERLOCK.SCR", "rb");
    if (!f)
    {
        fprintf(stderr, "FL: ERROR - Can't open title screen file 'SHERLOCK.SCR'\n");
        exit(-1);
    }
    else
    {
        for (i = 16384; i < ((16384 + 256 / 8 * 192) + (32 * 24)); i++)
        {
            fscanf(f, "%c", &b);
            WrZ80(i, b);
        }
        fclose(f);
    }

    VerboseLevel = 1;
    HelpInfo(&HelpWin, &CharSet);
    UnLockScreen(screen);
    RunMainLoop = 1;
    while (RunMainLoop)
    {
        if (SDL_PollEvent(&event))
        {
            switch (event.type)
            {
                case SDL_KEYDOWN:
                    CurrentPressedKey = event.key.keysym.unicode;
                    RunMainLoop = 0;
                        break;
            }
        }
        SDL_Delay(100);
    }

    ResetZ80(&z80);
    z80.SP.W = 0x5D80;  // SP is inizialized in loader code 'sherlock'!!!
    mem[SV_RAMTOP + 0] = RAMTOP & 0x00FF;   // default RAMTOP 65367
    mem[SV_RAMTOP + 1] = RAMTOP >> 8;
    mem[RAMTOP] = 0x3E; // see ROM RESET1 @ 0x1225
    //z80.SP.W = RAMTOP - 1;
    mem[SV_ERRSP + 0] = (RAMTOP - 3) & 0x00FF;
    mem[SV_ERRSP + 1] = (RAMTOP - 3) >> 8;
    z80.IY.W = SV_ERRNO;    // IY never changes its value
    mem[SV_REPDEL + 0] = 0x23;
    mem[SV_REPDEL + 1] = 0x05;
    for (i = 0; i < 8; i++)
        mem[SV_KSTATE + i] = 0;
    mem[SV_KSTATE + 0]--;   // KSTATE0: no new key
    mem[SV_KSTATE + 4]--;   // LSTATE4: no new key
    mem[SV_FLAGS] |= 0x08;  // to get out of K-Mode


    if (InitGame(SV))
    {
        fprintf(stderr, "FL: ERROR initializing game. Program aborted.\n");
        exit(-1);
    }

    // ignore PRINT_DICT_WORDS variable
    mem[0xA88B] = 0;        // the RET Z instruction is overwritten with a NOP

    Build_Dictionary();

    switch (SV)
    {
        case V10:
            z80.PC.W = L_START_V10;
            break;
        case V20:
            z80.PC.W = L_START_V10; // all labels are the same as in V 1.0
            break;
        default:
            exit(-1);
    }

    if (SeedRND)
        z80.R = (byte)SDL_GetTicks();

    SDL_EnableUNICODE(1);
    RunMainLoop = 1;



    /****************************** MAIN LOOP ******************************/
    while (RunMainLoop)
    {

        // we run the main loop with FPS Hz
        DeltaT = SDL_GetTicks() - msTimer;  // on my Intel Core2 Duo E6850@3GHz ca. 5 ms
        if (DeltaT < DELAY_MS)
            if (!MaxSpeed)
                SDL_Delay(DELAY_MS - DeltaT);
        msTimer = SDL_GetTicks();
        FrameCount++;


        LockScreen(screen);

        ExecZ80(&z80, TSTATES_PER_LOOP);

        IntZ80(&z80, INT_RST38);    // serve the keyboard interrupt in Spectrum ROM

        PrintObjectsList(ObjectsIndexAdr, ObjectsStartAdr, &ObjWin, &CharSet, SC_BRYELLOW, SC_BRBLUE);

        if (FrameCount > FPS)
        {
            FrameCount = 0;

            DisplayGameMap();
            DisplayCharacterPositions(screen, &CharSet);

            PrintStatus(0, &LogWin, &CharSet, SC_BLACK, SC_WHITE);
        }

        UnLockScreen(screen);


        if (SDL_PollEvent(&event))
        {
            switch (event.type)
            {
                case SDL_QUIT:
                    RunMainLoop = 0;
                    break;
                case SDL_KEYDOWN:
                    CurrentPressedKey = event.key.keysym.unicode;
                    if (CurrentPressedKey == 'Q')
                        RunMainLoop = 0;
                    if (CurrentPressedKey == 'S')
                        SaveGame(&HelpWin, &CharSet, SV, SC_BRGREEN, SC_BRBLACK);
                    if (CurrentPressedKey == 'L')
                        LoadGame(&HelpWin, &CharSet, SV, SC_BRGREEN, SC_BRBLACK);
                    if (CurrentPressedKey == 'H')
                        HelpInfo(&HelpWin, &CharSet);
                    if (CurrentPressedKey == 'I')
                        Info(&HelpWin, &CharSet);
                    if (CurrentPressedKey == 'G')
                        Go(&HelpWin, &CharSet, SV, SC_BRGREEN, SC_BRBLACK);
                    //if (CurrentPressedKey == 'P')
                        //Poke(&HelpWin, &CharSet, SV, SC_BRYELLOW, SC_BRBLACK);
                    if (CurrentPressedKey == 'V')
                    {
                        VerboseLevel++;
                        if (VerboseLevel >= 3)
                            VerboseLevel = 0;
                        HelpInfo(&HelpWin, &CharSet);
                    }
                    break;
                case SDL_KEYUP:
                    CurrentPressedKey = 0;
                    break;
            }
        }
    }

    SDL_Quit();
    exit(0);
}
