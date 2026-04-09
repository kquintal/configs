# Configs — Dotfiles Repository

Personal dotfiles for fish shell, neovim, starship, and tmux.

## Repo Structure

```
fish/         — Fish shell config, completions, and functions
nvim/         — Neovim configuration
starship/     — Starship prompt config
tmux/         — Tmux configuration
```

## Security Rules

These are **non-negotiable** and apply to every commit:

- **No local/absolute paths** — Never hardcode paths like `/Users/<name>/...`. Always use `$HOME`, `~`, or environment variables.
- **No hardcoded usernames or hostnames** — Machine-specific identifiers must be parameterized.
- **No secrets or credentials** — Never commit API keys, tokens, passwords, private keys, database connection strings, or `.env` files.
- **No sensitive environment variables** — Any env var containing secrets must go in `fish/local.fish` (gitignored), not in tracked files.
- **Pre-commit audit** — Before every commit, review the full diff for leaked paths, secrets, or machine-specific values. If in doubt, ask.

## Commit Guidelines

- Use concise, descriptive commit messages in imperative mood (e.g., "Add slp function for streamling plugin dev")
- One logical change per commit — don't bundle unrelated changes
- Always review `git diff` before committing

## Fish Shell Context

- This repo targets **fish shell** — not bash or zsh
- Functions go in `fish/functions/` (one function per file, filename matches function name)
- Completions go in `fish/completions/`
- Machine-local config that shouldn't be tracked goes in `fish/local.fish` (sourced by config.fish, gitignored)

## Workflow

- Use `$HOME` or `~` for home directory references, never absolute paths
- Test config changes locally (e.g., `source ~/.config/fish/config.fish`) before committing
- When adding new tools/aliases, check if a function or completion file is more appropriate than adding to config.fish

## Session Wrap-Up

At the end of every session, write learnings, decisions, and context to `napkin.md` so future sessions can pick up where we left off.
