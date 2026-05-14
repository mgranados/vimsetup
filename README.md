# vimsetup

Portable Vim setup for Martin. The repo now mirrors the plugin set and mappings
from this computer's local `~/.vimrc`, but is arranged so it can bootstrap a
fresh dev VM.

## Quick start on a dev VM

```sh
git clone <this-repo-url> ~/vimsetup
cd ~/vimsetup
./install.sh
```

The installer backs up any existing `~/.vimrc`, symlinks this repo's `.vimrc`,
installs Vundle in `~/.vim/bundle/Vundle.vim`, then runs `:PluginInstall`.

If you prefer a copied config instead of a symlink:

```sh
./install.sh --copy
```

## Recommended VM packages

For full feature parity with the local setup:

```sh
sudo apt-get update
sudo apt-get install -y vim-nox git curl ripgrep silversearcher-ag python3-pip python3-venv black flake8
```

Notes:

- Use `vim-nox` rather than `vim-tiny`; it has the Vim features needed for
  Python formatting and LSP work. Use `vim-gtk3` instead if you also need
  system clipboard support in a graphical/forwarded session.
- `rg` powers the preferred fast file/search path for review work.
- `ag` is kept as a fallback for `:Ag` and CtrlP search.
- `black` powers the `<F9>` formatter mapping.
- `flake8` is used by the Python linting plugins.
- `vim-lsp-settings` can install language servers from inside Vim for languages
  you use in the VM.

## Important mappings

| Mapping | Action |
| --- | --- |
| `<C-n>` | Open NERDTree |
| `<C-t>` | Toggle NERDTree |
| `<C-f>` | Find current file in NERDTree |
| `<leader>m` | CtrlP file finder |
| `<C-s>` | `:Ag` search |
| `<leader>ag` | Search word under cursor with `:Ag` |
| `<leader>rg` | Search with ripgrep when available, fallback to `:Ag` |
| `<leader>f` | FZF file picker |
| `<leader>b` | FZF buffer picker |
| `<F9>` | Format with Black |
| `<leader>jd` | Go to definition via vim-lsp |
| `<leader>ji` | Find references via vim-lsp |
| `<leader>gb` | Toggle Blamer |
| `<leader>gs` | Open Fugitive Git status |
| `<leader>gd` | Diff current file with Git index/worktree |
| `<leader>gB` | Fugitive blame |
| `]h` / `[h` | Next/previous Git hunk |
| `<leader>hp` | Preview current Git hunk |
| `]q` / `[q` | Next/previous quickfix item |
| `<leader>co` / `<leader>cc` | Open/close quickfix list |
| `]l` / `[l` | Next/previous location-list item |
| `<leader>lo` / `<leader>lc` | Open/close location list |
| `<leader>tw` | Toggle visible whitespace |
| `<leader>yl` | Copy `relative/path:line` for review comments |
| `<space>` | Toggle fold |

This config intentionally keeps Vim's default leader (`\`) to match the current
local `~/.vimrc`.

## Review-oriented workflow

For reviewing code, open Vim from the project root and lean on:

1. `<leader>gs` for a Git status overview.
2. `<leader>gd` plus `]h` / `[h` to inspect changed hunks.
3. `<leader>rg`, `<leader>f`, and `<leader>b` to jump around quickly.
4. `:LspDocumentDiagnostics`, `]q` / `[q`, and location-list mappings for issues.
5. `<leader>tw` when whitespace changes matter.
6. `<leader>yl` to copy a `relative/path:line` reference for review comments.

## Repo maintenance

Plugins are declared in `.vimrc` and installed by Vundle. Do not commit plugin
source trees into this repo; they belong in `~/.vim/bundle` on each machine.

The old repo committed stale Pathogen plugin copies. Those were removed in favor
of a reproducible Vundle install that matches the active local configuration.
