#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
## update script
# to do : -know how much the update weighs/needs to be downloaded 
#         -prompt user before dls
#         -clean older versions of packages or at least have a flag to do it
#         -recognize which packages have been updated in a better way than just
#          checking for the result of git pull
#         -keep a list a packages that failed to install to try and reinstall
#          them in the next run of yaah -u

if [[ -z $GITPATH ]]; then
    echo -e "Error : Please use command yaah -u and not yaah-update\n"
    yaah-help
    exit 1
fi
nbu=0

# cycle through the packages found in $GITPATH
for i in ${GITPATH}*;do
    if [[ -d $i ]];then
        cd $i
        pkg=$(echo $i | cut -d "/" -f "6")
        git fetch --dry-run 2> ../fetch.tmp
        ret=$?
        fetch=$(head -n1 ../fetch.tmp | cut -c1-6)
        if [[ $ret = 0 && -f PKGBUILD && -n $fetch ]];then
            git pull > /dev/null
            makepkg -si    ## à update
            if [[ $? -eq 0 ]];then
                echo -n "$pkg " >> ../pkg.tmp
                nbu=$(( $nbu + 1 ))
            fi
        fi
    fi
done

# "pretty" text display
if [[ $nbu -eq 0 ]]; then
    echo "YAAH - Aucun paquet n'a été mis à jour"
elif [[ $nbu -eq 1 ]]; then
    echo -n "YAAH - $nbu paquet a été mis à jour : "
    cat ../pkg.tmp
    printf "\n"
else
    echo -n "YAAH - $nbu paquets ont été mis à jour : "
    for i in $(cat ../pkg.tmp);do
        echo -n "$i "
    done
    printf "\n"
fi

rm ../fetch.tmp
if [[ -e ../pkg.tmp ]];then
    rm ../pkg.tmp
fi
