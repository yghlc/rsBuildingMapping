#!/usr/bin/env bash

#truecsv=$1
#detectedcsv=$2

spacenet_root=${HOME}/Data/spacenet
output_root=${HOME}/experiment/pytorch_deeplab_resnet

exprid=spacenet_rgb_aoi_4


python_script=${HOME}/codes/rsBuildingMapping/SpaceNetChallenge/utilities/python/evaluateScene.py

truecsv=${spacenet_root}/AOI_4_Paris_Train/summaryData/AOI_4_Paris_Train_Building_Solutions.csv
detectedcsv=${output_root}/${exprid}/results/result_buildings.csv

echo SpaceNetTruthFile: ${truecsv}
echo SpaceNetProposalFile: ${detectedcsv}

# for my first test, --useParallelProcessing make the F1 score to be 0
python ${python_script} ${truecsv} ${detectedcsv} --resultsOutputFile SpaceNetResults.csv