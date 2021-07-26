#! /bin/bash

# vim: ft=sh

echo .bash_profile >&2

if type -p autotrash > /dev/null
then
    autotrash -d 15
fi

# Set MANPATH so it includes users' private man if it exists
if [ -d "${HOME}/man" ]; then
    MANPATH="${HOME}/man:${MANPATH}"
fi

# Set INFOPATH so it includes users' private info if it exists
if [ -d "${HOME}/info" ]; then
    INFOPATH="${HOME}/info:${INFOPATH}"
fi

case "$(uname -o)" in
    (Cygwin)
        # if [ -z ${DISPLAY:=""} ]
        # then
        #     export DISPLAY=':0.0'
        # fi

        export TMPDIR=${TMPDIR:-${ORIGINAL_TEMP:-/tmp}}

        export SSH_AUTH_SOCK=${TMPDIR:-/tmp}/.ssh-pageant
        eval $(ssh-pageant -ra "$SSH_AUTH_SOCK")
        ;;
esac

EDITOR=emacs

[[ -x ~/.bashrc ]] && . ~/.bashrc
