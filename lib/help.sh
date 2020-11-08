#!/bin/bash

if [[ ! -v __INCLUDE_HELP_SH__ ]]; then __INCLUDE_HELP_SH__=true

###############################################################################
# This renders the help screen containing synopsis etc.                       #
###############################################################################

source ./color.sh
source ./echo.sh
##
# Shows the usage of this script.
##
function help::show {
    local -r w=${COLOR[w]}
    local -r W=${COLOR[W]}
    [[ $# -gt 0 ]] && echo::error "$@" && echo

    echo -e "${W}Usage:$w $BASENAME DESTINATION"
    echo

    if [[ ${#CONFIGSECTIONS[@]} -eq 0 ]]; then
        echo::error "No destinations configured."
    else
        echo -en "where ${W}DESTINATION$w is one of "
        help::create_destination_list
        echo
    fi
}

function help::create_destination_list {
    echo -n "'$CONFIGSECTIONS'"
    local i=1 n=
    ((n=${#CONFIGSECTIONS[@]}-1))
    while [[ $i -lt $n ]]; do
        echo -n ", '${CONFIGSECTIONS[$i]}'"
        ((i++))
    done
    if [[ $i -lt ${#CONFIGSECTIONS[@]} ]]; then
        echo -n " or '${CONFIGSECTIONS[$i]}'"
    fi
}

fi
