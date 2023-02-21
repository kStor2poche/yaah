#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
## install script
# to do : -similar improvements as the ones listed in the update script
#         -prompt the user for cleaning if the package couldn't have been installed
#         -handle the possibly uninstalled packages (e.g. due to ^C)
#         -if no search match for is found by name, prompt the user to change the pattern
#         -handle cases where Description is null (e.g. for firefox_remove_ctrl_q) so that it doesn't shift everything
#         -more specific help for scenarios such as the one in line 39
#         -use a pager (maybe less, though coloring'll have to be done on stderr) to display the package search result if it's longer than the terminal height
#         -target the 'too much packages' error in a better way


if [[ -z $GITPATH ]]; then
    echo -e "Error : Please use command yaah -s and not yaah-install\n"
    yaah-help
    exit 1
fi

# search option

search() {
    # check for a forced search pattern, and apply it to the search mechanism
    if [[ ${1::2} == "--" ]]; then
        tmpswitch=${1:2}
        IFSbak=$IFS
        IFS=$"="
        read -r switch subswitch <<< "$tmpswitch"
        IFS=$IFSbak
        shift
        if [[ $switch != pattern ]]; then
            echo "option \"$switch\" inconnue"
            yaah-help
            exit 1
        fi
        if [[ ! $subswitch =~ ^(name|name-desc|keywords|conflicts|provides)$ ]]; then
            echo -e "Error : please give a valid search pattern for the search function to use\n"
            yaah-help # have a switch to get specific help
            exit 1
        fi
        SearchPattern=$subswitch
    fi
    if [[ -n $2 ]]; then
        echo "Search terms after $1 were ignored, expressions containing a space should be quoted."
    fi

    # fetch the search
    result=$(curl -X 'GET' \
       "https://aur.archlinux.org/rpc/v5/search/$1?by=$SearchPattern" \
       -H 'accept: application/json' 2>/dev/null | sed -r -e "s/(\[|,\"|,\{)/,\n\"/g")
    echo -e "$result"
    # format the results and put them in a variable
    pkgnb=$(echo -e "$result" | grep '"resultcount":' | cut -d "\"" -f3 | sed "s/[,:]//g")
    error=$(echo -e "$result" | grep \{\"error | cut -d "\"" -f4)
    names=$(echo -e "$result" | grep '"Name":"' | cut -d "\"" -f4)
    descs=$(echo -e "$result" | grep '"Description":"' | cut -d "\"" -f5)
    vers=$(echo -e "$result" | grep '"Version":"' | cut -d "\"" -f4)
    # IFS trickery
    IFSbak=$IFS # IFS backup
    IFS=$'\n' # use \n as the IFS for putting the variables in an array
    namesa=($names)
    descsa=($descs)
    versa=($vers)
    IFS=$IFSbak # restore IFS

    # watch for errors from the aur api response
    if [[ -n $error ]]; then
        echo -e "La recherche à retourné une erreur : $error\n\n"
        if [[ $pkgnb -ne 0 ]] && [[ $SearchPattern != name ]];then
            echo -e "\033[1;34m::\033[0m \033[1mRetenter une recherche uniquement sur le nom ? [O/n] \033[0m"
            read yn
            if [[ ${yn,,} = y ]]; then
                search --pattern=name-desc $1
            fi
        fi
        exit 2
    fi

    ## Affichage
    
    echo -e "\033[1;34m::\033[0m \033[1mNombre de paquets trouvés : $pkgnb\033[0m\n"
    # suggérer un autre pattern de recherche si aucun de résultat trouvé
    if [[ $SearchPattern -ne name && $pkgnb -eq 0 ]];then
        echo -n "Réessayer la recherche sur les descriptions en plus des noms ? [O/n]"
        read yn
        if [[ ${yn,,} = y ]]; then
            search --pattern=name $1
        fi
        exit 2
    fi
    for i in $(seq 0 $(($pkgnb - 1)));do
        echo -ne "\033[1m${namesa[$i]}"
        echo -e "\033[32m ${versa[$i]}\033[0m"
        echo -e "    ${descsa[$i]}"
    done
}

if [[ ${1::1} == - ]]; then
    switch=${1:1:2}
    subswitch=${1:2}
    shift
    if [[ -n $subswitch ]]; then
        echo -e "Error : switch too long, due to $subswitch\n"
        yaah-help
    fi
fi

if [[ $switch == s ]]; then
    search $@
    exit 0
fi

# install part of the script

cd ${GITPATH}
nbi=0  # number of successfully installed packages
nbni=0 # number of packages that could not be installed
if [[ -z $1 ]]; then
    echo -e "Error : Please give at least one package to install\n"
    yaah-help
fi

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
if [[ $nbi -eq 0 ]]; then
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
    echo -n "$nbni paquet devait être installé : "
    cat pkgni.tmp
    printf "\n"
elif [[ $nbni -ne 0 ]]; then
    echo -n "$nbni paquets auraient du être installés : "
    for i in $(cat pkgni.tmp);do
        echo -n "$i "
    done
    printf "\n"
fi

if [[ -e pkg.tmp ]];then
    rm pkg.tmp
fi
if [[ -e pkgni.tmp ]];then
    rm pkgni.tmp
fi
