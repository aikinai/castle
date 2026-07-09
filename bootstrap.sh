#!/usr/bin/env bash
# Idempotent new-Mac bootstrap for the aikinai/castle Homeshick castle.
# Safe to re-run. Does not force-push, overwrite SSH keys, or build ffmpeg.
set -euo pipefail

CASTLE_ROOT="$(cd "$(dirname "$0")" && pwd)"
HOMESHICK_DIR="${HOMESHICK_DIR:-$HOME/.homesick/repos/homeshick}"
CASTLE_DIR="${CASTLE_DIR:-$HOME/.homesick/repos/castle}"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM_DIR:-$HOME/.oh-my-zsh-custom}"

log()  { printf '\n\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

clone_or_update() {
  local url="$1" dest="$2"
  if [[ -d "$dest/.git" ]]; then
    git -C "$dest" pull --ff-only || warn "could not update $dest (continuing)"
  elif [[ -e "$dest" ]]; then
    warn "$dest exists but is not a git repo; skipping clone of $url"
  else
    git clone --depth=1 "$url" "$dest"
  fi
}

# ── Homebrew ──────────────────────────────────────────────────────────
install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew already installed"
  else
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  command -v brew >/dev/null 2>&1 || die "brew not on PATH after install"
}

brew_bundle() {
  log "Installing packages from Brewfile"
  brew bundle --file="$CASTLE_ROOT/Brewfile"
}

# ── Homeshick + castle ────────────────────────────────────────────────
install_homeshick_and_link() {
  log "Homeshick + castle"
  mkdir -p "$HOME/.homesick/repos"
  clone_or_update https://github.com/andsens/homeshick.git "$HOMESHICK_DIR"

  if [[ ! -d "$CASTLE_DIR/.git" ]]; then
    if [[ "$CASTLE_ROOT" != "$CASTLE_DIR" ]]; then
      clone_or_update https://github.com/aikinai/castle.git "$CASTLE_DIR"
    else
      # Already running from a castle checkout; ensure it is registered under homesick.
      if [[ "$(cd "$CASTLE_ROOT" && pwd -P)" != "$(cd "$CASTLE_DIR" 2>/dev/null && pwd -P)" ]]; then
        mkdir -p "$(dirname "$CASTLE_DIR")"
        ln -sfn "$CASTLE_ROOT" "$CASTLE_DIR"
      fi
    fi
  fi

  # shellcheck source=/dev/null
  source "$HOMESHICK_DIR/homeshick.sh"
  homeshick link castle
}

# ── Oh My Zsh + plugins ───────────────────────────────────────────────
install_oh_my_zsh() {
  log "Oh My Zsh and custom plugins"
  clone_or_update https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"

  # ZSH_CUSTOM must match home/.zshrc (not ~/.oh-my-zsh/custom).
  mkdir -p "$ZSH_CUSTOM_DIR/plugins" "$ZSH_CUSTOM_DIR/themes"

  clone_or_update https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
  clone_or_update https://github.com/jeffreytse/zsh-vi-mode.git \
    "$ZSH_CUSTOM_DIR/plugins/zsh-vi-mode"
  clone_or_update https://github.com/zsh-users/zsh-autosuggestions.git \
    "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
  clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"

  # Prebuilt gitstatusd for p10k VCS segment (clone does not always include it).
  local gitstatus_install="$ZSH_CUSTOM_DIR/themes/powerlevel10k/gitstatus/install"
  if [[ -x "$gitstatus_install" ]]; then
    "$gitstatus_install" -f || warn "gitstatus install failed (p10k git segment may show errors)"
  fi
}

set_default_shell() {
  log "Default shell → Homebrew zsh"
  local brew_zsh
  brew_zsh="$(brew --prefix)/bin/zsh"
  [[ -x "$brew_zsh" ]] || die "expected zsh at $brew_zsh"

  if ! grep -qxF "$brew_zsh" /etc/shells 2>/dev/null; then
    echo "$brew_zsh" | sudo tee -a /etc/shells >/dev/null
  fi

  if [[ "$(dscl . -read "/Users/$USER" UserShell 2>/dev/null | awk '{print $2}')" != "$brew_zsh" ]]; then
    chsh -s "$brew_zsh" || warn "chsh failed; run: chsh -s $brew_zsh"
  else
    log "Login shell already $brew_zsh"
  fi
}

# ── fzf shell integration ─────────────────────────────────────────────
install_fzf_shell() {
  log "fzf keybindings"
  local fzf_install
  fzf_install="$(brew --prefix)/opt/fzf/install"
  if [[ -x "$fzf_install" ]]; then
    # Non-interactive: keybindings + completion, no rc updates we already handle.
    "$fzf_install" --key-bindings --completion --no-update-rc --no-bash --no-fish || \
      warn "fzf install script failed; zshrc can still source brew's shell files"
  else
    warn "fzf not installed yet; re-run after brew bundle"
  fi
}

# ── tmux TPM ──────────────────────────────────────────────────────────
install_tpm() {
  log "tmux plugin manager"
  local tpm="$HOME/.tmux/plugins/tpm"
  clone_or_update https://github.com/tmux-plugins/tpm.git "$tpm"

  if command -v tmux >/dev/null 2>&1; then
    # Headless plugin install when possible.
    "$tpm/bin/install_plugins" || warn "TPM install_plugins failed (open tmux and press prefix+I)"
  fi

  if ! infocmp -x tmux-256color >/dev/null 2>&1; then
    local terminfo_src
    terminfo_src="$(echo /opt/homebrew/Cellar/tmux/*/share/terminfo/t/tmux-256color 2>/dev/null | awk '{print $1}')"
    if [[ -n "${terminfo_src:-}" && -f "$terminfo_src" ]]; then
      /usr/bin/tic -x -o "$HOME/.terminfo" "$terminfo_src" 2>/dev/null || true
    fi
  fi
}

# ── Vim plugins ───────────────────────────────────────────────────────
install_vim_plugins() {
  log "Vim plugins (vim-plug)"
  if [[ -x "$CASTLE_DIR/vim/vim-plug.sh" ]]; then
    bash "$CASTLE_DIR/vim/vim-plug.sh" || warn "vim-plug.sh failed"
  elif [[ -x "$CASTLE_ROOT/vim/vim-plug.sh" ]]; then
    bash "$CASTLE_ROOT/vim/vim-plug.sh" || warn "vim-plug.sh failed"
  else
    warn "vim-plug.sh not found"
  fi
}

# ── macOS defaults & Scripts repo ─────────────────────────────────────
macos_defaults() {
  log "macOS defaults (screenshots → ~/Downloads)"
  defaults write com.apple.screencapture location "$HOME/Downloads/"
  killall SystemUIServer 2>/dev/null || true
}

install_scripts_repo() {
  log "Scripts repo → ~/Programs/Scripts"
  mkdir -p "$HOME/Programs"
  local dest="$HOME/Programs/Scripts"
  if [[ -d "$dest/.git" ]]; then
    git -C "$dest" pull --ff-only || warn "could not update $dest"
  elif [[ -e "$dest" ]]; then
    warn "$dest exists but is not a git repo; skipping"
  else
    git clone --recursive https://github.com/aikinai/Scripts.git "$dest"
  fi
}

print_next_steps() {
  cat <<'EOF'

────────────────────────────────────────────────────────────
Bootstrap finished.

Optional / manual:
  • Ghostty font: install "PlemolJP35 Console NF" (or change Ghostty config)
  • ffmpeg: custom ARM build is optional; see README
  • Server terminfo (Ghostty / tmux-256color): see README
  • Open a new terminal, or: exec zsh -l

Day-2 updates:
  homeshick pull castle && homeshick link castle
  brew bundle --file ~/.homesick/repos/castle/Brewfile
  ~/.tmux/plugins/tpm/bin/update_plugins all
  ~/.homesick/repos/castle/vim/vim-plug.sh
────────────────────────────────────────────────────────────
EOF
}

main() {
  install_homebrew
  brew_bundle
  install_homeshick_and_link
  install_oh_my_zsh
  set_default_shell
  install_fzf_shell
  install_tpm
  install_vim_plugins
  macos_defaults
  install_scripts_repo
  print_next_steps
}

main "$@"
