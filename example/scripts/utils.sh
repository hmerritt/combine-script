#
# Utility functions
#
# Can be used in any other script, very useful!
#

function version
{
    setenv
    echo "myScript [Version v${version}]"
    echo
}

function printsection
{
    green "-------------------------------------------"
    green "     ${1}"
    green "-------------------------------------------"
}

# Check if a command exists
# - Usage: command_exists <command>
function command_exists
{
	  command -v "$@" > /dev/null 2>&1
}

function change_owner
{
    local -r usergroup="${1}"
    local -r directory_path="${2}"

    chown --recursive $usergroup:$usergroup "${directory_path}"
    chmod 770 "${directory_path}"
}

function ask_user
{
    input="junk"
    read -p "" input
    echo "${input}"
}

function confirm_continue
{
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
    fi
}

function wait_for_response
{
    local -r name="${1}"
    local -r requestURL="${2}"
    local -r requestResponse="${3}"

    # Wait for response to be ready
    while true; do
        echo "Waiting for ${name} to be ready..."
        curl -sL ${requestURL} | grep -q "${requestResponse}" && break
        sleep 1
    done
}
