args <- commandArgs(TRUE)
the_path <- args[1]
#'/Users/yuyuan/Desktop/Work/DIGI/NHRI/03_Group_project/04_05Project_local_test/NHRI_group4/NHRI_report_html'
#########
a <-  read.csv(paste0(the_path,"/img/recon_files_name.txt"), header = F, sep="/")
a <- a[,ncol(a)]
b <- read.csv(paste0(the_path,"/tabletxt/recon_files_name.txt"), header = F, sep="/")
b <- b[,ncol(b)]
img_head <- '<div class="item" data-desktop-seq-no="8" data-mobile-seq-no="6"><img src="img/'
img_mid <- '" alt="Image"></div><div><p class="tm-block-right tm-text-white">'
img_tail <-  '</p>'
table_head <- '<a href="tabletxt/'
table_mid <- '" download><p class="tm-block-right">download table here: '
table_tail <- '</p></a></div><br></br>'
html_mid<-' '
for(i in 1:length(a)){
  html_mid<- paste0(html_mid,img_head, a[[i]], img_mid, a[[i]], img_tail, table_head, b[[i]], table_mid, b[[i]], table_tail)
}
html_head <-readChar(paste0(the_path,"/prepare_files/index_head.html"), file.info(paste0(the_path,"/prepare_files/index_head.html"))$size)
html_tail <-readChar(paste0(the_path,"/prepare_files/index_tail.html"), file.info(paste0(the_path,"/prepare_files/index_tail.html"))$size)
html_total <- paste0(html_head,html_mid,html_tail)

fileConn<-file(paste0(the_path,"/index.html"))
writeLines(html_total, fileConn)
close(fileConn)
