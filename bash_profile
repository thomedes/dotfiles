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
        SSH_ENV=~/.ssh-environment

        function start_pageant {
            echo "Initializing new SSH agent..."
            case "$(uname -m)" in
                (x86_64)
                    ssh-pageant-64.exe
                    ;;
                (*)
                    ssh-pageant.exe
                    ;;
            esac | sed 's/^echo/#echo/' > "${SSH_ENV}"
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

