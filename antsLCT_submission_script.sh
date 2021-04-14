#!/bin/bash
for subjName in `cat ~/scripts/STIMMRI/subjnames.csv` ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/STIMMRI/antsLCT_PBS_script.pbs
done