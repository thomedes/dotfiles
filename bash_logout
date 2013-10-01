# ~/.bash_logout: executed by bash(1) when login shell exits.

if [ -x /usr/bin/ssh-pageant -a ! -z "$SSH_PAGEANT_PID" ]; then
    eval $(/usr/bin/ssh-pageant -qk 2>/dev/null)
fi

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi

