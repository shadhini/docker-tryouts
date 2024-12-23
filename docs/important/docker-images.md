---
icon: image-landscape
---

# Docker Images

## When to create your own image?

* If a component or service you need for your application is not already available on Docker Hub.
* When you/your team decided to dockerize the application you’re developing to simplify shipping and deployment.



## Create your own image

1.  Understand&#x20;

    1. what we are containerizing; what application we are creating an image for&#x20;
    2. how the application is built; what you'd do if you want to deploy the application manually


2. Write down the steps required in the right order
   *   e.g: containerize a simple web application developed using Python flask framework

       1. OS - Ubuntu
       2. Update _apt_ repo
       3. Installing dependencies using _apt_
       4. Install python dependencies using _pip_
       5. Copy source code to `/opt` folder
       6. Run the web server using the `"flask"` command


3.  Create `Dockerfile` using these steps

    * ```docker
      FROM ubuntu:latest
      LABEL authors="shadhini"

      RUN apt-get update
      RUN apt-get install python

      RUN pip install flask
      RUN pip install flask-mysql

      COPY . /opt/source-code

      ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
      ```


4.  Build the docker image locally and tag it

    * ```bash
      docker build <PATH_TO_DOCKERFILE> -t <IMAGE_TAG/NAME>

      # example
      docker build . -t shadhinij/flask-webapp
      ```


5. Push to public `DockerHub` registry
   * ```bash
     docker push <IMAGE_NAME>

     # example
     docker push shadhinij/flask-webapp
     ```



{% hint style="info" %}
By default, if you don't specify an organization in the image name, Docker tries to push it to the **`library`** (the default account for official repositories) and attempt would fail.&#x20;

Only Docker-supported official repositories can push to **`library`**.&#x20;

You can push images only to repositories under your own account.
{% endhint %}

## Dockerfile

<figure><img src="../.gitbook/assets/dockerfile.png" alt="" width="375"><figcaption><p>Dockerfile</p></figcaption></figure>

{% hint style="success" %}
Every Docker image must be **based on either an operating system or another image** derived from an OS.
{% endhint %}

{% hint style="success" %}
All Dockerfiles **must** start with the **FROM** instruction specifying the **base image**.
{% endhint %}

`FROM`: used to specify the base image

`RUN`: instructs to run a particular command on the base image

`COPY`: copies files from the local system on to the docker image

`ENTRYPOINT`: allows us to specify a command that will be run when the image is run as a container&#x20;



## Layered Architecture

{% hint style="success" %}
Docker builds images in a **layered architecture**,&#x20;

where **each instruction creates a new layer** that includes only the changes from the previous layer.
{% endhint %}

{% hint style="info" %}
Since **each layer** **only** **stores the changes from the previous layer**,&#x20;

&#x20;       it is reflected in the **size** as well.
{% endhint %}

<figure><img src="../.gitbook/assets/layered-architecture-n-size.png" alt=""><figcaption><p>Layered Architecture</p></figcaption></figure>

You can view information about layered architecture of the docker image with size using the following command

```bash
docker history <IAMGE_NAME>
```



{% hint style="success" %}
The `docker build` command shows each step and its result

&#x20;          and it **cashes all the layers**.



So the layered architecture allows you&#x20;

* to resume the build from a specific step if it fails — rebuild resumes from the failed layer
* to resume if new steps are added to the build process without starting from the beginning — only layers above the updated layer is rebuilt

╰**--**➤ **rebuilding image is faster**
{% endhint %}



