#!/bin/bash
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N x-11-test
#PBS -q ngscourse
#PBS -o x-11-test.std
#PBS -e x-11-test.err
#PBS -m e
#PBS -M adp871111@gmail.com

~/bin/Rscript /home/u1397281/12.Group_study/NHRI_group4/TestMuSiCa/R_x11_test.R  
