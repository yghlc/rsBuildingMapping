#!/usr/bin/env bash



cd spacenet_release/PSPNet
# clean the previous building files
make clean

make all -j8
#make test -j8

make matcaffe -j8

cd $HOME
