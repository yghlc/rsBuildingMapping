#!/usr/bin/env bash

#Create by Lingcao Huang,  27 May, 2017
#email:  huanglingcao@gmail.com

topcoderid=yghlc
net=deeplab_largeFOV
init_folder=${HOME}/building_spacenet_init_files
gpuid=7

# check input arguments
if [[ $# -eq 0 ]] ; then
    echo 'Wrong input, the right input:  '
    echo "./train.sh /data/train/AOI_2_Vegas_Train /data/train/AOI_3_Paris_Train /data/train/AOI_4_Shanghai_Train /data/train/AOI_5_Khartoum_Train"
    exit 1
fi


project=$(pwd)/building_spacenet_${topcoderid}
mkdir ${project}

echo "Input:" "$@"
echo "Project fodler:"  ${project}

outputDirectory=${project}/voc_format

python_script=${HOME}/codes/rsBuildingMapping/SpaceNetChallenge/utilities/python/createDataSpaceNet.py
replaceXml2Png=${HOME}/codes/rsBuildingMapping/bash_script/replaceXml2Png.sh

run_train=${HOME}/codes/rsBuildingSeg/DeepLab-Context/run_train.py

function get_aoi(){
    # Get AOI name (The last folder name in the training_data_root)
    city=$1
    IFS='/' read -r -a array <<< "$city"
    for element in "${array[@]}"
    do
        AOI="$element"
    done
    echo ${AOI}
}



#pre-processing
for city in "$@"
do
    training_data_root=${city}
    AOI=$(get_aoi ${city})
    echo "AOI:" ${AOI}

    outputDirectory=${project}/voc_format/${AOI}

    echo ${training_data_root}
    echo ${outputDirectory}
    if [ ! -d "$outputDirectory" ]; then
        python ${python_script} ${training_data_root} --convertTo8Bit --trainTestSplit 0.8 --srcImageryDirectory RGB-PanSharpen --outputDirectory ${outputDirectory} --annotationType PASCALVOC2012

        cd ${outputDirectory}
        ${replaceXml2Png} test
        ${replaceXml2Png} trainval
        cd -
    fi
done

###run training
train_all_dir=${project}/train_4_cities

#training on all cities
if [[ $# -eq 4 ]]; then
    echo "begin training on four cities"
    mkdir ${train_all_dir}
    # prepare config and init model
    cp -rT ${init_folder}/config_4_cities ${train_all_dir}/config
    cp -rT ${init_folder}/model ${train_all_dir}/model

    # prepare list
    mkdir ${train_all_dir}/list
    for city in "$@"
    do
        AOI=$(get_aoi ${city})
        outputDirectory=${project}/voc_format/${AOI}
        cp ${outputDirectory}/trainval_aug.txt ${train_all_dir}/list/trainval_aug_${AOI}.txt
        cp ${outputDirectory}/test_aug.txt ${train_all_dir}/list/test_aug_${AOI}.txt
    done
    cat ${train_all_dir}/list/trainval_aug_*.txt ${train_all_dir}/list/test_aug_*.txt > ${train_all_dir}/list/train_aug.txt

    #run training
    cd ${train_all_dir}
    python ${run_train} $(pwd) ${gpuid}
    cd -

else
    echo "Please input the four cities for training"
#    exit 1
fi

#fine tune for each city

for city in "$@"
do
    echo "begin finetune on " ${city}
    AOI=$(get_aoi ${city})

    train_dir=${project}/train_${AOI}

    mkdir ${train_dir}
    # prepare config and init model
    cp -rT ${init_folder}/config ${train_dir}/config
    mkdir -p ${train_dir}/model/{$net}
    newest_model=$(ls -t ${train_all_dir}/model/${net}/*00.caffemodel | head -1)
    if [ -f $newest_model ]; then
       cp -rT ${newest_model} ${train_dir}/model/{$net}/init.caffemodel
    else
       echo "No initial training model, Please input the four cities for initial training first."
       exit 1
    fi

    # prepare list
    mkdir ${train_dir}/list
    outputDirectory=${project}/voc_format/${AOI}
    cp ${outputDirectory}/trainval_aug.txt ${train_dir}/list/trainval_aug_${AOI}.txt
    cp ${outputDirectory}/test_aug.txt ${train_dir}/list/test_aug_${AOI}.txt
    cat ${train_dir}/list/trainval_aug_*.txt ${train_dir}/list/test_aug_*.txt > ${train_dir}/list/train_aug.txt

    #run training
    cd ${train_dir}
    python ${run_train} $(pwd) ${gpuid}
    cd -
done



