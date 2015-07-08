FROM ubuntu

MAINTAINER Basil Veerman <bveerman@uvic.ca>

RUN apt-get update

RUN apt-get -yq install libhdf5-dev \
                        libnetcdf-dev \
                        libgdal-dev \
			libyaml-dev

RUN apt-get -yq install python \
                        python-dev \
                        python-pip \
                        python-virtualenv

RUN apt-get -yq install python-numpy \
                        python-GDAL \
                        cython

RUN pip install h5py netCDF4 psycopg2 PyYAML pillow