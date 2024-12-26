---
icon: globe-wifi
---

# Docker Networks

## Inspect Docker Networks

<pre class="language-bash"><code class="lang-bash">~ ➜  docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
74a8528b0999   bridge    bridge    local
a9ddd20e58a2   host      host      local
38672f05baf9   none      null      local


~ ✖ docker network inspect bridge
[
    {
        "Name": "bridge",
        "Id": "74a8528b0999eb10dbb8cfc2651f4964c04acd731d33af0802d50f709032e65f",
        .....
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": <a data-footnote-ref href="#user-content-fn-1">"172.12.0.0/24"</a>,
                    "Gateway": "172.12.0.1"
                }
            ]
        },
        .....
    }
]


~ ➜  docker inspect alpine-1      
[
    {
        .....
        "NetworkSettings": {
            "Bridge": "",
            .....
            "Networks": {
                <a data-footnote-ref href="#user-content-fn-2">"host"</a>: {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "MacAddress": "",
                    "NetworkID": "a9ddd20e58a296eb7739da0c571e8bf1ed78beb32306f2230c9eaf16e90077f5",
                    "EndpointID": "6fd29be0fe2c0fae4d259dd637896bd0181a2f726b093ea4d914cecf72bd5f8b",
                    "Gateway": "",
                    "IPAddress": "",
                    "IPPrefixLen": 0,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "DriverOpts": null,
                    "DNSNames": null
                }
            }
        }
    }
]

</code></pre>



## Create user-defined network

```bash
~ ✖ docker network create \
> --driver bridge \
> --subnet 182.18.0.0/24 \
> --gateway 182.18.0.1 \
> wp-mysql-network
a70656c7969a9fe6b8180897e06fe0f337b9aa0eed892f287bfd1084e6473c89


~ ➜  docker run -d --name mysql-db --network=wp-mysql-network -e MYSQL_ROOT_PASSWORD=db_pass123 mysql:5.6
eea0edcc02ff29b709ac89f2fe2e218dea805498123d0eac1a1f65a16a00799c

~ ➜  docker run -d --name webapp -p 38080:8080 --network=wp-mysql-network -e DB_Host=mysql-db -e DB_Password=db_pass123 --link mysql-db:mysql-db kodekloud/simple-webapp-mysql
f4d00fb727eba11152ea3b50f371b7df021030248f9e7b0d3793f4d1b2c1f783
```

[^1]: Subnet of bridge network

[^2]: the network to which the alpine-1 container is attached to&#x20;
