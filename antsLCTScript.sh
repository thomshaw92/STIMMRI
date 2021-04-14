#!/bin/bash

#antsCortical Long. thickness script for extracting
#volume, SA, and cortical thickness for STIMMRI data
#Tom Shaw 31/03/2021

#Will run on HPCs - PBS

subjName=$1
singularity="singularity exec --bind /30days:/30days/ /home/uqtshaw/ants_2.3.4.sif"
module load singularity
mkdir -p /30days/$USER/STIMMRI/alct/$subjName
cd /30days/$USER/STIMMRI/alct/$subjName

data_dir="/30days/uqtshaw/STIMMRI_BIDS"
atlas_dir="/30days/uqtshaw/STIMMRI_ATLAS"

tp_1_t1w=$(echo "${data_dir}/${subjName}/ses-01/anat/${subjName}"*"T1w.nii.gz")
tp_2_t1w=$(echo "${data_dir}/${subjName}/ses-02/anat/${subjName}"*"T1w.nii.gz")
tp_3_t1w=$(echo "${data_dir}/${subjName}/ses-03/anat/${subjName}"*"T1w.nii.gz")

#ANTS LCT 3TP
${singularity} antsLongitudinalCorticalThickness.sh -d 3 \
-e ${atlas_dir}/STIMMRI_T1w_template0.nii.gz \
-m ${atlas_dir}/antsCTBrainExtractionMaskProbabilityMask.nii.gz \
-p ${atlas_dir}/antsCTBrainSegmentationPosteriors%d.nii.gz \
-f ${atlas_dir}/antsCTBrainExtractionMask.nii.gz \
-t ${atlas_dir}/antsCTBrainExtractionBrain.nii.gz \
-o ${subjName}_long_cortical_thickness \
-k '2' \
-c '2' \
-j '10' \
-r '1' \
-q '0' \
-n '1' \
-b '1' \
${tp_1_t1w} \
${tp_2_t1w} \
${tp_3_t1w}


#JLF the data

