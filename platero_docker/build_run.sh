#!/usr/bin/env bash

## return to the version before add opencv 3 with GDAL support
#git reset --hard 5fb23254997931105afe00d996f98da619d08152
## clean the previous building files
#make clean

#build and run docker for space net challenge:
#
#cd ~/spaceNetChallege_docker
docker build -t platero .

# note: docker run (need absolute path for the data folder)
nvidia-docker run -v /home/hlc/spaceNetChallege_docker:/data -it platero

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
