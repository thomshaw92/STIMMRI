#!/bin/bash
atlasDir=./mindboggle_all_data_for_JLF_of_ANTCT
target_image=./t1w195_brain_eroded_3.nii.gz
command="antsJointLabelFusion.sh -d 3 -t ${target_image} -x or -o dkt_${TP} -c 2 -j 8"

for i in {1..20} ;  do
        command="${command} -g ${atlasDir}/OASIS-TRT-20_volumes/OASIS-TRT-20-${i}/t1weighted_brain.nii.gz"
        command="${command} -l ${atlasDir}/OASIS-TRT-20_DKT31_CMA_labels_v2/OASIS-TRT-20-${i}_DKT31_CMA_labels.nii.gz"
done
$command
