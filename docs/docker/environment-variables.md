---
icon: square-root-variable
---

# Environment Variables

Environment variables are **used to configure runtime behavior** of the container.

i.e: We can modify the behavior of a Docker container by  using environment variables.

{% hint style="success" %}
It's best practice to move **configuration information out of the application** code and **into** an **environment variables**.
{% endhint %}

<pre class="language-bash"><code class="lang-bash">docker run <a data-footnote-ref href="#user-content-fn-1">-e</a> &#x3C;ENVIRONMENT_VARIABLE_NAME>=&#x3C;VALUE> &#x3C;IMAGE_NAME>

#examples
docker run -e APP_COLOR=blue simple-webapp-color
docker run -e APP_COLOR=red simple-webapp-color
</code></pre>



#### To inspect environment variable that is set on a container that is already running

```bash
docker inspect <CONTAINER_ID/CONTAINER_NAME>
```



<pre class="language-bash"><code class="lang-bash">~ via 💎 v3.1.3 
❯ docker run -e APP_COLOR=blue simple-webapp-color


~ via 💎 v3.1.3 
❯ docker inspect simple-flask-webapp
[
    {
        .....
        "Config": {
            ....
            <a data-footnote-ref href="#user-content-fn-2">"Env"</a>: [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "APP_COLOR=blue"
            ],
            ....
        },
        ....
    }
]
</code></pre>





\


[^1]: option to pass environment variables

[^2]: This section lists down Environment variables of a container
