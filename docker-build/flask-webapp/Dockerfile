FROM ubuntu:latest
LABEL authors="shadhini"

RUN apt-get update
RUN apt-get install -y python3 python3-pip python3-venv

RUN python3 -m venv .venv

COPY ./simple-flask-webapp/. /opt/flask-webapp

RUN .venv/bin/pip install -r /opt/flask-webapp/requirements.txt

##### Command to run the Flask app ------------------

# Option 1: using only the ENTRYPOINT instruction
ENTRYPOINT . .venv/bin/activate && FLASK_APP=/opt/flask-webapp/app.py flask run --host=0.0.0.0 --port=5000

# Option 2: using only the CMD instruction
#CMD ["/bin/sh", "-c", ". .venv/bin/activate && FLASK_APP=/opt/flask-webapp/app.py flask run --host=0.0.0.0 --port=5000"]

# Option 3: [doesn't work] using both CMD and ENTRYPOINT instructions
# --- arguments passed via both options; through CMD instruction and through docker run command weren't captured
#ENTRYPOINT ["/bin/sh", "-c", ". .venv/bin/activate && FLASK_APP=/opt/flask-webapp/app.py flask run"]
#CMD ["--host=0.0.0.0", "--port=5000"]

