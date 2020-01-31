export XDG_CONFIG_HOME="$HOME/.config"

mkdir -p "$HOME/.everything/bin"
mkdir -p "$HOME/bin"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/composer/vendor/bin"

# Add bin directory in home directory to PATH
export PATH="$HOME/.everything/bin:$HOME/bin:$HOME/.local/bin:$HOME/.config/composer/vendor/bin:$PATH"
