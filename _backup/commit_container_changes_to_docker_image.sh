#!/usr/bin/env bash
# save the state of a container as a new Docker image.


#docker commit -m "What you did to the image" -a "Author Name" container_id repository/new_image_name
# Unless you created additional repositories on Docker Hub, the repository is usually your Docker Hub username.
docker commit -m "added Node.js" -a "sammy" d9b100f2f636 sammy/ubuntu-nodejs

# You can also build Images from a Dockerfile, which lets you automate the installation of software in a new image.


