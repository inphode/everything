#!/bin/bash

STOW_ARGS="--restow --no-folding --override=.* --dir=$EVERYTHING_PATH/packages --target=$HOME_PATH --verbose"

# Export all variables and functions
set -a

if ! [[ -v ENVIRONMENT_LIST_FILE ]]; then
    ENVIRONMENT_LIST_FILE="$EVERYTHING_PATH/environments.list"
fi

if ! [[ -v ENVIRONMENT_LIST ]]; then
    ENVIRONMENT_LIST=$(egrep -v '^#' "$ENVIRONMENT_LIST_FILE" | xargs)
fi

function package_find_conflicts { packages=$@
    packages=$(package_list $@)
    # Look for conflicts with a dry-run of stow
    stow --simulate $STOW_ARGS "$packages" 2>&1 |
        awk '!a[$0]++' |
        awk '/\* existing target is/ {print $NF}' |
        xargs
}

function package_backup_conflicts { packages=$@
    conflicts=$(package_find_conflicts $packages)
    if [[ -z $conflicts ]]; then
        return 0
    fi
    # Create a new backup directory
    backup_dir=backups/conflicts.$SERIAL
    # This populates the $# variable with count
    set -- $conflicts
    echo_subheading "Backing up conflicts ($#) to $backup_dir"
    mkdir -p $EVERYTHING_PATH/$backup_dir
    # Delete symlinks and move files
    for file in $conflicts; do
        if [[ -L $HOME_PATH/$file ]]; then
            echo_warning "Removing symlink $HOME_PATH/$file"
            rm "$HOME_PATH/$file"
        elif [[ -f $HOME_PATH/$file ]]; then
            echo_warning "Backing up file $HOME_PATH/$file"
            # Make the directory (removing file name from path)
            mkdir -p "$EVERYTHING_PATH/$backup_dir/${file%${file##*/}}"
            mv "$HOME_PATH/$file" "$EVERYTHING_PATH/$backup_dir/$file"
        fi
    done
}

function package_restore_conflicts { serial=$1
    if [[ -z $serial ]]; then
        serial=$(cd $EVERYTHING_PATH/backups 2>&1 && ls | sort -r | head -1)
    fi
    if [[ -z $serial ]]; then
        echo_info "No backups found to restore"
        return 1
    fi
    backup_dir=$EVERYTHING_PATH/backups/conflicts.$serial
    echo_subheading "Restoring conflict backup $backup_dir"
    if ! [[ -d $backup_dir ]]; then
        echo_error "Couldn't find requested backup to restore in $backup_dir"
        return 1
    fi
    for file in $(cd $backup_dir; find . -type f -print | sed 's#./##' | xargs);
    do
        if [[ -L $HOME_PATH/$file ]]; then
            echo_info "Removing symlink $HOME_PATH/$file"
            rm "$HOME_PATH/$file"
        fi
        echo_info "Restoring backup file $file"
        mv "$backup_dir/$file" "$HOME_PATH/$file"
        if [[ $? -ne 0 ]]; then
            echo_error "An error was encountered restoring $file"
            restore_error=1
        fi
    done
    if [[ -z $restore_error ]]; then
        echo_info "Cleaning up backup directory: $backup_dir"
        rm -r $backup_dir
    else
        echo_error "Please manually review the files remaining in $backup_dir"
    fi
}

# Looks for packages and packages with environments
function package_list { packages=$@
    if [[ -z $packages ]]; then
        packages=$(egrep -v '^#' $EVERYTHING_PATH/packages.list | xargs)
    fi
    package_list=""
    for package in $packages
    do
        # Skip empty
        [[ -z "$package" ]] && continue
        # If the package directory exists
        if [[ -d $EVERYTHING_PATH/packages/$package ]]; then
            package_list+=" $package"
        fi
        # For each of the environments
        for environment in $ENVIRONMENT_LIST
        do
            # If environment is not empty and the package.environment directory exists
            if [[ -n "$environment" && -d $EVERYTHING_PATH/packages/$package.$environment ]]; then
                package_list+=" $package.$environment"
            fi
        done
    done
    echo $package_list
}

function package_apply { packages=$@
    packages=$(package_list $@)
    echo_subheading "Using packages: $packages"
    echo_debug "stow command: stow $STOW_ARGS $packages"
    output=$(stow $STOW_ARGS $packages 2>&1)
    echo_verbose "stow output: $output"
}

set +a

