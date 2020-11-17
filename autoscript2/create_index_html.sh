#!/usr/bin/env bash
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N createhtml
#PBS -q ngscourse
#PBS -o create_html.std
#PBS -e create_html.err

from_folder=$var1
to_folder=$var2/NHRI_report_html/img
cp ${from_folder}/*.png ${to_folder}/.
ls ${to_folder}/reconstructed* > ${to_folder}/recon_files_name.txt



to_folder=$var2/NHRI_report_html/tabletxt
cp ${from_folder}/*.txt ${to_folder}/.
ls ${to_folder}/reconstructed* > ${to_folder}/recon_files_name.txt

work_folder=$var2/NHRI_report_html
Rscript $var2/create_index_html.R $work_folder
