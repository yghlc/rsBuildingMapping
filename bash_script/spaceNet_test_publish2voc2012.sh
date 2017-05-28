#!/bin/bash

spacenet_root=${HOME}/Data/aws_SpaceNet/un_gz
output_root=${HOME}/Data/aws_SpaceNet/voc_format
#spacenet_root=${HOME}/Data/spacenet
#output_root=${HOME}/Data/spacenet_voc_format


python_script=${HOME}/codes/rsBuildingMapping/SpaceNetChallenge/utilities/python/createDataSpaceNet.py

#${spacenet_root}
#AOI_2=AOI_2_Vegas_Test_public
#AOI_3=AOI_3_Paris_Test_public
#AOI_4=AOI_4_Shanghai_Test_public
#AOI_5=AOI_5_Khartoum_Test_public

AOI_2=AOI_2_Vegas_Train
AOI_3=AOI_3_Paris_Train
AOI_4=AOI_4_Shanghai_Train
AOI_5=AOI_5_Khartoum_Train

# remove previous success_save.txt file
rm success_save.txt

#echo ${AOIs} ${AOI_3} ${AOI_4} ${AOI_5}
for AOI in ${AOI_2} ${AOI_3} ${AOI_4} ${AOI_5}
do
    echo training data dir: $spacenet_root/$AOI

test_data_root=${spacenet_root}/${AOI}/MUL-PanSharpen
outputDirectory=${output_root}/${AOI}/MUL-PanSharpen_8bit
echo ${test_data_root}
echo ${outputDirectory}

dir=${test_data_root}
for tiffile in $(ls $dir/*.tif)
do
    echo $tiffile
python ${HOME}/codes/rsBuildingMapping/basic/tif_16bit_to_8bit.py ${tiffile} ${outputDirectory}

done


done


