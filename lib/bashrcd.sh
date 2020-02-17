#!/bin/bash

# Export all variables and functions
set -a

if ! [[ -v BASHRCD_PATH ]]; then
    BASHRCD_PATH="$HOME_PATH/.bashrc.d"
fi

if ! [[ -v BASHRCD_AVAILABLE_PATH ]]; then
    BASHRCD_AVAILABLE_PATH="$HOME_PATH/.bashrc.d/available"
fi

BASHRCD_CODE='# ---BASHRCD_MANAGED---DO_NOT_MODIFY---BEGIN
# Source bash files in .bashrc.d directory
if [[ -d "$HOME/.bashrc.d" ]]; then
    for x in "$HOME/.bashrc.d"/*.bash ; do
        test -f "$x" || continue
        . "$x"
    done
fi
# ---BASHRCD_MANAGED---DO_NOT_MODIFY---END'

function bashrcd_install {
    mkdir -p "$BASHRCD_PATH"
    sed -i --follow-symlinks '/# ---BASHRCD_MANAGED---DO_NOT_MODIFY---BEGIN/,/# ---BASHRCD_MANAGED---DO_NOT_MODIFY---END/c\' "$HOME/.bashrc"
    echo "$BASHRCD_CODE" >> "$HOME/.bashrc"
}

function bashrcd_disable { script=$1
    rm -f "$BASHRCD_PATH/"*".$script.bash"
    rm -f "$BASHRCD_PATH/$script.bash"
}

function bashrcd_enable { script=$1; priority=$2
    bashrcd_disable $script
    source="$BASHRCD_AVAILABLE_PATH/$script.bash"
    if [[ $# == 2 ]]; then
        destination="$BASHRCD_PATH/$priority.$script.bash"
    else
        destination="$BASHRCD_PATH/$script.bash"
    fi
    ln -s "$source" "$destination"
}

function bashrcd_source { script=$1
    . "$BASHRCD_AVAILABLE_PATH/$script.bash"
}

set +a

