# Audio Sentiment Analysis using Docker Container
<!-- Project description -->
This file aims to provide with the key steps for running a Jupyter Notebook and Flask API through a Docker container on a Мac machine.

## Prerequisities
* Install the latest Docker version via https://docker.com/.
* (optional) Install Visual Studio code https://code.visualstudio.com/ for easier code navigation and debugging.

After docker.dm is installed, open the docker daemon by typing the following command in terminal:

```bash
open -a Docker 
```

## Create container from a predefined image
* Use the `cd` command to enter the working directory *SER_Project_Marija_Stojchevska* which contains the Dockerfile:

```bash
# Specifies the parent image from which we are building
FROM python:3.9
# Creates new directory
RUN mkdir /app
# Copies the current directory contents into the container at /app
COPY . /app
# Sets the working directory to /app
WORKDIR /app

# Downloads and installs the updates for each outdated package and dependency
RUN apt-get update \
&& apt-get upgrade -y \
&& apt-get install -y \
# Fixes an OSError that occurs when installing librosa  z
&& apt-get -y install apt-utils gcc libpq-dev libsndfile-dev 

# Installs jupyter lab
RUN pip install jupyterlab
# Installs project packages from the libraries.txt file
RUN pip install -r libraries.txt

EXPOSE 105
```

* Run the command `docker-compose up` that triggers image assebling by reading the instructions from the Dockerfile. In this way, we build a container from the predefined image ("python:3.9") inside the Dockerfile and start the container. This operation may take some time until the jupyter lab and the other required packages listed in *libraries.txt* are installed.
* Check for an existing containers or images by running the commands:

```bash
docker ps
docker image ls 
```

## Check if the container is listening on different ports

At runtime, the container should listen on the network ports specified in the *docker-compose.yaml* file.

```bash
version: '3.8'
services:

  report:
    build: .
    ports: 
      - "8888:8888"
    volumes: 
      - ./SEReport:/app
    entrypoint:
      jupyter notebook --ip='0.0.0.0' --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''
  
  api:
    build: .
    ports: 
      - "8000:8000"
    expose:
      - 105
    volumes: 
      - ./FlaskAPI:/app
    entrypoint:
      jupyter lab --ip='0.0.0.0' --port=8000 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''
```

* Verify that the *Report_SER.ipynb* file is exposed on port 8888 by openning a web browser and typing http://localhost:8888.
* Verify that the Flask API *app.ipynb* is exposed on port 8000 by openning a web browser and typing http://localhost:8000.

## Jupyter notebook and Flask API

* The jupyter notebook accessed via http://localhost:8888 contains an implementation of CNN model for Speech Emotion Recognition. To download and pre-process the appropriate dataset(http://emodb.bilderbar.info/index-1280.html), as well as to train and evaluate the model, we go to the notebook navigation bar `Cell -> Run All` .

* The Flask API accessed via http://localhost:8000 contains two endpoints, masks an URL path to two different logics. The first endpoint trains the model and saves it to a *my_model* directory. We can run it at `path:port/1/` which is a predefined url that requires variable 1 for training. The second endpoint evaluates the last trained model on an audio file of our choice. We can executed it at `path:port/audio_file_name/` which is a predefined url that includes the name of the audio (eg: "08a01Fd.wav") in the url variable section. The output prints the predicted emotion.

## Exit container and uninstall existing containers and images

```bash
# Exit container
  cmd+C
# Stop and remove container by ID:
  docker stop (container ID)
  docker rm (container ID)
# Once a container is deleted remove the corresponding image 
  docker rmi (image ID)
# Memory saver: remove all images, containers, and networks use
   docker system prune
```
