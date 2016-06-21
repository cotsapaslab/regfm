###############################################################################
##################             Code Description             ###################
###############################################################################
# This function gets the per-chromosome DHS-gene correlation matrix, and outputs a
# subset of this matrix that includes DHS and genes overlapping a 2Mbp region. 

Subset.Crr.Pval <- function(chr, start, end, Rdata.path, Crr.Pval.PerChr.Path) {
  load(paste(Rdata.path, "/Norm-Trans-Exp.Rdata", sep=""))
  load(paste(Crr.Pval.PerChr.Path, "/Crr-pval-mat-", chr, ".Rdata", sep=""))
  dhs.info <- read.table(paste(Rdata.path, "/DHS-Data-Sorted.bed", sep=""), sep="\t", stringsAsFactors=F, header=F)
  colnames(dhs.info) <- c("chr", "dhsStart", "dhsEnd")
  
  # Select genes overlapping region of interest
  indx <- which(norm.trans.exp[, "chrom"] == chr &
                  norm.trans.exp[, "txStart"] <= end &
                  norm.trans.exp[, "txEnd"] >= start)
  exp.data <- norm.trans.exp[indx, -c(1:11)]
  rownames(exp.data) <- paste(norm.trans.exp[, "chrom"], norm.trans.exp[, "ensTrans.hugoGene"], sep="-")[indx]
  genes <- rownames(exp.data)
  
  # Select DHSs overlapping region of interest
  indx.dhs <- which(dhs.info[, "chr"] == chr & 
                      as.numeric(dhs.info[, "dhsStart"]) <= end & 
                      as.numeric(dhs.info[, "dhsEnd"]) >= start)
  dhs.ids <- paste(dhs.info[indx.dhs, "chr"], dhs.info[indx.dhs, "dhsStart"], dhs.info[indx.dhs, "dhsEnd"], sep="-")
  
  M <- matrix(chr.crr.pval.mat[dhs.ids, genes], nrow=length(dhs.ids), ncol=length(genes), dimnames=list(dhs.ids, genes))
  
  return(M)  
}