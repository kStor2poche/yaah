#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
## help script
# to do : -not much
#         -list all the possible search options

if [[ -z $1 ]];then
    echo -e "\e[3mYAAH - YET ANOTHER AUR HELPER\e[0m\n"
    echo -e "Usage : yaah [ -u | -S[s] | -r[s] | -g[e] ] [package names]\n"
    echo "Switches : -s -> install packages
           -ss -> search for packages
           -u -> update packages and install the ones provided in the rest of the command
           -r -> remove packages
           -g -> change the \$GITPATH variable, which contains the path to the package installation folders
           -ge -> print \$GITPATH
           -h -> show this help"
    exit 0
fi
