if status is-interactive
    # Commands to run in interactive sessions can go here
end

#  Set greeting
set fish_greeting "🚀 Welcome back, $USER 🚀"

# Make sure Path for cargo is set
if not contains ~/.cargo/bin $PATH
    set -gx PATH $PATH ~/.cargo/bin
end

set -gx WORK_HOME "$HOME/Documents/Goldsky"

starship init fish | source
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH "/opt/homebrew/opt/node@22/bin" $PATH

# Source local config (not tracked in git)
if test -f ~/.config/fish/local.fish
    source ~/.config/fish/local.fish
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
