#include "../stdlib_far.h"

void *memset_far(void __far *str, int c, size_t n){
    for (int i = 0; i < n; i++){
        str[0] = c;
    }
}


int memcmp_far(const void __far *str1, const void __far *str2, size_t n){
    // Cast the input pointers to unsigned char pointers for byte-wise comparison
    const unsigned char __far *p1 = (const unsigned char __far *)str1;
    const unsigned char __far *p2 = (const unsigned char __far*)str2;

    for (size_t i = 0; i < n; i++) {
        if (p1[i] != p2[i]) {
            // Return the difference between the first non-matching bytes
            return (int)(p1[i] - p2[i]);
        }
    }

    // If no differences are found, return 0
    return 0;
}
