#!/bin/bash

__COMBINESCRIPT__VERSION=0.0.1


# Print a list of all functions
# within the current script
function __combinescript__print_functions
{
	echo "Functions"
    grep "^function" $0
    grep "^()" $0
}


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
