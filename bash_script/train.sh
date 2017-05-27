#!/usr/bin/env bash

#Create by Lingcao Huang,  27 May, 2017
#email:  huanglingcao@gmail.com

topcoderid=yghlc


# check input arguments
if [[ $# -eq 0 ]] ; then
    echo 'Wrong input, the right input:  '
    echo "./train.sh /data/train/AOI_2_Vegas_Train /data/train/AOI_3_Paris_Train /data/train/AOI_4_Shanghai_Train /data/train/AOI_5_Khartoum_Train"
    exit 1
fi

project=buidling_spacenet_${topcoderid}
mkdir project

echo "Input:" "$@"
echo "Project fodler:"  ${project}

outputDirectory=${project}/voc_format

python_script=${HOME}/codes/rsBuildingMapping/SpaceNetChallenge/utilities/python/createDataSpaceNet.py

#pre-processing
for city in "$@"
do
    training_data_root=${city}
    # Get AOI name (The last folder in the training_data_root)
    IFS='/' read -r -a array <<< "$city"
    for element in "${array[@]}"
    do
        AOI="$element"
    done
    echo "AOI:" ${AOI}

    outputDirectory=${project}/voc_format/${AOI}

    echo ${training_data_root}
    echo ${outputDirectory}

    python ${python_script} ${training_data_root} --convertTo8Bit --trainTestSplit 0.8 --srcImageryDirectory RGB-PanSharpen --outputDirectory ${outputDirectory} --annotationType PASCALVOC2012

done

#run training



