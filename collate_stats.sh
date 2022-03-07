#!/bin/bash

#antsCortical Long. thickness script for extracting
#volume, SA, and cortical thickness for STIMMRI data
#Tom Shaw 31/03/2021

#collect the stats
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=32
#subjName=$1
ml fsl
for subjName in sub-{001..200} ; do 
    #singularity="singularity exec --bind /30days:/30days/ /home/uqtshaw/ants_2.3.4.sif"
    #module load singularity
    scratch="/30days/uqtshaw/"
    mkdir -p ${scratch}/STIMMRI/alct/${subjName}
    cd ${scratch}/STIMMRI/alct/${subjName}

    data_dir="/30days/uqtshaw/STIMMRI/bids/"
    atlas_dir="${scratch}/STIMMRI_ATLAS"
    out_dir="${scratch}/STIMMRI/alct/${subjName}/${subjName}_long_cortical_thickness"

    tp_1_t1w=$(echo "${data_dir}/${subjName}/ses-01/anat/${subjName}"*"T1w.nii.gz")
    tp_2_t1w=$(echo "${data_dir}/${subjName}/ses-02/anat/${subjName}"*"T1w.nii.gz")
    tp_3_t1w=$(echo "${data_dir}/${subjName}/ses-03/anat/${subjName}"*"T1w.nii.gz")

    
    for TP in 01 02 03 ; do

	outdir_JLF=${scratch}/STIMMRI/alct/${subjName}/${subjName}_ses-${TP}_DKT_JLF
	dkt_labels_image=$(echo "${outdir_JLF}/dkt_${TP}Labels.nii.gz")
	

	ml fsl
	#collect some stats
	for num in 1003 1008 1012 1014 1018 1019 1020 1024 1027 1028 2003 2008 2012 2014 2018 2019 2020 2024 2027 2028 ; do
	    labelledimage=$(echo "${outdir_JLF}/dkt_${TP}Labels.nii.gz")
	    #fslmaths ${labelledimage} -thr ${num} -uthr ${num} ${outdir_JLF}/${num}_mask.nii.gz
	    #fslmaths ${outdir_JLF}/${num}_mask.nii.gz -bin ${outdir_JLF}/${num}_mask.nii.gz
	    cortical_thickness_image=$(echo "${out_dir}/${subjName}_ses-${TP}_"*"/${subjName}_ses-${TP}*_run-1_T1wCorticalThickness.nii.gz")
	    echo "${subjName} ses-${TP} ${num}">> ${outdir_JLF}/numstats.csv
	    #the stats are going to be min intensity, max intensity, mean of nonzero values, SD of nonzeroes
	    fslstats ${cortical_thickness_image} -k ${outdir_JLF}/${num}_mask.nii.gz -l 0.01 -R -M -S >> ${outdir_JLF}/stats.csv
	    #LabelGeometryMeasures 3  ${outdir_JLF}/${num}_mask.nii.gz [intensityImage=none] ${outdir_JLF}/stats_ants.csv
	    paste -d' ' ${outdir_JLF}/numstats.csv ${outdir_JLF}/stats.csv > ${outdir_JLF}/statsfile_temp.csv
	    cat ${outdir_JLF}/statsfile_temp.csv >> ${scratch}/STIMMRI/alct/statsfile.csv
	    tr -s '\t' <${scratch}/STIMMRI/alct/statsfile.csv | tr '\t' ',' >${scratch}/STIMMRI/alct/statsfilenowhite.csv
	    #rm ${scratch}/STIMMRI/alct/statsfile.csv
	    #mv ${scratch}/STIMMRI/alct/statsfilenowhite.csv ${scratch}/STIMMRI/alct/statsfile.csv
	    rm ${outdir_JLF}/statsfile_temp.csv ${outdir_JLF}/numstats.csv ${outdir_JLF}/stats.csv
	done
    done 
done
