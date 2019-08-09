#!/bin/bash

# Export all variables and functions
set -a

function option_flag { option=$1; true_value=$2; false_value=$3
    shift 3
    options=$@
    if [[ $options =~ [[:space:]]"--$option"([[:space:]]+|$) ]]; then
        echo $true_value
    else
        echo $false_value
    fi
}

# A command to test various things during development.
function command_sandbox { args=$@
    module_sync_all $args
}

# Synchronise packages and modules.
function command_sync {
    echo ""
}

# Synchronise packages based on packages.list and environments.list files.
# packages: optional list of packages to sync, otherwise syncs all
function command_sync_packages { packages=$@
    echo ""
}

# Synchronise modules based on modules.list file.
# modules: optional list of modules to sync, otherwise syncs all
function command_sync_modules { modules=$@
    echo ""
}

set +a

