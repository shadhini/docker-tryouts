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

