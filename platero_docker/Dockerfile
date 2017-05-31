FROM nvidia/cuda:7.5-cudnn4-devel-ubuntu14.04
LABEL maintainer dlindenbaum

## Install General Requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        cmake \
        git \
        wget \
        vim \
        apt-utils
RUN echo "Done Install General Requirements "
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        python-dev \
        python-pip \
        python-setuptools \
        mlocate \
        bc
RUN pip install --upgrade pip
## Install Basics for Python
RUN apt-get update && apt-get install -y --no-install-recommends \
        python-numpy \
        python-scipy

## Install GDAL Requirments
#RUN apt-get install -y \
#        gdal-bin \
#        python-gdal

# Install Essentials for Caffe
RUN apt-get update && apt-get install -y --no-install-recommends \
	libprotobuf-dev \
	libsnappy-dev \
	libleveldb-dev \
	libopencv-dev \
	libhdf5-serial-dev \
	protobuf-compiler \
	libboost-all-dev \
	libgflags-dev \
	libgoogle-glog-dev \
	liblmdb-dev

RUN apt-get update && apt-get install -y --no-install-recommends \
    libatlas-base-dev \
    libmatio-dev \
    unzip


## FIXME: use ARG instead of ENV once DockerHub supports this
## Install RTRee
RUN apt-get update && apt-get install -y --no-install-recommends \
        libspatialindex-dev
RUN pip install rtree
RUN pip install protobuf
RUN pip install wget
RUN pip install Pillow

RUN apt-get install -y --no-install-recommends \
     software-properties-common \
     python-software-properties
RUN apt-add-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get update && apt-get install -y --no-install-recommends\
    gdal-bin \
    python-gdal

ENV HOME /home/platero
WORKDIR $HOME

COPY MATLAB.zip /home/platero/MATLAB.zip
RUN unzip MATLAB.zip
RUN rm MATLAB.zip
ENV PATH /home/platero/MATLAB/R2017a/bin:$PATH

#RUN apt-get update && apt-get install -y --no-install-recommends \
#       net-tools \
#       ethtool \
#       iputils-ping

COPY spacenet_release /home/platero/spacenet_release
COPY caffe.sh /home/platero/caffe.sh
RUN bash caffe.sh

ENV LD_LIBRARY_PATH /home/platero/spacenet_release/cudnn_v4/lib64:$LD_LIBRARY_PATH

WORKDIR /home/platero/spacenet_release


#
## Download codes and install
#WORKDIR $HOME/codes
#RUN git clone https://github.com/yghlc/rsBuildingSeg
#COPY  docker_data/file.txt /home/hlc/
#
#
#ENV PYUTILS_ROOT $GIT_BASE/utilities/python
#ENV PYTHONPATH $PYUTILS_ROOT:$PYTHONPATH
#
#WORKDIR /workspace


