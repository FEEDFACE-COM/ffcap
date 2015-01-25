#!/bin/bash

NAME=reg@$(hostname -s)


if [ $# != 0 ]; then
    echo bash ./run/core.sh 
    exit -1
fi

iex \
    --sname ${NAME} \
     -S mix \
     run \
     --config ./config/config.exs

     



    
