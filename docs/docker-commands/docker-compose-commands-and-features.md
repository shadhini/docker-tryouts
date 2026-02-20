---
icon: square-list
---

# Docker Compose Commands & Features

## Docker Compose Commands

<table><thead><tr><th valign="top">Docker Compose Command</th><th valign="top">Explanation</th></tr></thead><tbody><tr><td valign="top"><pre class="language-bash"><code class="lang-bash">docker compose version
</code></pre></td><td valign="top">Check docker compose version</td></tr><tr><td valign="top"><pre class="language-bash"><code class="lang-bash">docker compose up
</code></pre></td><td valign="top"><p>Build, create, and start Docker containers as defined in a <strong><code>docker-compose.yml</code></strong> file </p><ul><li>The <strong>directory name</strong> where you run the <code>docker compose up</code> command becomes the <strong>project name</strong>, and all objects created will have this <strong>project name prefixed</strong>.</li></ul></td></tr><tr><td valign="top"></td><td valign="top"></td></tr></tbody></table>

## Docker Compose  V2+ Features

* creates a **dedicated bridged network** for the application
* network takes care of DNS resolution
* all containers within the application can reach each other using the service names given in the `docker-compose.yml` file — no need for links



<table><thead><tr><th width="173.68359375" valign="top">Feature</th><th>Description</th></tr></thead><tbody><tr><td valign="top"><strong><code>depends_on</code></strong></td><td><p>used to specify a start up order for containers </p><pre class="language-yaml"><code class="lang-yaml">version: "2"
services:
    redis:
        image: redis
    db:
        image: postgres:9.4
    vote:
        build: ./vote
        ports: 
            - 5000:80
        depends_on:
            - redis
</code></pre><ul><li>Here, docker compose will make sure to start the <code>redis</code> container before the <code>vote</code> container</li></ul></td></tr><tr><td valign="top"><strong><code>deploy</code></strong> (v3+)</td><td>for defining deployment-specific options like replicas, resource limits, and rolling updates</td></tr><tr><td valign="top"><strong>multiple networks</strong></td><td><p>e.g: 2 networks for separating user traffic from internal application traffic</p><ol><li>front-end network — for user traffic — voting app, result app</li><li>back-end network — for internal traffic — db, in-memory db, worker</li></ol><pre class="language-yaml"><code class="lang-yaml">version: "2"
services:
    redis:
        image: redis
        networks:
            - back-end

    db:
        image: postgres:9.4
        networks:
            - back-end
    
    vote:
        image: voting-app
        ports: 
            - 5000:80
        networks:
            - front-end
            - back-end

    result:
        image: result-app
        ports: 
            - 5001:80
        networks:
            - front-end
            - back-end

    worker:
        image: worker
        networks:
            - back-end

networks:
    front-end:
    back-end:
</code></pre><p></p></td></tr><tr><td valign="top"></td><td></td></tr></tbody></table>



