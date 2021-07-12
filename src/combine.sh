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
VERSION=1.2.6

SCRIPTS_PATH=$(fallback $1 "./scripts")
SCRIPT_OUTPUT_PATH=$(fallback $2 "./script.sh")
BUNDLE_PATH="./__bundle"

# Options
BUNDLE_INTERFACE_FRAMEWORK="yes"
BUNDLE_HELPER_FUNCTIONS="yes"
LOG="no"
LOGPATH="./script.log"


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


# Remove $BUNDLE_PATH file if it exists
delete_file "${BUNDLE_PATH}"


# Get all script files in a directory (non-recursive)
files=($( cd "${SCRIPTS_PATH}" && ls -A1 | grep -E "*.sh|*.bash" ))


echo -e "Bundling Scripts"

# Loop each script in $SCRIPTS_PATH
# to create one bundle script
for file in "${files[@]}"
do
	echo -e "  * Add ${file} to bundle"
	echo -e "\n\n\n#\n# Script: ${file}\n#\n" | cat - "${SCRIPTS_PATH}/${file}" >> "${BUNDLE_PATH}"
done

# Remove every instance of shebang (#!)
# from the bundle file
sed -i "s/\#\!\/bin\/bash//g" "${BUNDLE_PATH}"
sed -i "s/\#\!\/bin\/sh//g" "${BUNDLE_PATH}"


echo
echo -e "Creating output script"
echo -e "  * ${SCRIPT_OUTPUT_PATH}"

# Create final script file
touch "${SCRIPT_OUTPUT_PATH}"
dd of="${SCRIPT_OUTPUT_PATH}" << EOF
#!/bin/bash

#
# Collection of scripts combined using:
# https://github.com/hmerritt/combine-script
#
# Metadata:
#   | Compiled Timestamp | $(date +%s)       |
#   | Compiled Date      | $(date +"%Y-%m-%d %H:%M") |
#   | Combine.sh Version | ${VERSION}            |
#
# Scripts Bundled:
#  (${#files[@]})  ${files[@]}
#


EOF


# Include helper function within $SCRIPT_OUTPUT_PATH
# Default: yes
if [ "${BUNDLE_INTERFACE_FRAMEWORK}" = "yes" ]; then
    echo
    echo -e "Injecting combine interface framework"

    cat <<EOF >> ${SCRIPT_OUTPUT_PATH}

#
# Combine.sh Interface Framework
#

__ARGS="\${@}"

LOG="${LOG}"
LOGPATH="${LOGPATH}"
ERROR=""


# Color codes
NOCOLOR="\\033[0m"

# Text
BLACK="\\e[30m"
RED="\\e[31m"
GREEN="\\e[32m"
ORANGE="\\e[33m"
BLUE="\\e[34m"
PURPLE="\\e[35m"
CYAN="\\e[36m"
LIGHTGRAY="\\e[37m"
DARKGRAY="\\e[90m"
LIGHTRED="\\e[91m"
LIGHTGREEN="\\e[92m"
YELLOW="\\e[93m"
LIGHTBLUE="\\e[94m"
LIGHTPURPLE="\\e[95m"
LIGHTCYAN="\\e[96m"
WHITE="\\e[97m"

# Background
BG_RED="\\e[41m\${WHITE}"
BG_GREEN="\\e[42m\${WHITE}"
BG_YELLOW="\\e[43m\${WHITE}"
BG_BLUE="\\e[44m\${WHITE}"
BG_PURPLE="\\e[45m\${WHITE}"
BG_CYAN="\\e[46m\${WHITE}"
BG_LIGHTRED="\\e[101m\${WHITE}"
BG_LIGHTGREEN="\\e[102m\${WHITE}"
BG_WHITE="\\e[107m\${BLACK}"


# Print colored text to the terminal
# - \$1: color
# - \$2: text
function cprint
{
	echo -e "\$1\$2\${NOCOLOR}"
}


# Print colored text
# - \$1: text
# -> output colored text with no background
function white
{
	cprint \$WHITE "\${1}"
}

function green
{
	cprint \$GREEN "\${1}"
}

function red
{
	cprint \$RED "\${1}"
}

function orange
{
	cprint \$ORANGE "\${1}"
}


# Print message by named state
# - \$1: text
function success
{
	cprint \$BG_GREEN "\${1}"
}

function failure
{
	cprint \$BG_RED "\${1}"
}

function error
{
	red "\${1}"
}

function warning
{
	orange "\${1}"
}


# Use a fallback value if initial value does not exist
# - Usage: value=\$(fallback \$1 "fallback")
# - \$1: initial value
# - \$2: fallback value
function fallback
{
	local value="\${1}"

	# Check for NULL/empty value
	if [ ! -n "\${value}" ]; then
		local value="\${2}"
	fi

	echo "\${value}"
}


# Log script
# date -- script name -- ok/error
function exitlog
{
	NAMEOFFUNCTION=\$(fallback "\${__ARGS}" "~~")
	if [ -n "\${ERROR}" ]; then code="ERROR"; else code="OK"; fi

	if [ "\${code}" == "OK" ]; then
		echo "\$(date)  --   OK    --  \${NAMEOFFUNCTION}" >> "\${LOGPATH}"
	else
		echo "\$(date)  --  ERROR  --  \${NAMEOFFUNCTION}" >> "\${LOGPATH}"
	fi
}

# Capture if process fails
function onfail
{
	if [ "\${?}" != "0" ]; then
		# Error
		ERROR="ERROR"
	fi
}



EOF
fi


# Append bundle to $SCRIPT_OUTPUT_PATH
cat "${BUNDLE_PATH}" >> "${SCRIPT_OUTPUT_PATH}"


# Include helper function within $SCRIPT_OUTPUT_PATH
# Default: yes
if [ "${BUNDLE_HELPER_FUNCTIONS}" = "yes" ]; then
    echo
    echo -e "Injecting combine helper functions"

    cat <<EOF >> ${SCRIPT_OUTPUT_PATH}


#
# Combine.sh Helper Functions
#

# Print a list of all functions
# within the current script
function __combinescript__print_functions
{
	echo "Functions"
    # grep "^function" \$0
    grep "^function" \$0 | while read -r line ; do
		# Exclude native combine functions
		if [ "\$line" != "function cprint" ] && [ "\$line" != "function white" ] && [ "\$line" != "function green" ] && [ "\$line" != "function red" ] && [ "\$line" != "function orange" ] && [ "\$line" != "function success" ] && [ "\$line" != "function failure" ] && [ "\$line" != "function error" ] && [ "\$line" != "function warning" ] && [ "\$line" != "function fallback" ] && [ "\$line" != "function exitlog" ] && [ "\$line" != "function onfail" ] && [ "\$line" != "function __combinescript__print_functions" ] && [ "\$line" != "function __combinescript__print_commands" ] && [ "\$line" != "function __combinescript__print_help" ]; then
		    fname=\$(echo "\${line}" | sed -n 's/function //p')
			echo "  * \${fname}"
		fi
	done
    grep -e "^\w*\s()" -e "^\w*()" \$0 | while read -r line ; do
		fname=\$(echo "\${line}" | grep -o "^\w*\b")
		echo "  * \${fname}"
	done
}


# Print a list of script commands
function __combinescript__print_commands
{
    echo "Commands"
    echo "  * run     |  run a function"
    echo "  * help    |  print script help"
    echo "  * repl    |  shell to run multiple commands (not for programmatic use)"
}


# Print combine-script help
function __combinescript__print_help
{
    echo "Help:"
    echo
    __combinescript__print_commands
    echo
    __combinescript__print_functions
}


# Print combine-script help message
# if no arguments have been passed
if [ "\${1}" = "" ] || [ "\${1}" = "help" ] || [ "\${1}" = "h" ]; then
  __combinescript__print_help
  exit 0
fi


# Command,  run
# > Run function via CLI
if [ "\${1}" = "run" ]; then
    if [ "\${2}" = "" ]; then
        echo -e "\e[31mNo function passed\033[0m"
        echo "run <function>"
        echo
        exit 0
    else
        "\${@: 2}"

		onfail

		# Log what just ran
		if [ "\${LOG}" == "yes" ]; then
			exitlog
		fi

		# If ERROR, force exit code
		if [ -n "\${ERROR}" ]; then
			exit 1
		fi
    fi
fi


# Command,  repl
# > Interactive REPL
if [ "\${1}" = "repl" ]; then
  __combinescript__print_help

  # Init repl
  while true ; do
    while IFS="" read -r -e -d $'\n' -p ':$ ' options; do
  	  if [ "\$options" = "quit" ]; then
	    exit 0
	  else
	    \${options}
	    echo
	  fi
	done
  done
fi

EOF
fi


# Make output script executable
chmod +x "${SCRIPT_OUTPUT_PATH}"


# Remove $BUNDLE_PATH file if it exists
delete_file "${BUNDLE_PATH}"


#
echo
echo -e "\e[42m${WHITE}Combine complete\033[0m"
