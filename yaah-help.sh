#! /bin/sh
## YAAH - YET ANOTHER AUR HELPER
## help script
# to do : -not much

if [[ -z $1 ]];then
    echo -e "\e[3mYAAH - YET ANOTHER AUR HELPER\e[0m\n"
    echo -e "Usage : yaah [-u | -s | -r[s]] [package name]\n"
    echo "Switches : -s -> intall
           -u -> update
           -r -> remove"
    exit 0
fi
