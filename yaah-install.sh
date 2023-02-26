#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
## install script
# to do : -similar improvements as the ones listed in the update script
#         -prompt the user for cleaning if the package couldn't have been installed
#         -handle the possibly uninstalled packages (e.g. due to ^C)
#          --> use a local repository rather than using a "gitpath"
#         -if no search match for is found by name, prompt the user to change the pattern
#         -more specific help for scenarios such as the one in line 39
#         -put an [installed] after the search result if the package has already been installed with yaah
#         -prompt the user to know if he wants to use a pager and maybe add a configuration option always enable or disable the pager or prompt the user every time
#         -implement the starts-with search option
#         -also implement a package lookup option

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
    # format the results and put them in a variable
    pkgnb=$(echo -e "$result" | grep '"resultcount":' | cut -d "\"" -f3 | sed "s/[,:]//g")
    error=$(echo -e "$result" | grep \{\"error | cut -d "\"" -f4)
    names=$(echo -e "$result" | grep '"Name":"' | cut -d "\"" -f4)
    descs=$(echo -e "$result" | grep '"Description":' | sed -e 's/"Description":null/"Description":"No description provided"/g'| cut -d "\"" -f5)
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
        echo -e "The package search query returned an error : $error"
        # and prompt for using a different search pattern if there are too much results
        if [[ $error = "Too many package results." ]] && [[ $SearchPattern != name ]];then
            printmsg -ne "Try again, only searching by name ? [Y/n] "
            read yn
            if [[ ${yn,,} = y ]] || [[ -z ${yn} ]]; then
                search --pattern=name $1
            fi
        fi
        exit 2
    fi

    ## Display search results
    
    # suggérer un autre pattern de recherche si aucun résultat trouvé
    if [[ $SearchPattern -ne name && $pkgnb -eq 0 ]];then
        echo -n "Réessayer la recherche sur les descriptions en plus des noms ? [O/n]"
        read yn
        if [[ ${yn,,} = y ]] || [[ -z ${yn} ]]; then
            search --pattern=name $1
        fi
        exit 2
    fi
    if [[ $((2 * pkgnb)) -ge $(tput lines) ]];then
        { printmsg -e "Nombre de paquets trouvés : $pkgnb\n"; 
        for i in $(seq 0 $(($pkgnb - 1)));do
            echo -ne "\033[1m"
            echo -n "${namesa[$i]}"
            echo -ne "\033[32m"
            echo " ${versa[$i]}"
            echo -ne "\033[0m"
            echo -e "    ${descsa[$i]}"
        done } | less -R
    else
        printmsg -e "Nombre de paquets trouvés : $pkgnb\n"
        for i in $(seq 0 $(($pkgnb - 1)));do
            echo -ne "\033[1m"
            echo -n "${namesa[$i]}"
            echo -ne "\033[32m"
            echo " ${versa[$i]}"
            echo -ne "\033[0m"
            echo -e "    ${descsa[$i]}"
        done
    fi
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
if [[ $nbni -ne 0 ]]; then
    if [[ $nbni -eq 1 ]]; then
        echo -n "$nbni paquet devait être installé : "
        cat pkgni.tmp
        printf "\n"
    else
        echo -n "$nbni paquets auraient du être installés : "
        for i in $(cat pkgni.tmp);do
            echo -n "$i "
        done
        printf "\n"
    fi
    #clean pgkni.tmp --> to implement
fi

if [[ -e pkg.tmp ]];then
    rm pkg.tmp
fi
if [[ -e pkgni.tmp ]];then
    rm pkgni.tmp
fi
