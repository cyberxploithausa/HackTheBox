#!/bin/sh

show_usage() {
        echo "Error: Incorrect arguments."
        echo "Usage: $0"
}


# Stop this script upon any error
set -e

# Parameter validation
if [ $# != 0 ]; then
    show_usage
    exit 1
fi

active_img=`nv getenv sw_active | sed 's/^.*=//g'`
if [ $active_img == 0 ]; then
    bak_img=1
elif [ $active_img == 1 ]; then
    bak_img=0
else
    echo "ERROR: incorrect sw_active flag, should be 0 or 1 but got $active_img"
    exit 1
fi

sw_updater=`nv getenv sw_updater | sed 's/^.*=//g'`
#Empty string in sw_updater refers to OMCI, DON'T change sw_commit
if [ "$sw_updater" != "" ]; then
    echo "sw_updater is $sw_updater"
    commit=`nv getenv sw_commit | sed 's/^.*=//g'`
    echo "sw_active=$active_img"
    echo "sw_commit=$commit"
    if [ "$commit" != "$active_img" ]; then
        echo "sw_active and sw_commit are different and updater is NOT OMCI"
        nv setenv sw_commit $active_img
    fi
    nv setenv sw_updater
fi

exit 0


