#!/bin/bash

# Export all variables and functions
set -a

if [[ $LOGGING == 1 ]]; then
    # Create logging directory if logging is enabled
    mkdir -p "$EVERYTHING_PATH/logs"
fi

function log_text {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $@" >> "$EVERYTHING_PATH/logs/$SERIAL.log"
}

function echo_text { color=$1; prefix=$2; codes=$3; shift 3; text=$*
    echo -e "\033[${color}m${codes}$prefix $text\033[0m"
    if [[ $LOGGING == 1 ]]; then
        log_text "$prefix $text"
    fi
}

function echo_heading {
    echo_text 36 "==>" "\e[1m" "$*"
}

function echo_subheading {
    echo_text 96 "-->" "\e[1m" "$*"
}

function echo_info {
    echo_text 92 "(i)" "" "$*"
}

function echo_warning {
    echo_text 35 "(?)" "" "$*"
}

function echo_error {
    echo_text 31 "(!)" "" "$*"
}

function echo_verbose {
    if [[ $VERBOSE == 1 || $DEBUG == 1 ]]; then
        echo_text 37 "(v)" "" "$*"
    fi
}

function echo_debug {
    if [[ $DEBUG == 1 ]]; then
        echo_text 33 "(d)" "" "$*"
    fi
}

set +a

