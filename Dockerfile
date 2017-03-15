FROM debian:jessie
MAINTAINER Rémi GATTAZ <remi.gattaz@gmail.com>

# Install dependencies for build
RUN apt-get update && apt-get install -y \
    ant \
    dpkg \
    gcc \
    git \
    gradle \
    openjdk-7-jdk \
    make \
    maven

# Ajouter le builder dans l'image
ADD . /builder

# Change working directory
WORKDIR /builder

# Update path
ENV PATH=/builder:$PATH

VOLUME ["/builder/built"]
