---
icon: folders
---

# Docker Container File System

## Docker Container File System



✅ Follows the <mark style="color:green;">**Linux Filesystem Hierarchy (FHS)**</mark> and common Docker conventions.

✅ Keeps **image size small** when you **delete installers** after installing.

✅ Makes ownership, permissions and volumes **predictable** for runtime data and upgrades.

* ✅  Create and switch to a non-root USER for running the app; chown files during build.

✅ Copy installers (transient installers/packages) to a temp dir (build-time temp location), install, then **remove them in the same `RUN` layer** to avoid leaving them in earlier layers.

✅ Avoid using `/root` for app files; reserve `/root` for the container user’s home if needed.

✅ **Ownership & user**: create a non‑root user and chown files.

✅ **Build hygiene**: use multi‑stage builds, copy only artifacts needed at runtime, and add a `.dockerignore` to exclude dev files.

✅  **Tooling**: install only required packages in the image and keep image layers small.

#### <mark style="color:blue;">**When to mount vs copy into image**</mark>

* **Mount** as a volume (`/var/lib/<app>` or `/srv/<app>`) when **data is large**, mutable or must survive container replacement.
* Copy into image only for static seed data or small datasets that should be baked into the image.

#### <mark style="color:blue;">**Permissions and user**</mark>

* During build, set ownership with --chown or chown in the same layer.
* Switch to a non-root user (USER) for runtime.
* e.g:: `COPY --chown=appuser:appgroup` ... and then `USER appuser`

<table data-header-hidden><thead><tr><th valign="top"></th><th valign="top"></th></tr></thead><tbody><tr><td valign="top"><p>build/install artifacts</p><ul><li>temporary during image build</li></ul></td><td valign="top"><code>/tmp</code> or <code>/usr/src/&#x3C;app></code></td></tr><tr><td valign="top"><p>third‑party application files / installed app </p><ul><li>so it’s easy to find  vendor software and doesn’t conflict with distro packages</li></ul></td><td valign="top"><code>/opt/&#x3C;app></code> or <code>/usr/local/&#x3C;app></code></td></tr><tr><td valign="top">runtime/persistent data</td><td valign="top"><code>/var/lib/&#x3C;app></code> or <code>/srv/&#x3C;app></code> — <strong>mount as a volume</strong> at runtime</td></tr><tr><td valign="top"><p>configuration files </p><ul><li>so system tools and admins can find it</li></ul></td><td valign="top"><p><code>/etc/&#x3C;app></code> </p><p>(or <code>/etc/default/&#x3C;app></code>, <code>/etc/&#x3C;app>/conf.d</code>)</p></td></tr><tr><td valign="top">Apt cache / archives (if you need to keep <code>.deb</code> files for some reason)</td><td valign="top"><p><code>/var/cache/apt/archives</code> </p><ul><li>but usually you should remove them</li></ul></td></tr><tr><td valign="top">your app code</td><td valign="top">copy to <code>/usr/src/app</code>, <code>/opt/</code>, or <code>/app</code> (common)</td></tr><tr><td valign="top">entrypoint / scripts / executable location &#x26; <code>ENTRYPOINT</code></td><td valign="top"><p>place executables in <code>/usr/local/bin</code> or under project <code>/opt/app/bin</code> and make them executable (chmod +x)</p><ul><li>keep scripts colocated with the project if they rely on relative paths</li><li>put small helper scripts in <code>/usr/local/bin</code></li><li>set <strong><code>ENTRYPOINT</code></strong> to the single orchestration script</li></ul></td></tr><tr><td valign="top">configs</td><td valign="top"><p>put runtime config templates in <code>/etc/</code> or inside the project at <code>/app/config</code> </p><ul><li>the entrypoint’s <code>CONFIG_DIR</code> must match</li></ul></td></tr><tr><td valign="top">runtime/state</td><td valign="top"><p>use <code>/var/lib/</code> or <code>/app/runtime</code> for generated artifacts</p><ul><li>prefer writable dirs with proper ownership</li></ul></td></tr><tr><td valign="top"></td><td valign="top"></td></tr></tbody></table>

#### Example — application layout recommendations

* /opt/myapp: application binaries and static bundled assets
* /etc/myapp: configuration files
* /var/lib/myapp: persistent runtime data (database files, uploads) — mount as Docker volume
* /var/log/myapp: logs (or forward logs to stdout/stderr instead)



