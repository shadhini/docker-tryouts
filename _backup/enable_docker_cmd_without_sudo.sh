#!/usr/bin/env bash
# By default, the docker command can only be run the root user or by a user in the docker group,
# which is automatically created during Docker’s installation process.
# If you want to avoid typing sudo whenever you run the docker command, add your username to the docker group

# to add currently logged in user to docker group
sudo usermod -aG docker ${USER}
su - ${USER}
id -nG

# to add a different user with username=abc to the docker group
sudo usermod -aG docker abc