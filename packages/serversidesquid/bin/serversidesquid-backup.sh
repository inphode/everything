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

BACKUP_DIR="$SSS_EVERYTHING_SYNC/backups/$(date +%Y-%m-%d--%H-%M-%S)"
mkdir -p "$BACKUP_DIR/sql"
mkdir -p "$BACKUP_DIR/git"

# Database backup
databases=$(mysql -u $SSS_DB_USER -p$SSS_DB_PASS -e "SHOW DATABASES;" 2>/dev/null | tr -d "| " | grep -v Database)

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != "performance_schema" ]] && [[ "$db" != "mysql" ]] && [[ "$db" != _* ]] && [[ "$db" != "sys" ]]; then
        echo "Dumping database: $db"
        mysqldump -u $SSS_DB_USER -p$SSS_DB_PASS --databases $db 2>/dev/null | gzip > "$BACKUP_DIR/sql/$db.sql.gz"
    fi
done

# Git repository backup
repositories=$(ls "$SSS_GIT_DIR" | xargs)

for repo in $repositories; do
    if [[ -d "$SSS_GIT_DIR/$repo/.git" ]]; then
        echo "Backing up repo: $repo"
        ( cd $SSS_GIT_DIR && tar czf "$BACKUP_DIR/git/$repo.tar.gz" "$repo" )
    fi
done

