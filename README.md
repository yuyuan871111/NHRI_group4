# Automated WGS reporting system for cancer
Group 4  
Team leader: Yu-yuan Yang (楊淯元)  
Members: (方柏翰), (鍾國洲), (李祖福), (陳延安), (曾宇璐)  
Advisor: Chun-chi Lai (賴俊吉)  
## Abstract
The automated WGS reporting system (for cancer) is based on GATK-workflow with little modification. The modified workflow was designed by our team. 

## Flowchart: Somatic variants analysis pipline 

## Main: Automated script 
Scripts are created by 方柏翰, 鍾國洲, 楊淯元  
README are created by 楊淯元  

Our work platform: Taiwania 1.  
Required tools should be installed into your computer:  
* bwa mem  
* fastp  
* sambamba  
* manta  
* freec  
* strelka  
* job-query-system  
* musica-env
#### 1. Preparation of sample and environment setting  
Enviroment setting:  
>1. Download miniconda:   
```
wget https://repo.anaconda.com/miniconda/Miniconda3-latestLinux-x86_64.sh
```  
>2. Install miniconda:  
```
bash ./Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc
```  
>3. Environment setting  
```
conda env create -f musica_env.yml
conda activate musica
``` 
>4. R packages setting  
```
Rscript Env_setting.R 
```
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
(path/to/the/program/theautomatedprogramfile) (path) (filename)  
```
./script.sh /work1/XXX123456/TXCRB/case001 test
```


#### 3. Results  
The script will create one folder named "dealed" and the all processed data are stored in "dealed".  




---
## Tools & Help & References
![](https://i.imgur.com/IRWvbBq.png)  
![](https://i.imgur.com/FhiXADT.png)  
![](https://i.imgur.com/WRSy053.png)  