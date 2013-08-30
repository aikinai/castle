######## MULTI-PLATFORM ITEMS #################################################

    # If not running interactively, don't do anything
    [ -z "$PS1" ] && return

    # Set Bash to vi mode
    set -o vi

    # Set default editor to Vim
    export EDITOR=vim

# vimpage screws up color in git output, so don't do this for now
#     # If vimpager is installed, use that for less and all paging
#     if command -v vimpager > /dev/null; then
#         export PAGER=vimpager
#         alias less=$PAGER
#     else
        # Otherwise, use Vim's built-in less script
        VLESS=$(find /usr/share/vim -name 'less.sh')
        if [ ! -z $VLESS ]; then
            alias less=$VLESS
        fi
#     fi

    # Unicode gpg
    alias gpg='gpg2 --display-charset utf-8'

    # Set Git SSL certificate
    # .gitconfig can't expand ~/ or $HOME, so I have to put this here
    # where it overrides the setting in .gitconfig anyway
    export GIT_SSL_CERT=$HOME/.certs/gateway.pem

    # When changing directory small typos can be ignored by bash
    # for example, cd /vr/lgo/apaache would find /var/log/apache
    shopt -s cdspell

    # Ignore some controlling instructions
    # HISTIGNORE is a colon-delimited list of patterns which should be excluded.
    # The '&' is a special pattern which suppresses duplicate entries.
    export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

    # Set locale so Japanese works
    export LANG=en_US.UTF-8

    # Alias sudo so that sudo aliases work
    alias sudo='sudo '

    # Color grep output
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # Don't put duplicate lines or lines starting with a space in the history.
    # See bash(1) for more options
    HISTCONTROL=ignoreboth

    # Append to the history file, don't overwrite it
    shopt -s histappend

    # For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
    HISTSIZE=50000
    HISTFILESIZE=50000

    # Check the window size after each command and, if necessary,
    # Update the values of LINES and COLUMNS.
    shopt -s checkwinsize

    # Make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    # Set up a cool prompt
    function parse_git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "("${ref#refs/heads/}")"
    }

    export PS1='\[\033k\033\\\]'
  # export PS1="\n\[\033[1;32m\]\u\033[0m\]@\033[1;35m\]\h\033[0m\] \w\n"$PS1'\$ '
    export PS1="\n\[\033[1;32m\]\u\033[0m\]@\033[1;35m\]\h\033[0m\] \w \033[38;05;17m\]\$(parse_git_branch)\033[0m\]\n"$PS1'\$ '

    # Set flag if this is a remote session
    # (Code from http://unix.stackexchange.com/a/9607)
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        REMOTE_SESSION=true
    else
        case $(ps -o comm= -p $PPID) in
            sshd|*/sshd) REMOTE_SESSION=true;;
        esac
    fi

###############################################################################
if [[ "$OSTYPE" == 'cygwin' ]]; then
######## WINDOWS-ONLY ITEMS ###################################################

    # Color ls output
    alias ls='ls --color=auto -h --ignore="[NTUSER|ntuser]*"'

    # Set colors for local shells only
    if ! [ -n "$REMOTE_SESSION" ]
    then
        # Set shell colors to Base16 Monokai
        ~/.scripts/base16-monokai.dark.sh
    fi

###############################################################################
else
######## UNIX-ONLY ITEMS ######################################################

    # If not running interactively, don't do anything
    [ -z "$PS1" ] && return

    # Enable programmable completion features
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    fi

    ###########################################################################
    if [[ "$OSTYPE" == darwin* ]]; then
    ######## OS X-ONLY ITEMS ##################################################
    
        # Color and prefixes in ls
        #alias ls='ls -Gh'
        alias ls='ls -h --color=auto'

        # Advanced Bash completion
        # Needs brew bash-completion package installed
        if [ -f `brew --prefix`/etc/bash_completion ]; then
            . `brew --prefix`/etc/bash_completion
        fi

        # Set colors for local shells only
        if ! [ -n "$REMOTE_SESSION" ]
        then
            # Use Monokai with profile-adjusted colors
            ~/.scripts/base16-monokai.iTerm.sh
        fi

        # Alias to launch MacVim better with mvim
        alias mvim='open -a MacVim'

        # Alias to launch p4merge from command line
        alias p4merge='/Applications/p4merge.app/Contents/MacOS/p4merge'

        # Add GNU coreutils to default path
        export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
        # Add GNU coreutils to defaul man path
        export MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"

    fi
    ###########################################################################
    if [[ "$OSTYPE" == linux* ]]; then
    ######## LINUX-ONLY ITEMS #################################################

        # Color ls output
        alias ls='ls --color=auto -h'

        # Set variable identifying the chroot you work in
        # (used in the prompt below)
        if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
            debian_chroot=$(cat /etc/debian_chroot)
        fi

        # Set a fancy prompt (non-color, unless we know we "want" color)
        case "$TERM" in
            xterm-color) color_prompt=yes;;
        esac

    fi
###########################################################################
fi
###############################################################################
if [[ "$HOSTNAME" == NST* ]]; then
######## NINTENDO MACHINES ONLY ###############################################

source ~/.bashrc.nst

###############################################################################
fi
