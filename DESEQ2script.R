
#Clean the workspace
rm(list = ls())

#we donwload the gene count table
setwd("your/path/here")
genecount <- read.table(file="", sep=",", header=T)

#we download the diagnostic  table 

#we clean useless informations


#we create a col table for deseq2
genecount2 <- rbind.fill(genecount,metadata)
col <- as.data.frame(t(genecount2[nrow(genecount2),]))
col$indiv <- row.names(col)
names(col) <- c("diagnostic", "indiv")

#we run DESeq2
de <- DESeqDataSetFromMatrix(genecount, col, design= ~diagnostic )
de <- DESeq(de)
result <- results(de, alpha = 0.05, lfcThreshold = 1, independentFiltering= F)
summary(result)
res <- as.data.frame(result)

#we filter the results
res <- subset(res, res$log2FoldChange > 1 | res$log2FoldChange <(-1))
res <- subset(res, res$padj < 0.1)
res <- na.omit(res)

#graphic representation
EnhancedVolcano(result,lab = rownames(result),
                x = 'log2FoldChange',
                y = 'pvalue')