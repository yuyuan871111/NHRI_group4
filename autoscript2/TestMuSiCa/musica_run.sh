#!/bin/bash
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N musica_job
#PBS -q ngscourse
#PBS -o musica_job.std
#PBS -e musica_job.err
#PBS -m e


Rscript=/pkg/biology/R/R_default/bin/Rscript
musica=$var1/TestMuSiCa/musica_run_nchc.R
envfile=$var1/TestMuSiCa/Env_setting.R
filetype=$var2
reftype=$var3
model=$var4
if [ "$model" == "0" ];
then
	echo "Program connection model"
	gunzip -c $var5/dealed/strelka/StrelkaSomaticAnalysis/results/variants/somatic.indels.vcf.gz \
	> $var5/dealed/strelka/StrelkaSomaticAnalysis/results/variants/somatic.indels.vcf.gz 
	datafolder=$var5/dealed/strelka/StrelkaSomaticAnalysis/results/variants
	cases=somatic.indels.vcf
	resultfolder=$var5/dealed/musica_result
else
	echo "Just using musica"
	datafolder=$var5
	cases=$var6
	echo $var6
	mkdir $var5/musica_result
	resultfolder=$var5/musica_result
fi
programfolder=$var1/TestMuSiCa
echo $programfolder
$Rscript $envfile
$Rscript $musica $filetype $reftype $datafolder $cases $programfolder $resultfolder
