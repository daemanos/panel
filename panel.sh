#!/usr/bin/bash
export PANEL_HOME=${XDG_CONFIG_HOME:-$HOME/.config}/panel

# configuration
source $PANEL_HOME/panel.cfg
[ -e $PANEL_HOME/prepare.sh ] && source $PANEL_HOME/prepare.sh "$@"

# create the socket if necessary
[ -e "$fifo" ] && rm "$fifo"
mkfifo "$fifo"

# kill any existing panels
killall $panel_cmd

# initiate modules
declare -A modules
for module in $PANEL_HOME/modules/*.sh ; do
    $module "$@" >"$fifo" &
done

while IFS='' read -r cmd; do
    IFS="$cmd_ifs" read -ra infos <<< "$cmd"
    modules[${infos[0]}]="${infos[1]}"

    echo "%{l-o}${modules[title]}%{c-o}${modules[tags]}%{r+o}${modules[song]}${modules[netw]}${modules[vol]}${modules[bat]}${modules[clock]}"
done <"$fifo" | $panel | $sh

wait
unset PANEL_HOME
