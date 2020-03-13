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

# Create a new module in specified packages with specified module name.
# package: package name of the package to create the module in
# module: name of the module to be created
function command_module_new { module=$2; package=$1
    if [[ -z "$module" ]]; then
        echo_error "You must specify a module name"
        return 1
    fi

    if [[ -z "$package" ]]; then
        echo_error "You must specify a package"
        return 1
    fi

    module_dir="$EVERYTHING_PATH/packages/$package/.everything/modules/$module"

    if [[ -d "$module_dir" ]]; then
        echo_error "The module directory with the name specified ($module) exists already."
        echo_error "Aborting"
        return 1
    fi

    mkdir -p "$module_dir"
    touch "$module_dir/enable.sh"
    touch "$module_dir/disable.sh"
    touch "$module_dir/verify.sh"

    command_module_modify $module $package
}

# Modify an existing package. Opens enable, disable and verify scripts
# in text editor. If you don't specify a package name, it will look for
# the module in the insalled modules directory.
# module: name of the module to edit
# package: (optional) package name where the module is to be found
function command_module_modify { module=$2; package=$1
    echo_info "Placeholder for module modify $module $package"
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

