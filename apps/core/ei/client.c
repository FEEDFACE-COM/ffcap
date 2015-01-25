

#include <unistd.h>
#include <stdlib.h>
#include <signal.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>


#include <erl_interface.h>
#include <ei.h>

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
    FFLOG("client stats  %s  %lld frames  %s",time,frame_count,fps);
}

void
usage(void)
{
    fprintf(stderr,"client\n\n");
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
    FFLOG("client interrupt by user");
    loop= 0;
}



int
main(int argc, char **args)
{
    char *node= "switch@cacodemon.hq.feedface.com";
    long long start_time = 0x0;
    unsigned long long frame_count= 0;

    get_options(argc,args);
    init_sig(sigint);
    
    

    FFLOG("client init");    

    start_time= timeofday();

    ETERM *fromp, *tuplep, *fnp, *argp, *resp;
    ErlMessage msg;
    int fd;
    
    erl_init(NULL,0);
    
    if (erl_connect_init(1,"feedface", 0) == -1)
        erl_err_quit("erl_connect_init");
    
    fd= erl_connect(node);
    if (fd < 0)
        erl_err_quit("erl_connect");
    
    FFLOG("connected to %s",node);

    while (loop) {
        #define buf_size (0x10000)
        unsigned char buf[buf_size]= {0};
        
        int r= erl_receive_msg(fd, buf, buf_size, &msg);
        if (r == ERL_TICK)
            continue;
        if (r == ERL_ERROR) {
            FFERROR("could not erl_receive_msg()");
            break;
        }
        
        FFLOG("got %d",r);

        frame_count++;
        if (verbosity > 1 && (frame_count%(1<<20) == 0))
            print_stats(timeofday()-start_time,frame_count);
    }
    
    print_stats(timeofday()-start_time,frame_count);    

    FFLOG("client exit");

}
