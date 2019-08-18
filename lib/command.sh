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

# Synchronise packages and modules.
function command_sync {
    if command_package_sync; then
        if command_module_sync; then
            echo_info "Synchronising finished"
        else
            echo_error "Failed to sync modules"
        fi
    else
        echo_error "Failed to sync packages. Aborting."
        return 1
    fi
}

# Synchronise packages based on packages.list and environments.list files.
# packages: optional list of packages to sync, otherwise syncs all
function command_package_sync { packages=$@
    echo_heading "Looking for conflicts"
    package_backup_conflicts $packages
    if [[ $? -ne 0 ]]; then
        echo_error "Encountered a problem while backing up conflicts"
        return 1
    fi
    echo_heading "Applying packages"
    package_apply $packages
    if [[ $? -ne 0 ]]; then
        echo_error "Encountered a problem while synchonising packages"
        return 1
    fi
}

# Synchronise modules based on modules.list file.
# modules: optional list of modules to sync, otherwise syncs all
function command_module_sync { modules=$@
    echo_heading "Synchronising modules"
    module_sync $modules
}

# Restore backed up package conflicts.
# serials: optional list of backups to restore
function command_restore { serials=$@
    if [[ -n $serials ]]; then
        for serial in $serials; do
            [[ -z $serial ]] && continue
            package_restore_conflicts $serial || return 1
        done
    else
        package_restore_conflicts || return 1
    fi
}

set +a

