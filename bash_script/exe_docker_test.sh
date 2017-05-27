#!/usr/bin/env bash

upcodes.sh
cp ~/codes/rsBuildingMapping/bash_script/train.sh .
cp ~/codes/rsBuildingMapping/bash_script/test.sh .

./train.sh /home/lchuang/Data/spacenet/AOI_2_Vegas_Train /home/lchuang/Data/spacenet/AOI_3_Paris_Train /home/lchuang/Data/spacenet/AOI_4_Shanghai_Train /home/lchuang/Data/spacenet/AOI_5_Khartoum_Train

#./train.sh /home/lchuang/Data/spacenet/AOI_2_Vegas_Train