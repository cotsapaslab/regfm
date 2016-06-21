###############################################################################
##################             Code Description             ###################
###############################################################################
# This code gets the P value of correlation between DHS and genes (which is 
# obtained by Wilcox Rank Sum test, after adjusting for the correlation structure
# of the gene expression data), and reduces inflation in the P values further
# by using permutations.

print("Running Compute-RTC-Pvalue.R  ........................................")

###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]
Big.Data.Dir <- args[3]

region.info.path <- paste(Work.Dir, "/BedData/", trait.type, "/Region-Info.bed", sep="")
annot.table.path <- paste(Work.Dir, "/Tables/", trait.type, "/credSNP-DHS-Gene-Annot.txt", sep="")
Out.Dir <- paste0(Work.Dir, "/Data/perRegion-DHS-Gene-Corr/", trait.type)

load(paste(Work.Dir, "/Rdata/Norm-Trans-Exp.Rdata", sep=""))
load(paste(Work.Dir, "/Rdata/DHS-Data.Rdata", sep=""))

All.Chromosomes <- paste("chr", 1:22, sep="")

perm=10000

library("gap")
library("ggplot2")

###############################################################################
######################              Step 1               ######################
###############################################################################
annot <- read.table(annot.table.path, stringsAsFactors=F, header=T, sep="\t")
all.regions <- unique(annot[, "Region"])

RTC.Pvalue <- list()
for (region in all.regions) {
  # print(region)
  
  load(paste(Work.Dir, "/Rdata/", trait.type, "/Crr-Pval-Mat/Crr-Pval-Mat-", region, ".Rdata", sep="")) # Load the DxG1 matrix; where D is the number of DHS clusters and G1 is the number of genes overlapping each 2Mbp locus.  
  load(paste(Out.Dir, "/Crr-pval-mat-", region, ".Rdata", sep="")) # Load the DxG2 matrix; where D is the number of DHS clusters overlapping each 2Mbp locus, and G2 is the number of genes in the genome.
  
  if (ncol(crr.pval.mat) > 0) {
    # remove DHS clusters that have NA correlation P values
    rm.indx <- which(is.na(crr.pval.mat[,1]))
    if (length(rm.indx) > 0) {      
      tss.dhs <- rownames(crr.pval.mat)[rm.indx]
      crr.pval.mat <- matrix(crr.pval.mat[-rm.indx,], nrow=(nrow(crr.pval.mat)-length(rm.indx)), ncol=ncol(crr.pval.mat), dimnames=list(rownames(crr.pval.mat)[-rm.indx], colnames(crr.pval.mat)))    
    } else {tss.dhs <- NULL}
    
    region.genes <- colnames(crr.pval.mat) 
    burdened.dhs <- setdiff(unique(annot[which(annot[,"Region"] == region), "DHS.ID"]), tss.dhs)  
    region.dhs <- unique(c(burdened.dhs, setdiff(rownames(crr.pval.mat), tss.dhs)))
    
    ###############################################################################
    ####   Compute Observed and Expected Normalized Rank of Each DHS Cluster   ####
    ###############################################################################
    # Randomly select 10000 genes from the genome, and extract P value of correlation between each DHS cluster in the region and all of the genes selected randomly.  
    random.genes <- colnames(region.crr.pval.mat)[sample.int(ncol(region.crr.pval.mat), perm, replace=FALSE)]
    # Obtain the normal test statistics corresponding to P values of correlation between each DHS cluster in the region and the 10000 genes selected randomly.
    Z.Mat.Null <- apply(region.crr.pval.mat[,random.genes], 2, function(x) {qnorm(1-x)})
    # For each random gene, rank all DHS clusters in the region. This builds a vector of the EXPECTED (NULL) normalized rank for each DHS cluster.
    RTC.Mat.Null <- apply(Z.Mat.Null, 2, function(x) {rank(x)/length(x)})
    
    # Obtain the normal test statistics corresponding to P values of correlation between each pair of DHS cluster and gene in the region.
    if (length(region.genes) > 1) {
      Z.Mat <- apply(region.crr.pval.mat[,region.genes], 2, function(x) {qnorm(1-x)}) 
    } else {
      Z.Mat <- matrix(qnorm(1-region.crr.pval.mat[,region.genes]), ncol=1, nrow=nrow(region.crr.pval.mat))
      rownames(Z.Mat) <- rownames(region.crr.pval.mat)
      colnames(Z.Mat) <- region.genes
    }
    # For each gene in the region, rank all DHS clusters. This builds a vector of the OBSERVED normalized rank for each DHS cluster in the region.
    RTC.Mat <- apply(Z.Mat, 2, function(x) {rank(x)/length(x)})
    
    ###############################################################################
    ###########            Compute Permutation-Based P Value            ###########
    ###############################################################################
    # Compute permutation-based P value of correlation between DHS-gene pairs in the region, by comparing NULL and the OBSERVED normalized ranks for each DHS cluster.
    compute.RTC.Pvalue <- function(ref.dhs, ref.genes, ref.mat) {
      func1 <- function(dhs) {    
        func2 <- function(gene) {
          return((1+sum(RTC.Mat.Null[dhs, ] >= ref.mat[dhs, gene]))/(1+ncol(RTC.Mat.Null)))
        }
        v <- unlist(lapply(as.list(ref.genes), func2))
        names(v) <- ref.genes
        return(v)
      }
      out <- lapply(as.list(ref.dhs), func1)
      names(out) <- ref.dhs
      X <- do.call(rbind, out)
      return(X)
    }
    
    RTC.Pvalue[[region]] <- compute.RTC.Pvalue(burdened.dhs, region.genes, RTC.Mat)
  }
}

save(RTC.Pvalue, file=paste(Work.Dir, "/Rdata/", trait.type, "/RTC-Pvalue.Rdata", sep=""))