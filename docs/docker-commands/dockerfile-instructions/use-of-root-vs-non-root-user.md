---
icon: user-group
---

# Use of root vs non-root user

## Use of root vs non-root user

{% hint style="info" %}
#### The principle:&#x20;

least privilege — give the container only the privileges it needs
{% endhint %}

✅ Prefer a **non-root user** for containers you build for production.&#x20;

✅ Run as **root** **only when** you must (e.g., for setup steps or when the process truly requires root capabilities).&#x20;

#### Why non-root is recommended (plain language)

* Security: If an attacker escapes the app/process, a non-root process has fewer privileges to damage the host or other containers.
* Defense-in-depth: Many layers (Docker, kernel, namespaces) help isolate containers — but running as root inside the container weakens those layers.
* Compliance & best practice: Many security scanners, CI checks and cloud providers flag or block root containers.
* Predictability: Files created by the container will use a known UID/GID instead of root:root which can cause surprises with host-mounted volumes.

#### When root inside container is OK or required

* Building or installing system packages in image layers (RUN apt-get …) usually needs root, but you can drop to non-root afterwards.
* Binding to privileged ports (<1024) or using capabilities (net admin, mounting, etc.) may require root or granting specific capabilities — better alternatives exist (setcap, reverse proxy, port mapping).
* Local development: sometimes running as root is convenient, but prefer matching production behavior early.

#### Practical issues to watch for

* Volumes and host mounts: If you mount a host directory, the host’s filesystem permissions apply. A non-root user inside the container may not have access unless you:
  * Make the mounted files accessible on the host, or
  * Run container with --user to match the host UID, or
  * In entrypoint, chown files (but chown on large volumes may be slow).
* Binding to port 80/443: Instead of running as root, use Docker’s port mapping (docker run -p 80:8080) or give only the executable the capability to bind lower ports via setcap.
* When you need a specific UID/GID (e.g., to match host user), create the user with that UID/GID in the Dockerfile.
