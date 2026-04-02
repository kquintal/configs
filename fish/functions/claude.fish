function claude
    if set -q argv[1]; and test -d $argv[1]
        set -l dir $argv[1]
        set -e argv[1]
        command claude --add-dir $dir $argv
    else if set -q WORK_HOME
        command claude --add-dir $WORK_HOME/repos $argv
    else
        command claude $argv
    end
end
