#!/bin/bash

# Export all variables and functions
set -a

REPORT_ENABLED=0
REPORT_DISABLED=102
REPORT_ERROR=103

function verify_command_exists {
    if [[ $1 =~ "/" ]]; then
        if ! [ -x "$1" ]; then
            exit $REPORT_DISABLED
        fi
    else
        if ! [ -x "$(command -v $1)" ]; then
            exit $REPORT_DISABLED
        fi
    fi
}

function verify_command_not_exists {
    if [[ $1 =~ "/" ]]; then
        if [ -x "$1" ]; then
            exit $REPORT_DISABLED
        fi
    else
        if [ -x "$(command -v $1)" ]; then
            exit $REPORT_DISABLED
        fi
    fi
}

function verify_file_exists {
    [[ -f "$1" ]] || exit $REPORT_DISABLED
}

function verify_file_not_exists {
    [[ -f "$1" ]] && exit $REPORT_DISABLED
}

function verify_file_empty {
    [[ -s "$1" ]] && exit $REPORT_DISABLED
}

function verify_file_not_empty {
    [[ -s "$1" ]] || exit $REPORT_DISABLED
}

function verify_directory_exists {
    [[ -d "$1" ]] || exit $REPORT_DISABLED
}

function verify_directory_not_exists {
    [[ -d "$1" ]] && exit $REPORT_DISABLED
}

function verify_command_true {
    if ! eval "$@"; then
        exit $REPORT_DISABLED
    fi
}

function verify_command_false {
    if eval "$@"; then
        exit $REPORT_DISABLED
    fi
}

function verify_command_matches {
    pattern="$1"
    shift
    output=$(eval "$@")
    if ! [[ $output =~ $pattern ]]; then
        exit $REPORT_DISABLED
    fi
}

function verify_command_not_matches {
    pattern="$1"
    shift
    output=$(eval "$@")
    if [[ $output =~ $pattern ]]; then
        exit $REPORT_DISABLED
    fi
}

function verify_command_contains {
    pattern="$1"
    shift
    output=$(eval "$@")
    if ! [[ $output =~ "$pattern" ]]; then
        exit $REPORT_DISABLED
    fi
}

function verify_command_not_contains {
    pattern="$1"
    shift
    output=$(eval "$@")
    if [[ $output =~ "$pattern" ]]; then
        exit $REPORT_DISABLED
    fi
}

function verify_content_matches {
    pattern="$1"
    shift
    output=$(cat "$@")
    if ! [[ $output =~ $pattern ]]; then
        exit $REPORT_DISABLED
    fi
}

function verify_content_not_matches {
    pattern="$1"
    shift
    output=$(cat "$@")
    if [[ $output =~ $pattern ]]; then
        exit $REPORT_DISABLED
    fi
}

function verify_content_contains {
    pattern="$1"
    shift
    output=$(cat "$@")
    if ! [[ $output =~ "$pattern" ]]; then
        exit $REPORT_DISABLED
    fi
}

function verify_content_not_contains {
    pattern="$1"
    shift
    output=$(cat "$@")
    if [[ $output =~ "$pattern" ]]; then
        exit $REPORT_DISABLED
    fi
}

# Turn off automatic variable/function export
set +a

