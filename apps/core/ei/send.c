
#include <unistd.h>
#include <pcap.h>
#include <ei.h>
#include "fflog.h"




void
send_linktype(int link_type)
{
    ei_x_buff msg;

    
    if (ei_x_new_with_version(&msg) != 0 )                             { FFERROR("ei_x error"); return; }
    if (ei_x_encode_list_header(&msg,1) != 0 )                         { FFERROR("ei_x error"); return; }
    
    if (ei_x_encode_tuple_header(&msg,2) != 0 )                        { FFERROR("ei_x error"); return; }
    if (ei_x_encode_atom(&msg,"link_type") != 0 )                      { FFERROR("ei_x error"); return; }
    if (ei_x_encode_long(&msg,link_type) != 0)                          { FFERROR("ei_x error"); return; }
    if (ei_x_encode_empty_list(&msg) != 0)                             { FFERROR("ei_x error"); return; }

    
    u_int16_t len= htons(msg.index);        
    if (write(fileno(stdout), &len, sizeof(len)) != sizeof(len)) {
        FFERROR("could not write() linktype msg length");
        return;
    }
    
    if (write(fileno(stdout), msg.buff, msg.index) != msg.index)  {
        FFERROR("could not write() linktype msg");
        return;
    }

    ei_x_free(&msg);    
    
}



int
send_capture(unsigned long long frame_count, struct pcap_pkthdr *head, const u_char* data)
{    

    long long now= head->ts.tv_sec * 1000 * 1000 + head->ts.tv_usec;

    
    ei_x_buff msg;

    if (ei_x_new_with_version(&msg) != 0 )                            { FFERROR("ei_x error"); return 0; }
    if (ei_x_encode_list_header(&msg,1) != 0 )                        { FFERROR("ei_x error"); return 0; }

    if (ei_x_encode_tuple_header(&msg,2) != 0 )                       { FFERROR("ei_x error"); return 0; }
    if (ei_x_encode_atom(&msg,"capture") != 0 )                       { FFERROR("ei_x error"); return 0; }
    
    if (ei_x_encode_list_header(&msg,3) != 0 )                        { FFERROR("ei_x error"); return 0; }

    if (ei_x_encode_tuple_header(&msg,2) != 0 )                       { FFERROR("ei_x error"); return 0; }
    if (ei_x_encode_atom(&msg,"time") != 0 )                          { FFERROR("ei_x error"); return 0; }
    if (ei_x_encode_longlong(&msg,now) != 0)                          { FFERROR("ei_x error"); return 0; }

    if (ei_x_encode_tuple_header(&msg,2) != 0 )                       { FFERROR("ei_x error"); return 0; }
    if (ei_x_encode_atom(&msg,"size") != 0 )                          { FFERROR("ei_x error"); return 0; }
    if (ei_x_encode_long(&msg,head->caplen) != 0)                     { FFERROR("ei_x error"); return 0; }

    if (ei_x_encode_tuple_header(&msg,2) != 0 )                       { FFERROR("ei_x error"); return 0; }
    if (ei_x_encode_atom(&msg,"data") != 0 )                          { FFERROR("ei_x error"); return 0; }
    if (ei_x_encode_binary(&msg, data, head->caplen) != 0 )           { FFERROR("ei_x error"); return 0; }
    if (ei_x_encode_empty_list(&msg) != 0)                            { FFERROR("ei_x error"); return 0; } ;        

    if (ei_x_encode_empty_list(&msg) != 0)                            { FFERROR("ei_x error"); return 0; } ;        
        
    u_int16_t len= htons(msg.index);        
        
    if (write(fileno(stdout), &len, sizeof(len)) != sizeof(len)) {
        FFERROR("could not write() capture msg length");
        return 0;
    }
    
    if (write(fileno(stdout), msg.buff, msg.index) != msg.index)  {
        FFERROR("could not write() capture msg");
        return 0;
    }


    ei_x_free(&msg);    
    
    return 1;
}
