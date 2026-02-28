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
</code></pre><p><code>docker build --target builder -t my-frontend:builder .</code> </p><ul><li>stop after stage 1 and produce an image containing the builder filesystem</li></ul></td></tr><tr><td valign="top"><strong><code>RUN</code></strong></td><td valign="top"><p>instructs to run a particular command on the base image </p><ul><li>Each <code>RUN</code> instruction in Docker executes in a new shell instance, so variables defined in one <code>RUN</code> command are lost when that command completes.</li></ul></td></tr><tr><td valign="top"><strong><code>COPY</code></strong></td><td valign="top">copies files from the local system on to the docker image</td></tr><tr><td valign="top"><strong><code>ENTRYPOINT</code></strong></td><td valign="top"><p>specifies the program/command to run when the container starts</p><ul><li>you can pass any executable file as the ENTRYPOINT </li></ul><pre class="language-docker"><code class="lang-docker">ENTRYPOINT &#x3C;COMMAND>

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
</code></pre><p></p></td></tr><tr><td valign="top"><strong><code>DEBIAN_FRONTEND</code></strong> env variable</td><td valign="top"><p>tells Debian/Ubuntu package tooling (debconf/dpkg) which UI frontend to use when configuring packages</p><ul><li>Common frontends: <code>dialog</code>, <code>readline</code> (interactive), <code>noninteractive</code>: used in automated builds</li><li><p><code>DEBIAN_FRONTEND=noninteractive</code> disables interactive prompts and forces packages to use defaults or previously-seeded debconf answers</p><ul><li>Without noninteractive, package installs that prompt will hang the build</li></ul></li></ul></td></tr><tr><td valign="top"></td><td valign="top"></td></tr></tbody></table>



## ✅️ Best Practices



### 🗄️ Use multiple FROMs to create multi-stage builds

{% content-ref url="use-multiple-froms-to-create-multi-stage-builds.md" %}
[use-multiple-froms-to-create-multi-stage-builds.md](use-multiple-froms-to-create-multi-stage-builds.md)
{% endcontent-ref %}



### 📁 Docker Container File System

{% content-ref url="docker-container-file-system.md" %}
[docker-container-file-system.md](docker-container-file-system.md)
{% endcontent-ref %}



### 🇽🇾 Passing ENV variables, ARGs and Configurations&#x20;

{% content-ref url="passing-env-variables-args-and-configurations.md" %}
[passing-env-variables-args-and-configurations.md](passing-env-variables-args-and-configurations.md)
{% endcontent-ref %}

