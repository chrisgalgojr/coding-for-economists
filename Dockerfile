# DOCKERFILE for Coding for Economists
# Please note that you will need a lot of RAM dedicated to Docker to build this image

# Set base image (this also loads the Alpine Linux operating system)
FROM continuumio/miniconda3:4.10.3-alpine

WORKDIR /app

# Update Linux package list and install some key libraries, including latex
RUN apk update && apk add openssl graphviz \
    nano texlive alpine-sdk build-base graphviz-dev \
    bash

# change default shell from ash to bash
RUN sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd

# Create the environment:
COPY environment.yml .
RUN conda env create -f environment.yml
# for debugging (builds in under 1 min)
# RUN conda create -n codeforecon -c conda-forge python=3.8 pyyaml rich numpy

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "codeforecon", "/bin/bash", "-c"]

# Copy over the incremental install script:
# COPY install_conda.py .

# RUN python3 install_conda.py 0
# RUN python3 install_conda.py 1
# RUN python3 install_conda.py 2
# RUN python3 install_conda.py 3
# RUN python3 install_conda.py 4
# RUN python3 install_conda.py 5
# RUN python3 install_conda.py 6
# RUN python3 install_conda.py 7
# RUN python3 install_conda.py 8
# RUN python3 install_conda.py 9

RUN conda list

RUN python3 -m spacy download en

# Copy the current directory contents into the container at /app
COPY . /app

RUN echo "Success building the codeforecon container!"
