function tms --description "Switch tmux sessions (fuzzy pick or by name)"
    if test (count $argv) -eq 0
        set -l session (tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --height 40% --reverse --prompt "tmux session> ")
        and tmux switch-client -t $session
    else
        tmux switch-client -t $argv[1]
    end
end
