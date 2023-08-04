#!/usr/local/bin/bash

if [[ ! -v __INCLUDE_COLOR_SH__ ]]; then __INCLUDE_COLOR_SH__=true

###############################################################################
# This exports an assoc array COLOR.
###############################################################################

declare -A COLOR
COLOR[r]="\033[0;31m"
COLOR[R]="\033[1;31m"
COLOR[g]="\033[0;32m"
COLOR[G]="\033[1;32m"
COLOR[y]="\033[0;33m"
COLOR[Y]="\033[1;33m"
COLOR[w]="\033[0m"
COLOR[W]="\033[1;37m"

fi
