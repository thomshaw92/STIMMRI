#!/bin/bash

#antsCortical Long. thickness script for extracting
#volume, SA, and cortical thickness for STIMMRI data
#Tom Shaw 31/03/2021

#Serial version for running on CAI
#bring the BIDS t1ws down from RDM
#rsync -v -a --prune-empty-dirs --include '*/' --include '*T1w.nii.gz' --exclude '*' ../STIMMRI_BIDS/ /scratch/project/uhfmri/STIMMRI/
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=64
#subjName=$1
for subjName in `cat /data/lfs2/uqtshaw/STIMMRI/scripts/STIMMRI/subjnames_remaining_130-151.csv` ; do 
    #singularity="singularity exec --bind /30days:/30days/ /home/uqtshaw/ants_2.3.4.sif"
    #module load singularity
    # local ANTs use is better - need to edit opts on scripts to tailor CPUs etc
    scratch="/30days/uqtshaw/STIMMRI/"
    mkdir -p ${scratch}/alct/${subjName}
    cd ${scratch}/alct/${subjName}

    data_dir="${scratch}/bids_t1w_only/"
    atlas_dir="/data/lfs2/uqtshaw/STIMMRI/STIMMRI_ATLAS"
    out_dir="${scratch}/alct/${subjName}/${subjName}_long_cortical_thickness"
    atlasDir="/data/lfs2/uqtshaw/STIMMRI/mindboggle_all_data"
    #don't ask me why i called these like this

   ########################## 
    tp_1_t1w=$(echo "${data_dir}/${subjName}/ses-01/anat/${subjName}"*"T1w.nii.gz")
    tp_2_t1w=$(echo "${data_dir}/${subjName}/ses-02/anat/${subjName}"*"T1w.nii.gz")
    tp_3_t1w=$(echo "${data_dir}/${subjName}/ses-03/anat/${subjName}"*"T1w.nii.gz")
    

    if [[ -e ${tp_1_t1w} && ! -e ${tp_2_t1w} && ! -e ${tp_3_t1w} ]] ; then
	inputs="${tp_1_t1w}"
	echo "only one timepoint (TP1) exists for ${subjName}, exiting"
	echo ${subjName}_TP1 >> ${scratch}/1TP_only_log.txt
	png_file=$(echo "${scratch}/alct/${subjName}/${subjName}_long_cortical_thickness/${subjName}_ses-01"*"/${subjName}_ses-01_acq-"*"T1wCorticalThicknessTiledMosaic.png")
    fi
    if [[ ! -e ${tp_1_t1w} && -e ${tp_2_t1w} && ! -e ${tp_3_t1w} ]] ; then
	inputs="${tp_2_t1w}"
	echo "only one timepoint (TP1) exists for ${subjName}, exiting"
	echo ${subjName}_TP2 >> ${scratch}/1TP_only_log.txt
	png_file=$(echo "${scratch}/alct/${subjName}/${subjName}_long_cortical_thickness/${subjName}_ses-02"*"/${subjName}_ses-02_acq-"*"T1wCorticalThicknessTiledMosaic.png")
    fi
    if [[ ! -e ${tp_1_t1w} && ! -e ${tp_2_t1w} && -e ${tp_3_t1w} ]] ; then
	inputs="${tp_3_t1w}"
	echo "only one timepoint (TP1) exists for ${subjName}, exiting"
	echo ${subjName}_TP3 >> ${scratch}/1TP_only_log.txt
	png_file=$(echo "${scratch}/alct/${subjName}/${subjName}_long_cortical_thickness/${subjName}_ses-03"*"/${subjName}_ses-03_acq-"*"T1wCorticalThicknessTiledMosaic.png")
    fi
    if [[ -e ${tp_1_t1w} && -e ${tp_2_t1w} && ! -e ${tp_3_t1w} ]] ; then
	inputs="${tp_1_t1w} ${tp_2_t1w}"
	png_file=$(echo "${scratch}/alct/${subjName}/${subjName}_long_cortical_thickness/${subjName}_ses-02"*"/${subjName}_ses-02_acq-"*"T1wCorticalThicknessTiledMosaic.png")
    fi
    if [[ -e ${tp_1_t1w} && ! -e ${tp_2_t1w} && -e ${tp_3_t1w} ]] ; then
	inputs="${tp_1_t1w} ${tp_3_t1w}"
	png_file=$(echo "${scratch}/alct/${subjName}/${subjName}_long_cortical_thickness/${subjName}_ses-03"*"/${subjName}_ses-03_acq-"*"T1wCorticalThicknessTiledMosaic.png")
    fi
    if [[ ! -e ${tp_1_t1w} && -e ${tp_2_t1w} && -e ${tp_3_t1w} ]] ; then
	inputs="${tp_2_t1w} ${tp_3_t1w}"
	png_file=$(echo "${scratch}/alct/${subjName}/${subjName}_long_cortical_thickness/${subjName}_ses-03"*"/${subjName}_ses-03_acq-"*"T1wCorticalThicknessTiledMosaic.png")
    fi
    if [[ -e ${tp_1_t1w} && -e ${tp_2_t1w} && -e ${tp_3_t1w} ]] ; then
	inputs="${tp_1_t1w} ${tp_2_t1w} ${tp_3_t1w}"
	png_file=$(echo "${scratch}/alct/${subjName}/${subjName}_long_cortical_thickness/${subjName}_ses-03"*"/${subjName}_ses-03_acq-"*"T1wCorticalThicknessTiledMosaic.png")
    fi

    #ANTS LCT 3TP

    if [[ ! -e ${png_file} ]] ; then
	antsLongitudinalCorticalThickness.sh -d 3 \
					     -e ${atlas_dir}/STIMMRI_T1w_template0.nii.gz \
					     -m ${atlas_dir}/antsCTBrainExtractionMaskProbabilityMask.nii.gz \
					     -p ${atlas_dir}/antsCTBrainSegmentationPosteriors%d.nii.gz \
					     -f ${atlas_dir}/antsCTBrainExtractionMask.nii.gz \
					     -t ${atlas_dir}/antsCTBrainExtractionBrain.nii.gz \
					     -o ${subjName}_long_cortical_thickness \
					     -k '1' \
					     -c '2' \
					     -j '32' \
					     -r '1' \
					     -q '0' \
					     -n '1' \
					     -g '1' \
					     -b '0' \
					     ${inputs}
    fi

    #JLF the data

    for TP in 01 02 03 ; do

	outdir_JLF=${scratch}/alct/${subjName}/${subjName}_ses-${TP}_DKT_JLF
	dkt_labels_image=$(echo "${outdir_JLF}/dkt_${TP}Labels.nii.gz")
	if [[ ! -e ${dkt_labels_image} ]] ; then
	    mkdir -p ${outdir_JLF}
	    cd ${outdir_JLF}
	    
	    target_image=$(echo "${out_dir}/${subjName}_ses-${TP}_"*"/${subjName}_ses-${TP}_"*"T1wExtractedBrain0N4.nii.gz")
	    if [[ -e ${target_image} ]] ; then
		command="antsJointLabelFusion.sh -d 3 -t ${target_image} -x or -o dkt_${TP} -c 2 -j 64"
		
		for i in {1..20} ;  do
		    command="${command} -g ${atlasDir}/OASIS-TRT-20_volumes/OASIS-TRT-20-${i}/t1weighted_brain.nii.gz"
		    command="${command} -l ${atlasDir}/OASIS-TRT-20_DKT31_CMA_labels_v2/OASIS-TRT-20-${i}_DKT31_CMA_labels.nii.gz"
		done
		
		$command
	    fi
	fi
	#collect some stats - add extra regions
	
	for num in 1002 1003 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1016 1017 1018 1019 1020 1021 1022 1023 1025 1026 1027 1028 1029 1030 1031 1034 1035 2002 2003 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029 2030 2031 2034 2035 ; do
	    labelledimage=$(echo "${outdir_JLF}/dkt_${TP}Labels.nii.gz")
	    if [[ -e ${labelledimage} ]] ; then
		echo "${subjName}, ses ${TP}, label ${num}"
		fslmaths ${labelledimage} -thr ${num} -uthr ${num} ${outdir_JLF}/${num}_mask.nii.gz && fslmaths ${outdir_JLF}/${num}_mask.nii.gz -bin ${outdir_JLF}/${num}_mask.nii.gz &
	    fi
	    #cortical_thickness_image=$(echo "${out_dir}/${subjName}_ses-${TP}_"*"/${subjName}_ses-${TP}*_run-1_T1wCorticalThickness.nii.gz")
	    #echo "${subjName} ses-${TP} ${num}">> ${outdir_JLF}/numstats.csv
	    #the stats are going to be min intensity, max intensity, mean of nonzero values, SD of nonzeroes
	done
	#volume
	for num in 71 72 73 75 76 630 631 632 91 92 16 24 14 15 72 85 4 5 6 7 10 11 12 13 17 18 25 26 28 30 91 43 44 45 46 49 50 51 52 53 54 57 58 60 62 92 630 631 632 ; do 
	    labelledimage=$(echo "${outdir_JLF}/dkt_${TP}Labels.nii.gz")
	    if [[ -e ${labelledimage} ]] ; then
		fslmaths ${labelledimage} -thr ${num} -uthr ${num} ${outdir_JLF}/${num}_mask.nii.gz && fslmaths ${outdir_JLF}/${num}_mask.nii.gz -bin ${outdir_JLF}/${num}_mask.nii.gz &
	    fi
	done
	sleep 20s
    done
    cd ${scratch}/alct/
    #zip -r -0 ${subjName}.zip ${subjName} && cp ${subjName}.zip /winmounts/uqtshaw/data.cai.uq.edu.au/STIMMRI20-Q1876/data/derivatives/alct/ && rm ${subjName}.zip &
done
