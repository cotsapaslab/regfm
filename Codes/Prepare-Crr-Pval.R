###############################################################################
##################             Code Description             ###################
###############################################################################
# For each 2Mbp risk locus, this code generates a matrix of correlation between 
# DHS clusters overlapping the locus and all genes in the genome. The output of
# this code is used by 10-Compute-RTC.R code to run permutation-based P value
# calculation.

print("Running Prepare-Crr-Pval.R  ..........................................")

###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]
Big.Data.Dir <- args[3]

region.info.path <- paste(Work.Dir, "/BedData/", trait.type, "/Region-Info.bed", sep="")
Chunk.Dir <- paste0(Big.Data.Dir, "/Full-State")
Out.Dir <- paste0(Work.Dir, "/Data/perRegion-DHS-Gene-Corr/", trait.type)

All.Chromosomes <- paste("chr", 1:22, sep="")

load(paste(Work.Dir, "/Rdata/Unique-DHS-Data.Rdata", sep=""))
load(paste(Work.Dir, "/Rdata/DHS-Data.Rdata", sep=""))

###############################################################################
######################              Step 1               ######################
###############################################################################
region.info <- read.table(region.info.path, stringsAsFactors=F, header=F, sep="\t")
colnames(region.info) <- c("Chr", "Start", "End", "Region")
all.regions <- unique(region.info[,"Region"])

for (region in all.regions) {
  # print(region)
  load(paste(Work.Dir, "/Rdata/", trait.type, "/Crr-Pval-Mat/Crr-Pval-Mat-", region, ".Rdata", sep=""))
  region.dhs <- rownames(crr.pval.mat)
  # For each DHS, build a string of binary values which has a length equal to 
  # the number of cell types. This forms the on/off patterns.
  patterns <- apply(DHS.Data[region.dhs,], 1, function(x){paste(x, collapse="-")})
  unique.patterns <- unique(patterns)
  # Identify DHS clusters that are ON in all cell types
  rm.pattern <- paste(rep(1,times=ncol(DHS.Data)), collapse="-")
  
  # For each 0/1 pattern, identify the path where the corresponding correlation 
  # P value is saved; and load the corresponding P value matrix.  
  indx <- match(unique.patterns, rownames(Unique.DHS.Data))
  find.chunk <- function(x) {return(floor((x-1)/1000) + 1)}
  chunk.numbers <- unlist(lapply(as.list(indx), find.chunk))
  
  A <- c()
  for (chunk in setdiff(unique(chunk.numbers),NA)) {
    # print(chunk)
    n1 <- (chunk-1) * 1000 + 1
    n2 <- min(nrow(Unique.DHS.Data), 1000*chunk)
    
    load(paste(Chunk.Dir, "/Crr-Pval-Mat-", n1, "-", n2, ".Rdata", sep=""))
    
    ind2 <- which(chunk.numbers == chunk)
    
    my.patterns <- rownames(Unique.DHS.Data)[indx[ind2]]
    D <- matrix(crr.pval.mat[my.patterns,], nrow=length(my.patterns), ncol=ncol(crr.pval.mat))
    rownames(D) <- my.patterns
    colnames(D) <- colnames(crr.pval.mat)
    
    A <- rbind(A, D)
  }
  
  # Remove DHS clusters that are ON in all cell types, as they produce NA correlation P values.
  rm.indx <- which(patterns[region.dhs] == rm.pattern)
  if (length(rm.indx) > 0) {
    region.crr.pval.mat <- A[as.character(patterns[region.dhs])[-rm.indx], ]
    rownames(region.crr.pval.mat) <- region.dhs[-rm.indx]
  } else {
    region.crr.pval.mat <- A[as.character(patterns[region.dhs]), ]
    rownames(region.crr.pval.mat) <- region.dhs
  }
  
  # Save the matrix of correlation between DHS clusters overlapping the locus 
  # and all genes in the genome.
  save(region.crr.pval.mat, file=paste(Out.Dir, "/Crr-pval-mat-", region, ".Rdata", sep="")) 
}