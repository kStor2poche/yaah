#! /bin/bash
## YAAH - YET ANOTHER AUR HELPER
## help script
# to do : -not much

if [[ -z $1 ]];then
    echo -e "\e[3mYAAH - YET ANOTHER AUR HELPER\e[0m\n"
    echo -e "Usage : yaah [-u | -s | -r[s]] [package name]\n"
    echo "Switches : -h -> show this help
           -s -> intall a package
           -u -> update your packages and install the ones provided in the rest of the command
           -r -> remove as in uninstall packages"
    exit 0
fi
