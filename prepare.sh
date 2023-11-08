#!/bin/bash

set -ex

#docker install
sudo apt update
sudo apt -y install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ${USER}

#install ForcAD
git clone -b upgrade-deps https://github.com/pomo-mondreganto/ForcAD.git
cp ./config.yml ./ForcAD
cp -r ./checkers/* ./ForcAD/checkers
cd ./ForcAD

#python venv
sudo apt-get install python3-venv -y
python3 -m venv venv
source venv/bin/activate

#checkers requirements
cd ./checkers
chmod +x ./install_checker_requirements.sh
./install_checker_requirements.sh
cd ../

#cli requirements
pip install -r cli/requirements.txt
deactivate

