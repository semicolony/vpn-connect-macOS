#!/bin/bash

if [[ ! -v __INCLUDE_TUNNEL_SH__ ]]; then __INCLUDE_TUNNEL_SH__=true
###############################################################################
# This renders the help screen containing synopsis etc.                       #
###############################################################################

source ./echo.sh
source ./assoc.sh

function tunnel::open {
    local -n tunnel_open_config=$1
    local -n tunnel_open_options=$2
    local additional_args=

    [[ "$(assoc::get "tunnel_open_config" "2fa-append")" == "yes" ]] && \
        [[ -n "$(assoc::get "tunnel_open_config" "password")" ]] && \

        tunnel_open_config[password]="${tunnel_open_config[password]}$(tunnel::_read_token)"


    for key in "${!tunnel_open_config[@]}"; do
        case $key in
            2fa-append|password|client|username|uri)
                continue
                ;;
            *)
                additional_args="$additional_args --$key $(assoc::get "tunnel_open_config" "$key")"
        esac
    done

    [[ -n "$(assoc::get "tunnel_open_config" "client")" ]] || return 1

    tunnel::_${tunnel_open_config[client]} \
        "$(assoc::get "tunnel_open_config" "username")" \
        "$(assoc::get "tunnel_open_config" "password")" \
        "$(assoc::get "tunnel_open_config" "uri")" \
        "$(assoc::get "tunnel_open_options" "background")" \
        "$additional_args"
}

function tunnel::_openconnect {
    local username="$1"
    local password="$2"
    local uri="$3"
    local background="$4"
    local additional_args="$5"

    local cmd="openconnect "
    [[ -n "$background" ]] && \
        cmd="$cmd -b"

    cmd="$cmd -u $username"

    [[ -n "$password" ]] && \
        cmd="echo $password | $cmd --passwd-on-stdin"

    cmd="$cmd $additional_args $uri"
    eval $cmd
}

function tunnel::_openvpn {
    local username="$1"
    local password="$2"
    local uri="$3"
    local background="$4"
    local additional_args="$5"

    [[ -n "$uri" ]] && \
        additional_args="$additional_args --remote $uri"

    [[ -n "$background" ]] && \
        additional_args="$additional_args --daemon"

    if [[ -n $username || -n $password ]]; then
        openvpn $additional_args --auth-user-pass <(echo -e "$username\n$password")
    else
        openvpn $additional_args
    fi
}

function tunnel::_read_token {
    echo::question "Token: " "Interactive terminal needed."
    read token
    echo $token
}

fi
