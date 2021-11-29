#!/usr/bin/Rscript --slave

#we download the packages
list.of.packages <- c("FactoMineR", "factoextra")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)){
    install.packages(new.packages)
}
if(!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("EnhancedVolcano")

library(DESeq2)
library(FactoMineR)
library(factoextra)
library(EnhancedVolcano)

args <- commandArgs(T)
counts <- args[1]
typedata <- args[2]

###we construct a gene count table and a metadata table
genecount <- read.table(counts, skip = 1, header =TRUE, sep ='\t')
metadata <- read.table(typedata, header =F, sep =';')
names(metadata) <- c( "indiv","Group")
metadata$indiv <- paste(metadata$indiv, "bam", sep = ".")
rownames(genecount) <- genecount$Geneid
rownames(metadata) <- metadata$indiv
genecount <- genecount[,-(1:6)]
genecount <- as.data.frame(t(genecount))
genecount <- merge(genecount, metadata, by="row.names")
rownames(genecount) <- genecount[,1]
genecount <- genecount[,-c(1,length(genecount)-1)]

###PCA

#we run the PCA
pdf("variables.pdf")
resPCA <- PCA(genecount[ , ! colnames(genecount) %in% c("Group")], scale.unit = TRUE, ncp = 5, graph = TRUE)
dev.off()
pdf("individuals.pdf")
fviz_pca_ind (resPCA,label="none",habillage= as.factor(genecount$Group), addEllipses = T, pointsize=5) + theme( axis.title = element_text(size = 15),axis.text = element_text(size = 15))
dev.off()

###DESeq

#we adjust the genecount table
genecount <- genecount[ , ! colnames(genecount) %in% c("Group")]
genecount <- as.data.frame(t(genecount))


#we run DESeq2
de <- DESeqDataSetFromMatrix(genecount, metadata, design= ~Group )
de <- DESeq(de)
result <- results(de, alpha = 0.05, lfcThreshold = 1)
summary(result)
res1 <- as.data.frame(result)
write.csv(res1, "restot.csv")

#we filter the results
res <- subset(res1, res1$log2FoldChange > 1 | res1$log2FoldChange <(-1))
res <- subset(res, res$padj < 0.05)
res <- na.omit(res)
write.csv(res, "res.csv")

#graphic representation
pdf("volcanoplot.pdf")
EnhancedVolcano(result,lab = rownames(result),
                x = 'log2FoldChange',
                y = 'pvalue')
dev.off()
