# AGENTS.md

Guidance for coding agents working in this repo.

- This repo is a portable Vim setup intended to mirror Martin's local `~/.vimrc`.
- Use `./install.sh` for installation testing; it bootstraps Vundle and installs
  plugins into `~/.vim/bundle`.
- Keep plugin source trees out of git. Add or remove plugins by editing the
  Vundle declarations in `.vimrc`, not by committing `bundle/` contents.
- Preserve dev-VM portability: guard macOS-only commands, Homebrew paths, and
  optional external binaries with `executable()` / `has()` checks.
- If you change mappings or plugin behavior, update `README.md` at the same time.
- Optimize for code-review workflows: fast search, Git diff/hunk navigation,
  diagnostics/quickfix navigation, and low-friction file/buffer switching.
- When reviewing changes in this repo, report findings first, then mention tests
  or validation. Avoid broad rewrites unless explicitly requested.
- Basic validation: run `bash -n install.sh` and load the config with
  `vim -Nu ./.vimrc -n +'qall!'` before handing off.
