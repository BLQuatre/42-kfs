#ifndef STRING_H
#define STRING_H

#include "types.h"

size_t strlen(const char *str);
int strcmp(const char *s1, const char *s2);
int strncmp(const char *s1, const char *s2, size_t n);
void *memset(void *dst, int c, size_t n);
void *memcpy(void *dst, const void *src, size_t n);

#endif
