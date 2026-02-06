#!/usr/bin/env bash
docker start f63807851cc6

# to check status of started container
docker ps

# CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
# f63807851cc6        ubuntu              "/bin/bash"         49 minutes ago      Up 2 seconds                            elastic_murdock

# You can start a new container and give it a name using the --name switch.
# You can also use the --rm switch to create a container that removes itself when it’s stopped.
# See the docker run help command for more information on these options and others