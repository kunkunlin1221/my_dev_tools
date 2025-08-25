# syntax=docker/dockerfile:experimental
FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu24.04 as builder

# Install dependencies

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1

RUN apt update -y && apt install -y software-properties-common wget apt-utils patchelf git git-lfs libprotobuf-dev protobuf-compiler cmake \
	git bash curl libturbojpeg exiftool ffmpeg poppler-utils \
	libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev \
	libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python3-tk \
	libharfbuzz-dev libfribidi-dev libxcb1-dev python3-pip
RUN unattended-upgrade
RUN apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

# install miniconda (comes with python 3.10 default)
ARG MINICONDA_PREFIX=/home/jack/miniconda3
ARG CONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-py310_25.5.1-1-Linux-x86_64.sh

RUN curl -fSsL --insecure ${CONDA_URL} -o install-conda.sh && \
	/bin/bash ./install-conda.sh -b -p $MINICONDA_PREFIX && \
	$MINICONDA_PREFIX/bin/conda clean -ya

ENV PATH=$MINICONDA_PREFIX/bin:${PATH}
ARG PYTHON_EXE=$MINICONDA_PREFIX/bin/python

ARG work_folder
WORKDIR $work_folder

CMD ["bash"]