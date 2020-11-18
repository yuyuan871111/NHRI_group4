library(heatmaply)
a <- read.csv(file = "/home/u1397281/12.Group_study/NHRI_group4/TestMuSiCa/test_files/a.csv", row.names = 1)
colorends <- c("white","red", "white", "blue")
dendro <- "column"

#heatmap_cwc<-
  heatmaply(a, scale_fill_gradient_fun = scale_fill_gradientn(colours = colorends, limits = c(0,3)),
          dendrogram = dendro, k_row = 1, k_col = 1, column_text_angle = 45, hide_colorbar = TRUE,
          distfun = 'pearson', file = 'comparison_with_cancers.png')

#orca(heatmap_cwc, file = '/comparison_with_cancers.png')
