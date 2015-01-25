
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <pcap.h>

#include "fflog.h"
#include "send.h"
#include "pretty.h"
#include "util.h"

static int loop= 1;
static int verbosity = 0;





void
print_stats(long long delta, unsigned long long frame_count, unsigned long long byte_count)
{
    char bps[0x100]; char time[0x100]; char fps[0x100];
    print_time(delta,time);
    print_bps(delta,byte_count,bps);
    print_fps(delta,frame_count,fps);
    FFLOG("capture stats  %s  %lld frames  %llu byte  %s  %s",time,frame_count,byte_count,fps,bps);
}


pcap_t*
init_pcap(char *filter, char *interface, char *readpath)
{
    int snaplen= 1500;
    int promiscous= 0;
    int wait= 100;

//    char *dev= "en1";
//    char *filter = "arp or icmp or icmp6 or (udp and (port 53 or port 5353))";

    struct bpf_program bpf;
    char errbuf[PCAP_ERRBUF_SIZE] = "";
    pcap_t *ret;

    if (interface) {
        FFLOG("capture interface %s with snaplen %d", interface, snaplen);
        ret= pcap_open_live(interface, snaplen, promiscous, wait, errbuf);
        if (!ret) {
            FFFATAL("could not open_live(): %s", errbuf);
        } else if (*errbuf != 0x0) {
            FFERROR("open_live: %s", errbuf);
        }
    } else if (readpath) {
        FFLOG("capture read from %s", readpath);
        ret= pcap_open_offline(readpath,errbuf);
        if (!ret) {
            FFFATAL("could not open_offline(): %s",errbuf);
        } else if (*errbuf != 0x0) {
            FFERROR("could not open_offline(): %s",errbuf);
        }
    } else {
        FFFATAL("no interface no readpath");    
    }
    
    if (filter) {
        FFLOG("capture filter %s",filter);
        if (pcap_compile(ret, &bpf, filter, 0, PCAP_NETMASK_UNKNOWN) < 0) {
            FFFATAL("could not pcap_compile() %s: %s",filter,pcap_geterr(ret));
        }
        if (pcap_setfilter(ret, &bpf) < 0) {
            FFFATAL("could not pcap_setfilter() %s: %s",filter,pcap_geterr(ret));
        }
    }
        
    return ret;
}





void
usage(void)
{
    fprintf(stderr,"capture [ -i interface | -r file ] [ -f filter ]\n\n");
    exit(-1);   
}


void
get_options(int argc, char **args, char **filter, char **interface, char **readpath)
{
    char chr;

     while ((chr = getopt(argc, args, "vf:i:r:")) != -1) {
             switch (chr) {
                 case 'i':
                    *interface= optarg;
                    break;
                 case 'f':
                     *filter= optarg;
                     break;
                 case 'r':
                     *readpath= optarg;
                     break;
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
    FFLOG("capture interrupt by user");
    loop= 0;   
}




int
main(int argc, char **args) 
{
    pcap_t *handle;
    
    
    char *interface= 0x0;
    char *readpath= 0x0;
    char *filter= 0x0;
    
    long long start_time = 0x0;
    int link_type;
    
    unsigned long long frame_count= 0;
    unsigned long long byte_count= 0;
    
        
    get_options(argc,args,&filter,&interface,&readpath);


    if ((interface && readpath) || (!interface && !readpath))
        usage();


    FFLOG("capture init");
    init_sig(sigint);
    handle= init_pcap(filter,interface,readpath);    
    

    link_type= pcap_datalink(handle);
    if (link_type >= 0) {
        if (verbosity)
            FFLOG("capture link type is %x", link_type);
        send_linktype(link_type); 
    }        
    else {
        FFERROR("got link type %x", link_type);
    }
    
    start_time= timeofday();
    
    while (loop) {
        struct pcap_pkthdr *head;
        const u_char *data;
        int err;
        
        err= pcap_next_ex(handle,&head,&data);
        switch (err) {
            case 1:
                if (verbosity >= 3)
                    FFLOG("capture frame #%06llu %d byte", frame_count, head->len);
                if ( send_capture(frame_count,head,data) ) {
                    frame_count++;
                    byte_count+= head->len;
                } else {
                    loop= 0;
                }
                if (verbosity > 1 && (frame_count%1024 == 0)) 
                    print_stats(timeofday()-start_time,frame_count,byte_count);
                break;
            case 0: //TIMEOUT
                break;
            case -2: //END OF FILE
                FFLOG("capture end of file");
                loop= 0;
                break;
            default:
                FFERROR("pcap error: %s",pcap_geterr(handle));
                loop= 0;
                break;
        }
    }
    
    pcap_close(handle);
    print_stats(timeofday()-start_time,frame_count,byte_count);    

    FFLOG("capture exit");
}






