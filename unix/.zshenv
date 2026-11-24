# Environment for login, non-login, interactive and non-interactive shells.
if [[ -f "$HOME/.cargo/env" ]]; then
    . "$HOME/.cargo/env"
fi

# Use the systemd SSH agent socket without replacing an inherited/forwarded agent.
if [[ "$OSTYPE" == linux* && -z "$SSH_AUTH_SOCK" ]]; then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/openssh_agent"
fi
