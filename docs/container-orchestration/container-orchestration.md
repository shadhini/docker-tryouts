---
icon: network-wired
---

# Container Orchestration

## Why Orchestrate?

When the number of users increases beyond what a single instance can handle, you must manually deploy additional instances of your application.&#x20;

╰**--**➤ This requires closely **monitoring the load, performance, and health** of your containers.&#x20;

* If a **container fails**,&#x20;
  * you must detect the failure and redeploy it.&#x20;
* If the Docker **host crashes**,&#x20;
  * all its containers become inaccessible, requiring further intervention.

Monitoring and managing large-scale applications with thousands of containers manually or through custom scripts is impractical.&#x20;

╰**--**➤ **Container orchestration** solves these challenges by **automating deployment, scaling, health monitoring, and recovery**.



## Container Orchestration

> **Container orchestration solutions:**
>
> provide tools and scripts to manage containers in production environments

&#x20;&#x20;

* typically, consist of **multiple Docker hosts** to ensure application availability even if one host fails.&#x20;
* enable the **deployment of** hundreds or **thousands of** application **instances** with a single command.&#x20;

#### Features:

* **automatic scaling** of instances based on user demand
* **adding additional hosts** to handle load
* **advanced networking** across hosts
* **load balancing**
* **shared storage**
* **configuration management**
* **security**



## Container Orchestration Solutions

#### 1. Docker Swam from Docker

* 🟢 easy to setup and get started
* 🔴 lacks some advanced auto-scaling features

#### 2. Kubernetes from Google

* 🟢 most popular
* 🔴 bit difficult to setup and get started&#x20;
* 🟢 provides a lot of options to customize deployments &#x20;
* 🟢 has support for many different vendors
* 🟢 now supported on all public cloud service providers like **GCP**, **Azure**, and **AWS**
* 🟢 one of the top-ranked projects on GitHub

#### 3. MESOS from Apache

* 🔴 quite difficult to setup and get started
* 🟢 support many advance features&#x20;

