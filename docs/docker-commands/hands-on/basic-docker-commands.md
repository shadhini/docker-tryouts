---
icon: a
---

# Basic Docker Commands

## Run container in Interactive mode

<pre class="language-bash"><code class="lang-bash">~ via 💎 v3.1.3 
<strong><a data-footnote-ref href="#user-content-fn-1">❯</a> docker run -it ubuntu bash 
</strong><a data-footnote-ref href="#user-content-fn-2">root@3def6556b686</a>:/# 
root@3def6556b686:/# 
root@3def6556b686:/# 
root@3def6556b686:/# cat /etc/*release*
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=24.04
DISTRIB_CODENAME=noble
DISTRIB_DESCRIPTION="Ubuntu 24.04.1 LTS"
PRETTY_NAME="Ubuntu 24.04.1 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.1 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
root@3def6556b686:/# 
root@3def6556b686:/# 
root@3def6556b686:/# exit
exit

~ via 💎 v3.1.3 took 9m10s 
❯ 

</code></pre>



### Run container in Detached mode

<pre class="language-bash"><code class="lang-bash"><strong>~ via 💎 v3.1.3 took 9m10s 
</strong>❯ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES 

~ via 💎 v3.1.3 
❯ docker run -d ubuntu sleep 60
7650fba53763787e003091c4e9f1849e6e3cab557bd73b71857f29cf4926af8a

~ via 💎 v3.1.3 
❯ docker ps
CONTAINER ID   IMAGE     COMMAND      CREATED         STATUS         PORTS     NAMES
7650fba53763   ubuntu    "sleep 60"   3 seconds ago   Up 2 seconds             goofy_gould

~ via 💎 v3.1.3 
❯
</code></pre>



## List all containers

```bash
~ via 💎 v3.1.3 
❯ docker ps -a
CONTAINER ID   IMAGE                          COMMAND                  CREATED              STATUS                          PORTS                                              NAMES
7650fba53763   ubuntu                         "sleep 60"               About a minute ago   Exited (0) 14 seconds ago                                                          goofy_gould
6b2a4d919497   ubuntu                         "sleep 60"               2 minutes ago        Exited (0) About a minute ago                                                      jolly_beaver
3def6556b686   ubuntu                         "bash"                   13 minutes ago       Exited (127) 4 minutes ago                                                         amazing_ptolemy
e3beee22cce3   ubuntu                         "/bin/bash"              14 hours ago         Exited (0) 14 hours ago                                                            nifty_knuth
b5af99b791e6   ubuntu                         "/bin/bash"              17 hours ago         Exited (0) 17 hours ago 
```



## Stop a running container

```bash
~ via 💎 v3.1.3 
❯ docker run -d ubuntu sleep 200
2413ba2a662d8e3ef074aab738f612dc10dffb98d041532ef2445457f9e3e841

~ via 💎 v3.1.3 
❯ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
2413ba2a662d   ubuntu    "sleep 200"   15 seconds ago   Up 14 seconds             quizzical_khorana

~ via 💎 v3.1.3 
❯ docker stop 2413
2413

~ via 💎 v3.1.3 took 10s 
❯ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```



## Exit Codes

Exit code `0` : Exited container under normal conditions, after executing the process

<pre class="language-bash"><code class="lang-bash">~ via 💎 v3.1.3 
❯ docker ps -a
CONTAINER ID   IMAGE                          COMMAND                  CREATED          STATUS                            PORTS                                              NAMES
2413ba2a662d   ubuntu                         "sleep 200"              2 minutes ago    Exited (<a data-footnote-ref href="#user-content-fn-3">137</a>) About a minute ago                                                      quizzical_khorana
7650fba53763   ubuntu                         "sleep 60"               8 minutes ago    Exited <a data-footnote-ref href="#user-content-fn-4">(0)</a> 7 minutes ago                                                             goofy_gould
6b2a4d919497   ubuntu                         "sleep 60"               10 minutes ago   Exited (0) 9 minutes ago                                                             jolly_beaver
3def6556b686   ubuntu                         "bash"                   21 minutes ago   Exited (127) 12 minutes ago                                                          amazing_ptolemy
e3beee22cce3   ubuntu                         "/bin/bash"              14 hours ago     Exited (0) 14 hours ago                                                              nifty_knuth
b5af99b791e6   ubuntu                         "/bin/bash"              17 hours ago     Exited (0) 17 hours ago                        
</code></pre>



## Remove containers

```bash
~ via 💎 v3.1.3 
❯ docker ps -a
CONTAINER ID   IMAGE                          COMMAND                  CREATED          STATUS                            PORTS                                              NAMES
2413ba2a662d   ubuntu                         "sleep 200"              2 minutes ago    Exited (137) About a minute ago                                                      quizzical_khorana
7650fba53763   ubuntu                         "sleep 60"               8 minutes ago    Exited (0) 7 minutes ago                                                             goofy_gould
6b2a4d919497   ubuntu                         "sleep 60"               10 minutes ago   Exited (0) 9 minutes ago                                                             jolly_beaver
3def6556b686   ubuntu                         "bash"                   21 minutes ago   Exited (127) 12 minutes ago                                                          amazing_ptolemy
e3beee22cce3   ubuntu                         "/bin/bash"              14 hours ago     Exited (0) 14 hours ago                                                              nifty_knuth
b5af99b791e6   ubuntu                         "/bin/bash"              17 hours ago     Exited (0) 17 hours ago                                                              sad_kirch

~ via 💎 v3.1.3 
❯ docker rm 24
24

~ via 💎 v3.1.3 
❯ docker rm 76 6b 3d e3 b5
76
6b
3d
e3
b5

~ via 💎 v3.1.3 
❯ docker ps -a 
CONTAINER ID   IMAGE                          COMMAND                  CREATED         STATUS                       PORTS                                              NAMES

```



## Remove images

```bash
❯ docker images
REPOSITORY               TAG       IMAGE ID       CREATED         SIZE
ubuntu                   latest    20377134ad88   4 weeks ago     101MB
amirpourmand/al-folio    latest    49510ed7947b   4 months ago    1.6GB
<none>                   <none>    3d7a4df306cd   4 months ago    1.6GB
<none>                   <none>    0d2d111caa80   4 months ago    1.59GB
<none>                   <none>    af0dfd2d4d1d   4 months ago    1.59GB
metabase/metabase        latest    e970c750a8b5   13 months ago   607MB
adoptopenjdk/openjdk15   latest    9afc4bf7c0f4   17 months ago   464MB
adoptopenjdk/openjdk11   latest    b39912ff66e1   17 months ago   428MB


~ via 💎 v3.1.3 
❯ docker rmi 3d7 0d2 af0
Deleted: sha256:3d7a4df306cdbb0ed084f29bc0e493d0f0b3d8de5cc84b6926b2ed4173a1a380
Deleted: sha256:0d2d111caa8025a60bfab4c2fab4165f568d1ab7fba69c848640bf29bf36b3fd
Deleted: sha256:af0dfd2d4d1d1cc862d70a58bba8b4733503e431c972b7bb061246b49f745ef0

~ via 💎 v3.1.3 
❯ docker rmi ubuntu
Untagged: ubuntu:latest
Untagged: ubuntu@sha256:80dd3c3b9c6cecb9f1667e9290b3bc61b78c2678c02cbdae5f0fea92cc6734ab
Deleted: sha256:20377134ad8875ad73c4a4f12b5d8e28c8665da80756c2afbb47d1f730bf2e5e
Deleted: sha256:1575723d84b80a2963cb6b2bf2ae5cefd3859bda7470710cff2b703d40a92000

~ via 💎 v3.1.3 
❯ docker images
REPOSITORY               TAG       IMAGE ID       CREATED         SIZE
amirpourmand/al-folio    latest    49510ed7947b   4 months ago    1.6GB
metabase/metabase        latest    e970c750a8b5   13 months ago   607MB
adoptopenjdk/openjdk15   latest    9afc4bf7c0f4   17 months ago   464MB
adoptopenjdk/openjdk11   latest    b39912ff66e1   17 months ago   428MB


```



## Pull an Image

```bash
~ via 💎 v3.1.3 
❯ docker pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
8bb55f067777: Pull complete 
Digest: sha256:80dd3c3b9c6cecb9f1667e9290b3bc61b78c2678c02cbdae5f0fea92cc6734ab
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest

What's next:
    View a summary of image vulnerabilities and recommendations → docker scout quickview ubuntu

~ via 💎 v3.1.3 took 12s 
❯ docker ps -a
CONTAINER ID   IMAGE                          COMMAND                  CREATED         STATUS                       PORTS                                              NAMES
40834cd5eef9   metabase/metabase              "/app/run_metabase.sh"   12 months ago   Exited (143) 12 months ago                                                      metabase
1213547bd1b5   metabase/metabase              "/app/run_metabase.sh"   13 months ago   Exited (143) 12 months ago                                                      metabase_default

~ via 💎 v3.1.3 
❯ docker images
REPOSITORY               TAG       IMAGE ID       CREATED         SIZE
ubuntu                   latest    20377134ad88   4 weeks ago     101MB
amirpourmand/al-folio    latest    49510ed7947b   4 months ago    1.6GB
metabase/metabase        latest    e970c750a8b5   13 months ago   607MB
adoptopenjdk/openjdk15   latest    9afc4bf7c0f4   17 months ago   464MB
adoptopenjdk/openjdk11   latest    b39912ff66e1   17 months ago   428MB
```



## Execute command on a running container

```bash
~ via 💎 v3.1.3 
❯ docker run -d ubuntu sleep 3600
69adb7efbd52d099cbdf37e0589a9ec38b9d69a6897482ccd9a2b1a00e9cb7fa

~ via 💎 v3.1.3 
❯ docker ps 
CONTAINER ID   IMAGE     COMMAND        CREATED         STATUS         PORTS     NAMES
69adb7efbd52   ubuntu    "sleep 3600"   4 seconds ago   Up 3 seconds             reverent_sinoussi

~ via 💎 v3.1.3 
❯ docker exec 69a cat /etc/*release*
zsh: no matches found: /etc/*release*

~ via 💎 v3.1.3 
❯ docker exec 69adb7efbd52 cat /etc/*release*
zsh: no matches found: /etc/*release*

~ via 💎 v3.1.3 
❯ docker exec reverent_sinoussi cat /etc/*release*
zsh: no matches found: /etc/*release*

~ via 💎 v3.1.3 
❯ docker exec 69a cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.17.0.2      69adb7efbd52
```



[^1]: docker host prompt

[^2]: docker container prompt

    3def6556b686 <- unique container id

[^3]: Exited due to killing the container with `docker stop` while it was running

[^4]: Exited under normal condition
