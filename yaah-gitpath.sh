#! /bin/sh
## YAAH - YET ANOTHER AUR HELPER
## gitpath change script
# to do : -react on whether or not user is logged as root
#         -use different directories depending on whether or not the script has been installed through locinstall.sh or not
#         -format paths correctly (with a / at the end, whether or not the user has typed it)

if [[ -z $1 ]];then
    echo "Erreur : il faut fournir le chemin souhaité pour entreposer les paquets de l\'AUR"
    exit 1
fi

echo -n "$1" > /usr/local/etc/yaah/gitpath

if [[ $? != 0 ]];then
    echo "Could not overwrite gitpath, please run command as root"
fi
