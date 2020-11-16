#HELP: python3 vcf2tsv.py TLCRC_020.hard-filtered_vep.annotation.vcf
import sys
file_name = sys.argv[1]

#Whole script
import pandas as pd
import allel
df = allel.vcf_to_dataframe(file_name, fields='variants/*')
df_tsv = df[['CHROM', 'POS', 'REF','ALT_1']]
df_tsv.columns = ['CHROM', 'POS', 'REF','ALT']
file_name_tsv = file_name.split(sep = '.vcf')[0]+'.tsv'
df_tsv.to_csv(file_name_tsv,sep='\t', index=False)