# Automated WGS reporting system for cancer
> Group 4  
> Team leader: Yu-yuan Yang (楊淯元)  
> Members: (陳延安), (方柏翰), (鍾國洲), (李祖福), (曾宇璐)  
> Advisor: Chun-chi Lai (賴俊吉)  
## Email information
> 楊淯元: adp871111@gmail.com  
> 陳延安: anttony1658@gmail.com  
> 方柏翰: asd2213857@gmail.com  
> 鍾國洲: Kylab.kc.chung@gmail.com  
> 李祖福: lzf859203@gmail.com  
> 曾宇璐: yulutseng@gmail.com  
> 賴俊吉: cclai@nhri.org.tw, jjlaisnoopy@gmail.com  
## Outline
### Automated script 
Created by (方柏翰), (鍾國洲)  
#### 1. Preparation of sample  
Required files in your path:  
`test.read1.fastq` `testread2.fastq`  
  
The files are collected by NGS machine such as NovaSeq, etc. Then, it would be converted to fastq file from your company.  
Required tools should be installed into your computer:  
* bwa mem  
* fastp  
* sambamba
* manta
* freec
* strelka
* job-query-system


#### 2. Main script  
Our tool is an automated processing tool in order to convert your data from fastq to vcf with gatk tools. At the same time, we will do multiple works, like alignment, sort, mark duokicatesm, indexing, variant calling and annotation.  


##### For example:  
Our work platform: Taiwania 1.  
And your files are saved at the following path:  
`/work1/XXX123456/TXCRB/case001/`  

The fastq files in the path are required: (forward read/backward read)  
`test.read1.fastq` `teat.read2.fastq`  

Execute: please operate below command in linux terminal  
The program structures:  
(path/to/the/program/theautomatedprogramfile) (path) (filename)  
`./script.sh /work1/XXX123456/TXCRB/case001 test`  


#### 3. Results  
The script will create one folder named "dealed" and the all processed data are stored in "dealed".  




### Flowchat: Somatic variants pipline reference
![](https://i.imgur.com/IRWvbBq.png)
![](https://i.imgur.com/FhiXADT.png)
![](https://i.imgur.com/WRSy053.png)

---

## Terms explanation

---
## Team plan
### Time schedule

| Date     | Event    | Note |
| -------- | -------- | -------- |
| 20.09.09 | First brain storming | 討論一些初步的想法 |
| 20.09.19 | 第一次線上開會| 確定大致方向，缺席：延安、宇璐 |
| 20.09.26 | 第一次返校開會，跟賴博討論，找資源、能往哪個方向 | 返國衛院報告 |
| 20.10.31 | 第二次返校開會 |返國衛院報告|
| 20.11.21 | 第三次返校開會 |返國衛院報告|
| 20.12.03-20.12.04 |DIGI發表會|要去某個不是國衛院的地方|

---
## Tools & Help & References
