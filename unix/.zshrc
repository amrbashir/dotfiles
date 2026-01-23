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

zinit light zsh-users/zsh-completions
zinit light jirutka/zsh-shift-select
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit 
zinit cdreplay -q

zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# ------------------
# Utility functions
# ------------------
merge_nearest_gitconfig() {
    # Reset any previous temporary git config
    if [[ -n "$GIT_CONFIG_GLOBAL" ]]; then
        rm -f "$GIT_CONFIG_GLOBAL" 2>/dev/null
        unset GIT_CONFIG_GLOBAL
    fi

    local current_dir="$PWD"
    local nearest_gitconfig=""

    # Find the nearest .gitconfig file upwards in the directory tree
    while [[ -n "$current_dir" ]]; do
        local gitconfig_path="$current_dir/.gitconfig"
        if [[ -f "$gitconfig_path" ]]; then
            nearest_gitconfig="$gitconfig_path"
            break
        fi

        # Move up one directory
        current_dir="${current_dir%/*}"
    done

    # if the found .gitconfig is not the user's global config, merge it
    if [[ -n "$nearest_gitconfig" && "$nearest_gitconfig" != "$HOME/.gitconfig" ]]; then
        # Create a temporary config file with the user's global config ~/.gitconfig
        local temp_config=$(mktemp)
        cat "$HOME/.gitconfig" > "$temp_config"

        # Append an include directive for the nearest .gitconfig
        echo -e "\n[include]\n    path = $nearest_gitconfig" >> "$temp_config"

        # Point Git to this merged config for the session
        export GIT_CONFIG_GLOBAL="$temp_config"
        echo "Merged git config from \e[36m$nearest_gitconfig\e[0m into current session."
    fi
}

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
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ---------------------
# Environment variables
# ---------------------
export EDITOR="nvim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# -------
# Aliases
# -------
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

# -----------------
# Integrations
# -----------------
eval "$(zoxide init zsh --cmd cd)"
eval "$(starship init zsh)"
eval "`fnm env --shell zsh --use-on-cd`"

# add hook on directory change to merge nearest gitconfig
# also run it once at startup
add-zsh-hook chpwd merge_nearest_gitconfig && merge_nearest_gitconfig