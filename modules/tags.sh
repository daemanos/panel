#!/bin/bash
source $PANEL_HOME/panel.cfg
tags=()

# brute force the tag list
brute() {
    if [ $1 ]; then
        case `herbstclient tag_status | sed "s/^.*\([\.:#!]\)${1}.*$/\1/"` in
            '#')
                tags["$1"]="$tag_current"
                ;;
            ':')
                tags["$1"]="$tag_occupied"
                ;;
            '.')
                tags["$1"]="$tag_empty"
                ;;
            '!')
                tags["$1"]="$tag_urgent"
                ;;
        esac
    else
        for tag in `herbstclient tag_status | tr '\t' ' '`; do
            case "${tag:0:1}" in
                '#')
                    tags["${tag##?}"]="$tag_current"
                    ;;
                ':')
                    tags["${tag##?}"]="$tag_occupied"
                    ;;
                '.')
                    tags["${tag##?}"]="$tag_empty"
                    ;;
                '!')
                    tags["${tag##?}"]="$tag_urgent"
                    ;;
            esac
        done
    fi
}

# send the current tag buffer to the panel
write() { echo "tags$cmd_ifs${tags[@]} " ; }

# initial setup
brute
write

# wait for events
herbstclient --idle 'tag_changed|tag_flags|reload' | while read event ; do
    case `awk -F '\t' '{ print $1 }' <<< "$event"` in
        tag_changed)
            brute "$current_tag"
            current_tag=`awk -F '\t' '{ print $2 }' <<< "$event"`
            tags[$current_tag]="$tag_current"
            ;;
        tag_flags)
            brute
            ;;
        reload)
            tags=()
            brute
            ;;
    esac
    write
done
