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

RUN apt-get -yq install python3 \
                        python3-dev \
                        python3-pip

RUN apt-get -yq install python3-numpy \
                        python3-GDAL \
                        cython3

RUN pip install h5py netCDF4 psycopg2 PyYAML pillow

RUN pip3 install h5py netCDF4 psycopg2 PyYAML pillow
