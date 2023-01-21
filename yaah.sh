#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
# to do : -Query the database for installed packages
#         -an install/update script that maybe doesn't rely on makepkg or at least not in the way it currently does
#         -a switch to edit $GITPATH
#         -a switch to get help
#         -move every script into one single big script

export GITPATH="/home/laio/Documents/Git\!/"

if [[ $1 = "-u" ]];then
    shift
    yaah-update
    #yaah-install $@        not implemented yet
    exit 0
elif [[ -z $1 ]];then
    echo "Erreur : il faut fournir des arguments"
    exit 1
else
    echo "Erreur : option non valide"
    exit 1
fi
