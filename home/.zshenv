# Always loaded (login, interactive, non-interactive). Keep this light.

# Detect Homebrew prefix for later PATH construction.
if [[ -x "$HOME/.homebrew/bin/brew" ]]; then
  export HOMEBREW="$HOME/.homebrew"
elif [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW=/opt/homebrew
elif [[ -x /usr/local/bin/brew ]]; then
  export HOMEBREW=/usr/local
else
  unset HOMEBREW
fi

# Ensure brew + system bins are available early (e.g. mosh-server under ssh/mosh).
if [[ -n "$HOMEBREW" && -x "$HOMEBREW/bin/brew" ]]; then
  eval "$("$HOMEBREW/bin/brew" shellenv)"
else
  export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin${PATH:+:$PATH}"
fi
