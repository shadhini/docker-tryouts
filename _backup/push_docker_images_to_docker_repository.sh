#!/usr/bin/env bash
# To push an image to Docker Hub or any other Docker registry, you must have an account there.
# To push your image, first log into Docker Hub.
docker login -u docker-registry-username


# Note: If your Docker registry username is different from the local username you used to create the image,
# you will have to tag your image with your registry username.
# For the example given in the last step, you would type:
docker tag sammy/ubuntu-nodejs docker-registry-username/ubuntu-nodejs

# push your own image using:
docker push docker-registry-username/docker-image-name
# To push the ubuntu-nodejs image to the sammy repository, the command would be
docker push sammy/ubuntu-nodejs

# After pushing an image to a registry, it should be listed on your account’s dashboard

# to pull the image to a new machine
docker pull sammy/ubuntu-nodejs
