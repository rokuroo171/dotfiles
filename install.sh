#!/bin/sh

set -e

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
  --dry-run | -d)
    DRY_RUN=1
    printf "${YELLOW}Running in dry-run mode.${RESET}\n\n"
    ;;
  esac
done

info() {
  printf "${BOLD}${GREEN}==>${RESET} %s\n" "$1"
}

warn() {
  printf "${YELLOW}[backup]${RESET} %s\n" "$1"
}

link() {
  printf "  ${BOLD}[link]${RESET} %s -> %s\n" "$1" "$2"
}

safe_link() {
  src="$1"
  dest="$2"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
      warn "Would backup $dest -> ${dest}.bak"
    else
      mv "$dest" "${dest}.bak"
    fi
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    link "$src" "$dest"
  else
    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    link "$src" "$dest"
  fi
}

build_suckless_tool() {
  name="$1"
  url="$2"
  cfg="$DOTFILES/specific/suckless/$name/config.h"

  if [ -f "$cfg" ]; then
    info "Building $name"
    if [ ! -d "$LOCAL_SRC/$name" ]; then
      git clone "$url" "$LOCAL_SRC/$name"
    fi
    cp "$cfg" "$LOCAL_SRC/$name/config.h"
    (cd "$LOCAL_SRC/$name" && sudo make clean install)
  fi
}

info "Linking core applications"
for app_path in "$DOTFILES/core/"*; do
  [ -d "$app_path" ] || continue
  app_name="$(basename "$app_path")"

  case "$app_name" in
  mksh | git | shell) continue ;;
  esac

  safe_link "$app_path" "$XDG_CONFIG_HOME/$app_name"
done

if [ -f "$DOTFILES/core/starship.toml" ]; then
  safe_link "$DOTFILES/core/starship.toml" "$XDG_CONFIG_HOME/starship.toml"
fi

if [ -f "$DOTFILES/core/mksh/mkshrc" ]; then
  safe_link "$DOTFILES/core/mksh/mkshrc" "$HOME/.mkshrc"
fi

if [ "$DRY_RUN" -eq 0 ]; then
  printf "\nBuild suckless tools (dwm/st)? [y/N]: "
  read -r build_suckless
else
  build_suckless="n"
fi

if [ "$build_suckless" = "y" ] || [ "$build_suckless" = "Y" ]; then
  LOCAL_SRC="$HOME/.local/src"
  mkdir -p "$LOCAL_SRC"
  build_suckless_tool "dwm" "https://git.suckless.org/dwm"
  build_suckless_tool "st" "https://git.suckless.org/st"
fi

printf "\n${BOLD}${GREEN}Done.${RESET}\n"
