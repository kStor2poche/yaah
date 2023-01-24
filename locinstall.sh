#! /bin/bash

for i in yaah*;do
    sudo cp $i /usr/local/bin/${i/.sh}
    echo /usr/local/bin/${i/.sh}
done
if [[ ! -e /usr/local/etc/yaah/gitpath ]];then
    sudo mkdir /usr/local/etc/yaah/
    sudo mkdir /usr/local/share/yaah/
    sudo sh -c "echo -n /usr/local/share/yaah/ > /usr/local/etc/yaah/gitpath"
    exit
fi
