#!/usr/bin/sh
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N variantcalling
#PBS -q ngscourse
#PBS -o variantcalling.std
#PBS -e variantcalling.err
strelka=/pkg/biology/Strelka/Strelka_v2.9.9/bin/configureStrelkaGermlineWorkflow.py
manta=/pkg/biology/Manta/Manta_v1.6.0/bin/configManta.py
freec=/pkg/biology/FREEC/FREEC_v11.5/freec
fileroad=$var1
filename=$var2
refch38=/pkg/biology/reference/Homo_sapiens/NCBI/GRCh38/Sequence/WholeGenomeFasta/genome.fa

mkdir $fileroad/dealed/manta
mkdir $fileroad/dealed/strelka
mkdir $fileroad/dealed/freec
cd $fileroad/dealed/manta
$manta --bam $fileroad/dealed/$filename\_sorted_mdp.bam \
--referenceFasta $refch38

MantaWorkflow/runWorkflow.py --mode=local --jobs=16

## run strelka
cd $fileroad/dealed/strelka
$strelka \
--bam $fileroad/dealed/$filename\_sorted_mdp.bam \
--referenceFasta $refch38

StrelkaGermlineWorkflow/runWorkflow.py --mode=local --jobs=16

## run freec
cd $fileroad/dealed/freec
$freec -conf $fileroad/dealed/freec/freec_config.txt

mkdir $fileroad\/dealed/document
mv *.std $fileroad\/dealed/document/
mv *.err $fileroad\/dealed/document/

