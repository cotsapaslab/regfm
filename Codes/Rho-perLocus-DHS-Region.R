###############################################################################
##################             Code Description             ###################
###############################################################################
# This code gets the results of credible interval analysis as input, and outputs 
# a data file in .Bed format that contains positions of credible interval SNPs, 
# their P values, and their R2 with the lead SNP.

print("Running Rho-perLocus-DHS-Region.R ....................................")


###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]


region.info.path <- paste0(Work.Dir, "/BedData/", trait.type, "/Region-Info-Sorted.bed")
region.dhs.ovrlp <- paste0(Work.Dir, "/BedData/", trait.type, "/DHS-RegionInfo-Ovrlp.bed")
annot.table.path <- paste(Work.Dir, "/Tables/", trait.type, "/credSNP-DHS-Gene-Annot.txt", sep="")
output.dir <- paste0(Work.Dir, "/BedData/", trait.type, "/perLocus-DHS")

###############################################################################
#######################               Step 1              #####################
###############################################################################
region.info <- read.table(region.info.path, stringsAsFactors=F, header=F, sep="\t")
colnames(region.info) <- c("Chr", "Start", "End", "Region.ID")
rownames(region.info) <- region.info[,"Region.ID"]

annot <- read.table(annot.table.path, stringsAsFactors=F, header=T, sep="\t")
all.regions <- unique(annot[, "Region"])

df <- read.table(region.dhs.ovrlp, header=F, sep="\t", stringsAsFactors=F)
colnames(df) <- c("DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID", "Region.Chr", "Region.Start", "Region.End", "Region.ID", "Overlap")

for (region in all.regions) {
  indx <- which(df[,"Region.ID"] == region)
  
  A <- df[indx, c("DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID")]
  write.table(A, file=paste0(Work.Dir, "/BedData/", trait.type, "/perLocus-DHS/", region), col.names=F, row.names=F, sep="\t", quote=F, append=F)
  
  B <- region.info[region, c("Chr", "Start", "End")]
  write.table(B, file=paste0(Work.Dir, "/BedData/", trait.type, "/perLocus-Regions/", region), col.names=F, row.names=F, sep="\t", quote=F, append=F)
}