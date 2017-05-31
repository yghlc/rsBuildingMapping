Building footprints extraction scripts and codes

The docker file and supported files are in platero_docker.zip

Training:
cd to spacenet_release folder, then run :
./train.sh /data/train/AOI_2_Vegas_Train /data/train/AOI_3_Paris_Train /data/train/AOI_4_Shanghai_Train /data/train/AOI_5_Khartoum_Train

Normally, We need input four cities for training, because we need all the images for initial training. But if you only input 1 or 2 cities, it also can work,
but only for the finetune of your input cities.

Inference:
cd to spacenet_release folder, then run :
./test.sh /data/test/AOI_2_Vegas_Test /data/test/AOI_3_Paris_Test /data/test/AOI_4_Shanghai_Test /data/test/AOI_5_Khartoum_Test out.csv

make sure the input path is correct, my script will not check.

I use MATLAB in the inference and the submitted package include a one month trail licence. It will expired on 26 June 2017.

Wei Yang
platero.yang@gmail.com