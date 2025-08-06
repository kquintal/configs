# Create an alias for the `cb` function which runs cargo build
function cb --wraps='cargo build' --description 'alias cb=cargo build'
  cargo build $argv
end
# This function allows you to run `cb` to execute `cargo build` with any additional
# arguments you might want to pass to the command.
