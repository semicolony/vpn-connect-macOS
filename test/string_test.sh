#!/usr/local/bin/bash

function testTrim() {
    assertEquals \
        "Should trim boing on both sides." \
        "boing" \
        "$(string::trim "    boing   ")"
}

function testLtrim() {
    assertEquals \
        "Should trim boing on the left." \
        "boing   " \
        "$(string::ltrim "    boing   ")"
}

function testRtrim() {
    assertEquals \
        "Should trim boing on the right" \
        "    boing" \
        "$(string::rtrim "    boing   ")"
}

function oneTimeSetUp {
    pushd ../lib >/dev/null
    source ./string.sh
    popd >/dev/null
}

source $(which shunit2)
