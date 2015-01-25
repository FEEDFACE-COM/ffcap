#!/bin/bash

NAME=p${PPID}@$(hostname -s)


if [ $# == 1 ]; then
REGISTRY=$1

    iex \
        --sname ${NAME} \
         -S mix \
         run \
         --no-start \
         --config ./config/parser.exs \
         --eval "Core.Parser.start_link :'${REGISTRY}'"
     
else
    echo bash ./run/parser.sh reg@cacodemon
    exit -1
fi



    
