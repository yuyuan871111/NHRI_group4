#usr/bin/bash

fileroad=$1
tumorname=$2
normalname=$3
echo "tumor file: $fileroad/$tumorname.read1.fastq and $fileroad/$tumorname.read2.fastq"
echo "normal file: $fileroad/$normalname.read1.fastq and $fileroad/$normalname.read2.fastq"

checkfileexist()
{
	echo "check $1"
	if [ -f "$3/$2.read1.fastq" ];
	then
	        echo "successfully"
	elif [ -f "$3/$2.read1.fastq.gz" ];
	then
		echo "successfully, the file exists"
		#echo "accepted to do the following works."

	else
	        echo "the $2 file isn't existing"
	        echo "$2 is your filename? y/n"
	        read namecheck
	        if [ "$namecheck" == "n" ];
	        then
	                echo "input your $1"
	                read $1 #replace old name
	        fi

		echo "$3 is your filepath? y/n"
	        read pathcheck
	        if [ "$pathcheck" == "n" ];
	        then
	                echo "input your filepath"
	                read fileroad #replace old filepath
		fi
        fi
}

secondcheck()
{
	echo "your set file: $1/$2.read1.fastq and $1/$2.read2.fastq"
	if [ -f "$1/$2.read1.fastq" ];
	then
        	echo "successfully, the file exists"
        	echo "accepted to do the following works."
	else
        	echo "the file isn't existing. Please check your filename."
        	echo "the format of the files SHOULD BE .read1.fastq, .read2.fastq or .read1.fastq.gz, .read2.fastq.gz"
        	exit 0
	fi
}

flow()
{
	JOB1=$(qsub fastp.sh -v var1=$1,var2=$2)
	JOB2=$(qsub -W depend=afterok:$JOB1 bwa-mem.sh -v var1=$1,var2=$2)
	JOB3=$(qsub -W depend=afterok:$JOB2 sort_index.sh -v var1=$1,var2=$2)
	#JOB4=$(qsub -W depend=afterok:$JOB3 variantcalling.sh -v var1=$1,var2=$2)
	qsub -W depend=afterok:$JOB3 document.sh -v var1=$1
}
#checking tumor file
checkfileexist tumorname $tumorname $fileroad
secondcheck $fileroad $tumorname

#checking normal file
checkfileexist normalname $normalname $fileroad
secondcheck $fileroad $normalname

echo "your file is whole genome sequence or whole exnome sequence? WGS/WES"
read filetype
if [ "$filetype" == "WGS" ] || [ "$filetype" == "WES" ];
then
	echo "performing script"
else
	echo "please enter WGS or WES"
	exit 0
fi
mkdir $fileroad\/dealed
#tumor flow
#flow $fileroad $tumorname
JOB1=$(qsub fastp.sh -v var1=$fileroad,var2=$tumorname)
JOB2=$(qsub -W depend=afterok:$JOB1 bwa-mem.sh -v var1=$fileroad,var2=$tumorname)
JOB3=$(qsub -W depend=afterok:$JOB2 sort_index.sh -v var1=$fileroad,var2=$tumorname)
#normal flow
#flow $fileroad $normalname
JOB4=$(qsub -W depend=afterok:$JOB3 fastp.sh -v var1=$fileroad,var2=$normalname)
JOB5=$(qsub -W depend=afterok:$JOB4 bwa-mem.sh -v var1=$fileroad,var2=$normalname)
JOB6=$(qsub -W depend=afterok:$JOB5 sort_index.sh -v var1=$fileroad,var2=$normalname)
#variant calling
JOB7=$(qsub -W depend=afterok:$JOB6 variantcalling.sh -v var1=$fileroad,var2=$tumorname,var3=$normalname)
qsub -W depend=afterok:$JOB7 document.sh -v var1=$fileroad

