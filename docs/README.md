---
icon: docker
---

# Docker Overview

> **Docker:**&#x20;
>
> an open platform to&#x20;
>
> * build,&#x20;
> * ship, and&#x20;
> * run&#x20;
>
> distributed applications on&#x20;
>
> * laptops,&#x20;
> * data center VMs, or&#x20;
> * the cloud



## Why Docker?

<figure><img src=".gitbook/assets/matrix-hell2.png" alt="" width="375"><figcaption><p>End to end application stack - causing a matrix from hell</p></figcaption></figure>

Traditional methods often struggle with:

* Compatibility between services, libraries, and OS versions
  * services and underlying OS and OS version
  * services and libraries and dependencies&#x20;
  * services and  different versions of dependent libraries
* Changes over time
  * e.g:&#x20;
    * changes to application architecture
    * version upgrades of different components
  * Compatibility between components and the underlying infrastructure must be verified whenever any of them undergoes a change.&#x20;
* Tedious environment setup for new developers
* Inconsistent application behavior across development, testing, and production environments



╰**---**➤ Difficulty in developing, building and shipping the application due to compatibility issues



{% hint style="success" %}
Docker addresses challenges like&#x20;

* **compatibility/ dependency** issues,&#x20;
* **environment setup**, and&#x20;
* **resource efficiency**.&#x20;
{% endhint %}

\


## What is Docker?

> * **Containerize applications**
>   * Purpos&#x65;**:**&#x20;
>     * package and containerize applications
>     * ship them&#x20;
>     * run them anywhere, anytime, as many times as you want
> * Run each service with its own dependencies in separate containers,&#x20;
>   * all on the same VM and the OS
>   * but within separate environments/containers

<figure><img src=".gitbook/assets/with-docker.png" alt="" width="563"><figcaption><p>With Docker</p></figcaption></figure>

## Benefits of Docker

* **Flexible Component Modification:** allows to modify/change components (even the underlying operating systems) as required, without affecting  other components&#x20;
* **Simplified setup:** A single Docker configuration (build once and for all) allows developers to start with a simple `docker run` command, irrespective of the underlying operating system they run.
  * They only need to have docker installed.
* **Portability:** Applications run consistently across different environments.
* **Efficiency:** Containers are lightweight (MBs vs. GBs for VMs) and boot up quickly (seconds vs. minutes for VMs).

{% hint style="info" %}
Containers are more lightweight and resource-efficient compared to virtual machines (VMs).
{% endhint %}



## Containers

> **Containers**:
>
> * completely isolated environments
>   * can have their own&#x20;
>     * processes/ services,&#x20;
>     * network interfaces
>     * mounts
> * like virtual machines, except they all share the same OS kernel

<figure><img src=".gitbook/assets/containers.png" alt="" width="563"><figcaption><p>Containers</p></figcaption></figure>

***

{% hint style="info" %}
**Containers are not new with Docker**
{% endhint %}

* some of the different types of containers: `LXC`, `LXD`, `LXCFS`
  * These are very low level and setting these container environments is hard
* Docker utilizes `LXC` containers and offers a high level tool with many powerful functionalities&#x20;

***



OS[^1] consists of 2 things&#x20;

1. [**OS Kernel**](#user-content-fn-2)[^2]: responsible for interacting with the underlying hardware
2. **Set of Software**: may consists of different user interfaces, drivers, compilers, file managers, developer tools, etc.

{% hint style="success" %}
The **OS kernel** remains same across different operating systems. It's the **software** above the kernel that differentiates them.&#x20;
{% endhint %}

e.g: a **common Linux kernel** is shared across various Linux-based OSs; custom software above it makes each OS unique

<figure><img src=".gitbook/assets/OS-kernal-n-software.png" alt="" width="563"><figcaption></figcaption></figure>

***

{% hint style="info" %}
Docker containers **share the underlying OS kernel**.&#x20;
{% endhint %}

* **`Docker`**, installed on an **`Ubuntu`** system, can run containers from any Linux distribution (e.g., Debian, Fedora, SUSE, CentOS), as long as they share the same Linux kernel.
  * Here, Docker uses the **Linux kernel** of the Docker host and each Docker container only has the additional software to create unique OSes.

<figure><img src=".gitbook/assets/docker-containers-n-oses.png" alt="" width="563"><figcaption></figcaption></figure>

* However, Docker, installed on an Ubuntu system, cannot run Windows-based containers, as Windows uses a different kernel.
  * To run a Windows container, Docker on a Windows server is required.
* When running a Linux container with Docker installed on Windows,&#x20;
  * Docker actually runs the container on a **Linux virtual machine** under the hood, not directly on Windows.

***

{% hint style="success" %}
Docker's **inability** **to run a different kernel on the host** operating system is **not a disadvantage**.
{% endhint %}

* **unlike** **`hypervisors`**, Docker is not meant to virtualize and run different operating systems and kernels on the same hardware.&#x20;
* Purpose of docker is to package and containerize applications so that they can be shipped and run anywhere anytime.

## Docker Containers vs. Virtual Machines

<figure><img src=".gitbook/assets/docker-vs-vm.png" alt="" width="563"><figcaption><p>VM vs Docker</p></figcaption></figure>



|                                                                                                                 VM                                                                                                                 |                                                                                               Docker Containers                                                                                               |
| :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| <p><code>Have separate OSs</code></p><p>Overhead causes <strong>higher utilization</strong> of underlying <strong>resources</strong><br><strong>-</strong> as there are multiple virtual operating systems and kernels running</p> |                                                   <p><code>Share the OS kernel</code></p><p>Have better <strong>resource efficiency</strong><br><br><br></p>                                                  |
|                                                                                 <p>HVM consume higher disk space<br><strong>GB</strong> in size</p>                                                                                |                                                               <p>Containers are <strong>lightweight</strong><br><strong>MB</strong> in size</p>                                                               |
|                                                                               <p>takes minutes to boot up <br>- since entire OS should be boot up</p>                                                                              |                                                                       <p>can boot up faster (in seconds)<br>- since it's lightweight</p>                                                                      |
|                                                         <p>completely isolated<br>can run different types of applications built on different OSs on the same hypervisor</p>                                                        |                                                            <p>less isolated<br>more resources are shared between the containers like the kernel</p>                                                           |
|                                                                    <p>provide <strong>full OS virtualization</strong> <br>- host an entire operating system</p>                                                                    | <p>Run a <strong>specific tasks or processes</strong><br><br>e.g: </p><ul><li>host an instance of a web server/ application server/database</li><li>carry some kind of computation ro analysis task</li></ul> |



## Containers provisioned on virtual Docker hosts

{% hint style="success" %}
**Containers and VMs can complement each other**,&#x20;

with containers deployed on virtualized hosts for scalability.
{% endhint %}

<figure><img src=".gitbook/assets/vm-compliments-docker-containers.png" alt="" width="563"><figcaption><p><strong>Containers and VMs can complement each other</strong></p></figcaption></figure>



Containers provisioned on virtual Docker hosts

* utilize the advantages of both technologies
  * benefits of **virtualization**&#x20;
    * to easily provision or decommission Docker hosts as required
  * benefits of **Docker**&#x20;
    * to easily provision applications and quickly scale them as required
  * In this case, number of VMs provisioned are lesser than usual
    * usual: VM for each application
    * in this case: VM for 100's 1000's of containers with containerized applications



{% hint style="info" %}
Most organizations have their products containerized and available in a p**ublic Docker repository** called `DockerHub` or `Docker Store`.&#x20;
{% endhint %}



## Images and Containers

> **Images:** Templates for creating containers (e.g., preconfigured application environments).
>
> **Containers:** Running instances of images with isolated environments.

<figure><img src=".gitbook/assets/images-vs-containers.png" alt="" width="375"><figcaption><p>Images VS Containers</p></figcaption></figure>

{% hint style="info" %}
If you can't find the image you are looking for,&#x20;

\--> then you can create your own image and push it to the DockerHub repository.
{% endhint %}

&#x20;&#x20;

## DevOps Integration

* Developers and Ops teams collaborate to create a DockerFile that defines application setup.
* Images built from the `DockerFile` ensure consistent behavior across all environments.

\


[^1]: e.g: Ubuntu, Fedora, SUSE, CentOS, Debian

[^2]: e.g: Linux
