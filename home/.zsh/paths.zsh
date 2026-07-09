typeset -U path manpath

# Personal tools and GNU utilities from Homebrew (prepend).
path=(
  "$HOME/Programs/Scripts/MacOS"
  "$HOME/Programs/Scripts/Photos"
  "$HOME/Programs/Scripts/Encoding"
  "$HOME/Programs/Selenium"
  "$HOME/.cargo/bin"
  ${HOMEBREW:+$HOMEBREW/opt/gnu-sed/libexec/gnubin}
  ${HOMEBREW:+$HOMEBREW/opt/coreutils/libexec/gnubin}
  ${HOMEBREW:+$HOMEBREW/opt/findutils/libexec/gnubin}
  ${HOMEBREW:+$HOMEBREW/opt/grep/libexec/gnubin}
  ${HOMEBREW:+$HOMEBREW/opt/python/libexec/bin}
  ${HOMEBREW:+$HOMEBREW/opt/perl/bin}
  ${HOMEBREW:+$HOMEBREW/opt/ruby/bin}
  $path
)

manpath=(
  ${HOMEBREW:+$HOMEBREW/opt/gnu-sed/libexec/gnuman}
  ${HOMEBREW:+$HOMEBREW/opt/coreutils/libexec/gnuman}
  ${HOMEBREW:+$HOMEBREW/opt/findutils/libexec/gnuman}
  ${HOMEBREW:+$HOMEBREW/opt/grep/libexec/gnuman}
  ${HOMEBREW:+$HOMEBREW/share/man}
  $manpath
)

export PATH MANPATH
