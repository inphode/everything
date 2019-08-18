#!/bin/bash

# TODO: Check for whiptail, curl, git, packages.list, modules.list, environments.list
# Allow interactive selection of environments, packages and modules.
# Provide some preset sensible default lists.
# Allow modules to trigger bashrc re-sourcing or pull env from a previous module.

# Get directory of script (even through symlinks)
export EVERYTHING_PATH="$(dirname "$(readlink -f "$0")")"

# Using a new variable for home directory to make custom target directories
# easier to implement in future.
export HOME_PATH="$HOME"

# A unique serial to identify this execution (for use in logs and backups)
export SERIAL=$(date +%s)

# Check for .env file and copy example if it doesn't exist
if ! [ -f "$EVERYTHING_PATH/.env" ]; then
    echo -e "\033[36m .env file not found. Copying example - please review and re-run.\033[0m"
    cp "$EVERYTHING_PATH/examples/.env.example" "$EVERYTHING_PATH/.env"
    cp "$EVERYTHING_PATH/examples/environments.list.example" "$EVERYTHING_PATH/environments.list"
    cp "$EVERYTHING_PATH/examples/packages.list.example" "$EVERYTHING_PATH/packages.list"
    cp "$EVERYTHING_PATH/examples/modules.list.example" "$EVERYTHING_PATH/modules.list"
    exit 1
fi

# Source the user's .env file
set -a
. "$EVERYTHING_PATH/.env"
set +a

# Ensure stow is installed
if ! [ -x "$(command -v stow)" ]; then
    echo -e "\033[36m stow command not found. Installing now...\033[0m"
    sudo apt install stow
fi

# Create and add required bin directories to path
mkdir -p "$EVERYTHING_PATH/bin"
mkdir -p "$HOME_PATH/.local/bin"
export PATH="$EVERYTHING_PATH/bin:$HOME_PATH/.local/bin:$PATH"

# Deploy a symlink to bin path location
if ! [[ -e "$EVERYTHING_PATH/bin/$EVERYTHING_BIN" ]]; then
    ln -s "$EVERYTHING_PATH/everything.sh" "$EVERYTHING_PATH/bin/$EVERYTHING_BIN"
fi

# Source library functions
. "$EVERYTHING_PATH/lib/bashrcd.sh"
. "$EVERYTHING_PATH/lib/output.sh"
. "$EVERYTHING_PATH/lib/package.sh"
. "$EVERYTHING_PATH/lib/module.sh"
. "$EVERYTHING_PATH/lib/verify.sh"
. "$EVERYTHING_PATH/lib/command.sh"

# Install bashrcd
bashrcd_install

if [[ "$1" = "sync" || "$1" = "s" ]]; then

    shift
    command_sync $@

elif [[ "$1" = "package" || "$1" = "p" ]]; then

    shift

    if [[ "$1" = "sync" || "$1" = "s" ]]; then

        shift
        command_package_sync $@

    elif [[ "$1" = "add" || "$1" = "a" ]]; then

        shift
        command_package_add $@

    elif [[ "$1" = "remove" || "$1" = "r" ]]; then

        shift
        command_package_remove $@

    else

        # TODO: echo package info/help
        command_package_status

    fi

elif [[ "$1" = "module" || "$1" = "m" ]]; then

    shift

    if [[ "$1" = "sync" || "$1" = "s" ]]; then

        shift
        command_module_sync $@

    elif [[ "$1" = "add" || "$1" = "a" ]]; then

        shift
        command_module_add $@

    elif [[ "$1" = "remove" || "$1" = "r" ]]; then

        shift
        command_module_remove $@

    elif [[ "$1" = "enable" || "$1" = "e" ]]; then

        shift
        command_module_enable $@

    elif [[ "$1" = "disable" || "$1" = "d" ]]; then

        shift
        command_module_disable $@

    elif [[ "$1" = "choose" || "$1" = "c" ]]; then

        shift
        command_module_choose

    elif [[ "$1" = "new" || "$1" = "n" ]]; then

        shift
        command_module_new $@

    elif [[ "$1" = "modify" || "$1" = "m" ]]; then

        shift
        command_module_modify $@

    else

        # TODO: echo module info/help
        command_module_status

    fi

elif [[ "$1" = "restore" || "$1" = "r" ]]; then

    shift
    command_restore $@

else

    # TODO: move to command_status
    echo_heading "Status overview"
    echo_subheading "environments.list"
    cat "$EVERYTHING_PATH/environments.list"
    echo_subheading "packages.list"
    cat "$EVERYTHING_PATH/packages.list"
    echo_subheading "modules.list"
    cat "$EVERYTHING_PATH/modules.list"

fi

