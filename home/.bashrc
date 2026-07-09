# Minimal bashrc for rare non-zsh invocations (scripts, scp edge cases, etc.).
# Primary interactive shell is zsh — see ~/.zshrc.

export LANG="${LANG:-en_US.UTF-8}"
export EDITOR="${EDITOR:-vim}"

# Prefer Homebrew bins when present (Apple Silicon, Intel, or custom prefix).
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x "$HOME/.homebrew/bin/brew" ]]; then
  eval "$("$HOME/.homebrew/bin/brew" shellenv)"
fi

# Homeshick
if [[ -f "$HOME/.homesick/repos/homeshick/homeshick.sh" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.homesick/repos/homeshick/homeshick.sh"
  alias homesick=homeshick
fi
