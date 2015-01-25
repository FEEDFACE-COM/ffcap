

#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>


#include "fflog.h"
#include "recv.h"
#include "pretty.h"
#include "util.h"

static int loop= 1;
static int verbosity = 0;

void
print_stats(long long delta, unsigned long long frame_count)
{
    char time[0x100]; char fps[0x100];
    print_time(delta,time);
    print_fps(delta,frame_count,fps);
    FFLOG("console stats  %s  %lld frames  %s",time,frame_count,fps);
}

void
usage(void)
{
    fprintf(stderr,"console\n\n");
    exit(-1);   
}

void
get_options(int argc, char **args)
{
    char chr;

     while ((chr = getopt(argc, args, "v")) != -1) {
             switch (chr) {
                 case 'v':
                    verbosity++;
                    break;
             default:
                     usage();
             }
     }
     argc -= optind;
     args += optind;
}

void
sigint()
{
    FFLOG("console interrupt by user");
    loop= 0;
}



int
main(int argc, char **args)
{
    long long start_time = 0x0;
    unsigned long long frame_count= 0;

    get_options(argc,args);
    init_sig(sigint);
    
    

    FFLOG("console init");    

    start_time= timeofday();
    while (loop) {

        int len= 0;
        unsigned char buf[0x10000];

        len= recv_msg(buf);
        
        if (len < 0)
            break;
        
        if (len == 0)
            continue;
            
//        FFLOG("recv_msg #%llu %d byte",frame_count,len);
        FFDUMP(buf,len,"recv_msg");
        
        frame_count++;
        if (verbosity > 1 && (frame_count%(1<<20) == 0))
            print_stats(timeofday()-start_time,frame_count);
    }
    
    print_stats(timeofday()-start_time,frame_count);    

    FFLOG("console exit");

}
