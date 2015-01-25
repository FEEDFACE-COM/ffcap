
#include "fflog.h"

void
print_bps(long long delta,unsigned long long bytes,char *buf)
{
    float bps = (bytes*8.) / (delta/(1000.*1000.));
    float value = 0.0; char *suffix= "???";
    if (bps > 10.*1024.*1024*1024.*1024.) { value= bps/(1024.*1024.*1024.*1024.); suffix= "tbps"; }
    else if (bps > 10.*1024.*1024*1024.) { value= bps/(1024.*1024.*1024.); suffix= "gbps"; }
    else if (bps > 10.*1024.*1024) { value= bps/(1024.*1024.); suffix= "mbps"; }
    else if (bps > 10.*1024.) { value= bps/(1024.); suffix= "kbps"; } 
    else { value = bps; suffix= "bps"; }
    sprintf(buf,"%.2f %s",value,suffix);
}

void
print_fps(long long delta, unsigned long long count, char *buf)
{
    float fps = (count) / (delta/(1000.*1000.));
    float value = 0.0; char *suffix= "???";
    if (fps > 10.*1024.*1024*1024.*1024.) { value= fps/(1024.*1024.*1024.*1024.); suffix= "tfps"; }
    else if (fps > 10.*1024.*1024*1024.) { value= fps/(1024.*1024.*1024.); suffix= "gfps"; }
    else if (fps > 10.*1024.*1024) { value= fps/(1024.*1024.); suffix= "mfps"; }
    else if (fps > 10.*1024.) { value= fps/(1024.); suffix= "kfps"; } 
    else { value = fps; suffix= "fps"; }
    sprintf(buf,"%.2f %s",value,suffix);
}

void
print_time(long long time, char *buf)
{
    long long value = 0; char *suffix= "??";
    if (time > 10*1000*1000) { value=time/(1000*1000); suffix= "s"; }
    else if (time > 10*1000) { value= time/1000; suffix= "ms"; }
    else { value = time; suffix= "us"; }
    sprintf(buf,"%llu %s",value,suffix);   
}
