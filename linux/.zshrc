# ------------------
# ZSH configurations
# ------------------
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history
unsetopt BEEP

# -- Keybindings
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
autoload -U compinit && compinit

# ---------------------
# Environment variables
# ---------------------
export LANG=en_US.UTF-8
export EDITOR="nvim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.nvm:$HOME/spicetify-cli:$PATH"

# -------
# Aliases
# -------
alias cls="clear"
alias ls="exa --icons"
alias lsa="exa -lah --icons --git --group-directories-first"
alias pacman="sudo pacman"
alias vim="nvim"

# -----------------
# Scripts execution
# -----------------
eval "$(sheldon source)"
eval "$(starship init zsh)"
[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"