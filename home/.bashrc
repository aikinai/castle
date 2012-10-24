######## MULTI-PLATFORM ITEMS #################################################

    # Use Vim's less script as an alias for less
    VLESS=$(find /usr/share/vim -name 'less.sh')
    if [ ! -z $VLESS ]; then
        alias less=$VLESS
    fi
    
    #Set Bash to vi mode
    set -o vi
    
    # Set default editor to Vim
    export EDITOR=vim
    
    # Unicode gpg
    alias gpg='gpg2 --display-charset utf-8'
    
    # Color and prefixes in ls
    alias ls='ls -Gh'
    
    # When changing directory small typos can be ignored by bash
    # for example, cd /vr/lgo/apaache would find /var/log/apache
     shopt -s cdspell

    # Ignore some controlling instructions
    # HISTIGNORE is a colon-delimited list of patterns which should be excluded.
    # The '&' is a special pattern which suppresses duplicate entries.
    export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well

    # Set locale so Japanese works
    export LANG=en_US.UTF-8

###############################################################################
if [[ "$OSTYPE" == 'cygwin' ]]; then
######## WINDOWS-ONLY ITEMS ###################################################

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

###############################################################################
else
######## UNIX-ONLY ITEMS ######################################################

    # Alias to launch p4merge from command line
    alias p4merge='/Applications/p4merge.app/Contents/MacOS/p4merge'

    ###########################################################################
    if [[ "$OSTYPE" == darwin* ]]; then
    ######## OS X-ONLY ITEMS ##################################################
    
        # Advanced Bash completion
        # Needs brew bash-completion package installed
        if [ -f `brew --prefix`/etc/bash_completion ]; then
            . `brew --prefix`/etc/bash_completion
        fi

    fi
###########################################################################
fi
###############################################################################
if [[ "$HOSTNAME" == NST* ]]; then
######## NINTENDO MACHINES ONLY ###############################################

source ~/.bashrc.nst

###############################################################################
fi
