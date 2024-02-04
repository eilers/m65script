#ifndef __M65SCRPT_FILEIO_H
#define __M65SCRPT_FILEIO_H

#include <stdint.h>
#include <stddef.h>
/**
 * @brief Open file
 * @param filename to open
 * @return File descriptor or `0xff` if error
 */
#ifdef __clang__
__attribute__((leaf))
#endif
uint8_t m65scrpt_open(char* filename);

/**
 * @brief Read up to 512 bytes from file
 * @param buffer Input buffer
 * @return Number of bytes read
 */
#ifdef __clang__
__attribute__((leaf))
#endif
size_t m65scrpt_read(char* buffer);


/**
 * @brief Close a single file
 * @param fd File descriptor pointing to file to close
 */
#ifdef __clang__
__attribute__((leaf))
#endif
int m65scrpt_close(uint8_t fd);

#endif // __M65SCRPT_FILEIO_H
