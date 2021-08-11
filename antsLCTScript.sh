#!/bin/bash

#antsCortical Long. thickness script for extracting
#volume, SA, and cortical thickness for STIMMRI data
#Tom Shaw 31/03/2021

#Will run on HPCs - PBS

subjName=$1
#singularity="singularity exec --bind /30days:/30days/ /home/uqtshaw/ants_2.3.4.sif"
#module load singularity
scratch="/scratch/user/$USER/"
mkdir -p ${scratch}/STIMMRI/alct/${subjName}
cd ${scratch}/STIMMRI/alct/${subjName}

data_dir="/RDS/Q1876/data/bids/STIMMRI_BIDS/"
atlas_dir="/home/${USER}/STIMMRI_ATLAS"
out_dir="${scratch}/STIMMRI/alct/${subjName}/${subjName}_long_cortical_thickness"

tp_1_t1w=$(echo "${data_dir}/${subjName}/ses-01/anat/${subjName}"*"T1w.nii.gz")
tp_2_t1w=$(echo "${data_dir}/${subjName}/ses-02/anat/${subjName}"*"T1w.nii.gz")
tp_3_t1w=$(echo "${data_dir}/${subjName}/ses-03/anat/${subjName}"*"T1w.nii.gz")

#ANTS LCT 3TP
if [[ ! -e ${scratch}/STIMMRI/alct/${subjName}/${subjName}_long_cortical_thicknessSingleSubjectTemplate/T_template0.nii.gz ]] ; then
    antsLongitudinalCorticalThickness.sh -d 3 \
    -e ${atlas_dir}/STIMMRI_T1w_template0.nii.gz \
    -m ${atlas_dir}/antsCTBrainExtractionMaskProbabilityMask.nii.gz \
    -p ${atlas_dir}/antsCTBrainSegmentationPosteriors%d.nii.gz \
    -f ${atlas_dir}/antsCTBrainExtractionMask.nii.gz \
    -t ${atlas_dir}/antsCTBrainExtractionBrain.nii.gz \
    -o ${subjName}_long_cortical_thickness \
    -k '1' \
    -c '2' \
    -j '14' \
    -r '1' \
    -q '0' \
    -n '1' \
    -g '1' \
    -b '0' \
    ${tp_1_t1w} ${tp_2_t1w} ${tp_3_t1w}
fi

#JLF the data

for TP in 01 02 03 ; do
outdir_JLF=${scratch}/STIMMRI/alct/${subjName}/${subjName}_ses-${TP}_DKT_JLF
    mkdir -p ${outdir_JLF}
    cd ${outdir_JLF}
    atlasDir=${scratch}/mindboggle_all_data
    target_image=$(echo "${out_dir}/${subjName}_ses-${TP}_"*"/${subjName}_ses-${TP}_"*"T1wExtractedBrain0N4.nii.gz")
    if [[ -e ${target_image} ]] ; then
        command="antsJointLabelFusion.sh -d 3 -t ${target_image} -x or -o dkt_${TP} -c 2 -j 8"
        
        for i in {1..20} ;  do
            command="${command} -g ${atlasDir}/OASIS-TRT-20_volumes/OASIS-TRT-20-${i}/t1weighted_brain.nii.gz"
            command="${command} -l ${atlasDir}/OASIS-TRT-20_DKT31_CMA_labels_v2/OASIS-TRT-20-${i}_DKT31_CMA_labels.nii.gz"
        done
        
        $command
        #collect some stats
        #ImageMath 3 ${outdir_JLF}/dkt_${TP}/output_stats.txt LabelStats ${outdir_JLF}/dkt_${TP}/labelimage.ext valueimage.nii
    fi
    
done

