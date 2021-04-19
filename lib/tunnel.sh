#!/bin/bash

if [[ ! -v __INCLUDE_TUNNEL_SH__ ]]; then __INCLUDE_TUNNEL_SH__=true
###############################################################################
# This renders the help screen containing synopsis etc.                       #
###############################################################################

source ./echo.sh

function tunnel::open {
    local -n tunnel_open_config=$1
    local -n tunnel_open_options=$2
    local additional_args=

    [[ ${tunnel_open_config[2fa-append]+exists} ]] && [[ ${tunnel_open_config[2fa-append]} == yes ]] && \
    [[ ${tunnel_open_config[password]+exists} ]] && [[ ${tunnel_open_config[password]} ]] && \
        tunnel_open_config[password]="${tunnel_open_config[password]}$(tunnel::read_token)"


    for key in "${!tunnel_open_config[@]}"; do
        case $key in
            2fa-append|password|client|username|uri)
                continue
                ;;
            *)
                additional_args="$additional_args --$key ${tunnel_open_config[$key]}"
        esac
    done

    [[ ${tunnel_open_config[client]+exists} ]] || return 1

    tunnel::${tunnel_open_config[client]} tunnel_open_config tunnel_open_options "$additional_args"
}

function tunnel::openconnect {
    local -n tunnel_openconnect_config=$1
    local -n tunnel_openconnect_options=$2
    local additional_args="$3"

    local cmd="openconnect "
    [[ ${tunnel_openconnect_options[background]+exists} && ${tunnel_openconnect_options[background]} ]] && \
        cmd="$cmd -b"

    cmd="$cmd -u ${tunnel_openconnect_config[username]}"

    [[ ${tunnel_open_config[password]+exists} && ${tunnel_open_config[password]} ]] && \
        cmd="echo ${tunnel_openconnect_config[password]} | $cmd --passwd-on-stdin"

    cmd="$cmd $additional_args ${tunnel_openconnect_config[uri]}"
    eval $cmd
}

function tunnel::openvpn {
    local -n tunnel_openvpn_config=$1
    local -n tunnel_openconnect_options=$2
    local additional_args="$3" password= username= file=

    [[ ${tunnel_openvpn_config[password]+exists} ]] && [[ ${tunnel_openvpn_config[password]} ]] && \
        password="${tunnel_openvpn_config[password]}"

    [[ ${tunnel_openvpn_config[username]+exists} ]] && [[ ${tunnel_openvpn_config[username]} ]] && \
        username="${tunnel_openvpn_config[username]}"

    [[ ${tunnel_openvpn_config[uri]+exists} ]] && [[ ${tunnel_openvpn_config[uri]} ]] && \
        additional_args="$additional_args --remote ${tunnel_openvpn_config[uri]}"

    [[ ${tunnel_openconnect_options[background]+exists} ]] && [[ ${tunnel_openconnect_options[background]} ]] && \
        additional_args="$additional_args --daemon"


    if [[ -n $username || -n $password ]]; then
        openvpn $additional_args --auth-user-pass <(echo -e "$username\n$password")
    else
        openvpn $additional_args
    fi


}

function tunnel::read_token {
    echo::question "Token: " "Interactive terminal needed."
    read token
    echo $token
}

fi
