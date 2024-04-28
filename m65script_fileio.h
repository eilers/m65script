#ifndef __M65SCRPT_FILEIO_H
#define __M65SCRPT_FILEIO_H

#include <stdint.h>
#include <stddef.h>

#ifndef __mos__
#define uint8_t int
#endif

/**
 * @brief Load file from disk into buffer
 * @param buffer Input buffer
 * @param size The size of the buffer
 * @param filename The name of the file to load
 * @param device Device number
 * @return Number of bytes read or -1 on error
 */
#ifdef __clang__
__attribute__((leaf))
#endif
int m65script_load(char* buffer, int size , char* filename, uint8_t device );


#endif // __M65SCRPT_FILEIO_H
