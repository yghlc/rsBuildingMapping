#!/usr/bin/env bash

#Create by Lingcao Huang,  27 May, 2017
#email:  huanglingcao@gmail.com

topcoderid=yghlc
init_folder=${HOME}/building_spacenet_init_files

# check input arguments
if [[ $# -eq 0 ]] ; then
    echo 'Wrong input, the right input:  '
    echo "./train.sh /data/train/AOI_2_Vegas_Train /data/train/AOI_3_Paris_Train /data/train/AOI_4_Shanghai_Train /data/train/AOI_5_Khartoum_Train"
    exit 1
fi


project=buidling_spacenet_${topcoderid}
mkdir ${project}

echo "Input:" "$@"
echo "Project fodler:"  ${project}

outputDirectory=${project}/voc_format

python_script=${HOME}/codes/rsBuildingMapping/SpaceNetChallenge/utilities/python/createDataSpaceNet.py
replaceXml2Png=${HOME}/codes/rsBuildingMapping/bash_script/replaceXml2Png.sh

run_train=${HOME}/codes/rsBuildingSeg/DeepLab-Context/run_train.py

#pre-processing
for city in "$@"
do
    training_data_root=${city}
    # Get AOI name (The last folder name in the training_data_root)
    IFS='/' read -r -a array <<< "$city"
    for element in "${array[@]}"
    do
        AOI="$element"
    done
    echo "AOI:" ${AOI}

    outputDirectory=${project}/voc_format/${AOI}

    echo ${training_data_root}
    echo ${outputDirectory}
    if [ ! -d "$outputDirectory" ]; then
#       python ${python_script} ${training_data_root} --convertTo8Bit --trainTestSplit 0.8 --srcImageryDirectory RGB-PanSharpen --outputDirectory ${outputDirectory} --annotationType PASCALVOC2012
    echo "skip"
    fi
    cd ${outputDirectory}
    ${replaceXml2Png} test
    ${replaceXml2Png} trainval
    cd -

done

###run training
train_all_dir=${project}/train_4_cities

#training on all cities
if [[ $# -eq 4 ]]; then
    echo "begin training on four cities"
    mkdir ${train_all_dir}
    # prepare config and init model
    cp -r $(HOME)/${init_folder}/config_4_cities ${train_all_dir}/config
    cp -r $(HOME)/${init_folder}/model ${train_all_dir}/model

    # prepare list
    mkdir ${train_all_dir}/list
    for city in "$@"
    do
        # Get AOI name (The last folder name in the training_data_root)
        IFS='/' read -r -a array <<< "$city"
        for element in "${array[@]}"
        do
            AOI="$element"
        done
        outputDirectory=${project}/voc_format/${AOI}
        cp ${outputDirectory}/trainval_aug.txt trainval_aug_${AOI}.txt
        cp ${outputDirectory}/test_aug.txt test_aug_${AOI}.txt
    done
    cat trainval_aug_*.txt test_aug_*.txt > train_aug.txt

    #run training
    python ${run_train}

else
    echo "Please input the four cities for training"
    exit 1
fi


#fine tune for each city





