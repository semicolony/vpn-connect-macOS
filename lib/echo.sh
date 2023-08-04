#!/usr/loca/bin/bash

if [[ ! -v __INCLUDE_ECHO_SH__ ]]; then __INCLUDE_ECHO_SH__=true

###############################################################################
# This exports many functions to create pretty output more easily.            #
# Colors are used, if and only if a terminal is present. Therefore            #
# redirections to files and pipes work as expected.                           #
###############################################################################

source ./color.sh

##
# Echos an error messages.
#
# $1 expected to contain the message
##
function echo::error() {
    if [[ $1 == "-n" ]]; then
        opts="en"
        shift 1
    else
        opts="e"
    fi
    declare msg=$@
    if [[ -t 2 ]]
    then
        (>&2 echo -$opts ${COLOR[r]}$msg${COLOR[w]})
    else
        (>&2 echo -$opts $msg)
    fi
}

##
# Echos a success message
#
# $1 expected to contain the message
##
function echo::success() {
    if [[ $1 == "-n" ]]; then
        opts="en"
        shift 1
    else
        opts="e"
    fi
    declare msg=$@
    if [[ -t 1 ]]
    then
        echo -$opts ${COLOR[g]}$msg${COLOR[w]}
    else
        echo -$opts $msg
    fi
}

##
# Echos a notification
#
# $1 expected to contain the message
##
function echo::notice() {
    if [[ $1 == "-n" ]]; then
        opts="en"
        shift 1
    else
        opts="e"
    fi
    declare msg=$@
    if [[ -t 2 ]]
    then
        (>&2 echo -$opts ${COLOR[y]}$msg${COLOR[w]})
    else
        (>&2 echo -$opts $msg)
    fi
}

##
# Echos a question
#
# $1 expected to contain the question to ask.
# $2 expected to contain the error message to echo, if stderr is no interactive
#    terminal (and therefore answering is impossible).
#    If omitted empty, nothing happs in this case.
#
# Returns 1, if $2 was printed, 0 otherwise.
##
function echo::question() {
    declare msg=$1 errmsg=$2
    if [[ -t 2 ]]
    then
        (>&2 echo -ne ${COLOR[W]}$msg${COLOR[w]})
        return 0
    elif [[ -n $errmsg ]]
    then
        echo::error $errmsg
        return 1
    fi
}

fi
