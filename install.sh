#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./install.sh [--copy] [--no-plugins]

Installs this repo's Vim setup for the current user:
  - backs up an existing ~/.vimrc when needed
  - symlinks ~/.vimrc to this repo's .vimrc by default
  - bootstraps Vundle into ~/.vim/bundle/Vundle.vim
  - runs :PluginInstall unless --no-plugins is passed

Options:
  --copy        copy .vimrc instead of symlinking it
  --no-plugins  only install ~/.vimrc and Vundle, skip PluginInstall
  -h, --help    show this help
USAGE
}

mode="symlink"
install_plugins="yes"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy)
      mode="copy"
      ;;
    --no-plugins)
      install_plugins="no"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

need_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

warn_missing() {
  if ! command -v "$1" >/dev/null 2>&1; then
    missing_optional+=("$1")
  fi
}

need_command git
need_command vim

repo_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
vimrc_src="$repo_dir/.vimrc"
vimrc_dest="${VIMRC_DEST:-$HOME/.vimrc}"
vim_dir="${VIM_DIR:-$HOME/.vim}"
bundle_dir="$vim_dir/bundle"
vundle_dir="$bundle_dir/Vundle.vim"

mkdir -p "$bundle_dir"

if [[ "$mode" == "symlink" && -L "$vimrc_dest" && "$(readlink "$vimrc_dest")" == "$vimrc_src" ]]; then
  echo "~/.vimrc already points at $vimrc_src"
else
  if [[ -e "$vimrc_dest" || -L "$vimrc_dest" ]]; then
    backup="$vimrc_dest.backup.$(date +%Y%m%d%H%M%S)"
    mv "$vimrc_dest" "$backup"
    echo "Backed up existing ~/.vimrc to $backup"
  fi

  if [[ "$mode" == "copy" ]]; then
    cp "$vimrc_src" "$vimrc_dest"
    echo "Copied .vimrc to $vimrc_dest"
  else
    ln -s "$vimrc_src" "$vimrc_dest"
    echo "Symlinked $vimrc_dest -> $vimrc_src"
  fi
fi

if [[ -d "$vundle_dir/.git" ]]; then
  echo "Updating Vundle..."
  git -C "$vundle_dir" pull --ff-only
else
  echo "Installing Vundle..."
  rm -rf "$vundle_dir"
  git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git "$vundle_dir"
fi

if [[ "$install_plugins" == "yes" ]]; then
  echo "Installing Vim plugins with Vundle..."
  vim -Nu "$vimrc_dest" -n +PluginInstall +qall

  if [[ -x "$bundle_dir/fzf/install" ]]; then
    echo "Installing fzf binary..."
    "$bundle_dir/fzf/install" --bin || echo "fzf binary install failed; install fzf manually if :Files is unavailable." >&2
  fi
fi

missing_optional=()
warn_missing rg
warn_missing ag
warn_missing python3
warn_missing black
warn_missing flake8

if [[ ${#missing_optional[@]} -gt 0 ]]; then
  cat <<EOF

Optional commands not found: ${missing_optional[*]}
For full parity on Debian/Ubuntu dev VMs, install something like:
  sudo apt-get update
  sudo apt-get install -y vim-nox git curl ripgrep silversearcher-ag python3-pip python3-venv black flake8
EOF
fi

vim_version="$(vim --version)"
missing_vim_features=()
for feature in +python3 +job +channel +timers; do
  if ! grep -Fq "$feature" <<<"$vim_version"; then
    missing_vim_features+=("$feature")
  fi
done

if [[ ${#missing_vim_features[@]} -gt 0 ]]; then
  cat <<EOF

Your Vim is missing features used by this setup: ${missing_vim_features[*]}
On Ubuntu, install vim-nox for terminal use or vim-gtk3 if you also need
system clipboard support.
EOF
fi

if ! grep -Fq '+clipboard' <<<"$vim_version"; then
  echo "Note: this Vim lacks +clipboard; editor use is fine, but system clipboard integration will be limited."
fi

echo "Vim setup complete. Open vim and run :PluginUpdate later when you want updates."
