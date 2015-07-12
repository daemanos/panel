#!/bin/bash
source $PANEL_HOME/panel.cfg
while true; do
    echo "clock$cmd_ifs$fmt_clock $(date +"$clock_fmt" | sed 's/^ *//') "
    sleep 5
done
