#! /bin/bash

command_not_found_handle()
{
    export TEXTDOMAIN=command-not-found

    local cmd state rest
    local -i pid ppid pgrp session tty_nr tpgid

    # do not run when inside Midnight Commander or within a Pipe
    if [ -n "$MC_SID" -o ! -t 1 ]; then
        echo $"$1: command not found"
        return 127
    fi

    # do not run when within a subshell
    read pid cmd state ppid pgrp session tty_nr tpgid rest  < /proc/self/stat
    if [ $$ -eq $tpgid ]; then
        echo "$1: command not found"
        return 127
    fi

    # test for /usr/sbin and /sbin
    if [ -x "/usr/sbin/$1" -o -x "/sbin/$1" ]; then
        if [ -x "/usr/sbin/$1" ]; then
            prefix='/usr';
        else
            prefix='';
        fi

        echo $"'$1' is located in '$prefix/sbin/', running it may \
require superuser privileges."

        return 127
    fi

    if [ -x /usr/bin/python ]; then
        if [ -x /usr/lib/command-not-found ]; then
            /usr/bin/python /usr/lib/command-not-found -- $1
            return $?
        fi

        if [ -x /usr/share/command-not-found ]; then
            /usr/bin/python /usr/share/command-not-found -- $1
            return $?
        fi
    fi

    # default handler
    echo "$1: command not found"
    return 127
}
