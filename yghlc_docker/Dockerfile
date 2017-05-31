FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04
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
RUN echo "Done Install General Requirements \n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
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
    libatlas-base-dev

## Install GDAL Requirments
RUN apt-get install -y \
        gdal-bin \
        python-gdal

## FIXME: use ARG instead of ENV once DockerHub supports this
## Install RTRee
RUN apt-get update && apt-get install -y --no-install-recommends \
        libspatialindex-dev
RUN pip install rtree
RUN pip install protobuf
# mat file read and write for Deeplab
RUN apt-get update && apt-get install -y --no-install-recommends \
    libmatio-dev

ENV HOME /home/root
WORKDIR $HOME

#COPY cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb /home/root/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
#RUN dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64.deb
#RUN apt-get update
#RUN apt-get install -y cuda

#copy and build caffe in Deeplab-Context
COPY codes /home/root/codes
COPY caffe.sh /home/root/caffe.sh
COPY building_spacenet_init_files /home/root/building_spacenet_init_files
COPY test.sh /home/root/test.sh
COPY train.sh /home/root/train.sh
#
RUN bash caffe.sh

# install python lib use in my codes
RUN pip install wget
RUN pip install Pillow


#
## Download codes and install
#WORKDIR $HOME/codes
#RUN git clone https://github.com/yghlc/rsBuildingSeg
#COPY  docker_data/file.txt /home/hlc/
#b234dd0d0f2f
#
#ENV PYUTILS_ROOT $GIT_BASE/utilities/python
#ENV PYTHONPATH $PYUTILS_ROOT:$PYTHONPATH
#
#WORKDIR /workspace


