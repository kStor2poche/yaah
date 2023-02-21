#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
# to do : -Query the database for installed packages
#         -an install/update script that maybe doesn't rely on makepkg or at least not in the way it currently does
#          -> use curl with the aur rpc interface : https://aur.archlinux.org/rpc/swagger
#         -move every script into one single big script
#         -make a function for switch handling ?
#         -make a (print and - maybe not, for even the tty supports colors -) printcolor function for pacman-like string formatting (cf line 39 of yaah-install.sh) (could export it with export -f )
#         -search a way to implement locales (or just write everything in enlish)

# global script variables
export GITPATH=$(cat /usr/local/etc/yaah/gitpath)
export SearchPattern=name-desc # to change to something put in the config file

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
        "-s")
            yaah-install $@;;
        "-r")
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
