# Automated WGS reporting system for cancer
Group 4  
Team leader: Yu-yuan Yang (楊淯元)  
Members: (方柏翰), (鍾國洲), (李祖福), (陳延安), (曾宇璐)  
Advisor: Chun-chi Lai (賴俊吉)  
## Abstract
The automated WGS reporting system (for cancer) is based on GATK-workflow with little modification. The modified workflow was designed by our team. In order to create report automatically, our team modified codes from MuSiCa github to a new Rscript file.  

## Introduction to MuSiCa - Mutational Signatures in Cancer

Citation: [Díaz-Gay et al., BMC Bioinformatics (2018)](https://doi.org/10.1186/s12859-018-2234-y)  
Copied from [marcos-diazg/musica gituhub](https://github.com/marcos-diazg/musica):  
>MuSiCa (Mutational Signatures in Cancer) is a shiny-based web application aimed to visualize the somatic mutational profile of a series of provided samples (different formats are allowed) and to extract the contribution of the reported mutational signatures ([Alexandrov L.B. et al., Nature (2013)](http://dx.doi.org/10.1038/nature12477), [Catalogue Of Somatic Mutations In Cancer, COSMIC (2020)](http://cancer.sanger.ac.uk/cosmic/signatures)) on their variation profile. It is mainly based on the MutationalPatterns R package ([Blokzijl et al., Genome Medicine (2018)](https://doi.org/10.1186/s13073-018-0539-0)).  


## Flowchart: Somatic variants analysis pipline 
* TOOLS
![](https://i.imgur.com/0bVzRXL.png)

* DATAFLOW CONCEPT
![](https://i.imgur.com/WJWz4Sc.png)

* SCRIPT DESIGN
![](https://i.imgur.com/DtqQkFD.png)


## Mode 1: Automated script - from fastq to vcf + MuSiCa report 
Scripts are created by 方柏翰, 鍾國洲, 楊淯元  
README are created by 方柏翰, 楊淯元  

Our testing platform is NCHC-Taiwania 1. The version of reference genome is hg38.  
Most required tools are pre-installed by NCHC. Please feel free to run our reporting system.  

If you want to excute on your own laptop (Linux/Unix-based), the following tools are required. Please install all of them.  
* bwa mem  
* fastp  
* sambamba  
* manta  
* strelka  
* vep  
* job-query-system  
* musica environment  
    >Please follow steps from [MuSiCa github](https://github.com/marcos-diazg/musica) "Local version installation"
#### 1. Preparation of sample and environment setting  
With NCHC Taiwania-1 system, most of packages are well installed.  
The only thing you need to do is put file correctly.  
FILE preparation:  
>The files are collected by NGS machine such as NovaSeq, etc. Then, it would be converted to fastq file from your company.  
>Required files in your path: `normal.read1.fastq` `normal.read2.fastq` `tumor.read1.fastq` `tumor.read2.fastq`  



#### 2. Main script  
Our tool is an automated processing tool in order to convert your data from fastq to vcf with gatk tools. At the same time, we will do multiple works, like alignment, sort, mark duplicates, indexing, variant calling and annotation.  

And your files are saved at the following path:  
`/work1/XXX123456/TXCRB/case001/`  

The fastq files in the path are required: (forward read/backward read)  
`normal.read1.fastq` `normal.read2.fastq` `tumor.read1.fastq` `tumor.read2.fastq`  

How to execute program?  
Answer:  
Please change path to the program folder, then type the following command in terminal.  

* The program structures:  
    >./script.sh (data_folder_path) (tumor_data_name) (normal_data_name)  
```
cd autoscipt2
./script.sh /work1/XXX123456/TXCRB/case001 tumor normal
```


#### 3. Results  
1. The script would create a folder named "dealed" and all processed data would be stored in "dealed".  
    >Data included: tumor/normal bam file, vcf file (w/ and w/o annotation), MuSiCa results -plots&tables  
2. The MuSiCa report are compressed to "NHRI_report_html.zip" file. Plot and tables are stored in the folder "musica_result" in your working directory.   
2. In order to view the report normally, please download the file `NHRI_report_html.zip` from NCHC-Taiwania 1. After decompressing the zip file, please open "index.html" with full screen browser to view the report.  
3. If there is any problem about viewing the report, please refresh your browser first.  
4. Any other questions, please contact us.  

#### 4. Re-run programs  
If you want to do it again, it is recommanded to remove old files. Please follow the steps below. (Note that you are in `autoscript2` directory) 
```
rm *.std *.err NHRI_report_html.zip
```



## Mode 2: ONLY MuSiCa reporting system - compare multiple sample
#### 1. Preparation of sample and install program  
With NCHC Taiwania-1 system, most of packages are well installed.  

(1) FILE preparation: You need to put files correctly in your working directory or a known path.  
>The files are collected by NGS machine such as NovaSeq, etc. Then, it have been converted to vcf file with DRAGEN pipeline or GATK pipeline.  
>For example: `Cancer-case1.vcf` `Cancer-case2.vcf` `Cancer-case3.vcf` `Cancer-case4.vcf` ... etc.  
>In the path: `/work1/XXX123456/TXCRB/case001`

(2) Install program: Please download our script program, change directory to `NHRI_group4/autoscript2` folder, and make all scripts excutable.  
```
git clone https://github.com/yuyuan871111/NHRI_group4.git
cd NHRI_group4/autoscript2
chmod -R 700 *
```


#### 2. Main script  
Our tool is an automated processing tool in order to create MuSiCa report in one html file.  

Please check your files have stored in your working directory again. As the example mentioned,  
File path: `/work1/XXX123456/TXCRB/case001`  
The vcf files: 
`Cancer-case1.vcf` `Cancer-case2.vcf` `Cancer-case3.vcf` `Cancer-case4.vcf` ... etc.  

Then, type the following command in terminal to exctute programs.  
```
./script.sh musica
```
or  
```
./script.sh MuSiCa
```
The program would ask for some input parameters.  
* WGS or WES: (WGS/WES)  
    > WGS: whole genome sequencing  
    > WES: whole exome sequencing  
* Reference human genome version: (19/37/hg38)  
    > 19: UCSC GRCh37/hg19  
    > 37: 1000genomes hs37d5  
    > hg38: UCSC GRCh38/hg38  
* Data path:   
    *input* `/work1/XXX123456/TXCRB/case001`  
* Data file: you can tell the program which data you want to compare with.  
    * simple file:  
        *input* `Cancer-case1.vcf`  
    * multiple files: joining with ':'  
      *input* `Cancer-case1.vcf:Cancer-case2.vcf:Cancer-case3.vcf:Cancer-case4.vcf`  

When you see "performing musica", all program go well. You can wait for results for about 30 mins (depend on your files).  
Check whether your jobs is completed with the following command.  
```
qstat ngscourse
```
or 
```
qstat -u (username)
```

#### 3. Results  
1. The MuSiCa report are compressed to "NHRI_report_html.zip" file. Plot and tables are stored in the folder "musica_result" in your working directory.   
2. In order to view the report normally, please download the file `NHRI_report_html.zip` from NCHC-Taiwania 1. After decompressing the zip file, please open "index.html" with full screen browser to view the report.  
3. If there is any problem about viewing the report, please refresh your browser first.  
4. Any other questions, please contact us.  

#### 4. Re-run programs  
If you want to do it again, it is recommanded to remove old files. Please follow the steps below. (Note that you are in `autoscript2` directory) 
```
rm *.std *.err NHRI_report_html.zip
```


## Trouble shooting
Some R packages are needed. Please excute following codes for setting.  
* Note that only curtain version of R on Taiwania-1 could run well.  
    >PATH on Taiwania-1: `/pkg/biology/R/R_default/bin/R` (version: 3.5.2)  
```
Rscript Env_setting.R 
```
About other questions, please contact us.

---
## Tools & Help & References
![](https://i.imgur.com/IRWvbBq.png)  
![](https://i.imgur.com/FhiXADT.png)  
![](https://i.imgur.com/WRSy053.png)  