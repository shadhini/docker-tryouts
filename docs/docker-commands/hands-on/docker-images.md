---
icon: image-landscape
---

# Docker Images

## View layered architecture of a docker image&#x20;

```bash
~ via 💎 v3.1.3 
❯ docker history jenkins/jenkins
IMAGE          CREATED       CREATED BY                                      SIZE      COMMENT
b9f350311251   3 days ago    LABEL org.opencontainers.image.vendor=Jenkin…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    ENTRYPOINT ["/usr/bin/tini" "--" "/usr/local…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    COPY jenkins-plugin-cli.sh /bin/jenkins-plug…   323B      buildkit.dockerfile.v0
<missing>      3 days ago    COPY jenkins.sh /usr/local/bin/jenkins.sh # …   2.4kB     buildkit.dockerfile.v0
<missing>      3 days ago    COPY jenkins-support /usr/local/bin/jenkins-…   6.5kB     buildkit.dockerfile.v0
<missing>      3 days ago    USER jenkins                                    0B        buildkit.dockerfile.v0
<missing>      3 days ago    COPY /javaruntime /opt/java/openjdk # buildk…   91.1MB    buildkit.dockerfile.v0
<missing>      3 days ago    ENV PATH=/opt/java/openjdk/bin:/usr/local/sb…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    ENV JAVA_HOME=/opt/java/openjdk                 0B        buildkit.dockerfile.v0
<missing>      3 days ago    ENV COPY_REFERENCE_FILE_LOG=/var/jenkins_hom…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    EXPOSE map[50000/tcp:{}]                        0B        buildkit.dockerfile.v0
<missing>      3 days ago    EXPOSE map[8080/tcp:{}]                         0B        buildkit.dockerfile.v0
<missing>      3 days ago    RUN |16 GIT_LFS_VERSION=3.6.0 TARGETARCH=arm…   6.95MB    buildkit.dockerfile.v0
<missing>      3 days ago    ARG PLUGIN_CLI_URL=https://github.com/jenkin…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG PLUGIN_CLI_VERSION=2.13.2                   0B        buildkit.dockerfile.v0
<missing>      3 days ago    RUN |14 GIT_LFS_VERSION=3.6.0 TARGETARCH=arm…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    ENV JENKINS_INCREMENTALS_REPO_MIRROR=https:/…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    ENV JENKINS_UC_EXPERIMENTAL=https://updates.…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    ENV JENKINS_UC=https://updates.jenkins.io       0B        buildkit.dockerfile.v0
<missing>      3 days ago    RUN |14 GIT_LFS_VERSION=3.6.0 TARGETARCH=arm…   96.4MB    buildkit.dockerfile.v0
<missing>      3 days ago    ARG JENKINS_URL=https://repo.jenkins-ci.org/…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG JENKINS_SHA=ccef73536436ced77776c994cfc8…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    ENV JENKINS_VERSION=2.491                       0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG JENKINS_VERSION=2.491                       0B        buildkit.dockerfile.v0
<missing>      3 days ago    RUN |11 GIT_LFS_VERSION=3.6.0 TARGETARCH=arm…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    VOLUME [/var/jenkins_home]                      0B        buildkit.dockerfile.v0
<missing>      3 days ago    RUN |11 GIT_LFS_VERSION=3.6.0 TARGETARCH=arm…   4.41kB    buildkit.dockerfile.v0
<missing>      3 days ago    ENV REF=/usr/share/jenkins/ref                  0B        buildkit.dockerfile.v0
<missing>      3 days ago    ENV JENKINS_SLAVE_AGENT_PORT=50000              0B        buildkit.dockerfile.v0
<missing>      3 days ago    ENV JENKINS_HOME=/var/jenkins_home              0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG REF=/usr/share/jenkins/ref                  0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG JENKINS_HOME=/var/jenkins_home              0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG agent_port=50000                            0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG http_port=8080                              0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG gid=1000                                    0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG uid=1000                                    0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG group=jenkins                               0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG user=jenkins                                0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG COMMIT_SHA=cadf75eb138f94ad70031803b79cc…   0B        buildkit.dockerfile.v0
<missing>      3 days ago    ARG TARGETARCH=arm64                            0B        buildkit.dockerfile.v0
<missing>      3 days ago    ENV LANG=C.UTF-8                                0B        buildkit.dockerfile.v0
<missing>      3 days ago    RUN |1 GIT_LFS_VERSION=3.6.0 /bin/sh -c arch…   11.8MB    buildkit.dockerfile.v0
<missing>      3 days ago    ARG GIT_LFS_VERSION=3.6.0                       0B        buildkit.dockerfile.v0
<missing>      3 days ago    RUN /bin/sh -c apt-get update   && apt-get i…   151MB     buildkit.dockerfile.v0
<missing>      2 weeks ago   # debian.sh --arch 'arm64' out/ 'bookworm' '…   139MB     debuerreotype 0.15
```



## Setup a simple flask web server on a docker container manually

```bash
~ via 💎 v3.1.3 
❯ docker run -it --name test-flask-webapp ubuntu bash

root@624b349ae035:/# python
bash: python: command not found


root@624b349ae035:/# apt-get update
.....
Fetched 27.3 MB in 13s (2080 kB/s)                                                                                                    
Reading package lists... Done


root@624b349ae035:/# apt-get install python3   
Reading package lists... Done
.....


root@624b349ae035:/# apt-get install python3-pip
Reading package lists... Done
.....


root@624b349ae035:/# apt-get install python3-venv
Reading package lists... Done

root@624b349ae035:/# python3 -m venv .venv
root@624b349ae035:/# ls -a
.  ..  .dockerenv  .venv  bin  boot  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var

root@624b349ae035:/# source .venv/bin/activate
(.venv) root@624b349ae035:/# 


(.venv) root@624b349ae035:/# pip install flask
Collecting flask .....
Successfully installed Jinja2-3.1.5 MarkupSafe-3.0.2 Werkzeug-3.1.3 blinker-1.9.0 click-8.1.8 flask-3.1.0 itsdangerous-2.2.0


(.venv) root@624b349ae035:/# pip install flask-mysql
Collecting flask-mysql.....
Successfully installed PyMySQL-1.1.1 flask-mysql-1.6.0
(.venv) root@624b349ae035:/# 

(.venv) root@624b349ae035:/# cat > /opt/app.py
import os
from flask import Flask
from flaskext.mysql import MySQL      # For newer versions of flask-mysql
# from flask.ext.mysql import MySQL   # For older versions of flask-mysql
app = Flask(__name__)

mysql = MySQL()

# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = 'docker-webapp'
app.config['MYSQL_DATABASE_PASSWORD'] = 'pwdocker-webapp'
app.config['MYSQL_DATABASE_DB'] = 'flask_webapp_db'
app.config['MYSQL_DATABASE_HOST'] = 'host.docker.internal'
mysql.init_app(app)

conn = mysql.connect()

cursor = conn.cursor()

@app.route("/")
def main():
    return "Welcome!"

@app.route('/how are you')
def hello():
    return 'I am good, how about you?'

@app.route('/read from database')
def read():
    cursor.execute("SELECT * FROM employees")
    row = cursor.fetchone()
    result = []
    while row is not None:
      result.append(row[0])
      row = cursor.fetchone()

    return ",".join(result)

if __name__ == "__main__":
    app.run()


(.venv) root@624b349ae035:/# 
(.venv) root@624b349ae035:/# FLASK_APP=/opt/app.py flask run --host=0.0.0.0
 * Serving Flask app '/opt/app.py'
 * Debug mode: off
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:5000
 * Running on http://172.17.0.2:5000
Press CTRL+C to quit

^C(.venv) root@624b349ae035:/# deactivate                                        
root@624b349ae035:/# exit
exit
```

{% hint style="success" %}
Use `host.docker.internal` instead of `localhost` to access a service running on the docker host from the docker container. This special DNS name resolves to the host machine's IP from within the container.
{% endhint %}

{% hint style="info" %}
Here, you cannot access web server on http://172.17.0.2:5000 if you are on **MacOS**. You have to map the internal port to a docker host port to access web server from docker host on **MacOS**. \
However, you cannot modify the port mapping of an existing container. Thus, this should be done at the time of container creation. Or you'll have to create a new container.
{% endhint %}

