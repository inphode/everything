# Everything

Scripts, dotfiles and other stuff for restoring and maintaining config and notes between systems.

## Setup

Set up file synchronisation via Google Drive, Dropbox or similar.

Set up a secure directory (ideally encrypted) containing sensitive data such as SSH keys.

Copy `.env.example` to `.env` and customise as needed (setting the paths for the above directories).

Run `./everything.sh init`.

This will install an `everything` executable to your `~/bin` directory.

## Updates

Run `everything`, followed by `everything apply` after inspecting changes.
