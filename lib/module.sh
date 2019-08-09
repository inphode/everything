#!/bin/bash

# Export all variables and functions
set -a

if [[ -z $MODULE_LIST_FILE ]]; then
    MODULE_LIST_FILE="$EVERYTHING_PATH/modules.list"
fi

if [[ -z $MODULE_LIST ]]; then
    MODULE_LIST=$(cat "$MODULE_LIST_FILE" | xargs)
fi

function module_verify {
}

function module_enable {
}

function module_verify_enable {
}

function module_disable {
}

function module_verify_disable {
}

set +a

