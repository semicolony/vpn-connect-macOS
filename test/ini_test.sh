#!/bin/bash

# This will be overridden in oneTimeSetUp().
MOCK_INI_FILE=''

function testParseFile() {
    local -a expected_sections=("cool" "muh" "asd")
    local -A expected_all=([no]="section" [cool,i]="like it" [cool,love]="100" [muh,boing]="")
    local -a result_sections
    local -A result_all

    ini::parse_file result_sections result_all "${MOCK_INI_FILE}"

    assertArrayEquals \
        expected_sections \
        result_sections

    assertArrayEquals \
        expected_all \
        result_all

}

function testExtractSection() {
    local -A assoc_ini=([cool,i]="like it" [cool,love]="" [muh,boing]="lala")

    declare -A result
    declare -A expected_result=([i]="like it" [love]=)

    ini::extract_section result assoc_ini "cool"

    assertArrayEquals \
        expected_result \
        result
}

function assertArrayEquals() {
    local -n assertArrayEqualsExpected=$1
    local -n assertArrayEqualsResult=$2

    assertEquals \
        "The length of two arrays are different." \
        ${#assertArrayEqualsExpected[@]} \
        ${#assertArrayEqualsResult[@]}

    for i in "${!assertArrayEqualsExpected[@]}"; do
        assertEquals \
            "A value is different for key $i." \
            "${assertArrayEqualsExpected[$i]}" \
            "${assertArrayEqualsResult[$i]}"
    done
}

function _createMockIniFile {
    MOCK_INI_FILE="${SHUNIT_TMPDIR}/test.ini"
    cat <<EOF >"${MOCK_INI_FILE}"
no=section
[  cool  ]
  i =  like it

 love=100

 [muh]
boing

[asd]
EOF
}

function oneTimeSetUp {
    _createMockIniFile
    pushd ../lib >/dev/null
    source ./ini.sh
    popd >/dev/null
}

source $(which shunit2)
