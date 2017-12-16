#!/bin/bash

# Script requires 1 argument: path to neo-cli project root
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <path-to-neo-cli>"
    exit 1
fi

# Get absolute path
NEO_CLI_PATH=$(readlink -f $1)
echo "neo-cli project root: $NEO_CLI_PATH"

# Change into script directory, in order to always reference the right
# source directory, no matter if this build script is invoked inside
# or outside the "scripts" directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Build the dotnet builder image
docker build -f Dockerfile.build-base -t neo-cli-build-base $NEO_CLI_PATH

# Build the current code
docker build --no-cache -f Dockerfile.build-local -t neo-cli-build $NEO_CLI_PATH
