#!/usr/bin/sh
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N fastp
#PBS -q ngscourse
#PBS -o fastp.std
#PBS -e fastp.err

if [ -f "$var1/${var2}.read1.fastq" ];
then
	/pkg/biology/fastp/fastp_v0.20.0/fastp -w 16 -i $var1/${var2}.read1.fastq \
	-I $var1/${var2}.read2.fastq \
	-o $var1/dealed/${var2}.read1.fq.gz \
	-O $var1/dealed/${var2}.read2.fq.gz

elif [ -f "$var1/${var2}.read1.fastq.gz" ];
then      
	/pkg/biology/fastp/fastp_v0.20.0/fastp -w 16 -i $var1/${var2}.read1.fastq.gz \
	-I $var1/${var2}.read2.fastq.gz \
	-o $var1/dealed/${var2}.read1.fq.gz \
	-O $var1/dealed/${var2}.read2.fq.gz
fi
