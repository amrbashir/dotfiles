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
export LANG=en_US.UTF-8
export EDITOR="nvim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export CARGO_TARGET_DIR=~/.cache/.cargo-target
export PNPM_HOME=~/.local/share/pnpm
export PATH=~/.local/bin:~/.cargo/bin:~/.fnm:$PNPM_HOME:$PATH

# -------
# Aliases
# -------
alias cls="clear"
alias pacman="sudo pacman"
alias vim="nvim"

alias ls="exa --icons"
alias ll="exa -lah --icons --git --group-directories-first"

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
eval "`fnm env`"
