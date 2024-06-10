#!/usr/bin/env bash

# set -e

# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# # NOTE: this is used in a docker build, so do not run any scripts here.

# Get GitHub repo of the chosen OpenPilot fork
repo=${1:-"https://github.com/commaai/openpilot.git"}

# Now, you can use the variable
echo "The used Repo will be: $repo"

# Check if ubuntu dependecies are already installed.
if [ -e "/path/to/your/file" ]; then
    echo "Ubuntu setup has yet been completed."
else
    # Install all needed Ubuntu Dependecies
    $DIR/scripts/ubuntu.sh
fi

# Check if a "OpenPilot" folder is yet existing
if [ -e "~/openpilot" ]; then
    echo "There is already a OpenPilot branch here, please do a factory reset first to get rid of this."
    exit 1
else
    # Clone OP Library
    git clone $repo
fi

# CD into the ~/openpilot folder
cd ~/openpilot

# Check if python dependecies are already installed.
if [ -e "/path/to/your/file" ]; then
    echo "Python setup has yet been completed."
else
    # Install all needed Python Dependecies
    $DIR/scripts/python.sh
fi

#Start poetry shell
poetry shell

#Build openpilot
scons -u -j$(nproc)

echo
echo "----   OPENPILOT SETUP DONE   ----"