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
export EDITOR="nvim"
export MANPAGER="bat -l man -p"
export GPG_TTY="$(tty)"
export GIT_ASKPASS="$HOME/.termux/git-ask-pass.sh"

export PATH="$HOME/.local/bin:$PATH"
# -------
# Aliases
# -------
alias cls="clear"
alias ls="exa --icons"
alias lsa="exa -lah --icons --git --group-directories-first"
alias vim="nvim"

# -----------------
# Scripts execution
# -----------------
eval "$(sheldon source)"
eval "$(starship init zsh)"
