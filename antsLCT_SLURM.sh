#!/bin/bash
#SBATCH --job-name=optimex-tse_nlin
#SBATCH -N 1
#nodes 
#SBATCH -n 1             
#SBATCH -c 4
#SBATCH --partition=all
# Name of the Slurm partition used
#SBATCH --mem=31000
#SBATCH -o slurm.%N.%j.out 
#SBATCH -e slurm.%N.%j.error  

#antsCortical Long. thickness script for extracting
#volume, SA, and cortical thickness for STIMMRI data
#Tom Shaw 09/11/2021
#run on SLURM

#use the serial script from here