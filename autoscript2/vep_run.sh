#!/usr/bin/sh
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N vep_anno
#PBS -q ngscourse
#PBS -o vep_anno.std 
#PBS -e vep_anno.err
input=$var1\/dealed/strelka/StrelkaSomaticAnalysis/results/variants/somatic.indels.vcf.gz
VEPPATH='/pkg/biology/Ensembl-VEP/Ensembl-VEP_v99.2'
REF_hg38_PATH='/pkg/biology/Ensembl-VEP/Ensembl-VEP_v99.2/.vep'


source $VEPPATH/env.sh
$VEPPATH/vep -i $input --vcf --species homo_sapiens --cache \
	--dir_cache $REF_hg38_PATH --offline --force_overwrite \
	-o $var1\/dealed/$var2.annotation.vcf \
	--sift b --polyphen b --ccds --uniprot --symbol --numbers --domains \
	--regulatory --canonical --protein --biotype --uniprot --tsl --appris \
	--gene_phenotype --variant_class 
