#!/bin/bash

if [[ ! -v __INCLUDE_ASSOC_SH__ ]]; then __INCLUDE_ASSOC_SH__=true
###############################################################################
# Helper functions to work with assoc arrays.                                 #
###############################################################################

function assoc::get {
    local -n assoc__get=$1
    local key=$2

    if [[ ${assoc__get[$key]+exists} ]]; then
        echo -n ${assoc__get[$key]}
    else
        echo -n ""
    fi
}

fi
