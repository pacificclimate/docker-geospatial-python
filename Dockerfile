# This Dockerfile is designed to be a base image for PCIC Python
# applications that require GDAL, numpy, NetCDF and HDF5 support. It
# is based from an official GDAL build (https://tinyurl.com/ydemhc7b)
# that contains a minimal set of functionality that we require (which
# is still enormous). It runs:
# Python 3.8
# GDAL 3.0
# NetCDF 4.7
# HDF5 1.10
# Numpy 1.18

FROM osgeo/gdal:alpine-normal-latest

MAINTAINER James Hiebert <hiebert@uvic.ca>

RUN apk update && \
    apk add \
    python3-dev \
    py3-pip \
    postgresql-dev \
    cython

RUN apk add make automake gcc g++
RUN apk add netcdf-dev hdf5-dev --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/

RUN pip3 install -U pip

# The GDAL docker image installs numpy, but unhelpfully omits the
# development headers which we need to build h5py
RUN pip3 uninstall -y numpy

RUN pip3 install --no-binary=numpy wheel cython numpy

RUN pip3 install h5py netCDF4
