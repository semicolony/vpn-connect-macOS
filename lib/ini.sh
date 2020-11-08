#!/bin/bash

if [[ ! -v __INCLUDE_INI_SH__ ]]; then __INCLUDE_INI_SH__=true
###############################################################################
# Functions to parse and write ini files.                                     #
###############################################################################

##
# Parses an ini file and fills an numeric array with the found section names
# and an associative array with the complete config, where key is
# "$section,$var".
#
# Example:
# [cool]
# i=like
# love=100
#
# Would fill the first passed array with ([0]="cool") and the second passed
# array with ([cool,i]="like" [cool,love]=100).
#
# The third parameter is expected to contain the filename of the ini file to
# parse.
##
function ini::parse_file {
    local -n ini_parse_file_result_sections=$1
    local -n ini_parse_file_result_all=$2
    local -r ini_file=$3
    local section= key= var= val= i=0

    while IFS='= ' read var val
    do
        if [[ $var == \[*] ]]; then
            section=${var:1:-1}
            ini_parse_file_result_sections[$i]=$section
            ((i++))
        elif [[ $var ]]; then
            if [[ -z $section ]]; then
                key="$var";
            else
                key="$section,$var";
            fi
            ini_parse_file_result_all[$key]=$val
        fi
    done < $ini_file
}

fi

