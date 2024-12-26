---
icon: cloud
---

# Docker Registry

> **Docker Registry:**
>
> Central repository for all docker images&#x20;



## Docker's naming convention for an Image:

> `<`_`Registry`_`>`**/**`<`_`User/Account`_` ``>`**/**`<`_`Image/Repository`_`>`

_`Registry`_: Where the images are stored and pulled from

* There are many popular registries
  * default registry - DockerHub: `docker.io`
    * hosted registry solution by `Docker Inc`
  * Google's registry - `gcr.io`

_`User/Account`_: The DockerHub account of an individual user or an organization



```
// Example Images 
docker.io/library/nginx
gcr.io/kubernetes-e2e-test-images/dnsutils
```

* in case the location to pull the images from is not specified, then it is assumed to be Docker's default registry `DockerHub`&#x20;
  * the DNS name for DockerHub is `docker.io`
* in case no specific account or repository is provided, `library` prefix is used indicating an official DockerHub image



## Public & Private Registries

{% hint style="info" %}
DockerHub, GCR are **public** **registries**.
{% endhint %}

{% hint style="info" %}
**Private registries** are ideal for hosting in-house applications that should not be publicly accessible.&#x20;

Cloud providers like AWS, Azure, and GCP offer private registries by default with their accounts.&#x20;

You have to login before pulling or pushing to a private registry.
{% endhint %}



## Deploy Private Registry

To deploy a private registry **for on-premises applications**, you can use Docker's **`registry`** image, which exposes the API on port 5000.&#x20;

```bash
docker run -d -p 5000:5000 --name registry registry:2
```



To push your image to this registry, which is now running at port 5000 of docker host

*   Tag your Docker image with the private registry's URL (e.g., `localhost:5000/image-name`) using the `docker image tag` command and

    <pre class="language-bash"><code class="lang-bash"><strong>docker image tag &#x3C;IMAGE_NAME> &#x3C;TAG:PRIVATE_REGISTRY_URL>
    </strong>
    # example
    docker image tag my-image localhost:5000/my-image
    </code></pre>
*   Push the image to the registry with `docker push`&#x20;

    ```bash
    docker push <IMAGE_TAG>

    # example
    docker push localhost:5000/my-image
    ```



Now, when needed you can pull it from within the network using `localhost` (on the same host) or the host's IP/domain name if accessing from another machine.

```bash
docker pull localhost:5000/my-image

docker pull 192.168.56.100:5000/my-image
```

