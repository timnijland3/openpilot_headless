#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Get GitHub repo of the chosen OpenPilot fork
repo=${1:-"https://github.com/commaai/openpilot.git"}

# Now, you can use the variable
echo "The used Repo will be: $repo"

# Check if ubuntu dependecies are already installed.
if [ -e "~/openpilot_headless/install/ubuntu.txt" ]; then
    echo "Ubuntu setup has yet been completed."
else
    # Install all needed Ubuntu Dependecies
    $DIR/ubuntu.sh
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
if [ -e "~/openpilot_headless/install/python.txt" ]; then
    echo "Python setup has yet been completed."
else
    # Install all needed Python Dependecies
    cd ~/openpilot
    $DIR/python.sh
fi

#Start poetry shell
cd ~/openpilot
poetry shell

#Build openpilot
scons -u -j$(nproc)

echo
echo "----   OPENPILOT SETUP DONE   ----"