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
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git --color=always"
export FZF_DEFAULT_OPTS="--ansi"
export PATH=~/.local/bin:$PATH

# -------
# Aliases
# -------
alias ls="exa --icons"
alias ll="exa -lah --icons --git --group-directories-first --no-user --no-time"
alias cls="clear"
alias vim="nvim"

alias gc="git checkout"
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gaa="git add ."
alias gcm="git commit"
alias gcmm="git commit -m"
alias gst="git stash"
alias gpull="git pull"
alias gpush="git push"
alias gl="git lg"
alias gb="git branch"
alias grestore="git restore"
alias greset="git reset"
alias gremote="git remote"
alias grebase="git rebase"

# -----------------
eval "$(sheldon source)"
eval "$(starship init zsh)"
