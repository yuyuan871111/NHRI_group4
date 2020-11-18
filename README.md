# Automated WGS reporting system for cancer
Group 4  
Team leader: Yu-yuan Yang (楊淯元)  
Members: (方柏翰), (鍾國洲), (李祖福), (陳延安), (曾宇璐)  
Advisor: Chun-chi Lai (賴俊吉)  
## Abstract
The automated WGS reporting system (for cancer) is based on GATK-workflow with little modification. The modified workflow was designed by our team. 

## Flowchart: Somatic variants analysis pipline 
* TOOLS
![](https://i.imgur.com/0bVzRXL.png)

* DATAFLOW concept
![](https://i.imgur.com/WJWz4Sc.png)

* SCRIPT DESIGN
![](https://i.imgur.com/DtqQkFD.png)


## Main: Automated script 
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
>Required files in your path: `test.read1.fastq` `test.read2.fastq`   



#### 2. Main script  
Our tool is an automated processing tool in order to convert your data from fastq to vcf with gatk tools. At the same time, we will do multiple works, like alignment, sort, mark duplicates, indexing, variant calling and annotation.  

And your files are saved at the following path:  
`/work1/XXX123456/TXCRB/case001/`  

The fastq files in the path are required: (forward read/backward read)  
`test.read1.fastq` `test.read2.fastq`  

Execute: please operate below command in linux terminal  
The program structures:  
(path/to/the/program/file/script.sh) (path) (filename)  
```
./script.sh /work1/XXX123456/TXCRB/case001 test
```


#### 3. Results  
1. The script would create a folder named "dealed" and all processed data would be stored in "dealed".  
    >Data included: tumor/normal bam file, vcf file (w/ and w/o annotation), MuSiCa results -plots&tables  
2. The MuSiCa report are stored in "NHRI_report_html" folder.
    >In order to view the report normally, please download the whole folder "NHRI_report_html" and open "index.html" with full screen browser.  
    >
    >If there is any problem about viewing report, please refresh first.   
    >Or, please contact us.

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