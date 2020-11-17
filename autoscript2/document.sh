#!/usr/bin/sh
#PBS -P ACD109058
#PBS -W group_list=ACD109058
#PBS -N document_deal
#PBS -o document.std
#PBS -e document.err
#PBS -q ngscourse

mkdir $var1\/dealed/document
mv *.std $var1\/dealed/document/
mv *.err $var1\/dealed/document/

