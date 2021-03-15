#!/bin/bash

__COMBINESCRIPT__VERSION=0.0.1


# Command,  run
# > Run function via CLI
if [ "${1}" = "run" ]; then
    if [ "${2}" = "" ]; then
        echo "no function passed"
        echo "run <function>"
        echo
    else
        "${@: 2}"
    fi
fi
