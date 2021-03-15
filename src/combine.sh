#!/bin/bash

__COMBINESCRIPT__VERSION=0.1.0


# Print a list of all functions
# within the current script
function __combinescript__print_functions
{
	echo "Functions"
    grep "^function" $0
    grep "^()" $0
}


# Print combine-script help
function __combinescript__print_help
{
    echo "Help:"
    echo
    echo "Commands"
    echo "  * run     |  run a function"
    echo "  * list    |  return all functions"
    echo "  * repl    |  shell to run multiple commands (not for programmatic use)"
    echo
    echo
    __combinescript__print_functions
}


# Print combine-script help message
# if no arguments have been passed
if [ "${1}" = "" ] || [ "${1}" = "help" ] || [ "${1}" = "h" ]; then
  __combinescript__print_help
  exit 1
fi


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


# Command,  repl
# > Interactive REPL
if [ "${1}" = "repl" ]; then
  __combinescript__print_help

  # Init repl
  while true ; do
    while IFS="" read -r -e -d $'\n' -p ':$ ' options; do
  	  if [ "$options" = "quit" ]; then
	    exit 0
	  else
	    "${options}"
	    echo
	  fi
	done
  done
fi
