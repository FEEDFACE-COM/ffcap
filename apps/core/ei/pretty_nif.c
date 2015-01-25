
#include <string.h>
#include "erl_nif.h"


#include "fflog.h"


static ERL_NIF_TERM 
mac_address(ErlNifEnv *env, int argc, const ERL_NIF_TERM args[])
{
    ERL_NIF_TERM ret;
    ErlNifBinary in,out;
    
    if ( ! enif_inspect_binary(env, args[0],&in) )
        return enif_make_badarg(env);
    
    if (in.size != 6)
        return enif_make_badarg(env);
    
    const long max= 6*2 + 5; // xx:xx:xx:xx:xx:xx
    char str[max+1];
    
    int n = snprintf((char*)str,max+1,
        "%02X:%02X:%02X:%02X:%02X:%02X",
        in.data[0],in.data[1],in.data[2],
        in.data[3],in.data[4],in.data[5]
    );
    
    enif_alloc_binary((size_t)n,&out);
    strncpy((char*)out.data,str,n);
    
    ret= enif_make_binary(env, &out);
    enif_release_binary(&out);
    return ret;
}


static ERL_NIF_TERM
ip_address(ErlNifEnv *env, int argc, const ERL_NIF_TERM args[])
{
    ERL_NIF_TERM ret;
    ErlNifBinary in,out;
    
    if ( ! enif_inspect_binary(env, args[0],&in) )
        return enif_make_badarg(env);
    
    if (in.size != 4)
        return enif_make_badarg(env);
    
    const long max= 4*3 + 3; // xxx.xxx.xxx.xxx
    char str[max+1];
    
    int n = snprintf((char*)str,max+1,
        "%d.%d.%d.%d",
        in.data[0],in.data[1],in.data[2],in.data[3]
    );
    
    enif_alloc_binary((size_t)n,&out);
    strncpy((char*)out.data,str,n);
    
    ret= enif_make_binary(env, &out);
    enif_release_binary(&out);
    return ret;
}

static ErlNifFunc funcs[] = {
    {"mac_address", 1, mac_address},
    {"ip_address", 1, ip_address},
};

ERL_NIF_INIT(pretty,funcs, NULL, NULL, NULL, NULL);

