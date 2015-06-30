FROM debian:jessie

MAINTAINER Basil Veerman <bveerman@uvic.ca>

RUN apt-get update

RUN apt-get -yq install libhdf5-dev \
                        libnetcdf-dev \
                        libgdal-dev

RUN apt-get -yq install python \
                        python-dev \
                        python-pip \
                        python-virtualenv

RUN apt-get -yq install python-numpy \
                        python-gdal \
                        python-h5py \
                        python-netcdf
