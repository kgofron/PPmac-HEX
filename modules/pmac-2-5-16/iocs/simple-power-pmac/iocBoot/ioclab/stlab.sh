#!/bin/sh
# This file was automatically generated on Thu 15 Nov 2018 14:28:58 GMT from
# source: /home/hgv27681/R3.14.12.7/support/pmac/etc/makeIocs/lab.xml
# 
# *** Please do not edit this file: edit the source file instead. ***
# 
cd "$(dirname "$0")"
if [ -n "$1" ]; then
    export EPICS_CA_SERVER_PORT="$(($1))"
    export EPICS_CA_REPEATER_PORT="$(($1 + 1))"
    [ $EPICS_CA_SERVER_PORT -gt 0 ] || {
        echo "First argument '$1' should be a integer greater than 0"
        exit 1
    }
fi

export INSTALL=$(realpath $(dirname ${BASH_SOURCE[0]})/../..)


exec ./lab stlab.boot