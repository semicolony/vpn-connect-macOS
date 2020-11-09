#!/bin/bash

if [[ ! -v __INCLUDE_TUNNEL_SH__ ]]; then __INCLUDE_TUNNEL_SH__=true
###############################################################################
# This renders the help screen containing synopsis etc.                       #
###############################################################################

source ./echo.sh

function tunnel::open {
    local -n tunnel_open_config=$1

    [[ ${tunnel_open_config[2fa-append]+exists} ]] && [[ ${tunnel_open_config[2fa-append]} == yes ]] && \
    [[ ${tunnel_open_config[password]+exists} ]] && [[ ${tunnel_open_config[password]} ]] && \
        tunnel_open_config[password]="${tunnel_open_config[password]}$(tunnel::read_token)"

    tunnel::${tunnel_open_config[client]} tunnel_open_config
}

function tunnel::openconnect {
    local -n tunnel_openconnect_config=$1
    local additional_args=

    [[ ${tunnel_openconnect_config[authgroup]+exists} ]] && [[ ${tunnel_openconnect_config[authgroup]} ]] && \
        additional_args="$additional_args --authgroup ${tunnel_openconnect_config[authgroup]}"

    if [[ ${tunnel_open_config[password]+exists} ]] && [[ ${tunnel_open_config[password]} ]]; then
        echo ${tunnel_openconnect_config[password]} | \
            openconnect -b -u ${tunnel_openconnect_config[username]} --passwd-on-stdin $additional_args ${tunnel_openconnect_config[uri]}
    else
        openconnect -b -u ${tunnel_openconnect_config[username]} $additional_args ${tunnel_openconnect_config[uri]}
    fi

}

function tunnel::read_token {
    echo::question "Token: " "Interactive terminal needed."
    read token
    echo $token
}

fi
