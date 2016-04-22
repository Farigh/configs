#! /bin/bash

# Define a bunch of alias
alias ls="ls --color"
alias la="ls -a"
alias ll="ls -lh"
alias lla="ls -lah"

# Common mistake
alias cd..="cd .."

# Secure operations
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
alias chmod="chmod --changes --preserve-root"

alias news="slrn"
alias md5="md5sum"
alias f="~/.apps/firefox/firefox &"

# Default to terminal version of emacs
alias emacs="emacs -nw"
alias grep="grep -nEI --color"

# Work-around to make alias works with sudo
alias sudo='sudo '
