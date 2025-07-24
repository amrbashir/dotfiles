# ------------------
# zinit
# ------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"


# ------------------
# zinit plugins
# ------------------

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light jirutka/zsh-shift-select
zinit light Aloxaf/fzf-tab
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit 
zinit cdreplay -q

# ------------------
# ZSH configurations
# ------------------

# History options
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Key bindings
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Completion options
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

# ---------------------
# Environment variables
# ---------------------
export EDITOR="nvim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export CARGO_TARGET_DIR=~/.cache/.cargo-target
export PATH=~/.local/bin:~/.cargo/bin:~/.local/share/fnm:$PATH

# -------
# Aliases
# -------
alias pacman="sudo pacman"
alias vim="nvim"

alias ls="eza --icons"
alias ll="eza -lah --icons --git --group-directories-first"

alias gc="git checkout"
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gaa="git add ."
alias gcm="git commit"
alias gcmm="git commit -m"
alias gst="git stash"
alias gpl="git pull"
alias gp="git push"
alias gl="git lg"
alias gb="git branch"
alias grestore="git restore"
alias greset="git reset"
alias gremote="git remote"
alias grebase="git rebase"

alias start="dolphin"

# -----------------
eval "$(starship init zsh)"
eval "`fnm env`"
