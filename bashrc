#! /bin/bash

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

#echo "=> .bashrc"   # incompatible with rsync

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

[[ -d ~/bin ]] && export PATH=~/bin:"$PATH"

if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Note: PS1 and umask are already set in /etc/profile. You should not
# need this unless you want different defaults for root.
# PS1='${debian_chroot:+($debian_chroot)}\h:\w\$ '
# umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
# export LS_OPTIONS='--color=auto'
# eval "`dircolors`"
# alias ls='ls $LS_OPTIONS'
# alias ll='ls $LS_OPTIONS -l'
# alias l='ls $LS_OPTIONS -lA'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='/bin/ls -F --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='/bin/grep --color=auto'
    alias fgrep='/bin/fgrep --color=auto'
    alias egrep='/bin/egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if which git && ! type -t __git_ps1; then
    __git_ps1 () {
        local b="$(git symbolic-ref HEAD 2>/dev/null)"
        if [ -n "$b" ]; then 
            echo " (${b##refs/heads/})"; 
        fi
    }
fi > /dev/null

genPS1 () {
    if which tput > /dev/null; then
        local bold="$(      tput bold   )"
        local reset="$(     tput sgr0   )"

        local black="$reset$(   tput setf 0 )"  #   0: Black        / Dark gray
        local blue="$reset$(    tput setf 1 )"  #   1: Dark Blue    / Blue
        local green="$reset$(   tput setf 2 )"  #   2: Dark Green   / Green
        local cyan="$reset$(    tput setf 3 )"  #   3: Dark Cyan    / Cyan
        local red="$reset$(     tput setf 4 )"  #   4: Dark Red     / Red
        local magenta="$reset$( tput setf 5 )"  #   5: Dark Magenta / Magenta
        local brown="$reset$(   tput setf 6 )"  #   6: Brown        / Yellow
        local gray="$reset$(    tput setf 7 )"  #   7: Gray         / White
    
        local dark_gray="$bold$(    tput setf 0 )"  #   0: Black        / Dark gray
        local light_blue="$bold$(     tput setf 1 )"  #   1: Dark Blue    / Blue
        local light_green="$bold$(    tput setf 2 )"  #   2: Dark Green   / Green
        local light_cyan="$bold$(     tput setf 3 )"  #   3: Dark Cyan    / Cyan
        local light_red="$bold$(      tput setf 4 )"  #   4: Dark Red     / Red
        local light_magenta="$bold$(  tput setf 5 )"  #   5: Dark Magenta / Magenta
        local yellow="$bold$(    tput setf 6 )"  #   6: Brown        / Yellow
        local white="$bold$(     tput setf 7 )"  #   7: Gray         / White
    else
        # Use ANSI colors
        local bold="\033[1m"
        local reset="\033[0m$gray"

        local black="$reset\033[30m"
        local red="$reset\033[31m"
        local green="$reset\033[32m"
        local brown="$reset\033[33m"
        local blue="$reset\033[34m"
        local magenta="$reset\033[35m"
        local cyan="$reset\033[36m"
        local gray="$reset\033[37m"

        local dark_black="$bold\033[30m"
        local light_red="$bold\033[31m"
        local light_green="$bold\033[32m"
        local yellow="$bold\033[33m"
        local light_blue="$bold\033[34m"
        local light_magenta="$bold\033[35m"
        local light_cyan="$bold\033[36m"
        local white="$bold\033[37m"
    fi

    # Color scheme
    local cs=($yellow $white $light_green $light_red $light_cyan)

    echo -n "${cs[0]}\u${cs[1]}@${cs[2]}\h ${cs[3]}\w"
    
    if type -t __git_ps1 > /dev/null; then
      echo -n "${cs[4]}\$(__git_ps1)"
    fi
    
    echo "$reset\n\$ "
}
PS1="$(genPS1)"

unset genPS1

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [[ $(uname -o) != Cygwin ]]; then    
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi
fi
