// Unix implementation of file io
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#include "../m65script_fileio.h"

int m65script_load(char* buffer, int size , char* filename, uint8_t device ){
    // Need to make a local copy in order to avoid
    // a bus error
    printf("1: loader..");
    char* filename_copy = malloc(strlen(filename));
    strcpy(filename_copy, filename);
    printf("2: loader..");

    // Strip all possible subcommands that is incoded in the string, seperated
    // by a ","
    printf("3: loader..");

    char* comma_ptr = strchr(filename_copy, ',');
    if (comma_ptr != NULL) {
        *comma_ptr = '\0';
    }

    printf("load file: %s\n", filename_copy);
    FILE *fp = fopen(filename_copy, "r");
    printf("fb: %d", fp);
    free(filename_copy);
    if (fp == NULL) {
        printf("File not found!\n");
        return -1;
    }

    size_t newLen = fread(buffer, sizeof(char), size, fp);
    if ( ferror( fp ) != 0 ) {
        fputs("Error reading file: %d\n", stderr);
        return -1;
    } else {
        buffer[newLen++] = '\0'; /* Just to be safe. */
    }

    fclose(fp);
    return newLen;
}
