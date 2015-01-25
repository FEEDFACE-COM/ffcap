-module(pretty).
-export([mac_address/1,ip_address/1]).
-on_load(init/0).

init() ->
    ok = erlang:load_nif("./pretty_nif",0).
    
mac_address(_X) ->
    exit(nif_library_not_loaded).


ip_address(_X) ->
    exit(nif_library_not_loaded).
    

