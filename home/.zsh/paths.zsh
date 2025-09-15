typeset -U path manpath  # dedupe

# Prepend custom PATHs
path=(
  "$HOME/Programs/Scripts/MacOS"
  "$HOME/Programs/Scripts/Photos"
  "$HOME/Programs/Scripts/Encoding"
  "$HOME/Programs/Selenium"
  "$HOME/.cargo/bin"
  ${HOMEBREW:+$HOMEBREW/opt/gnu-sed/libexec/gnubin}
  ${HOMEBREW:+$HOMEBREW/opt/coreutils/libexec/gnubin}
  ${HOMEBREW:+$HOMEBREW/opt/findutils/libexec/gnubin}
  ${HOMEBREW:+$HOMEBREW/opt/python/libexec/bin}
  ${HOMEBREW:+$HOMEBREW/opt/perl/bin}
  ${HOMEBREW:+$HOMEBREW/opt/ruby/bin}
  ${HOMEBREW:+$HOMEBREW/bin}
  ${HOMEBREW:+$HOMEBREW/sbin}
  $path
)

manpath=(
  ${HOMEBREW:+$HOMEBREW/opt/gnu-sed/libexec/gnuman}
  ${HOMEBREW:+$HOMEBREW/opt/coreutils/libexec/gnuman}
  ${HOMEBREW:+$HOMEBREW/opt/findutils/libexec/gnuman}
  ${HOMEBREW:+$HOMEBREW/share/man}
  $manpath
)

export PATH MANPATH
