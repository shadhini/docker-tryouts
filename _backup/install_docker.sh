#!/usr/bin/env bash
# The Docker installation package available in the official Ubuntu repository may not be the latest version.
# To ensure we get the latest version, we’ll install Docker from the official Docker repository.
# To do that, we’ll add a new package source, add the GPG key from Docker to ensure the downloads are valid, and then install the package.

sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce