# Clear-up display
clear

# Setup default editor
export EDITOR='emacs -nw'

# Setup ls colors
export LS_COLORS="~/.ls_color"
eval `dircolors ~/.ls_color`

export PATH="/usr/lib/ccache/:$PATH"

export TERM=xterm-256color;

################
# config files #
################

# Inport all bash configurations
if [ -x ~/.bashconfig/ ]; then
    for i in `ls ~/.bashconfig/*.bash`; do
        source $i;
    done;
fi
