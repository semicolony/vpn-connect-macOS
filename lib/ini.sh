#!/bin/bash

if [[ ! -v __INCLUDE_INI_SH__ ]]; then __INCLUDE_INI_SH__=true
###############################################################################
# Functions to parse and write ini files.                                     #
###############################################################################

source ./string.sh

##
# Parses an ini file and fills an numeric array with the found section names
# and an associative array with the complete config, where key is
# "$section,$var".
#
# Example:
#
# key=but no section
#
# [cool]
# i=like
# love=100
#
# Would fill the first passed array with ([0]="cool") and the second passed
# array with ([key]="but no section" [cool,i]="like" [cool,love]=100).
#
# The third parameter is expected to contain the filename of the ini file to
# parse.
##
function ini::parse_file {
    local -n ini_parse_file_result_sections=$1
    local -n ini_parse_file_result_all=$2
    local -r ini_file=$3
    local section='' key='' val='' line='' i=0

    while IFS= read -r line
    do
        if ini::_parser_is_comment "$line"; then
            continue;
        fi

        line="$(string::trim "$line")"

        if ini::_parse_is_empty "$line"; then
            continue;
        fi

        if ini::_parser_is_section "$line"; then
            section="$(string::trim "${line:1:-1}")"
            ini_parse_file_result_sections[$i]=$section
            ((i++))
            continue;
        fi

        if ini::_parser_is_key_value_pair "$line"; then
            key=$(echo "$line" | cut -d = -f 1)
            val=$(echo "$line" | sed 's/^[^=]*=//')
        else
            key=$(echo "$line")
            val=
        fi

        key="$(string::trim "$key")"
        val="$(string::trim "$val")"

        if [[ -n $section ]]; then
            key="$section,$key";
        fi
        ini_parse_file_result_all[$key]=$val
    done < "$ini_file"
}

function ini::_parser_is_comment {
    [[ ${1:0:1} == "#" ]]
}

function ini::_parser_is_section {
    [[ "$1" == '['*']' ]]
}

function ini::_parser_is_key_value_pair {
    [[ $1 == *'='* ]]
}

function ini::_parse_is_empty {
    [[ -z $1 ]]
}

##
# Extracts a section from the given config array.
#
# $1 Reference paramter. Contains the result as associativ array.
# $2 Pass the associative config array here as you've received it from
#    ini::parse_file, i.e. [$section,$key]=$value
# $3 The section to extract.
##
function ini::extract_section {
    local -n ini_extract_sections_result=$1 config=$2
    local section=$3 key_section_pair

    found=false
    for key_section_pair in "${!config[@]}"; do
        [[ "${key_section_pair/,*/}" == "$section" ]] && \
            ini_extract_sections_result[${key_section_pair/*,/}]=${config[$key_section_pair]} && \
            found=true
    done
    $found || return 1
}

##
# Creates and echos the file contents from an associative array as returned
# from ini::parse_file.
##
function ini::create_file {
    local -n ini_create_file_assoc=$1
    local section='' key=''

    for key in "${!ini_create_file_assoc[@]}"; do
        [[ "${key/,*/}" != "$section" ]] && \
            section=${key/,*/} && \
            echo "[$section]"
        echo "${key/*,/}=${ini_create_file_assoc[$key]}"
    done
}

fi

