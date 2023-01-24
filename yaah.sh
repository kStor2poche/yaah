#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
# to do : -Query the database for installed packages
#         -an install/update script that maybe doesn't rely on makepkg or at least not in the way it currently does
#         -a switch to get help
#         -move every script into one single big script

export GITPATH=$(cat /usr/local/etc/yaah/gitpath)
#"/home/laio/Documents/Git\!/"

if [[ -z $1 ]];then
    echo -e "Erreur : il faut fournir des arguments\n"
    yaah-help
    exit 1
fi

switch=$1
shift

case $switch in
    "-u")
        yaah-update;;
    "-s")
        yaah-install $@;;
    "-r")
        yaah-remove $@;;
    "-rs")
        yaah-remove -s $@;;
    "-g")
        yaah-gitpath $@;;
    "-ge")
        yaah-gitpath -e $@;;
    "-h")
        yaah-help;;
    *)
        echo -e "Erreur : option $switch inconnue\n"
        yaah-help;;
esac
