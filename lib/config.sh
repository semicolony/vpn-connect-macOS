#!/usr/local/bin/bash

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

    config::check_file_security "$conf_file" || return 1
    ini::parse_file config_load_result_sections config_load_result_all "$conf_file"
    config::validate config_load_result_all

}

function config::check_file_security {
    local -r filename=$1
<<<<<<< HEAD
    [[ "$(stat -c %A "$1")" != "-rw-------" ]] && \
        echo::error "$1 must have file mode -rw-------." && \
=======
    [[ "$(stat -f %OLp "$1")" != "600" ]] && \
        echo::error "$1 must have file mode 0600 -rw-------." && \
>>>>>>> bc04b7e (Init commit for the macOS - onepassword spoon)
        return 1
    return 0
}

function config::validate {
    local -n config_validate_config config_validate_sections

    # FIXME add validation
    return 0
}

fi
