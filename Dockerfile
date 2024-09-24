FROM ubuntu:22.04

LABEL Maintainer="James Hiebert <hiebert@uvic.ca>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq \
    libhdf5-dev \
    libnetcdf-dev \
    libyaml-dev \
    libgdal-dev \
    python3 \
    python3-dev \
    python3-pip \
    cython3 && \
    rm -rf /var/lib/apt/lists/*

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

RUN python3 -m pip install -U pip

RUN pip3 install numpy

RUN pip3 install gdal==3.4.1 h5py netCDF4 psycopg2 PyYAML pillow