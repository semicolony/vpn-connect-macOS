#!/usr/loca/bin/bash

if [[ ! -v __INCLUDE_STRING_SH__ ]]; then __INCLUDE_STRING_SH__=true
###############################################################################
# String helper functions can be found here.                                  #
###############################################################################

function string::trim() {
    echo "$(string::ltrim "$(string::rtrim "$1")")"
}

function string::ltrim() {
    echo "${1#"${1%%[![:space:]]*}"}"
}

function string::rtrim() {
    echo "${1%"${1##*[![:space:]]}"}"
}

fi
