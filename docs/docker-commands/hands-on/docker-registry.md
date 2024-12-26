---
icon: cloud
---

# Docker Registry

## Push images to an on-premise private registry &#x20;

```bash
~ ➜  docker run -d --name my-registry -p 5000:5000 --restart=always registry:2
.....
24e4af53b546df8efd2db01a278ec48ed81f3e18f46e5e3e7f0ebe87971620d9


~ ➜  docker ps                                                                
CONTAINER ID   IMAGE        COMMAND                  CREATED          STATUS          PORTS                                       NAMES
24e4af53b546   registry:2   "/entrypoint.sh /etc…"   41 seconds ago   Up 39 seconds   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   my-registry


~ ✖ docker pull nginx:latest
.....
docker.io/library/nginx:latest


~ ➜  docker pull httpd:latest
.....
docker.io/library/httpd:latest


~ ➜  docker images           
REPOSITORY                      TAG       IMAGE ID       CREATED         SIZE
nginx                           latest    f876bfc1cc63   4 weeks ago     192MB
alpine                          latest    91ef0af61f39   3 months ago    7.79MB
postgres                        latest    b781f3a53e61   4 months ago    432MB
ubuntu                          latest    edbfe74c41f8   4 months ago    78MB
redis                           latest    590b81f2fea1   4 months ago    117MB
mysql                           latest    a82a8f162e18   5 months ago    586MB
httpd                           latest    4ce47c750a58   5 months ago    147MB
registry                        2         c18a86d35e98   15 months ago   25.4MB
kodekloud/simple-webapp-mysql   latest    129dd9f67367   6 years ago     96.6MB
kodekloud/simple-webapp         latest    c6e3cd9aae36   6 years ago     84.8MB

~ ➜  docker image tag nginx localhost:5000/nginx

~ ➜  docker image tag httpd localhost:5000/httpd

~ ➜  docker push localhost:5000/nginx           
Using default tag: latest
The push refers to repository [localhost:5000/nginx]
..... 
latest: digest: sha256:1fdc65e25b1aa5ec3774c6226f5cf2d537c83bf42cf8ed679554489bfda6c385 size: 1778


~ ➜  docker push localhost:5000/httpd
Using default tag: latest
The push refers to repository [localhost:5000/httpd]
..... 
latest: digest: sha256:0b046566348f6be8735b6bcd7936b2517c86d9da5716e9502adcf8eae4da8fcc size: 1572


~ ➜  curl -X GET localhost:5000/v2/_catalog
{"repositories":["httpd","nginx"]}



```



## Pull images from an on-premise private registry

```bash
~ ➜  docker images
REPOSITORY                      TAG       IMAGE ID       CREATED         SIZE
nginx                           latest    f876bfc1cc63   4 weeks ago     192MB
localhost:5000/nginx            latest    f876bfc1cc63   4 weeks ago     192MB
alpine                          latest    91ef0af61f39   3 months ago    7.79MB
postgres                        latest    b781f3a53e61   4 months ago    432MB
ubuntu                          latest    edbfe74c41f8   4 months ago    78MB
redis                           latest    590b81f2fea1   4 months ago    117MB
mysql                           latest    a82a8f162e18   5 months ago    586MB
httpd                           latest    4ce47c750a58   5 months ago    147MB
localhost:5000/httpd            latest    4ce47c750a58   5 months ago    147MB
registry                        2         c18a86d35e98   15 months ago   25.4MB
registry                        latest    c18a86d35e98   15 months ago   25.4MB
kodekloud/simple-webapp-mysql   latest    129dd9f67367   6 years ago     96.6MB
kodekloud/simple-webapp         latest    c6e3cd9aae36   6 years ago     84.8MB

~ ➜  docker image prune -a
WARNING! This will remove all images without at least one container associated to them.
.....
untagged: ubuntu:latest
untagged: ubuntu@sha256:8a37d68f4f73ebf3d4efafbcf66379bf3728902a8038616808f04e34a9ab63ee
deleted: sha256:edbfe74c41f8a3501ce542e137cf28ea04dd03e6df8c9d66519b6ad761c2598a
deleted: sha256:f36fd4bb7334b7ae3321e3229d103c4a3e7c10a263379cc6a058b977edfb46de

Total reclaimed space: 1.592GB


~ ➜  docker images        
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE
registry     latest    c18a86d35e98   15 months ago   25.4MB


~ ➜  docker pull localhost:5000/httpd            
.....
localhost:5000/httpd:latest

~ ➜  docker pull localhost:5000/nginx                    
.....
localhost:5000/nginx:latest

~ ➜  docker images                   
REPOSITORY             TAG       IMAGE ID       CREATED         SIZE
localhost:5000/nginx   latest    f876bfc1cc63   4 weeks ago     192MB
localhost:5000/httpd   latest    4ce47c750a58   5 months ago    147MB
registry               latest    c18a86d35e98   15 months ago   25.4MB
```



