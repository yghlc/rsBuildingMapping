#!/usr/bin/env bash

# check input arguments
if [[ $# -eq 0 ]] ; then
    echo 'Wrong input, the right input:  '
    echo "./test.sh /data/test/AOI_2_Vegas_Test /data/test/AOI_3_Paris_Test /data/test/AOI_4_Shanghai_Test /data/test/AOI_5_Khartoum_Test out.csv"
    exit 1
fi

btesting=true
#check training results and copy them


#pre-processing




#test
if [ "$btesting" = true ] ; then
# clean previous result
rm ${dir}/${city}/features/${net}/val/fc8/*.mat
rm ${dir}/${city}/features/${net}/val/fc8/*.png
rm -r ${dir}/${city}/features/${net}/val/fc8/geojson
rm -r ${dir}/${city}/features/${net}/val/fc8/geojson_without_fix
rm ${dir}/${city}/features/${net}/val/fc8/result_buildings.csv
# run test on Test public data
python ~/codes/rsBuildingSeg/DeepLab-Context/run_test_and_evaluate.py ${dir}/${city}  ${gpuid}
fi

cd ..

#cp csv
cp ${dir}/${city}/features/${net}/val/fc8/result_buildings.csv result_csv/result_${city}.csv

