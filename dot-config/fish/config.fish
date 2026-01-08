#!/bin/fish

# Replace default greeting with empty string
set fish_greeting
# Nice looking shell prompt
set -l posh_config ~/.config/oh-my-posh/base.toml
if set -q POSH_CONFIG_PATH
    set posh_config "$POSH_CONFIG_PATH"
end
oh-my-posh --config $posh_config init fish | source

set -Ux PASSWORD_STORE_DIR ~/.local/share/pass-store

# Use gpg-agent when present and there is a key with Authenticate cap
if type -q gpg-agent; and type -q gpg; and gpg --list-keys --with-keygrip | grep "\[A\]" >/dev/null
    set -e SSH_AGENT_PID
    if [ "$gnupg_SSH_AUTH_SOCK_by" != "$fish_pid" ]
        set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    end
    set -gx GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null
end

# Auto install plugin manager
if status is-interactive; and not test -e ~/.config/fish/functions/fisher.fish
    curl --silent --location https://git.io/fisher | source
    fisher install jorgebucaran/fisher
    # Fix autocomplete for pass-otp
    fisher install mserajnik/fish-completions-pass-extensions
end

set -gx EDITOR nvim
alias vi nvim
alias vim nvim
alias vimdiff 'nvim -d'
