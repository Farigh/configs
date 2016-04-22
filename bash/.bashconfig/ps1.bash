#! /bin/bash

# Common colors
RESET_COLOR='\033[00m'
BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
RED='\033[0;31m'
LGHT_RED='\033[1;31m'
GREEN='\033[0;32m'
LGHT_GREEN='\033[1;32m'
BROWN='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LGHT_BLUE='\033[1;34m'
PURPLE='\033[0;35m'
LGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
LGHT_CYAN='\033[1;36m'
LGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'

# Detect chroot
if [ "x${debian_chroot}" != "x" ]; then
    displayed_host="${debian_chroot}"
elif [ "x${SCHROOT_SESSION_ID}" != "x" ]; then
    displayed_host="${SCHROOT_SESSION_ID}"
else
    displayed_host="\h"
fi

# root prompt :
#   "\nh:m [ ${USER}@${hostname} | ret = ${LAST_RETURN} > ${PATH}\n# "
# chroot prompt :
#   "\nh:m [ ${USER}@${chrootname} | ret = ${LAST_RETURN} > ${PATH}\n$ "
# default prompt :
#   "\nh:m [ ${USER}@${hostname} | ret = ${LAST_RETURN} > ${PATH}\n$ "
if [ "$USER" = "root" ]; then
    PS1="\n${LGHT_RED}\A${RESET_COLOR} [ ${LGHT_RED}\u${RESET_COLOR}@${YELLOW}"
    PS1="${PS1}${displayed_host}${RESET_COLOR} | ${PURPLE} ret = \$? "
    PS1="${PS1}${RESET_COLOR} > ${LGHT_BLUE}\w${RESET_COLOR}\n# "
else
    PS1="\n${LGHT_RED}\A${RESET_COLOR} [ ${GREEN}\u${RESET_COLOR}@${YELLOW}"
    PS1="${PS1}${displayed_host}${RESET_COLOR} | ${PURPLE} ret = \$? "
    PS1="${PS1}${RESET_COLOR} > ${LGHT_BLUE}\w${RESET_COLOR}\n$ "
fi
