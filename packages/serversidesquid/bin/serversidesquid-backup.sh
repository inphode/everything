#!/bin/bash

SSS_ENV="$HOME/.config/serversidesquid/sss.env"

# Terminate on error
set -e

# Check for .env file
if ! [[ -f "$SSS_ENV" ]]; then
    echo "$SSS_ENV file not found."
    echo "You must run the serversidesquid.sh script before performing backups."
    echo
    exit 1
fi

# Source the env config
set -a
. "$SSS_ENV"
set +a

# TODO: Implement full database SQL backup here

# TODO: Implement git non-version controlled file backup here

