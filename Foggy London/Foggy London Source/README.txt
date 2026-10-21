
                                  FOGGY LONDON

                             A Sherlock Environment

                                 (c) 2013 by CH

                             wilderland AT aonDOTat





CONTENT
=======

(0) Legal Info
(1) Introduction
(2) Game Versions
(3) Installing FL
(4) Obtaining The Game Files
(5) Starting 'Foggy London'
(6) Controlling 'Foggy London'
(7) The Objects
(8) The Map
(9) References



(0) - Legal Info
================

FOOGY LONDON is (c) 2013 by CH. You may use/modify it for private use; if you
   want to distribute a program based on FOGGY LONDON, please contact the
   author at "wilderland AT aonDOTat".

"Sherlock" is (c) Melbourne House / Beam Software, 1984. Written by Philip
   Mitchell.

Simple Direct Media Layer library (SDL 1.2) from www.libsdl.org (GNU licence).

Z80 emulator based on Marat Fayzullin's work from 2007. Free for non-profit
   projects (fms.komkon.org).

8x8 charset from ZX Spectrum ROM (c) by Amstrad; use granted for emulators.

YOU ARE NOT ALLOWED TO DISTRIBUTE 'FOOGY LONDON' TOGETHER WITH HOBBIT
BINARIES!



(1) - Introduction
==================

FOGGY LONDON (FL) allows you to see what's REALLY going on in this wonderful
world created by Philip Mitchell et al. in 1984 at Melbourne House. It runs
the original game code in a rudimentary Spectrum emulator, while displaying
the state of objects and persons, the current positions of the latter, and a
log what all the others (NPC) do while Sherlock is in one place.
This software is a direct descendant from the 'WILDERLAND' [1] hobbit environ-
ment by the same author.



(2) - Game Versions
===================
According to the Website 'World of Spectrum' [2] there are two versions of
this game. Investigation of the presented file does not indicate any dif-
ference, nor have I read of a second (bugfixed) version as it was the case
with 'The Hobbit' text adventure published by the same company.
FL does support the -V10 and -V20 switch, though these produce the same game
behaviour.
The Tape Converter utility supplied with FL takes the "SherlockV2.0.tap.zip"
file and creates the binary "SHER_V20.bin", so running FL with the -V20
switch should make sense.



(3) - Installing FL
===================
Just unzip all files to a directory. The package includes the source files
and a compiled version of FL. There are also a number of support files
(loading screen, high-res map, graphics DLL etc.) included.

FL was developed with 'Pelles C for Windows, V 6.50.8', Simple Direct Media
Layer library (SDL 1.2) from www.libsdl.org (GNU licence), and a Z80 emulator
based on Marat Fayzullin's work from 2007 (fms.komkon.org).



(4) - Obtaining the game files
==============================
The actual game files (ZX Spectrum binaries) you need to run FL are NOT
included in the FL download package for copyright reasons. You may get them
from various abandonware websites like 'World of Spectrum' [2].
I hereby explicitly prohibit the distribution of 'Foggy London' together with
the 'Sherlock' binaries!

Step-by-Step-Instruction:
   (4.1) Go to http://www.worldofspectrum.org
   (4.2) Select 'Archive!' - 'Text Adventures' - 'S' - 'Sherlock'
   (4.3) Download 'SherlockV2.0.tap.zip'
   (4.4) Unzip the 'SHERLOCK.TAP' file into the 'TapCon' directory.
   (4.5) Run 'TapCon.exe' to extract the game binary.
   (4.6) Copy 'SHER_V20.bin' to the FL directory.



(5) - Starting 'Wilderland'
===========================
Run FL from the command line with the following command:

   WL -V10|-V20 [-FULLSCREEN] [-MAXSPEED] [-NOSCANLINES] [-SEEDRND]

'-V10' or '-V20' selects the game version (use '-V20')
-FULLSCREEN runs the game in fullscreen mode (only recommended for screens
   with 1280 x 1024 pixel native resolution)
-MAXSPEED runs the emulator with maximum speed (usefull if you just want to
   see the NPCs roam around). Otherwise the Spectrum speed with an appr. 
   30 seconds wait cycle is emulated.
-NOSCANLINES suppresses the TV-like scanlines in the game window (less
   authentic but better for the eye!).
-SEEDRND. The game uses the Z80 processor's refresh register to generate
   random numbers. With this option this register is initialized to an
   arbitrary value to make game play more unpredictable.



(6) - Controlling 'Foggy London'
==============================
The 'Foogy London' screen is divided into a number of different windows with
the following layout:

                     +--------+--------------+------------+
                     |        |              |            |
                     |  Log   |     Game     |            |
                     |        |              |            |
                     | Window |    Window    |   Object   |
                     |        |              |            |
                     +--------+--------------+   Window   |
                     |                       |            |
                     |                       |            |
                     |      Map Window       |            |
                     |                       +------------+
                     |                       | Commd.Win. |
                     +-----------------------+------------+

Log Window: shows what's going on in the 'background' of the game (e.g. what
   the NPC do in their respective locations). The 'Verbose' commoand (see
   below) selects how much information is presented.
Game Window: this is an exact representation of the Spectrum's screen while
   the game is running.
Object Window: the state of all objects (and characters which are also objects
   in the game's context) is displayed here. See section "(7) - The Objects"
   for a full reference.
Map Window: the position of all the characters is indicated in this game map
   (a high-res version for print-out can be found in the 'FL' directory of
   FL). Dead characters have an additional '+' attached to their names.
Command Window: this is FL's command window. Help information is displayed
   within or filenames for load/save commands can be entered.


When running FL you control two different environments: the game itself and
the emulator. The basic principle is the following:

            Just typing goes to the game, while
            caps-shifted letters control the emulator.


(6.1) - Game Control

a-z, 0-9 ............... these characters appear in the game's input line
. and , and " .......... full stop, comma & quote-mark are also used for input
BACKSPACE .............. is the DELETE key for the game
@ ...................... is the 'do-the-last-command-again' key

The cursor keys for walking around are not supported.


(6.2) - Environment Control

H ... Help - A short overview over commands and abbreviations
I ... Info - Legal infos on the software are displayed
S ... Save - Saves the current state of the game
L ... Load - Loads a previous saved game
      No filename editing is possible in SAVE and LOAD. If you mistyped, just
      press ENTER and start again.
G ... Go - Jump directly to a specific room. Enter number in hex and press
      enter (no editing is possible). See the map in the \FL directory for a
      reference on room numbers. NB: this 'beaming' only transports you, the
      objects you are holding stay in place (though technically you still
      possess them)!
V ... Verbose-Mode. Toggle between 0 (no output), 1 (everything but trains),
      and 2 (full output).
Q ... Quit - Quits the emulator. If the console window stays on the screen,
      press another key to close it.



(7) - The Objects
=================
The object database is (beside the room and dictionary database) one of the
core items of the game. The following information is stored for each object:

Object Number: the game's internal object reference number.
Name: the object's full name (a noun and a maximum of two adjectives; for money
   the value in pound, shilling and pence is given).
1L (first location): most objects do only appear in one location, which is
   referenced here as room number (see game map). Some objectes (eg. doors) are
   visible from more than one room, in this cases only the first room is
   indicated.
# (number of): how many times the object appears in the game.
MO (mother object): if an object is carried or enclosed within another object
   this object is referenced by its object number (or 0xFF if this is not the
   case).
+2 (unknown): presumable the object's volume.
+3 (unknwon): presumable the object's mass.
+4 (unknown)
Attributes-1 (each object has 2 x 8 binary attributes associated with it):
   v: visible
   A: animal/alive (otherwise it is an object)
   o: open (otherwise it is closed)
   *: gives light
   b: broken (or dead for characters)
   f: full
   L: it is a liquid
   l: locked
Attributes-2:
   ?: unknown or unused
   X: examined (the object has been closely examined)
   $: money (the 'object' is money and has a value associated with)



(8) - The Map
=============
The map is an important part of the game. A high-res version can be found in
the \FL directory under the filename 'GameMap_big.jpg'. The locations of
streets and railroad stations are take from a contemporary London map (with
the exception of Slater Street, which I could not find). Most cab travelling
times between locations reflect these layout correctly.



(9) - References
================
[1] http://members.aon.at/~ehesch1/wl/wl.htm
[2] http://www.worldofspectrum.org


README.TXT Version 1.00 - 20131208