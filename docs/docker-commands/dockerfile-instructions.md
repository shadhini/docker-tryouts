---
icon: docker
---

# Dockerfile Instructions

<table><thead><tr><th width="160.16796875" valign="top">Instruction</th><th valign="top">Description</th></tr></thead><tbody><tr><td valign="top"><strong><code>FROM</code></strong></td><td valign="top"><p>used to specify the base image/OS</p><ul><li><p><mark style="color:blue;"><strong>Stage boundary</strong>:</mark> a stage begins with <code>FROM</code> and ends when the next <code>FROM</code> appears (or the file ends)</p><ul><li>e.g: <code>FROM base AS build</code> → this begins the "build" stage</li></ul></li><li><p><mark style="color:blue;"><strong>Alias vs index:</strong></mark></p><ul><li><strong>Alias</strong>: <code>FROM node:20 AS builder</code> — you can reference this stage later as <kbd>"builder"</kbd></li><li><p><strong>Index</strong>: If you don't alias, the stage still has a numeric index <strong>(0, 1, 2...)</strong></p><ul><li>You can do <code>COPY --from=0</code> to pull from the first stage</li></ul></li></ul></li><li><p><mark style="color:blue;"><strong>Isolation</strong>:</mark> each stage has its own filesystem layers and metadata</p><ul><li>files created in stage A are not present in stage B unless you use <code>COPY --from=stage</code> to transfer them.</li></ul></li><li><p><mark style="color:blue;"><strong>Instruction scope:</strong></mark></p><ul><li><strong><code>ARG</code></strong> declared after a FROM is only available inside that stage</li><li><strong><code>ENV</code></strong>, <strong><code>WORKDIR</code></strong>, <strong><code>USER</code></strong>, <strong><code>RUN</code></strong>, etc. apply only to the current stage</li><li><strong><code>ARG</code></strong> declared before the first FROM can be used in the FROM line (for dynamic base images) but must be re-declared in later stages if you want to access it there</li></ul></li><li><p><mark style="color:blue;"><strong>Final image contents</strong></mark>: only what you leave in the last stage (or the stage you build to with <code>--target</code>) ends up in the final image</p><ul><li>intermediate stages are not included in the final image, though they may be cached locally</li></ul></li><li><mark style="color:blue;"><strong>Referencing other stages</strong></mark>: use <code>COPY --from=&#x3C;name-or-index></code> to copy files from a previous stage into the current stage</li><li><mark style="color:blue;"><strong>Build targeting:</strong></mark> <code>docker build --target &#x3C;stage-name></code> builds up to and returns the image of that stage (useful for testing or caching)</li><li><mark style="color:blue;"><strong>External stage sources:</strong></mark> <code>COPY --from=some-image:tag</code> can copy from any image published on a registry — not only previous stages</li></ul><pre class="language-docker"><code class="lang-docker">FROM node:20 AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM node:20 AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/build /usr/share/nginx/html
</code></pre><p><code>docker build --target builder -t my-frontend:builder .</code> </p><ul><li>stop after stage 1 and produce an image containing the builder filesystem</li></ul></td></tr><tr><td valign="top"><strong><code>RUN</code></strong></td><td valign="top">instructs to run a particular command on the base image</td></tr><tr><td valign="top"><strong><code>COPY</code></strong></td><td valign="top">copies files from the local system on to the docker image</td></tr><tr><td valign="top"><strong><code>ENTRYPOINT</code></strong></td><td valign="top"><p>specifies the program/command to run when the container starts</p><ul><li>you can pass any executable file as the ENTRYPOINT </li></ul><pre class="language-docker"><code class="lang-docker">ENTRYPOINT &#x3C;COMMAND>

# example
ENTRYPOINT ["bash"] ✅
ENTRYPOINT bash ✅
</code></pre><ul><li><strong>command line arguments</strong> passed with <em><code>docker run</code></em> command will be <strong>appended</strong> to the ENTRYPOINT instruction</li><li>If an <strong>executable command</strong> is passed with <em><code>docker run</code></em> command, then it'll <strong>replace</strong> the ENTRYPOINT instruction</li></ul></td></tr><tr><td valign="top"><strong><code>CMD</code></strong></td><td valign="top"><p>defines the program that will be run within the container when it starts; </p><ul><li>this command is used as the default command to run when container is up if no commands are specified with the <em><code>docker run</code></em> command</li></ul><pre class="language-docker"><code class="lang-docker"># shell command format
CMD &#x3C;COMMAND> &#x3C;PARAM1...>

# example
CMD sleep 5
</code></pre><pre class="language-docker"><code class="lang-docker"># JSON format
CMD [&#x3C;COMMAND>, &#x3C;PARAM1>, &#x3C;PARAM2> ...]

# example
CMD ["sleep", "5"] ✅

# wrong syntax
CMD ["sleep 5"] ⛔
</code></pre><ul><li>The <strong>command line parameters</strong> passed will <strong>replace</strong> the CMD instruction <strong>entirely</strong></li><li><strong>Appending a command</strong> to the <strong><code>docker run</code></strong> command <strong>overrides the default command</strong> specified in the Docker image with <strong>CMD</strong> instruction</li></ul></td></tr><tr><td valign="top"><strong><code>ENTRYPOINT</code></strong> and <strong><code>CMD</code></strong> together</td><td valign="top"><p>In this case the <strong><code>CMD</code></strong> instruction will be <strong>appended</strong> to the <strong><code>ENTRYPOINT</code></strong> instruction</p><ul><li>❗For this to work both <strong><code>ENTRYPOINT</code></strong> and <strong><code>CMD</code></strong> instructions should be specified in JSON format</li><li>This behaviour can be utilized <strong>to pass default parameters to the <code>ENTRYPOINT</code> instruction</strong>, just in case arguments are not passed with the docker run command</li></ul><pre class="language-docker"><code class="lang-docker">ENTRYPOINT [&#x3C;COMMAND>]
CMD [&#x3C;PARAM1>, &#x3C;PARAM2> ...] 

#example
ENTRYPOINT ["sleep"]
CMD ["10"]
</code></pre><ul><li>If you pass <strong>arguments</strong> with the <strong><code>docker run</code></strong> command, then the arguments specified with the <strong><code>CMD</code></strong> instruction will be <strong>replaced</strong> by them.</li></ul></td></tr><tr><td valign="top"><strong><code>WORKDIR</code></strong></td><td valign="top">sets the working (current) directory for subsequent Dockerfile instructions and for the container at runtime unless overridden</td></tr><tr><td valign="top"><strong><code>ARG</code></strong></td><td valign="top"><p>defines <strong>build-time variables</strong> that are <strong>available only during docker build</strong> (not at container runtime)</p><ul><li>use <strong><code>--build-arg &#x3C;NAME>=&#x3C;value></code></strong> to pass values from the docker build command</li><li><strong><code>ARG</code></strong> can have default values. If you want the value to persist into the final image runtime environment, copy it into an <strong><code>ENV</code></strong></li><li><strong><code>ARG</code></strong> <strong>scope is per-stage</strong>; declare it <strong>before</strong> a <strong><code>FROM</code></strong> to use it in that <code>FROM</code>, and re-declare it in stages where you need it</li><li><p><strong>Do NOT use <code>ARG</code> for secrets</strong> — they can be recorded in image layers and build cache </p><ul><li>use <mark style="color:blue;"><strong><code>BuildKit</code></strong></mark> secrets or other secret mechanisms</li></ul></li></ul><pre class="language-docker"><code class="lang-docker"># declared before FROM -> usable in FROM interpolation
ARG BASE_IMAGE=alpine

FROM ${BASE_IMAGE}:3.18 AS builder
# ARG is NOT automatically available inside this stage unless re-declared:
ARG BASE_IMAGE  # redeclare if you want to access it in this stage
RUN echo "Building on ${BASE_IMAGE}"

FROM scratch
# BASE_IMAGE not available here unless declared again 
</code></pre><p></p></td></tr><tr><td valign="top"><strong><code>DEBIAN_FRONTEND</code></strong> env variable</td><td valign="top"><p>tells Debian/Ubuntu package tooling (debconf/dpkg) which UI frontend to use when configuring packages</p><ul><li>Common frontends: <code>dialog</code>, <code>readline</code> (interactive), <code>noninteractive</code>: used in automated builds</li><li><p><code>DEBIAN_FRONTEND=noninteractive</code> disables interactive prompts and forces packages to use defaults or previously-seeded debconf answers</p><ul><li>Without noninteractive, package installs that prompt will hang the build</li></ul></li></ul></td></tr></tbody></table>



## Best Practices

✅️ Give stages **descriptive names** with `AS` (builder, deps, test, final) for readability and easier `COPY --from` usage

✅️ Keep the **final stage minimal** (only `COPY` what you need)

* Multi-stage builds do not automatically transfer files between stages

✅️ Use **`--target`** **in local development/CI** to build only up to a stage you care about (speeds iteration)

✅️ **Re-declare `ARGs` in stages** where you need them (`ARG` before `FROM` can be used in `FROM`; re-declare after `FROM` to access inside that stage)

✅️ **Do not pass secrets via `ARG`** — they can be recorded in image history

* use **`BuildKit`** secrets or external secret management

✅️ Be **explicit** when **copying**: avoid copying the whole builder filesystem if you only need one artifact

#### ✅️ Use multiple FROMs to create multi-stage builds

```docker
# syntax=docker/dockerfile:1
FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn package

FROM tomcat
COPY --from=build /app/target/file.war /usr/local/tomcat/webapps 
```

Each `FROM` starts an **isolated stage** so you can:

* compile/build in one stage (with all build tools) and copy only the artifact into a minimal runtime image
* cache dependencies in a dedicated stage
* run tests or linters in separate stages
* produce different final variants (debug vs slim) from the same Dockerfile
* copy files from external images or other stages with `COPY --from=<name-or-index>`
* **Benefits**:&#x20;
  * smaller final images
  * clearer separation of concerns
  * faster iteration (docker build --target)&#x20;
  * safer images (no build tools or credentials left behind)

When to use multiple FROMs (common scenarios)

* **Language build + runtime**: compile or transpile with a heavy SDK, then copy the binary/asset into a tiny runtime image (e.g., distroless, scratch, alpine)
* **Dependency caching**: install dependencies in their own stage so builds are cached and faster when only source changes
* **CI/test stages**: run unit tests, linters, or integration checks inside the Dockerfile stages so CI can build and run those steps in-container
* **Multi-variant outputs**: create debug and production variants in one Dockerfile and select with `--target` or tag multiple outputs.
* **Packaging or installer creation**: use one stage to build an installer/package and another to assemble or sign it
* **Copying from external images**: bring artifacts from other published images: `COPY --from=some-image:tag` ...
* **Cross-platform or multi-architecture workflows** (with `buildx`) where stages can help structure per-arch build steps

When not to use multiple FROMs

* **Simple apps** where build and runtime environments are identical and small — a single-stage image is simpler
* **When you need every build-step filesystem state preserved** in the final image (multi-stage intentionally discards intermediate state)



#### 📁 Docker Container File System

<mark style="color:blue;">**Best Practices**</mark>

✅ Follows the <mark style="color:green;">**Linux Filesystem Hierarchy (FHS)**</mark> and common Docker conventions.

✅ Keeps **image size small** when you **delete installers** after installing.

✅ Makes ownership, permissions and volumes **predictable** for runtime data and upgrades.

* ✅  Create and switch to a non-root USER for running the app; chown files during build.

✅ Copy installers (transient installers/packages) to a temp dir (build-time temp location), install, then **remove them in the same `RUN` layer** to avoid leaving them in earlier layers.

✅ Avoid using `/root` for app files; reserve `/root` for the container user’s home if needed.

<mark style="color:blue;">**When to mount vs copy into image**</mark>

* **Mount** as a volume (`/var/lib/<app>` or `/srv/<app>`) when **data is large**, mutable or must survive container replacement.
* Copy into image only for static seed data or small datasets that should be baked into the image.

<mark style="color:blue;">**Permissions and user**</mark>

* During build, set ownership with --chown or chown in the same layer.
* Switch to a non-root user (USER) for runtime.
* e.g:: `COPY --chown=appuser:appgroup` ... and then `USER appuser`

<table data-header-hidden><thead><tr><th valign="top"></th><th valign="top"></th></tr></thead><tbody><tr><td valign="top"><p>build/install artifacts</p><ul><li>temporary during image build</li></ul></td><td valign="top"><code>/tmp</code> or <code>/usr/src/&#x3C;app></code></td></tr><tr><td valign="top"><p>third‑party application files / installed app </p><ul><li>so it’s easy to find  vendor software and doesn’t conflict with distro packages</li></ul></td><td valign="top"><code>/opt/&#x3C;app></code> or <code>/usr/local/&#x3C;app></code></td></tr><tr><td valign="top">runtime/persistent data</td><td valign="top"><code>/var/lib/&#x3C;app></code> or <code>/srv/&#x3C;app></code> — <strong>mount as a volume</strong> at runtime</td></tr><tr><td valign="top"><p>configuration files </p><ul><li>so system tools and admins can find it</li></ul></td><td valign="top"><p><code>/etc/&#x3C;app></code> </p><p>(or <code>/etc/default/&#x3C;app></code>, <code>/etc/&#x3C;app>/conf.d</code>)</p></td></tr><tr><td valign="top">Apt cache / archives (if you need to keep <code>.deb</code> files for some reason)</td><td valign="top"><p><code>/var/cache/apt/archives</code> </p><ul><li>but usually you should remove them</li></ul></td></tr></tbody></table>



Example — application layout recommendations

* /opt/myapp: application binaries and static bundled assets
* /etc/myapp: configuration files
* /var/lib/myapp: persistent runtime data (database files, uploads) — mount as Docker volume
* /var/log/myapp: logs (or forward logs to stdout/stderr instead)





<br>

