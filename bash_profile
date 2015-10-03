#! /bin/bash

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
  PATH="${HOME}/bin:${PATH}"
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
        export TMPDIR=${TMPDIR:-${ORIGINAL_TEMP:-/tmp}}

        export SSH_AUTH_SOCK=${TMPDIR:-/tmp}/.ssh-socket
        ssh-pageant -ra "$SSH_AUTH_SOCK" > /dev/null
        ;;
esac

EDITOR=emacs

[[ -r ~/.bashrc ]] && . ~/.bashrc
