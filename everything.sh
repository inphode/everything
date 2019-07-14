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

PACKAGES=`( cd packages; ls -d * )`
STOW_ARGS="--restow --no-folding --ignore=setup --dir=$EVERYTHING_PATH/packages --target=$HOME_PATH --verbose $PACKAGES"

if [ "$1" = "apply" ]; then
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
    stow --simulate $STOW_ARGS
    echo ""
    echo -e "\033[36m Stow actions simulated.\033[0m\n"
    echo -e "\033[36m Run '$0 apply' to perform actions.\033[0m"
    echo -e "\033[36m Or for first time setup run '$0 init'.\033[0m\n"
fi

