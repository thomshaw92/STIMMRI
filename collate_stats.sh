#!/bin/bash

#antsCortical Long. thickness script for extracting
#volume, SA, and cortical thickness for STIMMRI data
#Tom Shaw 31/03/2021

#collect the stats
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=32

for subjName in sub-009 sub-054 sub-092 sub-101 sub-152 ; do 
    #singularity="singularity exec --bind /30days:/30days/ /home/uqtshaw/ants_2.3.4.sif"
    #module load singularity
    scratch="/90days/uqtshaw/STIMMRI_redos"
    mkdir -p ${scratch}/alct/${subjName}
    cd ${scratch}/alct/${subjName}

    #data_dir="${scratch}/STIMMRI/bids_t1w_only/"
    #atlas_dir="/data/lfs2/uqtshaw/STIMMRI/STIMMRI_ATLAS"
    out_dir="${scratch}/alct/${subjName}/${subjName}_long_cortical_thickness"

    #tp_1_t1w=$(echo "${data_dir}/${subjName}/ses-01/anat/${subjName}"*"T1w.nii.gz")
    #tp_2_t1w=$(echo "${data_dir}/${subjName}/ses-02/anat/${subjName}"*"T1w.nii.gz")
    #tp_3_t1w=$(echo "${data_dir}/${subjName}/ses-03/anat/${subjName}"*"T1w.nii.gz")
  
    for TP in 01 02 03 ; do
	outdir_JLF=${scratch}/alct/${subjName}/${subjName}_ses-${TP}_DKT_JLF
	dkt_labels_image=$(echo "${outdir_JLF}/dkt_${TP}Labels.nii.gz")
	#collect some stats
	for num in 1002 1003 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1016 1017 1018 1019 1020 1021 1022 1023 1024 1025 1026 1027 1028 1029 1030 1031 1034 1035 2002 2003 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 2034 2035 71 72 73 75 76 630 631 632 91 92 16 24 14 15 72 85 4 5 6 7 10 11 12 13 17 18 25 26 28 30 91 43 44 45 46 49 50 51 52 53 54 57 58 60 62 92 630 631 632 ; do
	    labelledimage=$(echo "${outdir_JLF}/dkt_${TP}Labels.nii.gz")
	    cortical_thickness_image=$(echo "${out_dir}/${subjName}_ses-${TP}_"*"/${subjName}_ses-${TP}*_run-1_T1wCorticalThickness.nii.gz")
	    echo "${subjName} ses-${TP} ${num}"
		rm ${outdir_JLF}/${subjName}_ses-${TP}_${num}statsfile_temp.csv ${outdir_JLF}/${subjName}_ses-${TP}_${num}numstats.csv ${outdir_JLF}/${subjName}_ses-${TP}_${num}stats.csv
		echo "${subjName} ses-${TP} ${num}">> ${outdir_JLF}/${subjName}_ses-${TP}_${num}numstats.csv \
		&& fslstats ${cortical_thickness_image} -k ${outdir_JLF}/${num}_mask.nii.gz -l 0.01 -R -M -S -V >> ${outdir_JLF}/${subjName}_ses-${TP}_${num}stats.csv \
 		&& paste -d' ' ${outdir_JLF}/${subjName}_ses-${TP}_${num}numstats.csv ${outdir_JLF}/${subjName}_ses-${TP}_${num}stats.csv > ${outdir_JLF}/${subjName}_ses-${TP}_${num}statsfile_temp.csv \
	    && cat ${outdir_JLF}/${subjName}_ses-${TP}_${num}statsfile_temp.csv >> ${scratch}/alct/statsfile.csv \
	    && rm ${outdir_JLF}/${subjName}_ses-${TP}_${num}statsfile_temp.csv ${outdir_JLF}/${subjName}_ses-${TP}_${num}numstats.csv ${outdir_JLF}/${subjName}_ses-${TP}_${num}stats.csv &
#the stats are going to be min intensity, max intensity, mean of nonzero values, SD of nonzeroes, number of nonzero voxels (volume)
	done
	sleep 30s 
    done 
done
tr -s '\t' <${scratch}/alct/statsfile.csv | tr '\t' ',' >${scratch}/STIMMRI/alct/statsfilenowhite.csv \
