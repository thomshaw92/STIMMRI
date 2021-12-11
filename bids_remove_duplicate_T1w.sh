#!/bin/bash
#remove BIDS duplictes or extra runs of T1w scans
#20211208
#Tom Shaw

#set up
bids_dir="/30days/uqtshaw/STIMMRI/bids"
cd ${bids_dir}
for file in `find . -type f -printf '%h\n' | sort | uniq -d ` ; do echo $file && ls ${file} ; done

##start removing files
#remove all with ND and MP2rage only

for subjname in 126 129 130 131 132 134 137 138 140 141 142 143 144 145 146 147 157 158 161 162 163 164 165 167 168 169 170 ; do
    rm ./sub-${subjname}/ses*/anat/*ND*T1w.*
done

##remove non RR ones that needed RR I guess?
for subjname in 108 103 114 126 131 132 135 136 139 140 141 142 143 144 146 147 148 150 151 152 153 154 155 156 157 158 159 161 160 162 163 164 165 168 170 ; do
    rm ./sub-${subjname}/ses*/anat/*75mmUNIDEN*T1w.*
done
#103 didn't work because the protocol changed
rm ./sub-103/ses*/anat/*7TUNIDEN*T1w.*

##remove ones with 2 runs - second run is repeat due to movement.

mv ./sub-038/ses-01/anat/sub-038_ses-01_acq-WIP944mp2rage075iso7TUNIDEN_run-2_T1w.nii.gz ./sub-038/ses-01/anat/sub-038_ses-01_acq-WIP944mp2rage075iso7TUNIDEN_run-1_T1w.nii.gz
mv ./sub-044/ses-01/anat/sub-044_ses-01_acq-WIP944mp2rage075iso7TUNIDEN_run-2_T1w.nii.gz ./sub-044/ses-01/anat/sub-044_ses-01_acq-WIP944mp2rage075iso7TUNIDEN_run-1_T1w.nii.gz
mv ./sub-095/ses-03/anat/sub-095_ses-03_acq-WIP944mp2rage075iso7TUNIDEN_run-2_T1w.nii.gz ./sub-095/ses-03/anat/sub-095_ses-03_acq-WIP944mp2rage075iso7TUNIDEN_run-1_T1w.nii.gz
mv ./sub-126/ses-01/anat/sub-126_ses-01_acq-MP2RAGEwip925b0p75mmRRUNIDEN_run-2_T1w.nii.gz ./sub-126/ses-01/anat/sub-126_ses-01_acq-MP2RAGEwip925b0p75mmRRUNIDEN_run-1_T1w.nii.gz
#and this weird one
mv ./sub-092/ses-03/anat/sub-092_ses-03_acq-WIP944mp2rage075iso7TrptUNIDEN_run-1_T1w.nii.gz ./sub-092/ses-03/anat/sub-092_ses-03_acq-WIP944mp2rage075iso7TUNIDEN_run-1_T1w.nii.gz

