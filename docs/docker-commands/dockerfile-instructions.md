---
icon: docker
---

# Dockerfile Instructions

<table><thead><tr><th width="126.75" valign="top">Instruction</th><th valign="top">Description</th></tr></thead><tbody><tr><td valign="top"><strong><code>FROM</code></strong></td><td valign="top">used to specify the base image/OS</td></tr><tr><td valign="top"><strong><code>RUN</code></strong></td><td valign="top">instructs to run a particular command on the base image</td></tr><tr><td valign="top"><strong><code>COPY</code></strong></td><td valign="top">copies files from the local system on to the docker image</td></tr><tr><td valign="top"><strong><code>ENTRYPOINT</code></strong></td><td valign="top"><p>specifies the program/command to run when the container starts</p><ul><li>you can pass any executable file as the ENTRYPOINT </li></ul><pre class="language-docker"><code class="lang-docker">ENTRYPOINT &#x3C;COMMAND>

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
</code></pre><ul><li>If you pass <strong>arguments</strong> with the <strong><code>docker run</code></strong> command, then the arguments specified with the <strong><code>CMD</code></strong> instruction will be <strong>replaced</strong> by them.</li></ul></td></tr><tr><td valign="top"><strong><code>WORKDIR</code></strong></td><td valign="top">sets the working (current) directory for subsequent Dockerfile instructions and for the container at runtime unless overridden</td></tr></tbody></table>

