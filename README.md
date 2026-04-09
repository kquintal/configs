# Configs

Personal dotfiles for macOS — fish, tmux, neovim, and starship.

## Setup

```bash
git clone https://github.com/kquintal/configs.git
cd configs
chmod +x setup.sh
./setup.sh
```

This will:
- Install [Homebrew](https://brew.sh) (if not present)
- Install all packages from the `Brewfile`
- Install Rust (via `rustup`), Bun, and Oh My Fish
- Symlink config files to `~/.config/`
- Set fish as the default shell

## Structure

```
fish/           Fish shell config, functions, and conf.d
nvim/           Neovim config (Lazy.nvim)
starship/       Starship prompt config
tmux/           tmux config
Brewfile        Homebrew dependencies
setup.sh        Bootstrap script
```

## Post-setup

Some tools need additional manual setup:

- **AWS CLI** — run `aws configure sso` to set up SSO profiles
- **kubectl** — configure your kubeconfig for cluster access
- **Claude CLI** — install separately via [claude.ai](https://claude.ai)
- **Local overrides** — create `~/.config/fish/local.fish` for machine-specific config (gitignored)
