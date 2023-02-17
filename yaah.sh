#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
# to do : -Query the database for installed packages
#         -an install/update script that maybe doesn't rely on makepkg or at least not in the way it currently does
#          -> use curl with the aur rpc interface : https://aur.archlinux.org/rpc/swagger
#         -move every script into one single big script

export GITPATH=$(cat /usr/local/etc/yaah/gitpath)

if [[ -z $1 ]];then
    echo -e "Erreur : il faut fournir des arguments\n"
    yaah-help
    exit 1
fi

switch=${1::2}
subswitch=${1:2}
shift

if [[ -z $subswitch ]]; then
    case $switch in
        "-u")
            yaah-update;;
        "-S")
            yaah-install $@;;
        "-R")
            yaah-remove $@;;
        "-g")
            yaah-gitpath $@;;
        "-h" | "--help")
            yaah-help;;
        *)
            echo -e "Erreur : option $switch inconnue\n"
            yaah-help;;
    esac
else
    case $switch in
        "-u")
            yaah-update;;
        "-s")
            yaah-install -$subswitch $@;;
        "-r")
            yaah-remove -$subswitch $@;;
        "-g")
            yaah-gitpath -$subswitch $@;;
        "-h" | "--help")
            yaah-help;;
        *)
            echo -e "Erreur : option $switch inconnue\n"
            yaah-help;;
    esac
fi
