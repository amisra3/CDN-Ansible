#!/bin/bash

#
# Copyright 2017 Intel Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom
# the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
# THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#


# Check if we're root
if [ "$EUID" -ne 0 ]; then
        echo "Please run this as root"
        exit 1
fi

if [ -f /etc/os-release ]; then
	. /etc/os-release
	OS=$NAME
	VER=$VERSION_ID
	echo
	echo "**********************************"
	echo "  Detected OS: $OS"
	echo "  Installing packages..."
	echo "**********************************"
	echo 
fi

if [ "$OS" = "Ubuntu" ]; then
	apt-get -y install software-properties-common sshpass python3-pip python-pip build-essential libssl-dev libffi-dev python-dev python-keyczar
        pip3 install Jinja2
	pip install httplib2
	pip install cryptography
	pip install pyyaml
	
	apt-add-repository ppa:ansible/ansible
	apt-get update
	apt-get install ansible
	
	
elif [ "$OS" = "Red Hat"* ] || [ "$OS" = "CentOS"* ] || [ "$OS" = "Fedora" ]; then
	echo -e "OS Not supported YET."
	exit 1
fi

echo
echo -e "**********************************"
echo -e "  Packages installed"
echo -e "**********************************"
echo 

read -p "Please enter the IP of host (Ansible) machine (IP of this machine): " -r HOST_IP

read -p "Please enter the user name of host machine: " -r HOST_USER

# Generating the ssh-key in host machine
ssh-keygen -t rsa -b 4096 -C ${HOST_USER}@${HOST_IP}

echo
echo -e "*********************************************************"
echo -e " ssh-key is successfully generated in host machine  "
echo -e "**********************************************************"
echo 

read -p "Enter the numbers of target machines: " -r NUM_TARGETS

# Copying the ssh-key to target machines
for i in $(seq 1 $NUM_TARGETS)
do

read -p "Please enter the IP of target machine ${i}: " -r TARGET_IP

read -p "Please enter the user name of target machine ${i}: " -r TARGET_USER

ssh-copy-id ${TARGET_USER}@${TARGET_IP}

echo
echo -e "*********************************************"
echo -e " ssh-key is copied to target machine ${i} "
echo -e "**********************************************"
echo 

done


