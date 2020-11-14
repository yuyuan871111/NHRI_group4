library(MutationalPatterns)
library(VariantAnnotation)
library(heatmaply)
library(reshape2)
library(ggplot2)
library(data.table)
library(gplots)
library(openxlsx)
library(readxl)
library(BSgenome)
library(Cairo)

#variables setting
#######################################
genome <- 'hg38'
#programfolder <- '/home/u1397281/12.Group_study/NHRI_group4/TestMuSiCa'
programfolder <- '/Users/yuyuan/Desktop/Work/DIGI/NHRI/03_Group_project/04_05Project_local_test/NHRI_group4/TestMuSiCa'
setwd(programfolder)
datafolder <-  paste0(programfolder,'/test_files')
resultfolder <- paste0(programfolder,'/results')
studytype <- 'WGS'
inFile<-data.frame(
  datapath = c(paste0(datafolder,'/TLCRC_020.hard-filtered.vcf'),
               paste0(datafolder,'/TLCRC_043.hard-filtered.vcf'),
               paste0(datafolder,'/TLCRC_047.hard-filtered.vcf')),
  name = c('TLCRC_020.hard-filtered.vcf','TLCRC_043.hard-filtered.vcf', 'TLCRC_047.hard-filtered.vcf'),
  size = c(NA,NA,NA),
  type = c(NA,NA,NA),
  stringsAsFactors = FALSE
)
#######################################
#Reference genome definition and loading [ref_genome]
#######################################
if (genome=="19"){
  ref_genome <- "BSgenome.Hsapiens.UCSC.hg19"
  library(ref_genome, character.only = TRUE)
}else if (genome=="37"){
  ref_genome <- "BSgenome.Hsapiens.1000genomes.hs37d5"
  library(ref_genome, character.only = TRUE)
}else if (genome=="hg38"){
  ref_genome <- "BSgenome.Hsapiens.UCSC.hg38"
  library(ref_genome, character.only = TRUE)
}


#######################################
#Loading testing sample file
#######################################
#filedata <- read.csv(file = inFile$datapath[[1]], header = T, sep = "\t")

#######################################
#Reading input files as GRanges objects [vcfs]
#######################################

vcfs<-read_vcfs_as_granges(inFile$datapath,inFile$name,ref_genome,group = "auto+sex", check_alleles = TRUE)

#######################################
#Mutation Matrix creation [mut_mat]
#######################################
if (genome=="19"){
  mut_mat <- mut_matrix(vcfs,"BSgenome.Hsapiens.UCSC.hg19")
}else if (genome=="37"){
  mut_mat <- mut_matrix(vcfs,"BSgenome.Hsapiens.1000genomes.hs37d5")
}else if (genome=="hg38"){
  mut_mat <- mut_matrix(vcfs,"BSgenome.Hsapiens.UCSC.hg38")
}

#######################################
#COSMIC Mutational Signatures loading (and adjustment) from COSMIC website [cancer_signatures]
#######################################
sp_url <- "http://cancer.sanger.ac.uk/cancergenome/assets/signatures_probabilities.txt"
cancer_signatures <- read.table(sp_url, sep = "\t", header = TRUE)
cancer_signatures_aux <- cancer_signatures[order(cancer_signatures[,1]),]
cancer_signatures <- as.matrix(cancer_signatures_aux[,4:33])
cancer_signatures_mut_types <- as.matrix(cancer_signatures_aux[,1:3])

#######################################
#Fitting mutations in samples (mut_mat) to COSMIC signatures [fit_res]
#######################################
fit_res <- fit_to_signatures(mut_mat, cancer_signatures)

#Auxiliar files of aetiology and known signatures by cancer type (from COSMIC)
proposed_etiology <- fread("./aux_files/proposed_etiology_COSMIC_signatures.txt",sep="\t",header=F,data.table=F)[,2]
known_cancer_signatures<-read.table("./aux_files/cancermatrix.tsv",header=TRUE,sep="\t",row.names=1)

#divisionRel function creation to print final dataframe
divisionRel<-function(df){
  sum_df<-sapply(df,sum)
  for (i in 1:ncol(df)){
    df[,i]<-round((df[,i]/sum_df[i]),3)
  }
  return(df)
}

#######################################
#Select which samples use to plot.
#######################################

if(length(inFile$name)>=2){
  mysamp<-c("All samples",colnames(as.data.frame(fit_res$contribution)))
}else{
  mysamp<-c(colnames(as.data.frame(fit_res$contribution)))
}

if ("All samples" %in% mysamp){
    aux<-divisionRel(as.data.frame(fit_res$contribution))
    con<-data.frame(aux)
    colnames(con)<-c(colnames(aux))
} else {
    aux<-divisionRel(as.data.frame(fit_res$contribution[,mysamp]))
    con<-data.frame(aux)
    colnames(con)<-colnames(aux)
}
colnames(con)<-setdiff(mysamp,c("All samples"))
my_contributions <- con

#######################################
### PLOT Somatic Mutation Prevalence (number mutations per megabase)
#######################################
#According to Alexandrov et al. 2013
if (studytype == "WGS"){
  megabases<-c(2800)
}else if (studytype == "WES"){
  megabases<-c(30)
}

#Selection of samples to plot
if ("All samples" %in% mysamp){
  mc<-data.frame(samples=names(vcfs),smp=(sapply(vcfs,length))/megabases)
} else {
  mc<-data.frame(samples=names(vcfs[mysamp]), smp=(sapply(vcfs[mysamp],length))/megabases)
}
mutation_counts<- mc

#PLOT somatic mutation prevalence (Cairo replaces gsave)
mutation_counts_new<-data.frame(samples=mutation_counts$samples,smp=round(mutation_counts$smp,1))
plot_smp<-ggplot(data=mutation_counts_new,aes(x=samples,y=smp))
CairoPNG(filename = paste0(resultfolder,'/mutation_counts_plot.png'), width = 25, height = min(2*nrow(mutation_counts_new),40), res = 300, units="cm")
plot_smp + geom_bar(stat="identity",fill="orangered2") + theme_minimal() + geom_text(aes(label=smp), size=5, position = position_stack(vjust = 0.5), colour="white") + coord_flip() + labs(x = "", y = "Somatic mutation prevalence (number of mutations per megabase)") + theme(axis.text=element_text(size=12), axis.title = element_text(size = 13, face = "bold"), panel.grid.major.y=element_blank(), panel.grid.minor.y=element_blank(), panel.grid.major.x=element_blank(), panel.grid.minor.x=element_blank())
#ggsave(paste0(resultfolder,'/mutation_counts_plot.png'),height=min(2*nrow(mutation_counts_new),40),width=25,dpi=300,units="cm")
dev.off()

#Download Table somatic mutation prevalence
mutation_counts_new<-data.frame(Sample=mutation_counts$samples,Somatic_Mutation_Prevalence=round(mutation_counts$smp,1),Number_of_Samples=length(names(vcfs)))
write.table(x = mutation_counts_new, file = paste0(resultfolder,'/mutation_counts_table.txt')
            , sep = "\t", quote=F, row.names=F)

# check whether the unwanted file exists and remove it
if (file.exists("Rplots.pdf")==TRUE){
  file.remove("Rplots.pdf")
}

#######################################
### PLOT 96 nucleotide changes profile (samples individually)
#######################################

#Plot 96 profile
aux_96_profile<-as.matrix(mut_mat[,setdiff(colnames(my_contributions),c("mean"))])
colnames(aux_96_profile)<-setdiff(colnames(my_contributions),c("mean"))
aux_ymax<-as.data.frame(aux_96_profile)
rownames(aux_ymax)<-1:96
max_ymax<-max(divisionRel(aux_ymax))
CairoPNG(filename = paste0(resultfolder,'/profile96.png'), width = 25, height = min(4*ncol(aux_96_profile),40), res = 300, units="cm")
plot_96_profile(aux_96_profile,ymax = max_ymax) + scale_y_continuous(breaks = seq(0, max_ymax, 0.05))
#ggsave(paste0(resultfolder,'/profile96.png'),height=min(4*ncol(aux_96_profile),40),width=25,dpi=300,units="cm")
dev.off()

#Download Plot 96 TABLE
aux_96_profile<-as.matrix(mut_mat[,setdiff(colnames(my_contributions),c("mean"))])
aux_ymax<-divisionRel(as.data.frame(aux_96_profile))
write.table(x = data.frame(Substitution_Type = cancer_signatures_mut_types[,1], Trinucleotide = cancer_signatures_mut_types[,2], Somatic_Mutation_Type = cancer_signatures_mut_types[,3], aux_ymax),
            file = paste0(resultfolder,'/profile96.txt'), sep = "\t", quote=F, row.names=F)

# check whether the unwanted file exists and remove it
if (file.exists("Rplots.pdf")==TRUE){
  file.remove("Rplots.pdf")
}

#######################################
###### PCA - Clustering of samples ## only if there are 3 or more samples
#######################################
my_contributions_mod <- my_contributions
if (ncol(as.data.frame(my_contributions_mod))>=3) {
  a<-t(as.data.frame(my_contributions_mod[30:1,]))
  for (i in 1:nrow(a)) {
    a[i,]<-a[i,]/sum(a[i,])   # put the proportions
  }
  a<-a[,which(apply(a,2,sd)>0)]# remove signatures without variation

  samplesnames<-rownames(a)
  rownames(a)<-1:(length(rownames(a)))

  CairoPNG(paste0(resultfolder,'/PCA_plot.png'),height=7*300,width=7*300,res=300)
  pca <- prcomp(a, scale=T)
  plot(pca$x[,1], pca$x[,2],        # x y and z axis
       col="red", pch=19,
       xlab=paste("Comp 1: ",round(pca$sdev[1]^2/sum(pca$sdev^2)*100,1),"%",sep=""),
       ylab=paste("Comp 2: ",round(pca$sdev[2]^2/sum(pca$sdev^2)*100,1),"%",sep=""),
       xlim=c(min(pca$x[,1])-0.5*(  max(pca$x[,1])-min(pca$x[,1]) ) ,max(pca$x[,1])+0.5*(  max(pca$x[,1])-min(pca$x[,1]) ) ),
       ylim=c(min(pca$x[,2])-0.5*(  max(pca$x[,2])-min(pca$x[,2]) ) ,max(pca$x[,2])+0.5*(  max(pca$x[,2])-min(pca$x[,2]) ) ),
       main="PCA")
  text(pca$x[,1], pca$x[,2]-0.15, rownames(a))
  dev.off()

  write.table(x = data.frame(ID=rownames(a),Sample=samplesnames),
              file = paste0(resultfolder,'/PCA.txt'), sep="\t",quote=F,row.names=F)
}

# check whether the unwanted file exists and remove it
if (file.exists("Rplots.pdf")==TRUE){
  file.remove("Rplots.pdf")
}

#######################################
### PLOT Reconstructed Mutational Profile
#######################################

#Plot reconstructed profile

mysamp_temp <- setdiff(mysamp,'All samples')
for (i in 1:length(mysamp_temp)){

  mysamp_rename <- strsplit(mysamp_temp[i], "\\.tsv")[[1]]
  original_prof <- mut_mat[,mysamp_temp[i]]
  reconstructed_prof <- fit_res$reconstructed[,mysamp_temp[i]]
  aux_ymax<-data.frame(original_prof,reconstructed_prof)
  max_ymax<-max(divisionRel(aux_ymax))
  CairoPNG(filename = paste0(resultfolder,'/reconstructed_table(',mysamp_rename,').png'), width = 30, height = 18, res = 300, units="cm")
  plot_com<-
    plot_compare_profiles(original_prof,reconstructed_prof,profile_names=c("Original","Reconstructed"),profile_ymax = max_ymax)
  # ggsave(plot=plot_com,paste0(resultfolder,'/reconstructed_table(',mysamp_rename,').png'),height=18,width=30,dpi=300, units = "cm")
  print(plot_com)
  dev.off()

  #Download reconstructed TABLE
  aux_ymax<-divisionRel(data.frame(Original_Profile = original_prof, Reconstructed_Profile = reconstructed_prof))
  write.table(x = data.frame(Substitution_Type = cancer_signatures_mut_types[,1], Trinucleotide = cancer_signatures_mut_types[,2], Somatic_Mutation_Type = cancer_signatures_mut_types[,3], aux_ymax),
              file = paste0(resultfolder,'/reconstructed_table(',mysamp_rename,').txt'), sep = "\t", quote=F, row.names=F)
}

# check whether the unwanted file exists and remove it
if (file.exists("Rplots.pdf")==TRUE){
  file.remove("Rplots.pdf")
}


#######################################
### Plot heatmap with contributions
#######################################

setwd(resultfolder)
#DataTable
contr<- data.frame(Signature = 1:30, Proposed_Etiology = proposed_etiology, round(my_contributions,3))
#Download Table
write.table(x = contr, file = paste0(resultfolder,'/COSMIC_sign_contributions.txt'), sep = "\t", quote=F, row.names=F)
#HeatMap
a<-my_contributions
if (ncol(a)==1) colnames(a)<-colnames(my_contributions) ## fix colnames when there is only one sample
rownames(a)<-colnames(cancer_signatures)[1:30]
colorends <- c("white","red")
dendro <- "none"
if (length(dev.list())==0){
  dev.new()
}

heatmap_sig<-
  heatmaply(a, scale_fill_gradient_fun = scale_fill_gradientn(colours = colorends, limits = c(0,1)),
          dendrogram = dendro, k_row = 1, k_col = 1, column_text_angle = 45, distfun = 'pearson', 
          plot_method = "ggplot") 
orca(heatmap_sig, file = '/signatures_plot.png')
dev.off()

# check whether the unwanted file exists and remove it
if (file.exists("Rplots.pdf")==TRUE){
  file.remove("Rplots.pdf")
}


#######################################
### PLOT - HeatMap-Comparison with other cancers
#######################################

my.sel.cancers<-colnames(known_cancer_signatures)
a<-data.frame(my_contributions[1:30,], known_cancer_signatures[1:30,my.sel.cancers])
rownames(a)<-colnames(cancer_signatures)[1:30]
if (ncol(my_contributions)==1) colnames(a)[1]<-colnames(my_contributions) ## fix colnames when there is only one sample

for (i in 1:(ncol(a)-length(my.sel.cancers))) {
  #a[,i]<-a[,i]/max(a[,i])  # don't do a rescaling
  a[,i]<-a[,i]/sum(a[,i])   # put the proportions
}
for (i in (ncol(a)-length(my.sel.cancers)+1):ncol(a)) {
  a[,i]<-a[,i]*2.5   # put the proportions   # 1 goes to 2.5 (light blue)

}

rownames(a)<-colnames(cancer_signatures)[1:30]
colorends <- c("white","red", "white", "blue")
dendro <- "column"
if (length(dev.list())==0){
  dev.new()
}
heatmap_cwc<-
  heatmaply(a, scale_fill_gradient_fun = scale_fill_gradientn(colours = colorends, limits = c(0,3)),
          dendrogram = dendro, k_row = 1, k_col = 1, column_text_angle = 45, hide_colorbar = TRUE,
          distfun = 'pearson')
orca(heatmap_cwc, file = '/comparison_with_cancers.png')
dev.off()

# check whether the unwanted file exists and remove it
if (file.exists("Rplots.pdf")==TRUE){
  file.remove("Rplots.pdf")
}


