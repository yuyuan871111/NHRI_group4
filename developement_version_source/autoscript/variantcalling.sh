#!/usr/bin/sh
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N variantcalling
#PBS -q ngscourse
#PBS -o variantcalling.std
#PBS -e variantcalling.err

strelka=/pkg/biology/Strelka/Strelka_v2.9.9/bin/configureStrelkaSomaticWorkflow.py
manta=/pkg/biology/Manta/Manta_v1.6.0/bin/configManta.py
fileroad=$var1
tumorname=$var2
normalname=$var3
refch38=/pkg/biology/reference/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa

mkdir $fileroad/dealed/manta
mkdir $fileroad/dealed/strelka

#run manta
cd $fileroad/dealed/manta
$manta --tumorBam $fileroad/dealed/$tumorname\_sorted_mdp.bam \
--referenceFasta $refch38 \
--exome \
--runDir MantaSomaticAnalysis

MantaSomaticAnalysis/runWorkflow.py --mode=local --jobs=16

## run strelka
cd $fileroad/dealed/strelka
$strelka \
--normalBam $fileroad/dealed/$normalname\_sorted_mdp.bam \
--tumorBam $fileroad/dealed/$tumorname\_sorted_mdp.bam \
--referenceFasta $refch38 \
--indelCandidates \
$fileroad/dealed/manta/MantaSomaticAnalysis/results/variants/candidateSmallIndels.vcf.gz \
--exome \
--runDir StrelkaSomaticAnalysis

StrelkaSomaticAnalysis/runWorkflow.py --mode=local --jobs=16

