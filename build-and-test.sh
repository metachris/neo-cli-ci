#!/bin/bash
#
# This script builds neo-cli with dotnet 2.0, and runs the tests.
#

# Script requires 1 argument: path to neo-cli project root
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <path-to-neo-cli>"
    exit 1
fi

# Get absolute path to neo-cli project root
USE_GITHUB=""
if [[ "$1" == "github" ]]; then
    USE_GITHUB="master"
fi

# Read path of this script into a variable. This allows to run this script from
# anywhere, whether from inside this directory or outside.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Build the dotnet builder image (can be cached)
docker build -f $DIR/Dockerfile.build-base -t neo-cli-build-base $DIR

# Build neo-cli
if [[ -n "$USE_GITHUB" ]]; then
    echo "USE GITHUB"
    docker build --no-cache -f $DIR/Dockerfile.build-github -t neo-cli-build-github $DIR
else
    NEO_CLI_PATH=$(readlink -f $1)
    echo "neo-cli project root: $NEO_CLI_PATH"
    docker build --no-cache -f $DIR/Dockerfile.build-local -t neo-cli-build $NEO_CLI_PATH
fi

