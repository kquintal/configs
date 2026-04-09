function slp --description 'Build and run a local streamling plugin pipeline'
    set -l plugin_dir $WORK_HOME/repos/streamling-goldsky-plugins
    set -l streamling_dir $WORK_HOME/repos/streamling

    if test (count $argv) -eq 0
        echo "Usage: slp <pipeline.yaml> [-- extra args...]"
        echo "  Builds the plugin and runs streamling locally."
        echo "  Example: slp pipeline-stellar-test.yaml"
        return 1
    end

    set -l pipeline $argv[1]
    set -l extra_args $argv[2..]

    # Resolve pipeline path relative to plugin dir if not absolute
    if not string match -q '/*' $pipeline
        if test -f $plugin_dir/$pipeline
            set pipeline $plugin_dir/$pipeline
        else if test -f (pwd)/$pipeline
            set pipeline (pwd)/$pipeline
        end
    end

    if not test -f $pipeline
        echo "Pipeline file not found: $pipeline"
        return 1
    end

    echo "Building plugin..."
    cargo build --lib --manifest-path $plugin_dir/Cargo.toml; or return 1

    echo "Running pipeline: $pipeline"
    # Run from the streamling repo root so config.yaml resolves correctly
    pushd $streamling_dir
    set -q STREAMLING__NUM_RECORDS_BEFORE_STOP; or set -l STREAMLING__NUM_RECORDS_BEFORE_STOP 10
    set -q RUST_LOG; or set -l RUST_LOG info
    STREAMLING__PLUGIN__PATH=$plugin_dir/target/debug/libgoldsky_plugins.dylib \
    STREAMLING__NUM_RECORDS_BEFORE_STOP=$STREAMLING__NUM_RECORDS_BEFORE_STOP \
    RUST_LOG=$RUST_LOG \
    cargo run -p streamling -- $pipeline $extra_args
    popd
end
