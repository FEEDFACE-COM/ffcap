#!/bin/bash

NAME=c${PPID}@$(hostname -s)


if [ $# == 1 ]; then
    REGISTRY=$1
    ARGS="'-i lo0 -f icmp'"
elif [ $# > 1 ]; then
    REGISTRY=$1
    shift
    ARGS=$@
    
else
    echo bash ./run/capture.sh reg@cacodemon "-i lo0 -f icmp"
    exit -1
fi

iex \
    --sname ${NAME} \
     -S mix \
     run \
     --no-start \
     --eval "Core.Capture.start_link :'${REGISTRY}', '$ARGS'"
     



    
