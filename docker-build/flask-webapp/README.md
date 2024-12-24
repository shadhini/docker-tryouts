# Containerize a Flask Webapp

---

Containerize a simple web application developed using Python flask framework.

---


* Flask application source code: Slightly modified source code based on [github.com/mmumshad/simple-webapp](https://github.com/mmumshad/simple-webapp.git)

### Steps to be included in Dockerfile:
1. OS - Ubuntu 
2. Update _apt_ repo 
3. Installing dependencies using _apt_ 
4. Creating virtual environment for _pip_ installations
5. Install python dependencies using _pip_ 
6. Copy source code to `/opt` folder 
7. Run the web server using the `"flask"` command

### Build the Image  

Build the dockerfile locally and tag it
```bash
docker build . -t shadhinij/simple-flask-webapp
```

View the image generated 
```bash
docker images
```
```text
REPOSITORY                      TAG       IMAGE ID       CREATED         SIZE
shadhinij/simple-flask-webapp   latest    729f9b3f6d23   2 minutes ago   568MB
```

### Run the Webapp: Run the Image

```bash
docker run -p 5003:5000 -it --name simple-flask-webapp shadhinij/simple-flask-webapp
```
Now, the webserver will be accessible via
* http://localhost:5003/
* http://localhost:5003/how%20are%20you

### Push Image to the DockerHub

Push image to the public Docker registry
```bash
docker push shadhinij/simple-flask-webapp
```

### Test Cases Covered
[x] Tested on `MacOS`



