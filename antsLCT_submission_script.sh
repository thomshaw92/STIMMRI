#!/bin/bash
for subjName in `cat ~/scripts/OPTIMEX/subjnames_06_redos.csv ` ; do 
	qsub -v SUBJNAME=$subjName ~/scripts/OPTIMEX/3_ANTSLCT/antsLCT_pbs_script_2TP.pbs
done