function turbo-local --description "Run a streamling pipeline YAML locally with a plugin .dylib/.so"
    # ─────────────────────────────────────────────────────────────────────────
    # Required env var:
    #   $STREAMLING_REPO            path to streamling source repo
    #                               (binary expected at $STREAMLING_REPO/target/<profile>/streamling)
    #
    # Optional env vars (sensible defaults if unset):
    #   $STREAMLING_PLUGINS_REPO    path to the plugin repo
    #                               (default: current working directory)
    #   $STREAMLING_PLUGIN_DYLIB    full path to the plugin .dylib/.so
    #                               (default: glob $STREAMLING_PLUGINS_REPO/target/<profile>/lib*.{dylib,so})
    #   $STREAMLING_CONFIG_DIR      dir containing the streamling config.yaml
    #                               (default: $STREAMLING_REPO/crates/streamling)
    #
    # Usage:
    #   turbo-local <pipeline-yaml> [--rebuild] [--release] [--timeout SECS] [--log LEVEL]
    #
    # Examples:
    #   turbo-local local-test-yaml/canton-scan-print.yaml
    #   turbo-local some.yaml --rebuild
    #   turbo-local some.yaml --release --timeout 60 --log debug
    # ─────────────────────────────────────────────────────────────────────────

    if test (count $argv) -lt 1
        echo "Usage: turbo-local <pipeline-yaml> [--rebuild] [--release] [--timeout SECS] [--log LEVEL]"
        echo ""
        echo "Required env: STREAMLING_REPO"
        echo "Optional env: STREAMLING_PLUGINS_REPO (default: cwd), STREAMLING_PLUGIN_DYLIB, STREAMLING_CONFIG_DIR"
        return 1
    end

    set -l pipeline_arg $argv[1]
    set -l rebuild 0
    set -l profile debug
    set -l timeout_secs 0
    set -l log_level info

    set -l i 2
    while test $i -le (count $argv)
        switch $argv[$i]
            case --rebuild
                set rebuild 1
            case --release
                set profile release
            case --timeout
                set i (math $i + 1)
                set timeout_secs $argv[$i]
            case --log
                set i (math $i + 1)
                set log_level $argv[$i]
            case '*'
                echo "turbo-local: unknown arg: $argv[$i]"
                return 1
        end
        set i (math $i + 1)
    end

    # ─── env-var-driven paths ────────────────────────────────────────────────
    if test -z "$STREAMLING_REPO"
        echo "turbo-local: \$STREAMLING_REPO is not set."
        echo "Add to your fish config:  set -gx STREAMLING_REPO ~/path/to/streamling"
        return 1
    end
    set -l plugins_repo (test -n "$STREAMLING_PLUGINS_REPO"; and echo $STREAMLING_PLUGINS_REPO; or pwd)
    set -l config_dir (test -n "$STREAMLING_CONFIG_DIR"; and echo $STREAMLING_CONFIG_DIR; or echo "$STREAMLING_REPO/crates/streamling")

    # ─── resolve pipeline path ───────────────────────────────────────────────
    set -l abs_pipeline (realpath $pipeline_arg 2>/dev/null)
    if test -z "$abs_pipeline"; or not test -e $abs_pipeline
        echo "turbo-local: pipeline YAML not found: $pipeline_arg"
        return 1
    end

    # ─── optional rebuild ────────────────────────────────────────────────────
    if test $rebuild -eq 1
        echo "→ rebuilding plugin ($profile) in $plugins_repo"
        pushd $plugins_repo >/dev/null
        if test "$profile" = release
            cargo build --release --lib
        else
            cargo build --lib
        end
        set -l build_rc $status
        popd >/dev/null
        if test $build_rc -ne 0
            return $build_rc
        end
    end

    # ─── locate plugin .dylib/.so ────────────────────────────────────────────
    set -l plugin_path
    if test -n "$STREAMLING_PLUGIN_DYLIB"
        set plugin_path $STREAMLING_PLUGIN_DYLIB
    else
        set -l candidates $plugins_repo/target/$profile/lib*.dylib $plugins_repo/target/$profile/lib*.so
        # Filter to only files that actually exist (glob may not match anything)
        set -l found
        for c in $candidates
            if test -e $c
                set found $found $c
            end
        end
        if test (count $found) -eq 0
            echo "turbo-local: no plugin found at $plugins_repo/target/$profile/lib*.{dylib,so}"
            echo "  Did you forget --rebuild? Or set \$STREAMLING_PLUGIN_DYLIB explicitly."
            return 1
        else if test (count $found) -gt 1
            echo "turbo-local: multiple plugin .dylib/.so candidates under $plugins_repo/target/$profile/:"
            for c in $found
                echo "    $c"
            end
            echo "  Set \$STREAMLING_PLUGIN_DYLIB to disambiguate."
            return 1
        end
        set plugin_path $found[1]
    end

    # ─── locate streamling binary ────────────────────────────────────────────
    set -l streamling_bin $STREAMLING_REPO/target/$profile/streamling
    if not test -e $streamling_bin
        echo "turbo-local: streamling binary not found at $streamling_bin"
        echo "  Build it: cd $STREAMLING_REPO; and cargo build --bin streamling"
        if test "$profile" = release
            echo "  (or rerun without --release)"
        end
        return 1
    end

    if not test -e $config_dir/config.yaml
        echo "turbo-local: $config_dir/config.yaml not found"
        echo "  Override with \$STREAMLING_CONFIG_DIR if your layout differs"
        return 1
    end

    # ─── run ─────────────────────────────────────────────────────────────────
    echo "→ pipeline: $abs_pipeline"
    echo "→ plugin:   $plugin_path"
    echo "→ binary:   $streamling_bin"
    echo "→ cwd:      $config_dir"
    echo "→ log:      $log_level"
    if test $timeout_secs -gt 0
        echo "→ timeout:  $timeout_secs s"
    end
    echo ""

    pushd $config_dir >/dev/null

    if test $timeout_secs -gt 0
        timeout $timeout_secs env \
            STREAMLING__PLUGIN__PATH=$plugin_path \
            STREAMLING__PIPELINE_DEFINITION_LOCATION=$abs_pipeline \
            RUST_LOG=$log_level \
            $streamling_bin
    else
        env \
            STREAMLING__PLUGIN__PATH=$plugin_path \
            STREAMLING__PIPELINE_DEFINITION_LOCATION=$abs_pipeline \
            RUST_LOG=$log_level \
            $streamling_bin
    end

    set -l rc $status
    popd >/dev/null
    return $rc
end
