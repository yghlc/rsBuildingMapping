#!/usr/bin/env bash

# train on all files
cd spacenet_rgb_aoi_2-4
#./exe.sh
cd ..

AOI_2=spacenet_rgb_aoi_2_test
AOI_3=spacenet_rgb_aoi_3_test
AOI_4=spacenet_rgb_aoi_4_test
AOI_5=spacenet_rgb_aoi_5_test

mkdir result_csv

for AOI in ${AOI_2}  ${AOI_3} ${AOI_4} ${AOI_5}
do
        ./fine_tune_city.sh ${AOI}
done

cd result_csv
cp ~/codes/rsBuildingMapping/basic/delete_csv_column.py .
cp ~/codes/rsBuildingMapping/basic/basic.py .
cp ~/codes/rsBuildingMapping/basic/io_function.py .
python delete_csv_column.py result_${AOI_2}.csv result_${AOI_3}.csv result_${AOI_4}.csv result_${AOI_5}.csv
cd ..