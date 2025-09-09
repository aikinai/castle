# Set HOMEBREW for later use in PATHs
if [[ -x "$HOME/.homebrew/bin/brew" ]]; then
  export HOMEBREW="$HOME/.homebrew"
elif [[ -x "/opt/homebrew/bin/brew" ]]; then
  export HOMEBREW="/opt/homebrew"
elif [[ -x "/usr/local/bin/brew" ]]; then
  export HOMEBREW="/usr/local"
else
  unset HOMEBREW
fi
