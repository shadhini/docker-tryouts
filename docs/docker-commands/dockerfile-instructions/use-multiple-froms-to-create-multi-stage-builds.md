---
icon: layer-plus
---

# Use multiple FROMs to create multi-stage builds

## Use multiple FROMs to create multi-stage builds

✅️ Give stages **descriptive names** with `AS` (builder, deps, test, final) for readability and easier `COPY --from` usage

✅️ Keep the **final stage minimal** (only `COPY` what you need)

* Multi-stage builds do not automatically transfer files between stages

✅️ Use **`--target`** **in local development/CI** to build only up to a stage you care about (speeds iteration)

✅️ **Re-declare `ARGs` in stages** where you need them (`ARG` before `FROM` can be used in `FROM`; re-declare after `FROM` to access inside that stage)

✅️ **Do not pass secrets via `ARG`** — they can be recorded in image history

* use **`BuildKit`** secrets or external secret management

✅️ Be **explicit** when **copying**: avoid copying the whole builder filesystem if you only need one artifact

```docker
# syntax=docker/dockerfile:1
FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn package

FROM tomcat
COPY --from=build /app/target/file.war /usr/local/tomcat/webapps 
```

#### <mark style="color:blue;">Each</mark> <mark style="color:blue;"></mark><mark style="color:blue;">`FROM`</mark> <mark style="color:blue;"></mark><mark style="color:blue;">starts an</mark> <mark style="color:blue;"></mark><mark style="color:blue;">**isolated stage**</mark> <mark style="color:blue;"></mark><mark style="color:blue;">so you can:</mark>

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

#### <mark style="color:blue;">When to use multiple FROMs (common scenarios)</mark>

* **Language build + runtime**: compile or transpile with a heavy SDK, then copy the binary/asset into a tiny runtime image (e.g., distroless, scratch, alpine)
* **Dependency caching**: install dependencies in their own stage so builds are cached and faster when only source changes
* **CI/test stages**: run unit tests, linters, or integration checks inside the Dockerfile stages so CI can build and run those steps in-container
* **Multi-variant outputs**: create debug and production variants in one Dockerfile and select with `--target` or tag multiple outputs.
* **Packaging or installer creation**: use one stage to build an installer/package and another to assemble or sign it
* **Copying from external images**: bring artifacts from other published images: `COPY --from=some-image:tag` ...
* **Cross-platform or multi-architecture workflows** (with `buildx`) where stages can help structure per-arch build steps

#### <mark style="color:blue;">When not to use multiple FROMs</mark>

* **Simple apps** where build and runtime environments are identical and small — a single-stage image is simpler
* **When you need every build-step filesystem state preserved** in the final image (multi-stage intentionally discards intermediate state)

#### <mark style="color:blue;">Naming Suggestions for Multiple Stages</mark>

* `prepare` — general-purpose stage for copying files and fetching packages (recommended)
* `deps` — when the stage’s primary job is installing dependency packages
* `setup` — clear intent to configure environment and fetch artifacts
* `bootstrap` — if it bootstraps the build environment (downloads toolchains, etc.)
* `builder` — when this stage also compiles/builds artifacts (common convention)
* `fetch` — when it only pulls/downloads external assets
* `assets` — for copying static assets from host + fetching related packages
* `runtime-deps` — when preparing runtime-only dependencies (separates from build deps)



## Multi Stages with Multiple Entrypoints

**`ENTRYPOINT ["/entrypoint3.sh"]` itself does NOT execute during build**, but if your script is being run via `RUN` or setting `ENV` variables, those will persist.

{% code title="Dockerfile" %}
```dockerfile
FROM image1 as stage1
ENTRYPOINT [entrypoint1.sh]
CMD [/bin/bash]

FROM image2 as stage2
ENTRYPOINT [entrypoint2.sh]
CMD [/bin/bash]

FROM image3 as stage3
ENTRYPOINT [entrypoint3.sh]
CMD [/bin/bash]
```
{% endcode %}

#### What happens when you run `docker run`

When you execute `docker run <final-image>`, **only `entrypoint3.sh` gets executed**, assuming the final image is built from `stage3`.

In a multi-stage Dockerfile, the rule of thumb is: The last one wins.&#x20;

* When you run `docker run` on an image built from this Dockerfile, only the final stage (e.g: `stage3`) determines what actually happens.&#x20;
* The previous stages are essentially temporary "workshops" used during the build process.

<mark style="color:blue;">**Why Only the Last Stage?**</mark>

1. **Multi-stage builds are sequential**: Each stage builds upon or uses artifacts from previous stages, but only the **last `FROM` instruction** determines the base image of the final output.
2. **Earlier stages are discarded**: After the build completes, `stage1` and `stage2` exist only temporarily during the build process. They're not part of the final image unless you explicitly copy files from them using `COPY --from=stage1` or `COPY --from=stage2`.&#x20;
   * But, even if you don't explicitly copy files from `stage1` and `stage2`, and if the build targets( i.e. ends in ) `stage2`, that case, `entrypoint2.sh` will be run upon calling `docker run`.
3. **Only one ENTRYPOINT per image**: A Docker image can only have **one** `ENTRYPOINT` and **one** `CMD`. The final stage's instructions override all previous ones.

<br>

