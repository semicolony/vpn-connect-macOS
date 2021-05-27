#!/bin/bash

function testAssocGet() {
    declare -A ASSOC=([a]="value A" [c]="")

    local valueA="$(assoc::get ASSOC a)"

    assertEquals \
        "The result of assoc::get for existing key was wrong."  \
        "value A" \
        "$valueA"

    local valueB="$(assoc::get ASSOC b)"

    assertEquals \
        "The result of assoc::get for non existing key was wrong."  \
        "" \
        "$valueB"

    local valueC="$(assoc::get ASSOC c)"

    assertEquals \
        "The result of assoc::get for existing key with empty value was wrong."  \
        "" \
        "$valueC"
}

function oneTimeSetUp() {
    source ../lib/assoc.sh
}

source $(which shunit2)
