
#include <stdio.h>

void
FFDUMP(const void *ptr, unsigned long len, const char* str)
{
    typedef unsigned char byte;
#if defined __LP64__
    //compiling for 64 bit architecture
    typedef unsigned long long word;
    const char *format= "%016llx:   ";
    const long mask = 0xfffffffffffffff0;
#else
    //compiling for 32 bit architecture
    typedef unsigned long word;
    const char *format= "%08lx:   ";
    const long mask = 0xfffffff0;
#endif

	word adr= ((word)ptr);
	word base= adr & mask;

	fprintf(stdout,"\n****%s****\n",str?str:"");
	for (word p= base; p < adr+len; p+=0x10) {
		fprintf(stdout,format,p);
		for (word q= p; q<p+0x10; q++) {
			byte c= *((byte*)q);
			if (q >= adr && q< adr+len)
				fprintf(stdout,"%02x%c",c,(q+1)%0x4?':':' ');
			else fprintf(stdout,"   ");	
		}
		fprintf(stdout,"  ");		
		for (word q= p; q<p+0x10; q++) {
				byte c= *((byte*)q);
				if (q >= adr && q< adr+len) {
					fprintf(stdout,"%c%s",c>=0x20&&c<0x7f?c:'.',(q+1)%0x8?"":" ");
			} else fprintf(stdout," %s",(q+1)%8?"":" ");	
		}	
		fprintf(stdout,"\n");
	}
	fprintf(stdout,"\n");
}


