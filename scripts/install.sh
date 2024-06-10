#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Get GitHub repo of the chosen OpenPilot fork
repo=${1:-"https://github.com/commaai/openpilot.git"}

# Now, you can use the variable
echo "This Openpilot repository will be installed: $repo"

# Check if ubuntu dependecies are already installed.
if [ -e "~/openpilot_headless/install/ubuntu.txt" ]; then
    echo "Ubuntu setup has yet been completed."
else
    # Install all needed Ubuntu Dependecies
    echo "Start installing Ubuntu dependecies..."
    $DIR/ubuntu.sh >>  $DIR/../logs/ubuntu.log 2>&1
    echo "Done."
fi

# Check if a "OpenPilot" folder is yet existing
if [ -e "~/openpilot" ]; then
    echo "There is already a OpenPilot branch here, please do a factory reset first to get rid of this."
    exit 1
else
    # Clone OP Library
    echo "Start cloning the chosen repository..."
    cd ~/
    git clone $repo >> $DIR/../logs/git_clone.log 2>&1
    git lfs pull
    echo "Done."
fi

# CD into the ~/openpilot folder
cd ~/openpilot

# Check if python dependecies are already installed.
if [ -e "~/openpilot_headless/install/python.txt" ]; then
    echo "Python setup has yet been completed."
else
    # Install all needed Python Dependecies
    echo "Start installing Python dependecies..."
    cd ~/openpilot
    $DIR/python.sh #>> $DIR/../logs/python.log 2>&
    echo "Done."
fi

#Start poetry shell
cd ~/openpilot
poetry shell

#Build openpilot
scons -u -j$(nproc)

echo
echo "----   OPENPILOT SETUP DONE   ----"