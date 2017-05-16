#!/usr/bin/env python
# Filename: run_test_and_evaluate.py
"""
introduction: run the test by using run_deeplab.py, convert the result in Mat by using matlab script
                convert the result to csv table and evaluate the result

authors: Huang Lingcao
email:huanglingcao@gmail.com
add time: 22 April, 2017
"""

import os,sys
import glob
# modify this if necessary
codes_path = '/home/lchuang/codes/rsBuildingMapping'
sys.path.insert(0, codes_path)

# modify this if necessary
expr_folder='/home/lchuang/experiment/pytorch_deeplab_resnet/spacenet_rgb_aoi_4'
test_list_file = 'val.txt'
GTpath='/home/lchuang/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations'
IMpath='/home/lchuang/Data/spacenet/voc_format/AOI_4_Shanghai_Train/annotations'
gpuid = 7
# NET_ID = 'deeplab_largeFOV'  # model name

import basic.basic as basic
import basic.io_function as io_function
from basic.RSImage import RSImageclass
from basic.RSImageProcess import RSImgProclass

# sys.path.insert(0, codes_path + '/SpaceNetData')
import SpaceNetData.geoJSONfromCluster as geoJSONfromCluster
import SpaceNetData.FixGeoJSON as FixGeoJSON

#sys.path.insert(0, os.getcwd() + '../SpaceNetChallenge/')
import SpaceNetChallenge.utilities.python.createCSVFromGEOJSON as createCSVFromGEOJSON

import pytorch_deeplab_resnet.evalpyt as evalpyt

if os.path.isdir(expr_folder) is False:
    print 'error, % not exist '%expr_folder
    exit(1)


test_file = os.path.join(expr_folder,test_list_file)
save_file_folder = os.path.join(expr_folder,'results')
io_function.mkdir(save_file_folder)

if os.path.isfile(test_file) is False:
    print 'error, % not exist '%test_file
    exit(1)

# id is need in caffe for output result


class SampleClass(object):
    image = ''      # path of image
    groudT = ''     # path of groud image
    id = ''         # file ID
# list of SampleClass
test_data = []


def model_finder(path):
    mtime = lambda f: os.stat(os.path.join(path, f)).st_mtime
    files = list(sorted(glob.glob(path+'/*.pth'), key=mtime))
    if len(files) >= 1:
        file_ = files[-1]
    else:
        basic.outputlogMessage('error, can not find pth model file')
        return False
    return file_

def read_test_data(test_file,file_id=None):
    """
    read the file list
    :param test_file: file tontains the test file list
    :param file_id: id is need in caffe for output result, not need in pytorch_deeplab_resnet
    :return: True if succeful, False otherwise
    """
    if os.path.isfile(test_file) is False:
        basic.outputlogMessage('error: file not exist %s'%test_file)
        return False
    f_obj = open(test_file)
    f_lines = f_obj.readlines()
    f_obj.close()

    if file_id is not None:
        fid_obj = open(file_id)
        fid_lines = fid_obj.readlines()
        fid_obj.close()

        if len(f_lines) != len(fid_lines):
            basic.outputlogMessage('the number of lines in test_file and test_file_id is not the same')
            return False

        for i in range(0,len(f_lines)):
            temp = f_lines[i].split()
            sample = SampleClass()
            sample.image = temp[0]
            if len(temp) > 1:
                sample.groudT = temp[1]
            sample.id = fid_lines[i].strip()
            test_data.append(sample)
    else:
        for i in range(0, len(f_lines)):
            temp = f_lines[i].split()
            sample = SampleClass()
            sample.image = temp[0]
            if len(temp) > 1:
                sample.groudT = temp[1]
            test_data.append(sample)

    basic.outputlogMessage('read test data completed, sample count %d'%len(test_data))
    return True

def run_test():
    """
    run test with pytorch_deeplab_resnet
    :return: result file list
    """
    # prepare file for pytorch_deeplab_resnet
    if len(test_data)< 1:
        basic.outputlogMessage('error, not input test data ')
        return False

    # check all image file and ground true file, only keep the basename
    for sample in test_data:
        # check image path
        image_basename = os.path.basename(sample.image)
        if os.path.isfile(sample.image) is False:
            # sample.image = os.path.basename(sample.image)
            sample.image =os.path.join(IMpath,image_basename)
        if os.path.isfile(sample.image) is False:
            basic.outputlogMessage('error, file not exist: %s'%sample.image)
            return False

        # check ground path
        if len(sample.groudT)>0 and os.path.isfile(sample.groudT) is False:
            sample.groudT = os.path.basename(sample.groudT)
            sample.groudT = os.path.join(GTpath, sample.groudT)

        if len(sample.id)< 1:
            sample.id = os.path.splitext(image_basename)[0]

    find_model = model_finder(os.path.join(expr_folder,'data','snapshots'))
    if find_model is False:
        return False
    result_list=evalpyt.run_evalpyt(gpuid,find_model,test_data,save_file_folder)

    return result_list

# def convert_mat_to_png(mat_folder, b_runmatlab=True):
#
#     # need to run matlab script
#     # original_path = str(os.getcwd())
#     # path = os.path.join(codes_path,'DeepLab-Context','matlab','my_script')
#     # os.chdir(path)
#     # # convert the mat files to png or tif
#     # if b_runmatlab :
#     #     subprocess.call("matlab -r 'converttoPng; exit;'", shell=True)
#     # os.chdir(original_path)
#
#     # using python script instead of matlab script
#     if mat_To_png.convert_mat_to_png(mat_folder) is False:
#         return False
#
#     # read the png or tif files list
#     result = io_function.get_file_list_by_ext('.tif',mat_file_foler,bsub_folder=False)
#     if len(result) < 1:
#         result = io_function.get_file_list_by_ext('.png', mat_file_foler, bsub_folder=False)
#     if len(result) < 1:
#         basic.outputlogMessage('error, Not result (.tif or .png) in Mat folder:%s'%mat_file_foler)
#         return False
#     if len(result) != len(test_data):
#         basic.outputlogMessage('error, the count of results is not the same as input test file')
#         return False
#     return result

def convert_png_result_to_geojson(result_list):
    rsimg_obj = RSImageclass()
    rsimgPro_obj = RSImgProclass()

    if len(result_list) != len(test_data):
        basic.outputlogMessage('error, the count of results is not the same as input test file')
        return False

    geojson_without_fix_folder = os.path.join(save_file_folder,'geojson_without_fix')
    io_function.mkdir(geojson_without_fix_folder)

    geojson_folder = os.path.join(save_file_folder,'geojson')
    io_function.mkdir(geojson_folder)

    basic.outputlogMessage('geojson_without_fix_folder: %s'%geojson_without_fix_folder)
    basic.outputlogMessage('geojson_folder: %s'%geojson_folder)


    geojson_list = []

    for i in range(0,len(result_list)):
        # read geo information

        if rsimg_obj.open(test_data[i].image ) is False:
            return False
        result_file = os.path.join(save_file_folder, test_data[i].id + '.png')
        if result_file not in result_list:
            basic.outputlogMessage('result_file file not in the list %s'%result_file)
            return False
        basic.outputlogMessage('png to geojson: %d / %d :Convert file: %s'%(i+1, len(result_list),os.path.basename(result_file)))

        prj = rsimg_obj.GetProjection()
        geom = rsimg_obj.GetGeoTransform()

        # read pixel value
        im_data = rsimgPro_obj.Read_Image_band_data_to_numpy_array_all_pixel(1,result_file)
        if im_data is False:
            basic.outputlogMessage('Read image data failed: %s'%result_file)
            return False
        # im = Image.open(result_file)  # Can be many different formats.
        # pix = im.load()
        # im_data = numpy.array(pix)

        imgID = test_data[i].id #test_data[i][2]

        geojson = geoJSONfromCluster.CreateGeoJSON(geojson_without_fix_folder,imgID,im_data,geom,prj)
        fix_geojson = FixGeoJSON.FixGeoJSON(geojson,geojson_folder)
        geojson_list.append(fix_geojson)

    return geojson_list


def spaceNet_evaluate():
    pass


def main():

    if read_test_data(test_file) is False:
        return False

    # result_list = run_test()
    # if result_list is False:
    #     return False
    result_list = io_function.get_file_list_by_ext('.png',save_file_folder,bsub_folder=False)


    # get the deeplab output result, in png or tif format
    # result_list = convert_mat_to_png()
    # result_list = convert_mat_to_png(mat_file_foler,b_runmatlab=True)
    # if result_list is False:
    #     return False


    # the file in result_list don't have the same order as the files in read_data

    #convert the result to csv table
    geojson_list = convert_png_result_to_geojson(result_list)

    # original raster file list, can get extract imageID
    rasterList = [item.image for item in test_data]
    outputCSVFileName = os.path.join(save_file_folder,'result_buildings.csv')
    if createCSVFromGEOJSON.createCSVFromGEOJSON(rasterList,geojson_list,outputCSVFileName) is not True:
        return False

    # evaluate
    # use a separate bash file to do evaluate

    pass

if __name__=='__main__':
    main()