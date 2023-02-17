#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
## install script
# to do : -a search option
#         -similar improvements as the ones listed in the update script


if [[ -z $GITPATH ]]; then
    echo -e "Error : Please use command yaah -s and not yaah-install\n"
    yaah-help
    exit 1
fi
nbi=0  # number of successfully installed packages
nbni=0 # number of packages that could not be installed

#
# for a future search option
#
#if [[ "-" -eq ${1::1} ]]; then
#    $switch=${1::2}
#    $subswitch=${1:2}
#    shift
#    if [[ ! -z $subswitch ]]; then
#        echo -e "Error : switch too long, please remove $subswitch\n"
#        yaah-help
#    fi
#fi

if [[ -z $1 ]]; then
    echo -e "Error : Please give at least one package to install\n"
    yaah-help
fi

cd ${GITPATH}
# cycle through the packages found in $@ and install them
for i in ${@}; do
    git clone "https://aur.archlinux.org/$i.git"
    cd $i
    makepkg -si
    if [[ $? -eq 0 ]]; then
        nbi=$(( $nbi + 1 ))
        echo -n "$i " > ../pkg.tmp
    else
        nbni=$(( $nbni + 1 ))
        echo -n "$i " > ../pkgni.tmp
    fi
    cd ..
done

# "pretty" text display
printf "\n"
if [[ $(( nbi + nbni )) -eq 0 ]]; then
    echo "YAAH - Aucun paquet n'a été installé"
elif [[ $nbi -eq 1 ]]; then
    echo -n "YAAH - $nbi paquet a été installé : "
    cat pkg.tmp
    printf "\n"
else
    echo -n "YAAH - $nbi paquets ont été installés : "
    for i in $(cat pkg.tmp);do
        echo -n "$i "
    done
    printf "\n"
fi
if [[ $nbni -eq 1 ]]; then
    echo -n "et $nbni paquet n'a été installé : "
    cat pkgni.tmp
    printf "\n"
elif [[ $nbni -ne 0 ]]; then
    echo -n "et $nbni paquets n'ont pas été installés : "
    for i in $(cat pkgni.tmp);do
        echo -n "$i "
    done
    printf "\n"
fi

if [[ -e ../pkg.tmp ]];then
    rm ../pkg.tmp
fi
if [[ -e ../pkgni.tmp ]];then
    rm ../pkgni.tmp
fi
