#!/usr/bin/env python
# Filename: combine_IMGpath_and_Groundpath 
"""
introduction:

authors: Huang Lingcao
email:huanglingcao@gmail.com
add time: 21 May, 2017
"""
from optparse import OptionParser
import os,sys
HOME = os.path.expanduser('~')
codes_path = HOME+'/codes/rsBuildingMapping'
sys.path.insert(0, codes_path)
import basic.basic as basic
import basic.io_function as io_function

def combine_IMGpath_and_Groundpath(img_only_list_file,img_groud_true_list_file,result_path):
    if io_function.is_file_exist(img_only_list_file) is False \
            or io_function.is_file_exist(img_groud_true_list_file) is False:
        return False

    f_img_only = open(img_only_list_file, 'r')
    f_img_ground = open(img_groud_true_list_file,'r')
    fw_obj = open(result_path, 'w')

    mg_ground_lines = f_img_ground.readlines()

    for line in f_img_only.readlines():
        line = line.strip()
        # get imgid
        imgid = os.path.splitext(os.path.basename(line))[0]
        imgid = imgid[imgid.find('img'): len(imgid)]

        write_line = ''
        for save_line in mg_ground_lines:
            bfound = False
            if save_line.find(imgid) >= 0:
                temp = save_line.split()
                write_line = line + ' ' +temp[1] +'\n'
                bfound = True
                break
        if bfound:
            fw_obj.writelines(write_line)
        else:
            basic.outputlogMessage('Image %s can not found ground True'%line)


    f_img_only.close()
    f_img_ground.close()
    fw_obj.close()




    return True

def main(options, args):

    img_only = args[0]
    img_groud_true = args[1]
    save_path =  args[2]
    combine_IMGpath_and_Groundpath(img_only,img_groud_true,save_path)


if __name__=='__main__':
    usage = "usage: %prog [options] img_only_list_file img_groudTrue_list_file save_path"
    parser = OptionParser(usage=usage, version="1.0 2017-4-23")

    (options, args) = parser.parse_args()
    main(options, args)