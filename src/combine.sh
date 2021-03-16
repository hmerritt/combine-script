#!/bin/bash

#
# Combine.sh
# https://github.com/hmerritt/combine-script
#
# Usage:
# ./combine.sh <path-to-scripts-directory> <output-script-name>
# ./combine.sh ./scripts script.sh
#


# Use a fallback value if initial value does not exist
# - Usage: value=$(fallback $1 "fallback")
# - $1: initial value
# - $2: fallback value
function fallback
{
	local value=$1

	# Check for NULL/empty value
	if [ ! -n "${value}" ]; then
		local value=$2
	fi

	echo "${value}"
}


# Print script help
function print_help
{
    echo "combine <path-to-scripts-directory> <output-script-name>"
    echo "combine ./scripts script.sh"
}


# Remove file if it exists
function delete_file
{
    if [ -f "${1}" ]; then
        rm "${1}"
    fi
}


# Print script help message
if [ "${1}" = "help" ] || [ "${1}" = "h" ]; then
  print_help
  exit 1
fi


# Script Variables
VERSION=0.2.0

SCRIPTS_PATH=$(fallback $1 "./scripts")
SCRIPT_OUTPUT_PATH=$(fallback $2 "./script.sh")
BUNDLE_PATH="./__bundle"
BUNDLE_HELPER_FUNCTIONS="yes"


# Check if $SCRIPTS_PATH is a directory
if [ ! -d "${SCRIPTS_PATH}" ];
then
	echo -e "\e[31mERROR"
    echo -e "  * Path to scripts folder does not exist:"
    echo -e "    : ${SCRIPTS_PATH}"
    echo -e "\033[0m"
    print_help
    exit 1
fi
