#!/usr/bin/env bash

# check input arguments
if [[ $# -eq 0 ]] ; then
    echo 'Wrong input, the right input:  '
    echo "./test.sh /data/test/AOI_2_Vegas_Test /data/test/AOI_3_Paris_Test /data/test/AOI_4_Shanghai_Test /data/test/AOI_5_Khartoum_Test out.csv"
    exit 1
fi

ROOT_DIR=$PWD

topcoderid=yghlc
net=deeplab_largeFOV
init_folder=${HOME}/building_spacenet_init_files
gpuid=0

python_script=${ROOT_DIR}/rsBuildingMapping/basic/tif_16bit_to_8bit.py
extract_id=${ROOT_DIR}/rsBuildingMapping/bash_script/extract_fileid.sh

project=$(pwd)/building_spacenet_${topcoderid}
mkdir ${project}
mkdir -p ${project}/result_csv


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
function get_aoi_n(){
    AOI=$1
    IFS='_' read -r -a array <<< "$AOI"
    aoi_n=${array[0]}_${array[1]}
    echo ${aoi_n}
}
if [ "$#" -lt 2 ]; then
  echo "please at least input one city and output file name"
  exit 1
else
  arguments=( "$@" )
fi

#pre-processing
city_count=$(expr $# - 1)
for para_index in $(seq 1 $city_count)
do
    index=$(expr $para_index - 1)
    test_data=${arguments[$index]}
    echo ${test_data}

    test_AOI=$(get_aoi ${test_data})

    data_root=${test_data}/RGB-PanSharpen
    outputDirectory=${project}/voc_format/${test_AOI}/RGB-PanSharpen_8bit

    echo $data_root
    echo $outputDirectory

    if [ ! -d "$outputDirectory" ]; then
         mkdir -p ${outputDirectory}
         for tiffile in $(ls ${data_root}/*.tif)
         do
              python ${python_script} ${tiffile} ${outputDirectory}
         done
    fi

    aoi_n=$(get_aoi_n ${test_AOI})
    EXPR=$(ls ${project}/train_${aoi_n}_*)

    exit 1

    cd ${outputDirectory}
       ls ${PWD}/*8bit*.tif > test_${test_AOI}.txt
       bash ${extract_id} test_${test_AOI}
       cp test_${test_AOI}.txt ${EXPR}/list/val.txt
       cp test_${test_AOI}_id.txt ${EXPR}/list/val_id.txt
    cd -
    # copy trained model
    cp ${ROOT_DIR}/building_spacenet_init_files/trained_model/${aoi_n}_train_iter_6000.caffemodel ${EXPR}/model/${net}/train_iter_6000.caffemodel

    # clean previous result
    rm ${EXPR}/features/${net}/val/fc8/*.mat
    rm ${EXPR}/features/${net}/val/fc8/*.png
    rm -r ${EXPR}/features/${net}/val/fc8/geojson
    rm -r ${EXPR}/features/${net}/val/fc8/geojson_without_fix
    rm ${EXPR}/features/${net}/val/fc8/result_buildings.csv

    # RUN TEST
    python ${ROOT_DIR}/rsBuildingSeg/DeepLab-Context/run_test_and_evaluate.py ${EXPR}  ${gpuid}

    #cp csv
    cp ${EXPR}/features/${net}/val/fc8/result_buildings.csv ${project}/result_csv/result_${aoi_n}.csv

done

#merge_result

outputcsv=${arguments[$city_count]}
echo "Output file: " $outputcsv
R_AOI_2=${project}/result_csv/result_AOI_2.csv
R_AOI_3=${project}/result_csv/result_AOI_3.csv
R_AOI_4=${project}/result_csv/result_AOI_4.csv
R_AOI_5=${project}/result_csv/result_AOI_5.csv
python ${ROOT_DIR}/rsBuildingMapping/basic/delete_csv_column.py ${R_AOI_2} ${R_AOI_3} ${R_AOI_4} ${R_AOI_5}

mv ${project}/result_csv/result_buildings_Test_public.csv ${outputcsv}





