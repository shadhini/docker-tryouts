---
icon: apple
---

# Docker on Mac

## Running Linux Containers on Mac

### 1. Docker on Mac using Docker Toolbox

| **Linux VM with Docker**: Boot2Docker Linux VM with Docker pre-installed |
| ------------------------------------------------------------------------ |
| **Oracle** **Virtual Box**                                               |
| **Mac**                                                                  |

* Original support for docker on Mac
* This involves running Docker on a Linux VM created with VirtualBox.&#x20;
* It only supports Linux containers and is unrelated to macOS applications, images, or containers.
* Docker Toolbox includes tools such as&#x20;
  * Oracle VirtualBox,&#x20;
  * Docker Engine,&#x20;
  * Docker Machine,&#x20;
  * Docker Compose&#x20;
  * Kitematic UI.&#x20;
* Installing Docker Toolbox **sets up VirtualBox and deploys a lightweight VM called Boot2Docker with Docker pre-installed**.&#x20;
* It requires macOS 10.8 or newer.

### 2. Docker Desktop for Mac

| **Linux VM with Docker** |
| ------------------------ |
| **HyperKit**             |
| **Mac**                  |

* Docker Desktop for Mac replaces `Oracle VirtualBox` with **`HyperKit`** virtualization.&#x20;
* It sets up a Linux system using HyperKit to run Docker.&#x20;
* This requires macOS Sierra 10.12 or newer and Mac hardware from 2010 or later.



{% hint style="info" %}
There are no Mac based images or containers as of today.
{% endhint %}
