#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
# to do : -Query the database for installed packages
#         -an install/update script that maybe doesn't rely on makepkg or at least not in the way it currently does
#         -a switch to edit $GITPATH
#         -a switch to get help
#         -move every script into one single big script

export GITPATH="/home/laio/Documents/Git\!/"

if [[ -z $1 ]];then
    echo "Erreur : il faut fournir des arguments"
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
    *)
        echo "Erreur : option $switch inconnue"
        yaah-help;;
esac
