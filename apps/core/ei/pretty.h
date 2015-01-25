#ifndef PRETTY_H
#define PRETTY_H


void print_bps(long long delta,unsigned long long bytes,char *buf);
void print_fps(long long delta, unsigned long long count, char *buf);
void print_time(long long time, char *buf);

#endif
