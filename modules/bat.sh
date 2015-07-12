#!/bin/bash
source $PANEL_HOME/panel.cfg

if [ -e $bat ]; then
    while true; do
        buf="bat$cmd_ifs"
        case `cat $bat/capacity` in
            [0-9]|1[0-9])
                buf="$buf$fmt_bat_bad"
                ;;
            [2-5]*)
                buf="$buf$fmt_bat_ok"
                ;;
            *)
                buf="$buf$fmt_bat_good"
                ;;
        esac
        if grep -Eq 'Charging|Full' $bat/status ; then
            buf="$buf $ico_bat_charging"
        else
            buf="$buf $ico_bat_discharging"
        fi
        echo "$buf $(cat $bat/capacity)% "

        sleep 60
    done
else
    exit 1
fi
