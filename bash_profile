#! /bin/bash

echo "=> .bash_profile"

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

