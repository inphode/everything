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
    echo ""
}

function module_enable {
    echo ""
}

function module_verify_enable {
    echo ""
}

function module_disable {
    echo ""
}

function module_verify_disable {
    echo ""
}

function module_sync {
    echo "args passed to module_sync: $@"
    return 1
}

function module_sync_all { options=$@
    force=$(option_flag "force" 1 0 $@)

    echo "force = $force"

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

