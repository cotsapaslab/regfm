###############################################################################
##################             Code Description             ###################
###############################################################################
# This code annotates candidate DHS clusters that overlap CI SNPs, and the genes
# these prioritized DHS clusters are correlated to.

print("Running credSNPs-DHS-Extn-CrrGene-Annot.R  ..........................")

###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]

path.to.Table2 <- paste(Work.Dir, "/BedData/", trait.type, "/credSNP-DHS-Ovrlp.bed", sep="")
region.path <- paste(Work.Dir, "/BedData/", trait.type, "/Region-Info.bed", sep="")

load(paste(Work.Dir, "/Rdata/Norm-Trans-Exp.Rdata", sep=""))
load(paste(Work.Dir, "/Rdata/DHS-Data-Extn.Rdata", sep=""))

DHS.Data <- DHS.Broad.Data

All.Cells <- colnames(DHS.Data)

library("e1071")
library("gplots")

###############################################################################
######################              Step 1               ######################
###############################################################################
# Extract information regarding disease loci boundaries
region.info <- read.table(region.path, sep="\t", stringsAsFactors=F, header=F)
colnames(region.info) <- c("Chr", "Start", "End", "RegionID")
rownames(region.info) <- region.info[, "RegionID"]
All.Regions <- region.info[, "RegionID"]

# Extract DHS clusters that are overlapping CI SNPs
Table2 <- read.table(path.to.Table2, sep="\t", header=F, stringsAsFactors=F)
colnames(Table2) <- c("Chr", "Start", "Pos", "SNP", "leadSNP", "Region", "R2", "P", "DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID", "Overlap")

###############################################################################
######################              Step 2               ######################
###############################################################################
burdened.DHSs <- target.genes <- all.genes <- genes.pval <- target.transcripts <- c()
for (region in All.Regions) {
  # Load gene-DHS correlation data
  load(paste(Work.Dir, "/Rdata/", trait.type, "/Crr-Pval-Mat/Crr-Pval-Mat-", region, ".Rdata", sep=""))  
  log.p.mat <- -log10(crr.pval.mat)
  if (!is.matrix(log.p.mat)) {print("Error")}
  
  if(is.matrix(log.p.mat)) {
    indx <- which(Table2[,"Region"] == region)
    srt.dhs <- Table2[indx, "DHS.ID"]
    
    if (length(srt.dhs) > 0) {
      all.genes <- c(all.genes, colnames(log.p.mat))
      burdened.DHSs <- c(burdened.DHSs, srt.dhs)
      
      # Identify IDs of the genes correlated to candidate DHS clusters
      target.genes <- c(target.genes, lapply(as.list(srt.dhs), function(dhs) {
        y <- log.p.mat[dhs, ]; z<-names(y[which(y >= -log10(0.05))]);  return(unlist(lapply(as.list(z), function(x){paste(unlist(strsplit(x, "-"))[-c(1:2)], collapse="-")})))
      }))
      
      # Identify transcript IDs of the genes correlated to candidate DHS clusters
      target.transcripts <- c(target.transcripts, lapply(as.list(srt.dhs), function(dhs) {
        y <- log.p.mat[dhs, ]; z<-names(y[which(y >= -log10(0.05))]);  return(unlist(lapply(as.list(z), function(x){unlist(strsplit(x, "-"))[2]})))
      }))
      
      # Identify P value of genes correlated to candidate DHS clusters
      genes.pval <- c(genes.pval, lapply(as.list(srt.dhs), function(dhs) {
        y <- log.p.mat[dhs, ]; z<-names(y[which(y >= -log10(0.05))]);  return(10^(-log.p.mat[dhs, z]))
      }))      
    }
  } else {print(paste0("ERROR..........: ", region))}
}
names(target.genes) <- names(target.transcripts) <- names(genes.pval) <- burdened.DHSs


# Make an annotation matrix containing information for prioritized CI SNPs, their LD with the lead SNPs, the DHS clusters they are located on, and the genes correlated to the prioritized DHS clusters.
X <- c()
for (dhs in burdened.DHSs) {
  genes <- target.genes[[dhs]]
  transcripts <- target.transcripts[[dhs]]
  p <- genes.pval[[dhs]]  
  if (is.null(genes)) {
    X <- rbind(X, c(dhs, NA, NA, NA))
  } else {
    U <- cbind(rep(dhs, times=length(genes)), genes, transcripts, p)
    X <- rbind(X, U)
  }
}
colnames(X) <- c("DHS.ID", "Corr.Genes", "Transcripts", "Crr.Pvalue")

df1 <- as.data.frame(Table2[,-ncol(Table2)])
df2 <- as.data.frame(X)
df <- merge(df1, df2)

my.table <- unique(df[,c("Chr", "Pos", "SNP", "leadSNP", "Region", "R2", "P", "DHS.Start", "DHS.End", "DHS.ID", "Corr.Genes", "Transcripts", "Crr.Pvalue")])

write.table(my.table, file=paste(Work.Dir, "/Tables/", trait.type, "/credSNP-DHS-Gene-Annot.xls", sep=""), sep="\t", col.names=T, row.names=F, quote=F, append=F)

write.table(my.table, file=paste(Work.Dir, "/Tables/", trait.type, "/credSNP-DHS-Gene-Annot.txt", sep=""), sep="\t", col.names=T, row.names=F, quote=F, append=F)