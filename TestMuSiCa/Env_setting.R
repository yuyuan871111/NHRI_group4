if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("BSgenome.Hsapiens.UCSC.hg38")
BiocManager::install("BSgenome.Hsapiens.1000genomes.hs37d5")
BiocManager::install("BSgenome.Hsapiens.UCSC.hg19")
BiocManager::install("MutationalPatterns")

install.packages('heatmaply')
install.packages('Cairo')
