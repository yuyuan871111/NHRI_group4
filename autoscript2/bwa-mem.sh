#!/bin/bash
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N bwa_job
#PBS -q ngscourse
#PBS -o bwa_job.std
#PBS -e bwa_job.err
#PBS -m e

#bunzip2 $1/$2\.read1.bz2;
#bunzip2 $1/$2\.read2.bz2;

~/bin/bwa mem -t 3 \
-M \
-R '@RG\tID:test1\tSM:$var3' \
-K 10000000 \
/pkg/biology/reference/Homo_sapiens/NCBI/GRCh38/Sequence/BWAIndex/genome.fa \
$var1/dealed/$var2\.read1.fq.gz \
$var1/dealed/$var2\.read2.fq.gz \
| /pkg/biology/samblaster/samblaster_v0.1.25/samblaster -M -e \
| /pkg/biology/SAMtools/SAMtools_v1.9/bin/samtools view -Sb -o $var1/dealed/$var2\.bam
