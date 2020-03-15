#!/bin/bash

verify_bashrcd_enabled node

# This if statement is kind of silly, but it'll do for now
if [[ -d ~/.nvm ]]; then
    check_dir=~/.nvm
else
    check_dir=~/.config/nvm
fi
verify_directory_exists $check_dir
