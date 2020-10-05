#!/bin/bash
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N sort_job
#PBS -q ngscourse
#PBS -o sort_index_markdup_job.std
#PBS -e sort_index_markdup_job.err
#PBS -m e

SAMBAMBA="/pkg/biology/sambamba/sambamba_v0.7.1/sambamba"
####
$SAMBAMBA sort \
-t 3 \
-m 4G \
$var1/dealed/$var2\.bam \
-o $var1/dealed/$var2\_sorted.bam;


$SAMBAMBA markdup \
-t 3 \
$var1/dealed/$var2\_sorted.bam \
$var1/dealed/$var2\_sorted_mdp.bam
#SAMBAMBA stimulously sort and index
