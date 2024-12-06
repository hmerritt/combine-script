# Adds script variables into current context
#
# Example:
# function myFunction
# {
#     setenv
#     echo $version
# }
function setenv
{
	export version="2.1.17"
    export repo_url="https://github.com/hmerritt/combine-script"

    export list_dir="./scripts"
}

# Note: This is a public function (upper-case first letter)
#
# Usage: ./myScript.sh run print_env
function Print_env
{
    setenv # Call this at the top of any function

    echo "version: ${version}"
    echo "repo_url: ${repo_url}"
}
