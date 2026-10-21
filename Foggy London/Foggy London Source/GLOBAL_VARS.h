/****************************************************************************\
*                                                                            *
*                              GLOBAL_VARS.h                                 *
*                                                                            *
* The gloabal variables for the FL project.                                  *
*                                                                            *
* (c) 2013 by CH                                                             *
*                                                                            *
* V 1.03 - 20130531                                                          *
*                                                                            *
\****************************************************************************/


#ifndef GLOBAL_VARS_INCLUDED
#define GLOBAL_VARS_INCLUDED

#include "FL.h"     //it is unclear, why this is necessary. It started with V 1.03.

EXTERN int SV;      //Sherlock version

EXTERN word DictionaryIndexAdr, DictionaryStartAdr;
EXTERN word RoomsIndexAdr, RoomsStartAdr, RoomsNrOf;
EXTERN word ObjectsIndexAdr, ObjectsStartAdr;

EXTERN SDL_Surface *screen;
EXTERN SDL_Surface *GameMap;

EXTERN int NoScanLines;
EXTERN int LockLevel;
EXTERN int VerboseLevel;
EXTERN struct CharSetStruct CharSet;

EXTERN struct TextWindowStruct GameWin;  // dummy to draw frame
EXTERN struct TextWindowStruct LogWin;
EXTERN struct TextWindowStruct ObjWin;
EXTERN struct TextWindowStruct HelpWin;
EXTERN struct TextWindowStruct LLWin;

EXTERN byte mem[0x10000];         // Spectrum memory
EXTERN Z80 z80;                   // my Z80 processor

EXTERN Uint16 CurrentPressedKey;  // is used in InZ80()


// DICTIONARY
struct DictIndexStruct {
    byte LETTER;
    word LETTER_START_ADR;
};
struct DictIndexStruct DictIndex[32];

struct DictEntryStruct {
    word ADR;
    char WORD[MAXIMUM_WORD_LENGTH];
    byte TYPE;
    byte FLECTION;
    word SYNONYME;
    byte BYTE1;
    byte BYTE2;
};
EXTERN struct DictEntryStruct DictEntry[DICT_ENTRIES_NROF_MAX];


// TIMETABLE
struct TimetableStruct {
    byte ObjNr;
    char *ObjShortName;
};
EXTERN struct TimetableStruct Timetable[TIMETABLE_NUMBEROFENTRIES];

// CHARACTERS
struct CharacterLocationStruct {
    byte ObjNr;
    byte Group;
    char *Initials;
    byte Position1;
};
EXTERN struct CharacterLocationStruct CharacterLocation[CHARACTERS_NROF];

struct GroupedCharactersStruct {
    byte RoomNr;
    byte Group;
    char CharacterString[20];
};
EXTERN struct GroupedCharactersStruct GroupedCharacters[CHARACTERS_NROF];



#endif /* GLOBAL_VARS_INCLUDED */
