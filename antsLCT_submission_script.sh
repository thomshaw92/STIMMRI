#!/bin/bash
#for subjName in `cat ~/scripts/STIMMRI/subjnames.csv` ; do 
#	qsub -v SUBJNAME=$subjName ~/scripts/STIMMRI/antsLCT_PBS_script.pbs
#done
#SLURM
for subjName in `cat /data/lfs2/${USER}/STIMMRI/subjnames.csv` ; do 
    sbatch --export=SUBJNAME=$subjName /data/lfs2/${USER}/STIMMRI/anstsLCT_SLURM.sh
done