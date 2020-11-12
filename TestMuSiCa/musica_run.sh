#!/bin/bash
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N musica_job
#PBS -q ngscourse
#PBS -o musica_job.std
#PBS -e musica_job.err
#PBS -m e
#PBS -M adp871111@gmail.com

~/bin/Rscript /home/u1397281/12.Group_study/NHRI_group4/TestMuSiCa/musica_run_nchc.R  
