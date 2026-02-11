function dev-2
    if test (count $argv) -lt 1
        echo "Usage: dev-2 <session-name>"
        return 1
    end

    set -l name $argv[1]
    tmux new-session -d -s $name -c ~/Documents
    tmux split-window -h -c ~/Documents
    tmux split-window -v -c ~/Documents
    tmux select-pane -t 0
    tmux attach-session -t $name
end
