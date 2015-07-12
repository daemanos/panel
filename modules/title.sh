#!/bin/bash
source $PANEL_HOME/panel.cfg
xtitle -s | while read title ; do echo "title$cmd_ifs$fmt_title $title"; done
