#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
## gitpath change script
# to do : -use different directories depending on whether or not the script has been installed through locinstall.sh or not

if [[ -z $1 ]];then
    echo -e "Erreur : il faut fournir le chemin souhaité pour entreposer les paquets de l'AUR\n"
    yaah-help
    exit 1
fi

switch=${1:1:1}
subswitch=${1:2}

if [[ $switch = "e" ]];then
    echo -n "gitpath : "
    cat /usr/local/etc/yaah/gitpath
    printf "\n"
    exit 0
else
    write_success=$(echo -n "$(readlink -f "$1")/" > /usr/local/etc/yaah/gitpath)
fi

if [[ $write_success != 0 ]];then
    echo "Could not overwrite gitpath, please run command as root"
    exit 2
fi
