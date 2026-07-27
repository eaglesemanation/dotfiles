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

if type -q devenv;
    devenv hook fish | source
end

set -gx EDITOR nvim
alias vi nvim
alias vim nvim
alias vimdiff 'nvim -d'
