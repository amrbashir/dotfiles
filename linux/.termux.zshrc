# ------------------
# ZSH configurations
# ------------------
unsetopt BEEP
WORDCHARS="${WORDCHARS/\//}"

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

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
export GIT_ASKPASS=~/.termux/git-ask-pass.sh
export FZF_DEFAULT_COMMAND="fd . $HOME"
export PATH=~/.local/bin:$PATH

# -------
# Aliases
# -------
alias ls="exa --icons"
alias ll="exa -lah --icons --git --group-directories-first --no-user --no-time"
alias cls="clear"
alias vim="nvim"

alias ga="git add"
alias gcm="git commit"
alias gl="git lg"
alias gc="git checkout"
alias gb="git branch"
alias gs="git status"
alias gd="git diff"
alias gst="git stash"
alias gpull="git pull"
alias gpush="git push"

# -----------------
eval "$(sheldon source)"
eval "$(starship init zsh)"
