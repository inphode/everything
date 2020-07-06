# Make nvim the default editor
export VISUAL=nvim
export EDITOR="$VISUAL"

# Defeat muscle memory
alias vim='vim'

# FZF bash integration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
