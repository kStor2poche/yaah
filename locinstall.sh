#! /bin/bash

for i in yaah*;do
    sudo cp $i /usr/local/bin/${i/.sh}
    echo /usr/local/bin/${i/.sh}
done
