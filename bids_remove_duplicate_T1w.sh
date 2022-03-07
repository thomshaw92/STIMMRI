#!/bin/bash
#remove BIDS duplictes or extra runs of T1w scans
#20211208
#should only be run once on the dataset
#Tom Shaw

#set up
bids_dir="/30days/uqtshaw/STIMMRI/bids"
cd ${bids_dir}
for file in `find . -type f -printf '%h\n' | sort | uniq -d ` ; do echo $file && ls ${file} ; done

##start removing files
#remove all with ND and MP2rage only

for subjname in 129 130 131 132 137 138 140 141 142 144 145 146 147 157 158 161 162 163 164 165 167 168 169 170 174 175 177 179 180 181 182 183 186 189 192 194 196 197 198 199 200; do
    rm ./sub-${subjname}/ses*/anat/*ND*T1w.*
done

##remove non RR ones that needed RR I guess?
for subjname in 108 114 135 136 139 140 141 144 146 147 148 150 153 154 155 156 157 158 159 161 160 162 163 164 165 168 170 174 176 178 179 184 186 187 189 190 194 ; do
    rm ./sub-${subjname}/ses*/anat/*75mmUNIDEN*T1w.*
done
#special cases where things change between runs yay
# 103 126 131 132 134 142 143 151 152 185 188 191 195

rm ./sub-103/ses-03/anat/sub-103_ses-03_acq-WIP944mp2rage075iso7TUNIDEN_run-1_T1w.nii.gz

rm ./sub-126/ses-01/anat/*run-1*
rm ./sub-126/ses-01/anat/*run-3*
rm ./sub-126/ses-01/anat/sub-126_ses-01_acq-MP2RAGEwip925b0p75mmRRUNIDENND_run-2_T1w.nii.gz
mv ./sub-126/ses-01/anat/sub-126_ses-01_acq-MP2RAGEwip925b0p75mmRRUNIDEN_run-2_T1w.nii.gz ./sub-126/ses-01/anat/sub-126_ses-01_acq-MP2RAGEwip925b0p75mmRRUNIDEN_run-1_T1w.nii.gz

rm ./sub-131/ses-03/anat/sub-131_ses-03_acq-MP2RAGEwip925b0p75mmUNIDEN_run-1_T1w.nii.gz

rm ./sub-132/ses-03/anat/sub-132_ses-03_acq-MP2RAGEwip925b0p75mmUNIDEN_run-1_T1w.nii.gz

rm ./sub-134/ses-04/anat/sub-134_ses-04_acq-MP2RAGEwip925b0p75mmUNIDENND_run-1_T1w.nii.gz

rm ./sub-142/ses-02/anat/sub-142_ses-02_acq-MP2RAGEwip925b0p75mmUNIDEN_run-1_T1w.nii.gz
rm ./sub-142/ses-03/anat/sub-142_ses-03_acq-MP2RAGEwip925b0p75mmUNIDEN_run-1_T1w.nii.gz

rm ./sub-143/ses-01/anat/*run-1*
mv ./sub-143/ses-01/anat/sub-143_ses-01_acq-MP2RAGEwip925b0p75mmRRUNIDENND_run-2_T1w.nii.gz ./sub-143/ses-01/anat/sub-143_ses-01_acq-MP2RAGEwip925b0p75mmRRUNIDENND_run-1_T1w.nii.gz
rm ./sub-143/ses-01/anat/*run-2*
rm ./sub-143/ses-02/anat/sub-143_ses-02_acq-MP2RAGEwip925b0p75mmUNIDEN_run-1_T1w.nii.gz

mv ./sub-151/ses-02/ sub-151/ses-01
mv ./sub-151/ses-03/ sub-151/ses-02
mv ./sub-151/ses-04/ sub-151/ses-03
rm ./sub-151/ses-01/anat/sub-151_ses-02_acq-MP2RAGEwip925b0p75mmUNIDEN_run-1_T1w.nii.gz
mv ./sub-151/ses-01/anat/sub-151_ses-02_acq-MP2RAGEwip925b0p75mmRRUNIDEN_run-1_T1w.nii.gz ./sub-151/ses-01/anat/sub-151_ses-01_acq-MP2RAGEwip925b0p75mmRRUNIDEN_run-1_T1w.nii.gz
rm ./sub-151/ses-02/anat/sub-151_ses-03_acq-MP2RAGEwip925b0p75mmUNIDEN_run-1_T1w.nii.gz
mv ./sub-151/ses-02/anat/sub-151_ses-03_acq-MP2RAGEwip925b0p75mmRRUNIDEN_run-1_T1w.nii.gz ./sub-151/ses-02/anat/sub-151_ses-02_acq-MP2RAGEwip925b0p75mmRRUNIDEN_run-1_T1w.nii.gz
rm ./sub-151/ses-03/anat/sub-151_ses-04_acq-MP2RAGEwip925b0p75mmUNIDENND_run-1_T1w.nii.gz
mv ./sub-151/ses-03/anat/sub-151_ses-04_acq-MP2RAGEwip925b0p75mmUNIDEN_run-1_T1w.nii.gz ./sub-151/ses-03/anat/sub-151_ses-03_acq-MP2RAGEwip925b0p75mmUNIDEN_run-1_T1w.nii.gz

rm ./sub-152/ses-01/anat/sub-152_ses-01_acq-MP2RAGEwip925b0p75mmUNIDENNDEq1_run-1_T1w.nii.gz
rm ./sub-152/ses-02/anat/sub-152_ses-02_acq-MP2RAGEwip925b0p75mmUNIDEN_run-1_T1w.nii.gz




##remove ones with 2 runs - second run is repeat due to movement.

mv ./sub-038/ses-01/anat/sub-038_ses-01_acq-WIP944mp2rage075iso7TUNIDEN_run-2_T1w.nii.gz ./sub-038/ses-01/anat/sub-038_ses-01_acq-WIP944mp2rage075iso7TUNIDEN_run-1_T1w.nii.gz
mv ./sub-044/ses-01/anat/sub-044_ses-01_acq-WIP944mp2rage075iso7TUNIDEN_run-2_T1w.nii.gz ./sub-044/ses-01/anat/sub-044_ses-01_acq-WIP944mp2rage075iso7TUNIDEN_run-1_T1w.nii.gz
mv ./sub-095/ses-03/anat/sub-095_ses-03_acq-WIP944mp2rage075iso7TUNIDEN_run-2_T1w.nii.gz ./sub-095/ses-03/anat/sub-095_ses-03_acq-WIP944mp2rage075iso7TUNIDEN_run-1_T1w.nii.gz
mv ./sub-126/ses-01/anat/sub-126_ses-01_acq-MP2RAGEwip925b0p75mmRRUNIDEN_run-2_T1w.nii.gz ./sub-126/ses-01/anat/sub-126_ses-01_acq-MP2RAGEwip925b0p75mmRRUNIDEN_run-1_T1w.nii.gz
#and this weird one
mv ./sub-092/ses-03/anat/sub-092_ses-03_acq-WIP944mp2rage075iso7TrptUNIDEN_run-1_T1w.nii.gz ./sub-092/ses-03/anat/sub-092_ses-03_acq-WIP944mp2rage075iso7TUNIDEN_run-1_T1w.nii.gz

