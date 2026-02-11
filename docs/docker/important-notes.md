---
icon: circle-exclamation
---

# Important Notes

## Alive Period of Containers

{% hint style="success" %}
**Containers are designed to run specific tasks or processes**,&#x20;

not to host an entire operating system like virtual machines.



A **container** only **exists** **as long as the process inside it is running** (i.e. alive).&#x20;

Once the task is complete or the service stops, the container exits.
{% endhint %}



{% hint style="info" %}
When you run a Docker container from an **Ubuntu image** using the `docker run ubuntu` command,&#x20;

╰**---**➤ **the container starts and exits immediately**.&#x20;



Ubuntu is an image of an OS that is used as the base image for other applications.

Thus, the container runs its default command (usually a shell), completes it, and then stops.&#x20;

As a result, it doesn't appear in the list of running containers but can be found in the list of all containers, marked as "exited."
{% endhint %}

```bash
~ via 💎 v3.1.3 
❯ docker run ubuntu
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
8bb55f067777: Pull complete 
Digest: sha256:80dd3c3b9c6cecb9f1667e9290b3bc61b78c2678c02cbdae5f0fea92cc6734ab
Status: Downloaded newer image for ubuntu:latest

~ via 💎 v3.1.3 took 12s 
❯ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

~ via 💎 v3.1.3 
❯ docker ps -a
CONTAINER ID   IMAGE                          COMMAND                  CREATED          STATUS                       PORTS                                              NAMES
b5af99b791e6   ubuntu                         "/bin/bash"              10 seconds ago   Exited (0) 10 seconds ago                                                       sad_kirch
40834cd5eef9   metabase/metabase              "/app/run_metabase.sh"   12 months ago    Exited (143) 12 months ago                                                      metabase
1213547bd1b5   metabase/metabase              "/app/run_metabase.sh"   12 months ago    Exited (143) 12 months ago                                                      metabase_default

```



## Accessing Services on Docker Host from a Docker Container

{% hint style="success" %}
Use `host.docker.internal` instead of `localhost` to access a service running on the docker host from the docker container. This special DNS name resolves to the host machine's IP from within the container.
{% endhint %}





## Running Multiple Docker Instances&#x20;

{% hint style="success" %}
You can add as many as instances of the same image and configure a **load balancer** in the front.



**If an instance fails**,&#x20;

1. you can destroy it and launch a new one.
{% endhint %}

