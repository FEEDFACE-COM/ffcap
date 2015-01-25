
#include <sys/time.h>
#include <signal.h>
#include "fflog.h"

void
init_sig( void sigint(int) )
{
    struct sigaction sa;
    sigemptyset(&(sa.sa_mask));
    sa.sa_flags= 0;
    sa.sa_handler= sigint;
    if (sigaction(SIGINT,&sa,NULL) < 0) {
        FFFATAL("could not sigaction() sigint handler");
    }   
}



long long 
timeofday()
{
    struct timeval tv;
    if (gettimeofday(&tv,0))
        FFFATAL("could not gettimeofday()");
    return tv.tv_sec * 1000 * 1000 + tv.tv_usec;     
}


