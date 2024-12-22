---
icon: person-running
---

# Docker Run

## Attach standard output of a container running in background

```bash
~ via 💎 v3.1.3 took 5s 
❯ docker run johnfkraus/timer 
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
Sun Dec 22 13:15:50 UTC 2024
Sun Dec 22 13:15:51 UTC 2024
Sun Dec 22 13:15:52 UTC 2024
Sun Dec 22 13:15:53 UTC 2024
Sun Dec 22 13:15:54 UTC 2024
Sun Dec 22 13:15:55 UTC 2024
Sun Dec 22 13:15:56 UTC 2024
^C%                                                                                                                                    

~ via 💎 v3.1.3 took 18s 
❯ docker run -d johnfkraus/timer
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
abf6573d187ce81ef76fa613a3cf00727cb198c6f66c550e533b6dcd0dda0f9c


~ via 💎 v3.1.3 
❯ docker ps
CONTAINER ID   IMAGE              COMMAND           CREATED          STATUS          PORTS     NAMES
abf6573d187c   johnfkraus/timer   "sh /script.sh"   17 seconds ago   Up 16 seconds             keen_goldberg

~ via 💎 v3.1.3 
❯ docker attach ab
Sun Dec 22 13:17:05 UTC 2024
Sun Dec 22 13:17:06 UTC 2024
Sun Dec 22 13:17:07 UTC 2024
Sun Dec 22 13:17:08 UTC 2024
Sun Dec 22 13:17:09 UTC 2024
Sun Dec 22 13:17:10 UTC 2024
Sun Dec 22 13:17:11 UTC 2024
```



## Port Mapping

<pre class="language-bash"><code class="lang-bash">~ via 💎 v3.1.3 took 3s 
❯ docker run jenkins/jenkins
Running from: /usr/share/jenkins/jenkins.war
webroot: /var/jenkins_home/war
...

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

b2b612dfbb7e4537b873fd1bacbc2193

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

*************************************************************
*************************************************************
*************************************************************

2024-12-22 13:24:50.314+0000 [id=36]    INFO    jenkins.InitReactorRunner$1#onAttained: Completed initialization
2024-12-22 13:24:50.342+0000 [id=25]    INFO    hudson.lifecycle.Lifecycle#onReady: Jenkins is fully up and running
2024-12-22 13:24:52.423+0000 [id=64]    INFO    h.m.DownloadService$Downloadable#load: Obtained the updated data file for hudson.tasks.Maven.MavenInstaller
2024-12-22 13:24:52.429+0000 [id=64]    INFO    hudson.util.Retrier#start: Performed the action check updates server successfully at the attempt #1


~ via 💎 v3.1.3 
❯ docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS         PORTS                 NAMES
b075e31dd564   jenkins/jenkins   "/usr/bin/tini -- /u…"   5 minutes ago   Up 5 minutes   8080/tcp, 50000/tcp   naughty_wilbur

~ via 💎 v3.1.3 
❯ docker inspect b0
[
    {
        "Id": "b075e31dd56432231ecc2bf1f46cc2d36fa25bbc8e2c705f6879d53a37848b7d",
        ...
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "85b4bf737748d900838d59ca430ff0805f43f087294637abf5cebe73def0f190",
            "SandboxKey": "/var/run/docker/netns/85b4bf737748",
            "Ports": {
                "50000/tcp": null,
                "8080/tcp": null
            },
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "45a36768224ae9decfe88328871db2cce37208c6a1acb3f88c174431fcb573a6",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null,
                    "NetworkID": "a62f5a3da645355756f6ef29d33eda63146dd9442e1bf834b264833c4848a1a9",
                    "EndpointID": "45a36768224ae9decfe88328871db2cce37208c6a1acb3f88c174431fcb573a6",
                    "Gateway": "172.17.0.1",
                    "<a data-footnote-ref href="#user-content-fn-1">IPAddress</a>": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DNSNames": null
                }
            }
        }
    }
]
</code></pre>

{% hint style="danger" %}
**MacOS Networking**: On macOS, Docker uses a virtual machine to run containers, so directly accessing the container's internal IP from outside the Docker host is not possible unless you map the ports to the host machine using the `-p` option
{% endhint %}

```bash
~ via 💎 v3.1.3 
❯ docker run --name jenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins
Running from: /usr/share/jenkins/jenkins.war
webroot: /var/jenkins_home/war
....

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

d2ce34cd05b14257883287cfd31dfdc7

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

*************************************************************
...



~ via 💎 v3.1.3 
❯ docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED         STATUS         PORTS                                              NAMES
b4cf81696a7d   jenkins/jenkins   "/usr/bin/tini -- /u…"   5 seconds ago   Up 4 seconds   0.0.0.0:8080->8080/tcp, 0.0.0.0:50000->50000/tcp   jenkins
```

{% hint style="info" %}
With **port mapping**, you can now access the Jenkins server at `http://localhost:8080`.
{% endhint %}

{% hint style="success" %}
Suppose you log in to the Jenkins server and make some configuration changes. If you then spin up another container and access the Jenkins server there, you won't see the configuration changes made in the first container. This happens because these are two isolated environments, and the data from the first container is not shared with the second one.

To resolve this issue, you can use **volume mapping**. By mapping the data volumes of both containers to the same directory on the Docker host, the configurations and data will be shared between them. This ensures that changes made in one container are accessible in the other.
{% endhint %}



```bash
~ ➜  docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                                                                NAMES
0ba02655cbf1   nginx:alpine   "/docker-entrypoint.…"   16 seconds ago   Up 13 seconds   0.0.0.0:3456->3456/tcp, :::3456->3456/tcp, 0.0.0.0:38080->80/tcp, :::38080->80/tcp   recursing_galileo
```

`0.0.0.0:3456->3456/tcp,`&#x20;

`:::3456->3456/tcp,`&#x20;

`0.0.0.0:38080->80/tcp,`&#x20;

`:::38080->80/tcp`

* ports published on host: 3456 & 38080
* ports exposed on container: 3456 & 80











[^1]: Internal IP address of the docker container
