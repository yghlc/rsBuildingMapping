
scripts and codes for Spacenet Round 2 *TCO17*

I training the model by two step, 1. train the initial model base on all the images of four cities. 2. fine-tune on each city.
so please training the model by intput 4 cities at begining. For example:

./train.sh /data/train/AOI_2_Vegas_Train /data/train/AOI_3_Paris_Train /data/train/AOI_4_Shanghai_Train /data/train/AOI_5_Khartoum_Train

If only intput  1 or 2 cities, it will only execute the fine-tune the assigned cities.
 But if there is no trained the initial model produced by step 1, the script will exit.



Lingcao Huang
huanglingcao@gmail.com