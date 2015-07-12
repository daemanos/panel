#!/bin/bash
source $PANEL_HOME/panel.cfg

pull() {
    buf="netw$cmd_ifs"
    qual=`iwconfig net0 | grep 'Link' | sed -r 's/^.*Link Quality=(.*)\/70.*$/\1/g'`
    if [ $qual ]; then
        [ $qual -gt 50 ] && buf="$buf$fmt_good" || buf="$buf$fmt_ok"
        essid=`iwconfig net0 | head -1 | sed -r 's/^.*ESSID:(.*)$/\1/g' | tr -d '" '`
        echo "$buf $ico_wifi $essid "
    else
        echo "$buf$fmt_bad $ico_wifi_off "
    fi
}

if [ -e /sys/class/net/$netw_interface ]; then
    pull
    iwevent | while read; do
        pull
    done
else
    exit 1
fi
