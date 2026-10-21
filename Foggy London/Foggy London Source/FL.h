#ifndef FL_H
#define FL_H

// My data types
#ifndef BYTE_TYPE_DEFINED
#define BYTE_TYPE_DEFINED
typedef Uint8 byte;
#endif /* BYTE_TYPE_DEFINED */

#ifndef WORD_TYPE_DEFINED
#define WORD_TYPE_DEFINED
typedef Uint16 word;
#endif /* WORD_TYPE_DEFINED */

#ifndef COLOR_T_TYPE_DEFINED
#define COLOR_T_TYPE_DEFINED
typedef Uint32 color_t;
#endif /* COLOR_T_TYPE_DEFINED */


#define FL_DEBUG 1

#define V10 0
#define V20 1
#define FN_V10                      "SHER_V10.bin"
#define FN_V20                      "SHER_V20.bin"  // a patch file is loaded over the save area for Version 2
#define STARTADR_V10                0x5D80          // all other labels are the same
#define LENGTH_V10                  41600

#define DICTIONARY_INDEX_V10        0x5D80
#define DICTIONARY_START_OFFSET_V10 0x0040
#define DICTIONARY_END_V10          0x67B6
#define DICT_ENTRIES_NROF_MAX       1000            // ???
#define MAXIMUM_WORD_LENGTH         20              // actually 12

#define ROOMS_INDEX_V10             0x840B
#define ROOMS_V10                   0x84E1
#define ROOMS_NROF_V10              107
#define ROOMS_NROF_MAX              107
#define MAX_NROF_EXITS              10
#define ROOMS_ARRAY_SIZE            0xFF            // don't change!

#define OBJECTS_INDEX_V10           0x8B6F
#define OBJECTS_V10                 0x8CBA
#define OBJECTS_NROF_V10            110
#define OBJECTS_NROF_MAX            110
#define OBJECTS_NR_MAX              110
#define OBJECTS_ARRAY_SIZE          0xFF            // don't change!

#define TIMETABLE_START             0x9860
#define TIMETABLE_NUMBEROFENTRIES   24

#define SDLTWE_CHARSETFILEPATH      "CharSetSpectrum8x8.bin"
#define SDLTWE_CHARSETLENGTH        (0x300)

#define L_START_V10                 0xA040
#define L_PRINT_DICT_WORDS          0x5C3C

#define L_SUBJECT                   0xA036
#define L_YOU_OBJ_POSITION_V10      0x8CC9

#define SHILLINGSperPOUND           20
#define PENCEperSHILLING            12

// Object Number Characters
#define CHARACTERS_NROF             29
#define OBJNR_SHERLOCK              0x00
#define OBJNR_CHINAMAN              0x01
#define OBJNR_OLDMAN                0x64
#define OBJNR_LESTRADE              0x02
#define OBJNR_WATSON                0x03
#define OBJNR_STRAKER               0x04
#define OBJNR_DAPHNE                0x05
#define OBJNR_BASIL                 0x06
#define OBJNR_FFOULKES              0x07
#define OBJNR_GARDENER              0x08
#define OBJNR_COOK                  0x09
#define OBJNR_MAID                  0x0A
#define OBJNR_POLICEMAN1            0x0B
#define OBJNR_POLICEMAN2            0x0C
#define OBJNR_TRICIA                0x0D
#define OBJNR_AGENT                 0x68
#define OBJNR_MRSBROWN              0x5E
#define OBJNR_MRSJONES              0x5F
#define OBJNR_CABBIE1               0x1F
#define OBJNR_CABBIE2               0x22
#define OBJNR_POLICECAB             0x6D
#define OBJNR_STEAMTRAIN_24         0x24
#define OBJNR_STEAMTRAIN_25         0x25
#define OBJNR_STEAMTRAIN_26         0x26
#define OBJNR_STEAMTRAIN_27         0x27
#define OBJNR_STEAMTRAIN_28         0x28
#define OBJNR_STEAMTRAIN_29         0x29
#define OBJNR_STEAMTRAIN_2A         0x2A
#define OBJNR_STEAMTRAIN_2B         0x2B

// Object Properties Offsets
#define OCC_OFF          0x00
#define MO_OFF           0x01
//#define A5_OFF           0x05
#define ATTRIBUTE5_OFF   0x05
#define ATTRIBUTE6_OFF   0x06
#define FIRST_OCCURRENCE 0x0F

// Object Attributes
#define ATTR_LOCKED      0x01
#define ATTR_LIQUID      0x02
#define ATTR_FULL        0x04
#define ATTR_BROKEN      0x08
#define ATTR_GIVESLIGHT  0x10
#define ATTR_OPEN        0x20
#define ATTR_ANIMAL      0x40
#define ATTR_VISIBLE     0x80


// Rooms
#define ROOMNR_CAB       0x01


// Main Window
#define MAINWINWIDTH    1280
#define MAINWINHEIGTH   1024
#define COLORDEPTH      32

// Game Window
#define GAMEWINPOSX     (2*8 + 4 + LOGWINWIDTH)
#define GAMEWINPOSY     8
#define GAMEWINWIDTH    (256*2)
#define GAMEWINHEIGTH   (192*2)

// Log Window (partial overdraw of frames)
#define LOGWINPOSX      8
#define LOGWINPOSY      8
#define LOGWINWIDTH     (MAINWINWIDTH - 5*8 - GAMEWINWIDTH - OBJWINWIDTH)
#define LOGWINHEIGTH    (GAMEWINHEIGTH)

// Object Window
#define OBJWINPOSX      (MAINWINWIDTH - OBJWINWIDTH - 8)
#define OBJWINPOSY      8
#define OBJWINWIDTH     (60*8)
#define OBJWINHEIGTH    (112*8)

// Help Window
#define HELPWINPOSX     (MAINWINWIDTH - OBJWINWIDTH - 8)
#define HELPWINPOSY     (OBJWINHEIGTH + 2*8)
#define HELPWINWIDTH    (OBJWINWIDTH)
#define HELPWINHEIGTH   (MAINWINHEIGTH - OBJWINHEIGTH - 3*8)

// Lower Left (LL) Window
#define LLWINPOSX       2
#define LLWINPOSY       (MAINWINHEIGTH - GAMEWINHEIGTH - 2*8)
#define LLWINWIDTH      784
#define LLWINHEIGTH     624

// Game Map Window
#define GAMEMAPWIDTH    784
#define GAMEMAPHEIGTH   624
#define INDICATOROFFSET 1

// Display Mode
#define MODE_MAP        0
#define MODE_TABLES     1


#define SPECTRUMROM_FILEPATH  "SPECTRUM.ROM"
#define SPECTRUMROM_LENGTH    (0x4000)


struct GameKeyboardInputStruct {
    int B;
    int E;
    char buffer[100];
    int length;
};



// dummy labels from Hobbit, should be unnecessary in final version!
//#define ROOMS_NR_MAX 80

#define L_ACTING_ANIMAL_OWN     0xB68E
#define L_ACTING_ANIMAL_V10     0xB5DB
#define L_ACTING_ANIMAL_V12     0xB6EA
//#define L_YOU_OBJ_POSITION_OWN  0xC0CF
//#define L_YOU_OBJ_POSITION_V12  0xC12B


// Object Number Animals
#define OBJNR_YOU              0x00
#define OBJNR_DRAGON           0x3C
#define OBJNR_DISGUSTINGGOBLIN 0x4C



#endif /* FL_H */
