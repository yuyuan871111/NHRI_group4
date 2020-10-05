#usr/bin/bash

fileroad=$1
filename=$2
echo $fileroad
echo $filename
cd $fileroad
mkdir dealed
cd ./dealed
JOB1=$(qsub fastp.sh -v var1=$fileroad,var2=$filename)
JOB2=$(qsub -W depend=afterok:$JOB1 bwa-mem.sh -v var1=$fileroad,var2=$filename)
qsub -W depend=afterok:$JOB2 sort_index.sh -v var1=$fileroad,var2=$filename
mkdir ./document
mv *.std ./document/
mv *.err ./document/

