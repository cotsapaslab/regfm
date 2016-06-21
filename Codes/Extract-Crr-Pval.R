###############################################################################
##################             Code Description             ###################
###############################################################################
# This code gets the per-chromosome DHS-gene correlation matrix, and outputs a
# subset of this matrix that includes DHS and genes overlapping each 2Mbp region only.

print("Running Extract-Crr-Pval.R  ..........................................")

###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]

Rdata.path <- paste(Work.Dir, "/Rdata", sep="")
region.path <- paste(Work.Dir, "/BedData/", trait.type, "/Region-Info.bed", sep="")
Crr.Pval.PerChr.Path <- paste0(Work.Dir, "/BigData/Crr-Pval-Mat-PerChr")

source(paste0(Work.Dir, "/Codes/Subset-Crr-Pval.R"))

###############################################################################
############        Get Region Start, End, and Chromosome        ##############
###############################################################################
region.info <- read.table(region.path, sep="\t", stringsAsFactors=F, header=F)
colnames(region.info) <- c("Chr", "Start", "End", "RegionID")
rownames(region.info) <- region.info[, "RegionID"]

count <- 0
for (region in region.info[, "RegionID"]) {
  count <- count + 1
  # print(count)
  # print(region)
  
  chr <- region.info[region, "Chr"]
  start <- region.info[region, "Start"]
  end <- region.info[region, "End"]
  
  ###############################################################################
  ########        Identify DHS and Genes Overlapping Each Region        #########
  ########     and Extract a Subset of DHS-gene correlation matrix      #########
  ###############################################################################  
  crr.pval.mat <- Subset.Crr.Pval(chr, start, end, Rdata.path, Crr.Pval.PerChr.Path)
  save(crr.pval.mat, file=paste(Work.Dir, "/Rdata/", trait.type, "/Crr-Pval-Mat/Crr-Pval-Mat-", region, ".Rdata", sep=""))
}