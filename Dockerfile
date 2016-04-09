FROM ubuntu

MAINTAINER Basil Veerman <bveerman@uvic.ca>

RUN apt-get update && \
    apt-get -yq install \
    libhdf5-dev \
    libnetcdf-dev \
    libgdal-dev=1.10.1+dfsg-5ubuntu1 \
    libyaml-dev \
    python \
    python-dev \
    python-pip \
    python-virtualenv \
    cython \
    python3 \
    python3-dev \
    python3-pip \
    cython3

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

RUN pip install numpy && pip3 install numpy

RUN pip install gdal==1.10 h5py netCDF4 psycopg2 PyYAML pillow

RUN pip3 install gdal==1.10 h5py netCDF4 psycopg2 PyYAML pillow


