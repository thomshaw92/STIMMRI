#!/bin/bash
#this will unzip all the directories in local so bidscoiner doesn't screw up
#set the directory name
###DO NOT SET THIS TO THE RDM DIRECTORY - LOCAL (30days ONLY)
raw_dir="/path/to/30days/raw_data_dir"

#start unzipping
for x in {001..250}  ; do #or however many participants you have in raw_dir
    for ses in 01 02 03 ; do
        if [[ -d ${raw_dir}/sub-${x}/ses-${ses} ]] ; then
            cd ${raw_dir}/sub-${x}/ses-${ses}
            for file in *zip ; do
                unzip ${file}
                rm -rf ${file}
            done
        fi
    done
done