#!/bin/bash

if ! [ -f ".env" ]; then
    echo -e "\033[36m .env file not found. Copying example - please review and re-run.\033[0m"
    cp .env.example .env
    exit 1
fi

source .env

if ! [ -x "$(command -v stow)" ]; then
    echo -e "\033[36m stow command not found. Installing now...\033[0m"
    sudo apt install stow
fi

function backup_conflicts {
    mkdir -p backups
    for filename in $1; do
        if [[ -h $HOME_PATH/$filename ]]; then
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

PACKAGES=""
while IFS="" read -r package || [ -n "$package" ]
do
    [[ -z "$package" ]] && continue
    if [[ -d $EVERYTHING_PATH/packages/$package ]]; then
        PACKAGES+=" $package"
    fi
    while IFS="" read -r environment || [ -n "$environment" ]
    do
        if [[ -n "$environment" ]] && [[ -d $EVERYTHING_PATH/packages/$package.$environment ]]; then
            PACKAGES+=" $package.$environment"
        fi
    done < environments.list
done < packages.list

STOW_ARGS="--restow --no-folding --override=.* --dir=$EVERYTHING_PATH/packages --target=$HOME_PATH --verbose $PACKAGES"

if [ "$1" = "sync" ]; then

    CONFLICTS=$(stow --simulate $STOW_ARGS 2>&1 | awk '!a[$0]++' | awk '/\* existing target is/ {print $NF}' | xargs)
    if [[ -n "$CONFLICTS" ]]; then
        echo "Found conflicts: $CONFLICTS"
        echo "Backing up conflicts"
        backup_conflicts "$CONFLICTS"
    fi
    
    echo "Deploying symlinks"
    stow $STOW_ARGS

elif [ "$1" = "restore" ]; then

    restore_conflicts

elif [ "$1" = "apply" ]; then
    stow $STOW_ARGS
    for package in $PACKAGES
    do
        echo -e "\033[36m Looking for packages/$package/setup/always.sh\033[0m"
        test -x "packages/$package/setup/always.sh" || continue
        echo -e "\033[36m Found. Running...\033[0m\n"
        ( cd "packages/$package/setup" && eval $(egrep -v '^#' $EVERYTHING_PATH/.env | xargs) ./always.sh )
        echo ""
    done
elif [ "$1" = "init" ]; then
    stow $STOW_ARGS
    echo -e "\033[36m Initialising everything...\033[0m\n"
    ( eval $(egrep -v '^#' .env | xargs) FROM_SYNC=1 ./init.sh )
    echo ""
    for package in $PACKAGES
    do
        echo -e "\033[36m Looking for packages/$package/setup/once.sh\033[0m"
        test -x "packages/$package/setup/once.sh" || continue
        echo -e "\033[36m Found. Running...\033[0m\n"
        ( cd "packages/$package/setup" && eval $(egrep -v '^#' $EVERYTHING_PATH/.env | xargs) ./once.sh )
        echo ""
    done
else
    echo stow --simulate $STOW_ARGS
    stow --simulate $STOW_ARGS
    echo ""
    echo -e "\033[36m Stow actions simulated.\033[0m\n"
    echo -e "\033[36m Run '$0 apply' to perform actions.\033[0m"
    echo -e "\033[36m Or for first time setup run '$0 init'.\033[0m\n"
fi

