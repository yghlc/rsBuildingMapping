#!/usr/bin/env bash

ROOT_DIR=$PWD
DATA_ROOT=${ROOT_DIR}/data/spacenet

if [ ! -d "rsBuildingMapping" ]; then
    echo "rsBuildingMapping not exist. Please copy it to current directory!"
    exit 1
fi

python_script=${ROOT_DIR}/rsBuildingMapping/SpaceNetChallenge/utilities/python/createDataSpaceNet.py
replaceXml2Png=${ROOT_DIR}/rsBuildingMapping/bash_script/replaceXml2Png.sh

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

    outputDirectory=${DATA_ROOT}/voc_format/${AOI}

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