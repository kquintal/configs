#!/usr/bin/env bash
set -euo pipefail

CONFIGS_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "Installing Homebrew packages..."
brew bundle --file="$CONFIGS_DIR/Brewfile"

# --- Rust toolchain ---
if ! command -v rustc &>/dev/null; then
  echo "Installing Rust default toolchain..."
  rustup-init -y
  source "$HOME/.cargo/env"
fi

# --- Bun ---
if ! command -v bun &>/dev/null; then
  echo "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
fi

# --- Oh My Fish ---
if [ ! -d "$HOME/.local/share/omf" ]; then
  echo "Installing Oh My Fish..."
  curl -fsSL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fi

# --- Symlinks ---
echo "Symlinking config files..."

mkdir -p "$HOME/.config/fish"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/starship"

ln -sfn "$CONFIGS_DIR/fish/config.fish"   "$HOME/.config/fish/config.fish"
ln -sfn "$CONFIGS_DIR/fish/functions"      "$HOME/.config/fish/functions"
ln -sfn "$CONFIGS_DIR/fish/conf.d"         "$HOME/.config/fish/conf.d"
ln -sfn "$CONFIGS_DIR/nvim/init.lua"       "$HOME/.config/nvim/init.lua"
ln -sfn "$CONFIGS_DIR/nvim/lua"            "$HOME/.config/nvim/lua"
ln -sfn "$CONFIGS_DIR/nvim/lazy-lock.json" "$HOME/.config/nvim/lazy-lock.json"
ln -sfn "$CONFIGS_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
ln -sfn "$CONFIGS_DIR/tmux/tmux.conf"      "$HOME/.tmux.conf"

# --- Set fish as default shell ---
FISH_PATH="/opt/homebrew/bin/fish"
if ! grep -q "$FISH_PATH" /etc/shells; then
  echo "Adding fish to /etc/shells (requires sudo)..."
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

if [ "$SHELL" != "$FISH_PATH" ]; then
  echo "Setting fish as default shell..."
  chsh -s "$FISH_PATH"
fi

echo "Done! Restart your terminal to use the new config."
