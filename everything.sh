#!/bin/bash

# TODO: Check for curl, git, packages.list, modules.list, environments.list

if ! [ -f ".env" ]; then
    echo -e "\033[36m .env file not found. Copying example - please review and re-run.\033[0m"
    cp .env.example .env
    exit 1
fi

source .env

PATH=$EVERYTHING_PATH/bin:$HOME_PATH/.local/bin:$PATH

if ! [ -x "$(command -v stow)" ]; then
    echo -e "\033[36m stow command not found. Installing now...\033[0m"
    sudo apt install stow
fi

# Deploy a proxy to this script to bin/e
mkdir -p $EVERYTHING_PATH/bin
echo "#!/bin/bash" > $EVERYTHING_PATH/bin/e
echo "cd $EVERYTHING_PATH; exec ./everything.sh \"\$@\"" >> $EVERYTHING_PATH/bin/e
chmod +x $EVERYTHING_PATH/bin/e

function backup_conflicts {
    mkdir -p backups
    for filename in $1; do
        if [[ -L $HOME_PATH/$filename ]]; then
            echo "Removing symlink $HOME_PATH/$filename"
            rm "$HOME_PATH/$filename"
        elif [[ -f $HOME_PATH/$filename ]]; then
            echo "Backing up file $HOME_PATH/$filename"
            mkdir -p "backups/${filename%${filename##*/}}"
            mv "$HOME_PATH/$filename" "backups/$filename"
        fi
    done
}

function restore_conflicts {
    if [[ -d backups ]]; then
        for filename in $(cd backups; find . -type f -print | sed 's#./##' | xargs); do
            echo "Restoring backup $HOME_PATH/$filename"
            if [[ -h $HOME_PATH/$filename ]]; then
                rm "$HOME_PATH/$filename"
            fi
            mv "backups/$filename" "$HOME_PATH/$filename"
        done
    fi
    rm -r backups
}

function module_script {
    module=$1
    script=$2
    output=$( cd "modules/$module"; eval $(egrep -v '^#' $EVERYTHING_PATH/.env | xargs) PATH=$PATH ./$script.sh )
    return $?
}

function update_module_line {
    module_line=$1
    module=$2
    character=$3
    sed -i "s/$module_line/$character$module/g" $EVERYTHING_PATH/modules.list
}

function enable_module {
    module=$1
    [[ -x "modules/$module/enable.sh" ]] || (echo "Could not find module (enable): $module" && return 1)
    module_script $module "enable" || (echo "Failed to enable module: $module" && return 2)
    module_script $module "verify" || (echo "Enabled module, but verify failed: $module" && return 3)
}

function disable_module {
    module=$1
    [[ -x "modules/$module/disable.sh" ]] || (echo "Could not find module (disable): $module" && return 1)
    module_script $module "disable" || (echo "Failed to disable module: $module" && return 2)
    module_script $module "verify" && echo "Disabled module, but verify claims still enabled: $module" && return 3
}

function verify_module {
    module=$1
    [[ -x "modules/$module/verify.sh" ]] || (echo "Could not find module (verify): $module" && return 1)
    module_script $module "verify" || (echo "Previously enabled module failed verify: $module" && return 2)
}

function process_module_line {
    module_line=$1
    first_character=${module_line::1}
    if [[ $first_character == [-+?] ]]; then
        module=${module_line:1}
        if [[ $first_character == '-' ]]; then
            disable_module $module || (update_module_line $module_line $module '?' && return 1)
            update_module_line $module_line $module '#'
        elif [[ $first_character == '+' ]]; then
            enable_module $module || (update_module_line $module_line $module '?' && return 2)
            update_module_line $module_line $module ''
        else
            echo "Module previously marked as requiring manual investigation: $module"
            return 3
        fi
    else
        module=$module_line
        # Module line claims module is installed. Verify this and prefix with ? if not true.
        verify_module $module_line || (update_module_line $module_line $module '?' && return 4)
    fi
}

PACKAGES=""
while IFS="" read -r package || [ -n "$package" ]
do
    # Skip empty lines
    [[ -z "$package" ]] && continue
    # Skip lines starting with '#'
    [[ "${package::1}" == '#' ]] && continue
    # If the package directory exists
    if [[ -d $EVERYTHING_PATH/packages/$package ]]; then
        PACKAGES+=" $package"
    fi
    # For each of the environments listed in 'environments.list'
    while IFS="" read -r environment || [ -n "$environment" ]
    do
        # If environment is not empty and the package.environment directory exists
        if [[ -n "$environment" ]] && [[ -d $EVERYTHING_PATH/packages/$package.$environment ]]; then
            PACKAGES+=" $package.$environment"
        fi
    done < environments.list
done < packages.list

STOW_ARGS="--restow --no-folding --override=.* --dir=$EVERYTHING_PATH/packages --target=$HOME_PATH --verbose $PACKAGES"

if [ "$1" = "sync" ]; then

    # Look for conflicts with a dry-run of stow and backup if necessary
    conflicts=$(stow --simulate $STOW_ARGS 2>&1 | awk '!a[$0]++' | awk '/\* existing target is/ {print $NF}' | xargs)
    if [[ -n "$conflicts" ]]; then
        echo "Found conflicts: $conflicts"
        echo "Backing up conflicts"
        backup_conflicts "$conflicts"
    fi
    
    echo ""
    echo -e "\033[36m  Deploying symlinks:\033[0m\n"
    stow $STOW_ARGS

    module_lines=$(egrep -v '^#' $EVERYTHING_PATH/modules.list | xargs)
    for module_line in $module_lines
    do
        echo ""
        echo -e "\033[36m  Processing module: $module_line\033[0m"
        process_module_line $module_line || (echo "Issues found. Please review modules.list and resolve lines marked with ?" && exit 1)
    done
    echo ""

elif [ "$1" = "restore" ]; then

    restore_conflicts

else

    echo ""
    echo -e "\033[36m  Stow actions simulated:\033[0m\n"
    echo stow --simulate $STOW_ARGS
    stow --simulate $STOW_ARGS
    echo ""
    echo -e "\033[36m  Module status:\033[0m\n"
    cat $EVERYTHING_PATH/modules.list
    echo ""
    echo -e "\033[36m  No action taken.\033[0m"
    echo -e "\033[36m  Run '$0 sync' to sync packages and modules.\033[0m"
    echo ""

fi

