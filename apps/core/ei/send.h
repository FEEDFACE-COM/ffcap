#ifndef SEND_H
#define SEND_H

#include <pcap.h>


void send_linktype(int link_type);
int send_capture(unsigned long long framecount, struct pcap_pkthdr *head, const u_char* data);


#endif