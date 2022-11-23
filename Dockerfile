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