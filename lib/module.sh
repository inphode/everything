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

function module_sync {
}

function module_sync_all { $options=$@
    force=$([[ $options =~ "force" ]] && echo 1)

    for module_line in $MODULE_LIST
    do
        echo -e "\033[36m  Synchronising module: $module_line\033[0m"
        module_sync $module_line
        if [[ $? != 0 && $force != 1 ]]; then
            echo -e "\033[36m  Sync stopped by failed module: $module_line\033[0m"
        fi
    done
}

set +a

