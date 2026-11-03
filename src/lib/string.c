#include "string.h"

size_t strlen(const char *str)
{
	size_t len = 0;

	while (str[len])
		len++;
	return len;
}

int strcmp(const char *s1, const char *s2)
{
	while (*s1 && *s1 == *s2)
	{
		s1++;
		s2++;
	}
	return (unsigned char)*s1 - (unsigned char)*s2;
}

int strncmp(const char *s1, const char *s2, size_t n)
{
	for (size_t i = 0; i < n; i++)
	{
		if (s1[i] != s2[i] || !s1[i])
			return (unsigned char)s1[i] - (unsigned char)s2[i];
	}
	return 0;
}

void *memset(void *dst, int c, size_t n)
{
	uint8_t *d = dst;

	for (size_t i = 0; i < n; i++)
		d[i] = (uint8_t)c;
	return dst;
}

void *memcpy(void *dst, const void *src, size_t n)
{
	uint8_t *d = dst;
	const uint8_t *s = src;

	for (size_t i = 0; i < n; i++)
		d[i] = s[i];
	return dst;
}
