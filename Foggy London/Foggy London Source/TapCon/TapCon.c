/****************************************************************************\
*                                                                            *
*                                TapCon                                      *
*                                                                            *
* TAP format converter                                                       *
*                                                                            *
* This program is part of the 'Foogy London' package. It converts the TAP    *
* game file into binaries readable by the emulator.                          *
*                                                                            *
* (c) 2013 by CH. Contact: wilderland@aon.at                                 *
*                                                                            *
*                                                                            *
* V 1.00-FL - 20131128                                                       *
*                                                                            *
* Compiler: Pelles C for Windows 6.5.80 with 'Microsoft Extensions' enabled  *
*                                                                            *
\****************************************************************************/



/*** INCLUDES ***************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


/*** INCLUDES ***************************************************************/
#define TAP_LENGTH    56104
#define CODE_START    0x38A7
#define CODE_LENGTH   41600



/****************************************************************************\
*                                   main                                     *
*                                                                            *
\****************************************************************************/
int main(int argc, char *argv[])
{
    FILE *fr, *fw;
    long int FileLength;
    size_t BytesRead;
    unsigned char conversion_buffer[42000];

    fr = fopen("SHERLOCK.TAP", "rb");
    if (fr)
    {
    fseek(fr, 0, SEEK_END);
    FileLength = ftell(fr);
        if (FileLength == TAP_LENGTH)
        {
            fw = fopen("SHER_V20.bin", "wb");
            if (fw)
            {
                fseek(fr, CODE_START, SEEK_SET);
                BytesRead = fread(conversion_buffer, 1, CODE_LENGTH, fr);
                if (BytesRead == CODE_LENGTH)
                {
                    fwrite(conversion_buffer, 1, CODE_LENGTH, fw);
                    fprintf(stderr, "\nSHER_V20.bin successfully built.\n");
                }
                else
                {
                    fprintf(stderr, "Read length error in 'SHERLOCK.TAP'; no conversion possible.\n");
                }
                fclose(fw);
                fclose(fr);
            }
            else
            {
            fprintf(stderr, "Can't open 'SHER_V20.bin' for write; no conversion possible.\n");
            fclose(fr);
            }
        }
        else
        {
            fprintf(stderr, "SHERLOCK.TAP has wrong length; no conversion possible.\n");
            fclose(fr);
        }
    }
    else
    {
        fprintf(stderr, "Can't open 'SHERLOCK.TAP' for read; no conversion possible.\n");
    }

}
