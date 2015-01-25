#ifndef FFLOG_H
#define FFLOG_H

#include <stdlib.h>
#include <stdio.h>

#define FFLOG(...) do { \
	fprintf(stderr,">> "); \
	fprintf(stderr,__VA_ARGS__); \
	fprintf(stderr,"\n"); \
} while (0)

#define FFERROR(...) do { \
	fprintf(stderr,">> 3RR0R in %s #%d\n",__FILE__,__LINE__); \
	fprintf(stderr,">> "); \
	fprintf(stderr,__VA_ARGS__); \
	fprintf(stderr,"\n"); \
} while (0)

#define FFFATAL(...) do { \
	fprintf(stderr,">> F4T4L 3RR0R in %s #%d\n",__FILE__,__LINE__); \
	fprintf(stderr,">> "); \
	fprintf(stderr,__VA_ARGS__); \
	fprintf(stderr,"\n"); \
    fprintf(stderr,">> H4LT H4LT H4LT\n"); \
	exit(0xff); \
} while (0)

void FFDUMP(const void *ptr, unsigned long len, const char* str);


#endif
