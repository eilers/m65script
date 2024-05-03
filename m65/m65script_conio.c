
#include "../m65script_conio.h"
#include "mega65/memory.h"
#include "mega65/conio.h"


unsigned char m65script_cgetc(void){
    static int conioInitialized = 0;

    if (conioInitialized == 0){
        conioInitialized = 1;
        printf("init conio\n");
        conioinit();
    }

    flushkeybuf();
    return cgetc();
}
