#!/bin/bash

# Export all variables and functions
set -a

RESULT_ENABLED=0
RESULT_DISABLED=102
RESULT_ERROR=103

function verify_command_exists {
    if [[ $1 =~ "/" ]]; then
        if ! [ -x "$1" ]; then
            exit $RESULT_DISABLED
        fi
    else
        if ! [ -x "$(command -v $1)" ]; then
            exit $RESULT_DISABLED
        fi
    fi
}

function verify_command_not_exists {
    if [[ $1 =~ "/" ]]; then
        if [ -x "$1" ]; then
            exit $RESULT_DISABLED
        fi
    else
        if [ -x "$(command -v $1)" ]; then
            exit $RESULT_DISABLED
        fi
    fi
}

function verify_file_exists {
    [[ -f "$1" ]] || exit $RESULT_DISABLED
}

function verify_file_not_exists {
    [[ -f "$1" ]] && exit $RESULT_DISABLED
}

function verify_file_empty {
    [[ -s "$1" ]] && exit $RESULT_DISABLED
}

function verify_file_not_empty {
    [[ -s "$1" ]] || exit $RESULT_DISABLED
}

function verify_directory_exists {
    [[ -d "$1" ]] || exit $RESULT_DISABLED
}

function verify_directory_not_exists {
    [[ -d "$1" ]] && exit $RESULT_DISABLED
}

function verify_command_true {
    if ! eval "$@"; then
        exit $RESULT_DISABLED
    fi
}

function verify_command_false {
    if eval "$@"; then
        exit $RESULT_DISABLED
    fi
}

function verify_command_matches {
    pattern="$1"
    shift
    output=$(eval "$@")
    if ! [[ $output =~ $pattern ]]; then
        exit $RESULT_DISABLED
    fi
}

function verify_command_not_matches {
    pattern="$1"
    shift
    output=$(eval "$@")
    if [[ $output =~ $pattern ]]; then
        exit $RESULT_DISABLED
    fi
}

function verify_command_contains {
    pattern="$1"
    shift
    output=$(eval "$@")
    if ! [[ $output =~ "$pattern" ]]; then
        exit $RESULT_DISABLED
    fi
}

function verify_command_not_contains {
    pattern="$1"
    shift
    output=$(eval "$@")
    if [[ $output =~ "$pattern" ]]; then
        exit $RESULT_DISABLED
    fi
}

function verify_content_matches {
    pattern="$1"
    shift
    output=$(cat "$@")
    if ! [[ $output =~ $pattern ]]; then
        exit $RESULT_DISABLED
    fi
}

function verify_content_not_matches {
    pattern="$1"
    shift
    output=$(cat "$@")
    if [[ $output =~ $pattern ]]; then
        exit $RESULT_DISABLED
    fi
}

function verify_content_contains {
    pattern="$1"
    shift
    output=$(cat "$@")
    if ! [[ $output =~ "$pattern" ]]; then
        exit $RESULT_DISABLED
    fi
}

function verify_content_not_contains {
    pattern="$1"
    shift
    output=$(cat "$@")
    if [[ $output =~ "$pattern" ]]; then
        exit $RESULT_DISABLED
    fi
}

function verify_bashrcd_enabled { script=$1
    if ls "$BASHRCD_PATH/"*".$script.bash" 1> /dev/null 2>&1; then
        :
    elif [[ "$BASHRCD_PATH/$script.bash" ]]; then
        :
    else
        exit $RESULT_DISABLED
    fi
}

function verify_bashrcd_disabled { script=$1
    if ls "$BASHRCD_PATH/"*".$script.bash" 1> /dev/null 2>&1; then
        exit $RESULT_DISABLED
    elif [[ "$BASHRCD_PATH/$script.bash" ]]; then
        exit $RESULT_DISABLED
    fi
}

# Turn off automatic variable/function export
set +a

