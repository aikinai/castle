###############################################################################
if [[ "$OSTYPE" == 'cygwin' ]]; then
######## WINDOWS-ONLY ITEMS ###################################################

    # Color ls output
    # Ignore NTUSER registry files
    alias ls='ls --color=auto -h --ignore="NTUSER*" --ignore="ntuser*"'

    # Explicitly set terminal type so colors work correctly
    export TERM="xterm-256color"

###############################################################################
else
######## UNIX-ONLY ITEMS ######################################################

    # Color and human-readable prefixes in ls
    alias ls='ls -h --color=auto'

    # Enable programmable completion features
    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    fi

    ###########################################################################
    if [[ "$OSTYPE" == darwin* ]]; then
    ######## OS X-ONLY ITEMS ##################################################

        # Advanced Bash completion
        # Needs brew bash-completion package installed
        if [ -f /usr/local/etc/bash_completion ]; then
            . /usr/local/etc/bash_completion
        fi

        # Alias to launch MacVim better with mvim
        alias mvim='open -a MacVim'

        # Alias to launch p4merge from command line
        alias p4merge='/Applications/p4merge.app/Contents/MacOS/p4merge'

        # Add GNU coreutils to default path
        export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
        # Add GNU coreutils to defaul man path
        export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

        # Replace cal with gcal if it's installed
        if [ -f /usr/local/bin/gcal ]; then
            alias cal='gcal'
        fi

        # Use OS X specific config file for Tmux
        if command -v reattach-to-user-namespace &>/dev/null; then
            alias tmux='tmux -f ~/.tmux.osx.conf'
        else
            alias tmux='read -p "reattach-to-user-namespace is not installed.
Clipboard integration and launchctl will not function in Tmux." && tmux'
        fi

    fi
    ###########################################################################
    if [[ "$OSTYPE" == linux* ]]; then
    ######## LINUX-ONLY ITEMS #################################################

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

######## MULTI-PLATFORM ITEMS #################################################

    # Set flag if this session is interactive
    if [ -n "$PS1" ]; then
        INTERACTIVE_SESSION=true
    fi

    # Set flag if this is a remote session
    # (Code from http://unix.stackexchange.com/a/9607)
    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        REMOTE_SESSION=true
    fi

    # Set Bash to vi mode
    set -o vi

    # Set default editor to Vim
    export EDITOR=vim

    VLESS=$(find /usr/share/vim -name 'less.sh')
    if [ ! -z $VLESS ]; then
        alias less=$VLESS
    fi

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

    # Enable ** for recursive glob if bash is new enough
    if ((BASH_VERSINFO[0] >= 4)); then
        shopt -s globstar
    fi

    # Make less more friendly for non-text input files, see lesspipe(1)
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

    ########### THINGS TO SKIP FOR NON-INTERACTIVE SESSIONS ##########
    if $INTERACTIVE_SESSION; then

        # Set up colors
        DEFAULT="\[\e[0m\]"   # Revert to default
        GREEN="\[\e[0;32m\]"  # Green
        PURPLE="\[\e[1;35m\]" # Purple
        TAN="\[\e[38;05;130m\]"  # Tan


        # Displays current git branch for prompt
        function parse_git_branch {
        ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        echo "("${ref#refs/heads/}")"
        }

        # Set up prompt as below (with colors)
        # User@Host /Path (git branch)
        # $
        export PS1='\[\033k\033\\\]'
        export PS1="\n${GREEN}\u${DEFAULT}@${PURPLE}\h${DEFAULT} \w ${TAN}\$(parse_git_branch)${DEFAULT}\n"$PS1'\$ '

        # Colorize man pages
        man() {
            env \
                LESS_TERMCAP_mb=$(printf "\e[1;31m") \
                LESS_TERMCAP_md=$(printf "\e[1;31m") \
                LESS_TERMCAP_me=$(printf "\e[0m") \
                LESS_TERMCAP_se=$(printf "\e[0m") \
                LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
                LESS_TERMCAP_ue=$(printf "\e[0m") \
                LESS_TERMCAP_us=$(printf "\e[1;32m") \
                man "$@"
        }

        # Set Solarized dircolors (ls colors)
        if command -v dircolors &>/dev/null; then
            if [ -f ~/.dircolors ]; then
                eval `dircolors ~/.dircolors` # Solarized colors
            else
                eval `dircolors -b` # Default colors, just in case
            fi
        fi

    fi

# Enable Homeshick and alias 'homesick' to call Homeshick
if [ -d ~/.homesick/repos/homeshick ]; then
    source ~/.homesick/repos/homeshick/homeshick.sh
    alias homesick="homeshick"
else
    echo -e
    echo -e "\x1B[0;31mHomeshick not installed.\x1B[0m"
    echo -e "Install with:"
    echo -e "git clone git://github.com/andsens/homeshick.git ~/.homesick/repos/homeshick"
fi
