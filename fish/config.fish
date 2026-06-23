# Load local (untracked) config from Personal/configs
set -l local_config "$HOME/Documents/Personal/configs/fish/local.fish"
if test -f "$local_config"
    source "$local_config"
end

# Initialize Starship prompt
if type -q starship
    starship init fish | source
end
