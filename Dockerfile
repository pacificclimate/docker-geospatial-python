# syntax=docker/dockerfile:1

# Ubuntu 26.04 LTS ships Python 3.14 and GDAL 3.12 as distro defaults, so the
# GDAL Python bindings (built from source against libgdal-dev) match the system
# library exactly. The build is split into two stages: a build stage with the
# compilers and -dev headers needed to compile the C extensions, and a slim
# runtime stage that carries only the shared libraries they link against.

############################
# Build stage
############################
FROM ubuntu:26.04 AS build

LABEL org.opencontainers.image.authors="James Hiebert <hiebert@uvic.ca>"

ARG DEBIAN_FRONTEND=noninteractive
ENV PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        python3-dev \
        python3-venv \
        g++ \
        libgdal-dev \
        libhdf5-dev \
        libnetcdf-dev \
        libyaml-dev \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Build into an isolated virtualenv instead of the system interpreter; this
# avoids pip's --break-system-packages 
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    VIRTUAL_ENV="/opt/venv"

# numpy must be present before GDAL so the gdal_array bindings are built with
# numpy support. The GDAL binding version is pinned to whatever libgdal-dev the
# distro provides, so the two can never drift apart.
RUN pip install numpy
RUN pip install \
        "gdal==$(gdal-config --version)" \
        h5py \
        netCDF4 \
        psycopg2 \
        PyYAML \
        pillow

############################
# Runtime stage
############################
FROM ubuntu:26.04 AS runtime

LABEL org.opencontainers.image.authors="James Hiebert <hiebert@uvic.ca>" \
      org.opencontainers.image.title="geospatial-python" \
      org.opencontainers.image.description="Ubuntu + Python base image for geospatial netCDF data and web apps" \
      org.opencontainers.image.source="https://github.com/pacificclimate/docker-geospatial-python"

ARG DEBIAN_FRONTEND=noninteractive

# Only the shared runtime libraries the compiled extensions link against
# (libgdal38 pulls in PROJ, GEOS, etc. on its own). No compilers or headers.
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 \
        libgdal38 \
        libhdf5-310 \
        libnetcdf22 \
        libpq5 \
        libyaml-0-2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH" \
    VIRTUAL_ENV="/opt/venv" \
    PYTHONUNBUFFERED=1
