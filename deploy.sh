#!/usr/bin/env bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y git git-lfs wget gnupg2 python3-pip qml-module-qtquick2
cd ~
git clone --recurse-submodules https://github.com/navistonks/openpilot.git
#git clone --recurse-submodules https://github.com/commaai/openpilot.git
cd ~/openpilot
git lfs pull
echo "yyyyyyyyyyyyyyyyyy" | tools/ubuntu_setup.sh
source ~/.bashrc
cd ~/openpilot
wget http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu66_66.1-2ubuntu2_amd64.deb
sudo dpkg -i libicu66_66.1-2ubuntu2_amd64.deb
poetry run "USE_WEBCAM=1 scons -u -j$(nproc)"


#wget -qO - http://repo.radeon.com/rocm/rocm.gpg.key | sudo apt-key add -
#echo 'deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main' | sudo tee /etc/apt/sources.list.d/rocm.list
#sudo apt update -y
#sudo apt install -y rocm-dkms
#sudo usermod -aG video $USER
#sudo usermod -aG render $USER
#sudo reboot
# cd ~/openpilot
# poetry shell
# USE_WEBCAM=1 scons -j$(nproc)

#cd ~/openpilot/system/manager
#NOSENSOR=1 USE_WEBCAM=1 ./manager.py


#https://github.com/BBBmau/openpilot/tree/new-ubuntu-setup-flow/tools