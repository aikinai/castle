######## MULTI-PLATFORM ITEMS #################################################

# Just source .bashrc
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi

###############################################################################
if [[ "$OSTYPE" == 'cygwin' ]]; then
######## WINDOWS-ONLY ITEMS ###################################################

    :

###############################################################################
else
######## UNIX-ONLY ITEMS ######################################################

    :

    ###########################################################################
    if [[ "$OSTYPE" == linux* ]]; then
    ######## LINUX-ONLY ITEMS #################################################

        # # Make byobu run on login
        # _byobu_sourced=1 . /usr/bin/byobu-launch

        # Run anacron jobs
        /usr/sbin/anacron -t ~/.anacron/etc/anacrontab -S ~/.anacron/spool

    fi
fi
