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
Scripts are created by 方柏翰, 鍾國洲  
README are created by 楊淯元  
#### 1. Preparation of sample  
Required files in your path:  
`test.read1.fastq` `test.read2.fastq`  
  
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
`test.read1.fastq` `test.read2.fastq`  

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

| Date              | Event                | Note                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ----------------- | -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 20.09.09          | First brain storming | 討論一些初步的想法                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| 20.09.19          | 第一次線上開會       | 確定大致方向<br>缺席：延安、宇璐                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 20.09.26          | 第一次返校開會       | 跟賴博討論：問如何找資源、問能往哪個方向。<br>`返國衛院報告`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| 20.10.04          | 第二次線上開會       | 分工：<br>方柏翰、鍾國洲：fastq->bam(until remove duplicate) pipline串接與工具說明<br>楊淯元、李祖福：ANNOVAR, VEP工具研究與VCF處理結果比較<br>曾宇璐、陳延安：相關文獻閱讀與判斷評估結果<br><br>目前方向：分兩部分<br>1. 首先建立前端pipline(fastq to remove duplicates)，編寫automated script (input data: course practice)，整理Readme檔<br>2. annotation工具比較與評估比較，以case study 去做延伸（Input data: case study vcf)；有時間再去做Variants caliing的工具比較與評估 (Input data: bam)<br><br>最後呈現：<br>1. 串接from Head to toe(automated fastq to annotation for cancer)<br>2. vcf 工具比較分析 |
| 20.10.11          | 第三次線上開會       | 淯元、祖福：vep annovar<br>國洲、柏翰：補完到vcf的pipline (可以用小的檔案測試)<br>宇璐、延安：Driven gene, ....選的工具（延安幫補）<br>賴博的建議：特定的位點->特定的用藥(paper)<br>MuSiCa (cosmic database, somatic mutation)<br>分析一些pattern，可以做參考                                                                                                                                                                                                                                                                                                                                                    |
| 20.10.18          | 第四次線上開會       | 主軸：pipeline完成整串到後面annotation結束<br>(1)這週先把前面到annovar 的部分完成<br>(2)之後再看看如何接上musica及maftools <br>補充：<br>重點可以放在最後musica, maftools等工具能達到的圖以及圖的意義，並能清楚的展示，最終目標是希望能淺顯易懂的供醫生、病人去做參考<br>缺席：賴博、柏翰                                                                                                                                                                                                                                                                                                                        |
| 20.10.25          | 第五次線上開會       | 寫ReadMe檔，將前面的流程(fastq->vcf)接到annotation，再接到musica<br>注意variants calling是要用somatic vairants calling (Tumor vs Normal)，manta->strelka (key word: tumor only somatic variant)<br>缺席：宇璐、國洲                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| 20.10.31          | 第二次返校開會       | 有進行錄影，並分配後續工作<br>淯元：投影片毛片、各進度協助<br>柏翰：vcf接到R的musica<br>國洲：新環境測試及修正、之前的README整合<br>延安、宇璐：系統測試、文獻閱讀<br>祖福：投影片美化、系統測試<br>`返國衛院報告`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| 20.11.21          | 第三次返校開會       | `返國衛院報告`                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| 20.12.03-20.12.04 | DIGI發表會           | 松菸倉庫                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |

---
## Tools & Help & References
