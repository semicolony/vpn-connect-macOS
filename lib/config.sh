#!/bin/bash

if [[ ! -v __INCLUDE_CONFIG_SH__ ]]; then __INCLUDE_CONFIG_SH__=true
###############################################################################
# Loads ands parses the config file                                           #
###############################################################################

source ./ini.sh
source ./echo.sh

function config::load {
    local -n config_load_result_sections=$1
    local -n config_load_result_all=$2
    local -r conf_file=$3

    config::check_file_security $conf_file || return 1
    ini::parse_file config_load_result_sections config_load_result_all $conf_file
    config::validate config_load_result_all

}

function config::extract_section {
    local -n config_extract_sections_result=$1 config=$2
    local section=$3 key

    for key in ${!config[@]}; do
        [[ "${key/,*/}" == "$section" ]] && \
            config_extract_sections_result[${key/*,/}]=${config[$key]}
    done

}

function config::check_file_security {
    local -r filename=$1
    [[ "$(stat -c %A "$1")" != "-rw-------" ]] && \
        echo::error "$1 must have file mode -rw-------." && \
        return 1
    return 0
}

function config::validate {
    local -n config_validate_config config_validate_sections

    # FIXME add validation
    return 0
}

fi
