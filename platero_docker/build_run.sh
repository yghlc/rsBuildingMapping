#!/usr/bin/env bash


#make clean

#build and run docker for space net challenge:
#

docker build -t platero .

# note: docker run (need absolute path for the data folder)
nvidia-docker run -v /home/hlc/Data/aws_SpaceNet/un_gz:/data -it platero

#docker run --lxc-conf="lxc.network.hwaddr=02:42:ed:12:14:e4" -v /home/hlc/spaceNetChallege_docker:/data -it platero
#
#docker run --mac-address="02:42:ed:12:14:e4" -v /home/hlc/spaceNetChallege_docker:/data -it platero
#
#
#docker rm platero

# install matlab
#
#./install -mode slient
#
#
# apt-get install net-tools
