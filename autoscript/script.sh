#usr/bin/bash

fileroad=$1
filename=$2
echo "file: $fileroad/$filename.read1.fastq and $fileroad/$filename.read2.fastq"
if [ -f "$fileroad/$filename.read1.fastq" ];
then
	echo "successfully"
else
	echo "the file isn't existing"
	echo "$filename is your filename? y/n"
	read $namecheck
	if [ "$namecheck" = "n" ];
	then
		echo "input your filename"
		read $newfile
		$filename=$newfile
	echo "$fileroad is your filepath? y/n"
	read $pathcheck
	fi
	if [ "$pathcheck" = "n" ];
	then
		echo "input your filepath"
		read $newpath
		$fileroad=$newpath
	echo "your reset file: $fileroad/$filename.read1.fastq and $fileroad/$filename.read2.fastq"
	fi
fi
mkdir $fileroad\/dealed
JOB1=$(qsub fastp.sh -v var1=$fileroad,var2=$filename)
JOB2=$(qsub -W depend=afterok:$JOB1 bwa-mem.sh -v var1=$fileroad,var2=$filename)
JOB3=$(qsub -W depend=afterok:$JOB2 sort_index.sh -v var1=$fileroad,var2=$filename)
qsub -W depend=afterok:$JOB3 variantcalling.sh -v var1=$fileroad,var2=$filename
