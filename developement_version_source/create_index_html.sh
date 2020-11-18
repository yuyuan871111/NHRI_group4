#!/usr/bin/env bash

from_folder='/Users/yuyuan/Desktop/Work/DIGI/NHRI/03_Group_project/04_05Project_local_test/NCHC_test_musica'
to_folder='/Users/yuyuan/Desktop/Work/DIGI/NHRI/03_Group_project/04_05Project_local_test/NHRI_group4/developement_version_source/NHRI_report_html/img'
cp ${from_folder}/*.png ${to_folder}/.
ls ${to_folder}/reconstructed* > ${to_folder}/recon_files_name.txt



to_folder='/Users/yuyuan/Desktop/Work/DIGI/NHRI/03_Group_project/04_05Project_local_test/NHRI_group4/developement_version_source/NHRI_report_html/tabletxt'
cp ${from_folder}/*.txt ${to_folder}/.
ls ${to_folder}/reconstructed* > ${to_folder}/recon_files_name.txt

work_folder='/Users/yuyuan/Desktop/Work/DIGI/NHRI/03_Group_project/04_05Project_local_test/NHRI_group4/developement_version_source/NHRI_report_html'
Rscript create_index_html.R $work_folder