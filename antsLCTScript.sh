#!/bin/bash

#antsCortical Long. thickness script for extracting
#volume, SA, and cortical thickness for STIMMRI data
#Tom Shaw 31/03/2021

#Will run on HPCs - PBS

subjName=$1
singularity="singularity exec --bind $TMPDIR:/TMPDIR --pwd /TMPDIR/${subjName} /30days/uqtshaw/ants_fsl_robex_20180524.simg"
module load singularity/2.5.1
mkdir -p /30days/$USER/derivatives/3_alct/$subjName
cd /30days/$USER/derivatives/3_alct/$subjName
#Copy everything to TMPDIR
cp -r /RDS/Q0535/optimex/data/derivatives/preprocessing/${subjName} $TMPDIR
cd $TMPDIR
cp -r /30days/uqtshaw/cai63_asym_2017_nlin_TempAndPriors $TMPDIR/$subjName/
chmod -R 740 $TMPDIR/$subjName/
cp $TMPDIR/$subjName/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz $TMPDIR/$subjName/${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz
cp $TMPDIR/$subjName/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz $TMPDIR/$subjName/${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz
cp $TMPDIR/$subjName/${subjName}_ses-12_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz $TMPDIR/$subjName/${subjName}_ses-12_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz

#ANTS LCT 3TP
if [[ -e $TMPDIR/$subjName/${subjName}_ses-12_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz ]] ; then 
    cd $TMPDIR/$subjName
    $singularity antsLongitudinalCorticalThickness_noN4.sh -d 3 -e cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin.nii.gz -m cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_ProbabilityMask.nii.gz -p cai63_asym_2017_nlin_TempAndPriors/prior%d.nii.gz -f cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_BrainExtractionMask.nii.gz -t cai63_asym_2017_nlin_TempAndPriors/cai63_asym_2017_nlin_Extracted_Brain.nii.gz -o ${subjName}lct_3_timepoints -k '2' -c '2' -j '16' -r '1' -q '0' -n '1' -b '1' \
	${subjName}_ses-01_T1w_N4corrected_norm_preproc.nii.gz ${subjName}_ses-01_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz \
	${subjName}_ses-06_T1w_N4corrected_norm_preproc.nii.gz ${subjName}_ses-06_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz \
	${subjName}_ses-12_T1w_N4corrected_norm_preproc.nii.gz ${subjName}_ses-12_T2w_NlinMoCo_res-iso.3_N4corrected_denoised_brain_preproc.nii.gz
fi

rm -r $TMPDIR/$subjName/cai63_asym_2017_nlin_TempAndPriors

#move it out

cd $TMPDIR/$subjName/
tar -zcvf ./${subjName}lct_3_timepoints.tar.gz ./${subjName}lct_3_timepoints ./${subjName}lct_3_timepointsSingleSubjectTemplate
if [[ ! -e $TMPDIR/$subjName/${subjName}lct_3_timepoints.tar.gz ]] ; then
echo "${subjName} 3TP ANTSLCT didn't work.">>/RDS/Q0535/optimex/data/derivatives/ALCT_errorList.txt 
fi
mkdir /RDS/Q0535/optimex/data/derivatives/3_alct/$subjName
rsync -v -r $TMPDIR/$subjName/${subjName}lct_3_timepoints.tar.gz /RDS/Q0535/optimex/data/derivatives/3_alct/$subjName/
