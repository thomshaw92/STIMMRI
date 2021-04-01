#!/bin/bash

#antsCortical Long. thickness script for extracting
#volume, SA, and cortical thickness for STIMMRI data
#Tom Shaw 31/03/2021

#Will run on HPCs - PBS

subjName=$1
singularity="singularity exec --bind /30days:/30days/ /90days/uqtshaw/ants_2.3.4.sif"
module load singularity
mkdir -p /30days/$USER/STIMMRI/alct/$subjName
cd /30days/$USER/STIMMRI/alct/$subjName

atlas_dir="/30days/uqtshaw/STIMMRI_ATLAS"

#ANTS LCT 3TP
antsLongitudinalCorticalThickness.sh -d 3 -e ${atlas_dir}/STIMMRI_T1w_template0.nii.gz -m ${atlas_dir}/antsCTBrainExtractionMaskProbabilityMask.nii.gz \
-p ${atlas_dir}/antsCTBrainSegmentationPosteriors%d.nii.gz \
-f ${atlas_dir}cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_BrainExtractionMask.nii.gz \
-t cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_Extracted_Brain.nii.gz \
-o ${subjName}lct_3_timepoints \
-k '2' -c '2' -j '16' -r '1' -q '0' -n '1' -b '1' \
${subjName}_ses-01_T1w_N4corrected_norm_preproc.nii.gz ${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz \
${subjName}_ses-06_T1w_N4corrected_norm_preproc.nii.gz ${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz \
${subjName}_ses-12_T1w_N4corrected_norm_preproc.nii.gz ${subjName}_ses-12_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz

cd $TMPDIR/$subjName/
tar -zcvf ./${subjName}lct_3_timepoints.tar.gz ./${subjName}lct_3_timepoints ./${subjName}lct_3_timepointsSingleSubjectTemplate
if [[ ! -e $TMPDIR/$subjName/${subjName}lct_3_timepoints.tar.gz ]] ; then
    echo "${subjName} 3TP ANTSLCT didn't work.">>/RDS/Q0535/optimex/data/derivatives/ALCT_errorList.txt
fi
mkdir /RDS/Q0535/optimex/data/derivatives/3_alct/$subjName
rsync -v -r $TMPDIR/$subjName/${subjName}lct_3_timepoints.tar.gz /RDS/Q0535/optimex/data/derivatives/3_alct/$subjName/