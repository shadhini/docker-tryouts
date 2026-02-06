#!/usr/bin/env bash
# combination of the -i and -t switches gives you interactive shell access into the container:
docker run -it ubuntu

# root@f63807851cc6:/#

# Now you can run any command inside the container. For example, let’s update the package database inside the container.
# You don’t need to prefix any command with sudo, because you’re operating inside the container as the root user
# Any changes you make inside the container only apply to that container.

# root@f63807851cc6:/# apt update

# root@f63807851cc6:/# apt install nodejs

# root@f63807851cc6:/# node -v

# root@f63807851cc6:/# exit

