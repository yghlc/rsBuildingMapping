#!/usr/bin/env bash

## return to the version before add opencv 3 with GDAL support
#git reset --hard 5fb23254997931105afe00d996f98da619d08152
## clean the previous building files
#make clean

#build and run docker for space net challenge:

if [ ! -d "rsBuildingSeg" ]; then
 git clone https://github.com/yghlc/rsBuildingSeg.git
fi

if [ ! -d "rsBuildingMapping" ]; then
 git clone https://github.com/yghlc/rsBuildingMapping.git
fi

if [ ! -d "building_spacenet_init_files" ]; then
    echo "building_spacenet_init_files not exist. Please copy it to current directory!"
    exit 1
fi

docker build -t yghlc .

# note: docker run (need absolute path for the data folder)
#docker run -v /home/hlc/spaceNetChallege_docker:/data -it yghlc

#docker run -v /home/hlc/Data/aws_SpaceNet/un_gz:/data -it yghlc

# need nvidia for running GPU
nvidia-docker run -v /home/hlc/Data/aws_SpaceNet/un_gz:/data -it yghlc

#docker rm yghlc






#debconf: unable to initialize frontend: Dialog
#debconf: (TERM is not set, so the dialog frontend is not usable.)
#debconf: falling back to frontend: Readline
#debconf: unable to initialize frontend: Readline
#debconf: (This frontend requires a controlling tty.)
#debconf: falling back to frontend: Teletype
#dpkg-preconfigure: unable to re-open stdin:

#SOLUTION:
#ENV DEBIAN_FRONTEND noninteractive

#installing: conda-env-2.6.0-0 ...
#Python 2.7.13 :: Continuum Analytics, Inc.
