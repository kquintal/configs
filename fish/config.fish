if status is-interactive
    # Commands to run in interactive sessions can go here
end

#  Set greeting
set fish_greeting "🚀 Welcome back, Classicus 🚀"

# Make sure Path for cargo is set
if not contains ~/.cargo/bin $PATH
    set -gx PATH $PATH ~/.cargo/bin
end

starship init fish | source
