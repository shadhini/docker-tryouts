---
icon: square-list
---

# Docker Compose Commands & Features

## Docker Compose Commands

```shellscript
docker compose version
```

╰┈➤ check docker compose version

***

```bash
docker compose up
```

╰┈➤ build, create, and start Docker containers as defined in a **`docker-compose.yml`** file&#x20;

* The **directory name** where you run the `docker compose up` command becomes the **project name**, and all objects created will have this **project name prefixed**.

***

```bash
docker compose run [OPTIONS] SERVICE [COMMAND] [ARGS...]
```

╰┈➤  this command is specifically designed for <mark style="color:blue;">**one-off tasks**</mark>&#x20;

* used when you want to trigger a specific service to perform a single action—like running database migrations, executing a test suite, or opening an interactive shell
  * **overrides CMD**: ignores the `CMD` instruction in your `Dockerfile` and runs your provided command instead
  * **dependency startup**: by default, it starts any services linked via `depends_on` (unless you use `--no-deps`)
  * **no port mapping**: it does not map ports to your host machine by default (to avoid conflicts with already running services)
    * unless you explicitly add the `--service-ports` flag
  * **interactive mode**: it automatically opens an interactive terminal (`-it`), making it perfect for debugging
* ```bash
  # opens an interactive shell for the app service and remove the container automatically once the command finishes
  docker compose run --rm app sh

  # running a specific script inside your 'app' service
  docker compose run app python manage.py migrate
  ```
  * **`[OPTIONS]`**: flags — modify how the container runs
    * `--rm`: Automatically removes the container once the command finishes (highly recommended to keep your system clean)
      * `--name`: Gives this specific one-off container a custom name.
  * **`SERVICE`**: This must match one of the service names listed in your `docker-compose.yml` (e.g:  `web`, `app`, `db`)
  * **`[COMMAND]`**: The actual process you want to start (e.g: `sh`, `python`, `npm test`)
  * **`[ARGS...]`**: Any extra arguments for that command (e.g: the name of the script you want Python to run)

***



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



