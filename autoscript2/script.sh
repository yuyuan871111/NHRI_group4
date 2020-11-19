#usr/bin/bash

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
	elif [ -f "$1/$2.read1.fastq.gz" ];
        then
                echo "successfully, the file exists"
                echo "accepted to do the following works."
	else
        	echo "the file isn't existing. Please check your filename."
        	echo "the format of the files SHOULD BE .read1.fastq, .read2.fastq or .read1.fastq.gz, .read2.fastq.gz"
        	exit 0
	fi
}

checkfiletype()
{
	echo "Is your file whole genome sequence or whole exnome sequence? WGS/WES"
	read filetype
	if [ "$filetype" == "WGS" ] || [ "$filetype" == "WES" ];
	then
			echo "checking $filetype model"
	else
			echo "ERROR please enter WGS or WES"
			exit 0
	fi
}

checkreftype()
{
	echo "which reftype? 19/37/hg38"
	read reftype
	if [ "$reftype" == "19" ] || [ "$reftype" == "37" ] || [ "$reftype" == "hg38" ];
	then
			echo "checking reftype $reftype ,and then performing script"
	else
			echo "ERROR: please input 19,37,or hg38"
			exit 0
	fi
}

if [ "$1" == "musica" ] || [ "$1" == "MuSiCa" ];
then
	#MuSiCa
	echo "performing MuSiCa model"
	
	#sequence type
	checkfiletype
	#reference type
	checkreftype
	#current path
	cpath=$PWD

	echo "Please input the path of the folder storing your data."
	read datafolder
	echo "---------------------------------"
	echo "Please input the names of your cases. You can input simple file(e.g. TLCRC_020.hard-filtered.vcf)"
	echo "or multiple files joining with ':'(e.g. TLCRC_020.hard-filtered.vcf:TLCRC_043.hard-filtered.vcf)"
	read cases
	echo "---------------------------------"
	echo "your datafolder: $datafolder"
	echo "your cases:$cases"
	echo "your current path:$cpath"
	sleep 5s
	echo "---------------------------------"
	echo "performing musica"
	musica_result_folder=$datafolder/musica_result
	JOB1=$(qsub ./TestMuSiCa/musica_run.sh -v var1=$cpath,var2=$filetype,var3=$reftype,var4=1,var5=$datafolder,var6=$cases)
	qsub -W depend=afterok:$JOB1 create_index_html.sh -v var1=$musica_result_folder,var2=$PWD
else
	#Script
	fileroad=$1
	tumorname=$2
	normalname=$3
	echo "tumor file: $fileroad/$tumorname.read1.fastq and $fileroad/$tumorname.read2.fastq"
	echo "normal file: $fileroad/$normalname.read1.fastq and $fileroad/$normalname.read2.fastq"

	#checking tumor file
	checkfileexist tumorname $tumorname $fileroad
	secondcheck $fileroad $tumorname
	
	#checking normal file
	checkfileexist normalname $normalname $fileroad
	secondcheck $fileroad $normalname
	
	#sequence type
	checkfiletype
	#reference type
	reftype='hg38'
	
	echo "please input the name of your case"
	read casename
	
	
	mkdir $fileroad/dealed
	mkdir $fileroad/dealed/musica_result
	musica_result_folder=$fileroad/dealed/musica_result
	#tumor flow
	#flow $fileroad $tumorname
	JOB1=$(qsub fastp.sh -v var1=$fileroad,var2=$tumorname)
	JOB2=$(qsub -W depend=afterok:$JOB1 bwa-mem.sh -v var1=$fileroad,var2=$tumorname,var3=tumor)
	JOB3=$(qsub -W depend=afterok:$JOB2 sort_index.sh -v var1=$fileroad,var2=$tumorname)
	#normal flow
	#flow $fileroad $normalname
	JOB4=$(qsub -W depend=afterok:$JOB3 fastp.sh -v var1=$fileroad,var2=$normalname)
	JOB5=$(qsub -W depend=afterok:$JOB4 bwa-mem.sh -v var1=$fileroad,var2=$normalname,var3=normal)
	JOB6=$(qsub -W depend=afterok:$JOB5 sort_index.sh -v var1=$fileroad,var2=$normalname)
	#variant calling
	JOB7=$(qsub -W depend=afterok:$JOB6 variantcalling.sh -v var1=$fileroad,var2=$tumorname,var3=$normalname,var4=$filetype)
	qsub -W depend=afterok:$JOB7 vep_run.sh -v var1=$fileroad,var2=$casename
	JOB8=$(qsub -W depend=afterok:$JOB7 ./TestMuSiCa/musica_run.sh -v var1=$PWD,var2=$filetype,var3=$reftype,var4="0",var5=$fileroad)
	qsub -W depend=afterok:$JOB7 create_index_html.sh -v var1=$musica_result_folder,var2=$PWD
fi
