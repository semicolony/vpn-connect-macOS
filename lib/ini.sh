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
    local section= key= val= line=

    while IFS= read -r line
    do
        if [[ ${line:0:1} == "#" ]]; then
            continue; # comment
        elif [[ $line == \[*] ]]; then
            section=$(echo ${line:1:-1} | tr -d "[:blank:]")
            ini_parse_file_result_sections[$i]=$section
            ((i++))
        else
            key=$(echo $line | cut -d = -f 1 | tr -d "[:blank:]")
            if [[ -z $key ]]; then
                continue; # empty line
            fi
            val=$(echo $line | sed 's/^[^=]*=//' | tr -d "[:blank:]")
            if [[ ! -z $section ]]; then
                key="$section,$key";
            fi
            ini_parse_file_result_all[$key]=$val
        fi
    done < $ini_file
}

##
# Creates and echos the file contents from an associative array as returned
# from ini::parse_file.
##
function ini::create_file {
    local -n ini_create_file_assoc=$1
    local section= key=

    for key in "${!ini_create_file_assoc[@]}"; do
        [[ "${key/,*/}" != "$section" ]] && \
            section=${key/,*/} && \
            echo "[$section]"
        echo ${key/*,/}=${ini_create_file_assoc[$key]}
    done
}

fi

