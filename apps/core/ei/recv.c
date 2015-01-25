

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>

#include "fflog.h"
#include "recv.h"

int
recv_msg(unsigned char *buf)
{
    u_int16_t len;
    int cnt= 0;
    
    int fd= 3;;
    {    
        int r= read(fd,buf,sizeof(len));
        if (r < 0 && errno == EINTR)
            return 0;
        if (r == 0) 
            return -1;
        if (r != sizeof(len)) {
            FFERROR("read %d of %ld byte length: %s",r,sizeof(len),strerror(errno));
            return -1;
        }
        len= (buf[0] << 8) | buf[1];
    }
    do {
        int r= read(fd,buf+cnt,len-cnt);

        if (r < 0 && errno == EINTR)
            return 0;
        if (r == 0)
            return -1;
        if (r < 0) {
            FFERROR("read %d of %hd byte message: %s",r,len,strerror(errno));    
            return -1;
        }
        
        cnt+= r;
        
    } while (cnt < len);

    return cnt;

}
