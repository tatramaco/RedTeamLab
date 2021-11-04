#!/bin/bash
apt-get update
apt-get install -y git python3-pip python3.8 
python3.6 -m pip install virtualenv
apt-get install -y python3-venv
git clone https://github.com/Cyb3rWard0g/HELK.git
cd HELK/docker
./helk_install.sh -p hunting -i 10.0.1.50 -b 'helk-kibana-analysis-alert' > log.txt