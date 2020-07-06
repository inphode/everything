# Everything

Manage configuration between multiple systems and environments.

Currently has limited use to anyone except myself, but could be stripped back and used by anyone willing to read through and understand the bash scripts that make this up.

## Requirements

- Debian-based distros (The eventual intention is to make this work on a wide variety of systems)
- curl package (`sudo apt install curl`)
- Currently hard-coded to install into `~/.everything`
- Currently specifically assumes Ubuntu 20.04 LTS

## Installation

1. Check requirements are met
2. Run `sh -c "$(curl -sSL everything.run)"` in a terminal
3. Follow instructions displayed in terminal

## Usage

Run `./everything.sh` to initialise, create directories and see status.

Run `./everything.sh sync` to synchronise packages and modules.

Run `./everything.sh module modify vim install-vim` to modify the `install-vim` module in the `vim` package.

View the contents of `everything.sh` for other available commands.
