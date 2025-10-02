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

# Ensure PATH always contains Homebrew + system bins (login, interactive, non-interactive)
# Put brew first so mosh-server is found.
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin${PATH:+:$PATH}"
