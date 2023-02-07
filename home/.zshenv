# Find out where Homebrew is installed and set root directory
if [ -f ${HOME}/.homebrew/bin/brew ]; then
  HOMEBREW="${HOME}/.homebrew"
elif [ -f /opt/homebrew/bin/brew ]; then
  HOMEBREW="/opt/homebrew"
elif [ -f /usr/local/bin/brew ]; then
  HOMEBREW="/usr/local"
fi

# Set up environment using Homebrew utilities
if [ -n $HOMEBREW ]; then
  # Set PATH with GNU utilities and Homebrew programs first
  PATH=""
  PATH+="${HOME}/Programs/Scripts/MacOS:"
  PATH+="${HOME}/Programs/Scripts/Photos:"
  PATH+="${HOME}/Programs/Scripts/Encoding:"
  PATH+="${HOME}/Programs/Selenium:"
  PATH+="${HOMEBREW}/opt/gnu-sed/libexec/gnubin:"
  PATH+="${HOMEBREW}/opt/coreutils/libexec/gnubin:"
  PATH+="${HOMEBREW}/opt/findutils/libexec/gnubin:"
  PATH+="${HOMEBREW}/opt/python/libexec/bin:"
  PATH+="${HOMEBREW}/opt/perl/bin:"
  PATH+="${HOMEBREW}/opt/ruby/bin:"
  PATH+="${HOMEBREW}/bin:"
  PATH+="${HOMEBREW}/sbin:"
  PATH+="/usr/local/bin:"
  PATH+="/usr/bin:"
  PATH+="/bin:"
  PATH+="/usr/sbin:"
  PATH+="/sbin"
  export PATH

  # Set MANPATH with GNU utilities and Homebrew programs first
  MANPATH=""
  MANPATH+="${HOMEBREW}/opt/gnu-sed/libexec/gnuman:"
  MANPATH+="${HOMEBREW}/opt/coreutils/libexec/gnuman:"
  MANPATH+="${HOMEBREW}/opt/findutils/libexec/gnuman:"
  MANPATH+="${HOMEBREW}/share/man:"
  MANPATH+="/usr/share/man"
  export MANPATH

  # Add Homebrew Vim share directory to Vim runtimepath
  LATESTVIM=$(ls ${HOMEBREW}/opt/vim/share/vim/ | sort | tail -n 1)
  export VIMRUNTIME="${HOMEBREW}/opt/vim/share/vim/${LATESTVIM}/"

  # Export Tesseract language data path
  export TESSDATA_PREFIX="${HOMEBREW}/share/tessdata/"
fi

