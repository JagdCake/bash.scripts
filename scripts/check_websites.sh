#!/bin/bash

websites=(https://modeling.jagdcake.com/ https://dreams.jagdcake.com/)

for i in ${websites[@]}
do
    status_code=$(curl -Is ${i} | head -n 1 | awk '{ print $2 }') 
    if [ $status_code -eq 200 ] 
        then
            echo -e "${i} ONLINE"
        else
            echo -e "${i} OFFLINE"
    fi
done

