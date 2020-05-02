#!/bin/bash

SSS_ENV="$HOME/.config/serversidesquid/sss.env"

# Terminate on error
set -e

# Check for .env file
if ! [[ -f "$SSS_ENV" ]]; then
    echo "$SSS_ENV file not found."
    echo "You must run the serversidesquid.sh script before performing restore."
    echo
    exit 1
fi

# Source the env config
set -a
. "$SSS_ENV"
set +a

LATEST_BACKUP=$(ls "$SSS_EVERYTHING_SYNC/backups" | tail -n 1)
BACKUP_DIR="$SSS_EVERYTHING_SYNC/backups/$LATEST_BACKUP"

# Database restore
databases=$(ls "$BACKUP_DIR/sql" | xargs)

for db in $databases; do
    db=${db%%.*}
    echo "Restoring database: $db"
    mysql -u $SSS_DB_USER -p$SSS_DB_PASS -e "CREATE DATABASE IF NOT EXISTS $db CHARACTER SET utf8 COLLATE utf8_unicode_ci;" 2>/dev/null
    zcat "$BACKUP_DIR/sql/$db.sql.gz" | mysql -u $SSS_DB_USER -p$SSS_DB_PASS $db 2>/dev/null
done

# Git repository restore
repositories=$(ls "$BACKUP_DIR/git" | xargs)

for repo in $repositories; do
    repo=${repo%%.*}
    if [[ -d "$SSS_GIT_DIR/$repo" ]]; then
        echo "Removing existing target repo directory: $repo"
        rm -rf "$SSS_GIT_DIR/$repo"
    fi
    echo "Restoring repo: $repo"
    tar xzf "$BACKUP_DIR/git/$repo.tar.gz" -C "$SSS_GIT_DIR/"
done

