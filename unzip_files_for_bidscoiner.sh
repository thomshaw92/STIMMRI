#!/bin/bash
#this will unzip all the directories in local so bidscoiner doesn't screw up
#set the directory name
###DO NOT SET THIS TO THE RDM DIRECTORY - LOCAL (30days ONLY)
raw_dir="/30days/uqtshaw/STIMMRI/raw_data"

#start unzipping
for x in {007..113}  ; do #or however many participants you have in raw_dir
    for ses in 01 02 03 ; do
	echo "doing subject ${x} in session ${ses}"
        if [[ -d ${raw_dir}/sub-${x}/ses-${ses} ]] ; then
            cd ${raw_dir}/sub-${x}/ses-${ses}
	    # initialize a semaphore with a given number of tokens
	    open_sem(){
		mkfifo pipe-$$
		exec 3<>pipe-$$
		rm pipe-$$
		local i=$1
		for((;i>0;i--)); do
		    printf %s 000 >&3
		done
	    }

	    # run the given command asynchronously and pop/push tokens
	    run_with_lock(){
		local x
		# this read waits until there is something to read
		read -u 3 -n 3 x && ((0==x)) || exit $x
		(
		    ( "$@"; )
		    # push the return code of the command to the semaphore
		    printf '%.3d' $? >&3
		)&
	    }

	    N=4
	    open_sem $N     	
            for file in *zip ; do
<<<<<<< HEAD
                unzip ${file} -d ${file:0:-4}
=======
		run_with_lock unzip -o ${file} -d ${file:0:-4} 
>>>>>>> f0b8d9dcc744368bbe80dd5dbdd7522ba1b8b883
            done
	    
        fi
    done
<<<<<<< HEAD
=======
done
>>>>>>> f0b8d9dcc744368bbe80dd5dbdd7522ba1b8b883
