function gs-use --description "Switch active Goldsky CLI project token"
    set -l tokens_dir ~/.goldsky
    set -l token_files $tokens_dir/auth_token.*
    set -l available (string replace -r '.*/auth_token\.' '' $token_files)

    set -l target $argv[1]

    if test -z "$target"
        echo "usage: gs-use <name>"
        echo "available:"
        for t in $available
            echo "  - $t"
        end
        return 1
    end

    set -l src $tokens_dir/auth_token.$target
    if not test -f $src
        echo "no token file at $src"
        echo "available:"
        for t in $available
            echo "  - $t"
        end
        return 1
    end

    set -l perms (stat -f '%Lp' $src)
    if test "$perms" != '600'
        echo "warning: $src is mode $perms (expected 600)"
        echo "  fix with: chmod 600 $src"
    end

    printf '%s' (string trim < $src) > $tokens_dir/auth_token
    chmod 600 $tokens_dir/auth_token
    echo "active goldsky token → $target"
end
