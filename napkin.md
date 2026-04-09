# Napkin — Session Learnings & Notes

Running log of learnings, decisions, and context from Claude Code sessions.

---

## 2026-04-09

- Created `CLAUDE.md` with security rules (no local paths, no secrets, no hardcoded usernames), commit guidelines, and fish shell context
- Created `napkin.md` for cross-session memory persistence
- Added `slp` fish function for local streamling plugin development (builds goldsky plugins crate, runs streamling with the compiled `.dylib`)
- Added `WORK_HOME` env var to `config.fish` — uses `$HOME` to avoid path leaks
- Repo uses `fish/local.fish` (gitignored) for machine-specific secrets and config
