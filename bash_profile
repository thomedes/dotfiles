#! /bin/bash

echo "=> .bash_profile"

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
        SSH_ENV="$HOME/.ssh-environment"

        function start_pageant {
            echo "Initializing new SSH agent..."
            ssh-pageant.exe | sed 's/^echo/#echo/' > "${SSH_ENV}"
            echo "succeded"
            chmod 600 "${SSH_ENV}"
            . "${SSH_ENV}" > /dev/null
            #/usr/bin/ssh-add;
        }

        if [[ -f "${SSH_ENV}" ]]
        then
            . "${SSH_ENV}" > /dev/null
            if ! ps -ef | grep $SSH_PAGEANT_PID | grep ssh-pageant$ > /dev/null
            then
                start_pageant
            fi
        else
            start_pageant;
        fi
        ;;
esac

[[ -r ~/.bashrc ]] && . ~/.bashrc

if [ -z "$SSH_AUTH_SOCK" -a -x /usr/bin/ssh-pageant ]; then
    eval $(/usr/bin/ssh-pageant -q)
fi
trap logout HUP

__git_ps1 () {
    local b="$(git symbolic-ref HEAD 2>/dev/null)"
    if [ -n "$b" ]; then 
        echo "(${b##refs/heads/}) "; 
    fi
}

export PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\n\$(__git_ps1)\[\e[0m\]\$ "

