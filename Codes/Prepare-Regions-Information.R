###############################################################################
##################             Code Description             ###################
###############################################################################
# This codes uses the positions of lead SNPs, and outputs a file in Bed format
# that shows start and end position of each 2 Mbp region centered on the lead SNP.

print("Running Prepare-Regions-Information.R  ...............................")

###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]

cred.folder <- paste(Work.Dir, "/credible_analysis/", trait.type, "/credible_output", sep="")
bim.folder <- paste0(Work.Dir, "/Data/perRegion-1000Genome/", trait.type)

###############################################################################
##############        Read Data from Credible Set Folder        ###############
###############################################################################
files <- dir(cred.folder)

getRegion <- function(file) {
  x <- unlist(strsplit(file, ".txt"))[1]
  regionID <- unlist(strsplit(x, "_output_"))[2]
  leadSNP <- paste("rs", unlist(strsplit(regionID, "rs"))[2], sep="")
  if (leadSNP == "rsNA") {
    x1 <- unlist(strsplit(regionID,":"))
    chr <- paste("chr", unlist(strsplit(x1[1], "chr"))[3], sep="")
    leadSNP <- paste(chr, ":", x1[2], sep="")
  } else {chr <- unlist(strsplit(regionID, "rs"))[1] }
  
  # Identify positions of SNPs
  bim <- read.table(paste(bim.folder, "/", chr, leadSNP, ".bim", sep=""), stringsAsFactors=F)
  colnames(bim) <- c("chr", "SNP", "V3", "Pos", "A1", "A2")
  pos <- bim[match(leadSNP, bim[,"SNP"]), "Pos"]
  
  region <- c(chr, pos-1000000, pos+1000000, regionID)
  
  return(region)
}

###############################################################################
###########        Output Start and End of Each 2Mbp Region        ############
###############################################################################
out <- lapply(as.list(files), getRegion)
rslt <- do.call(rbind, out)
colnames(rslt) <- c("Chr", "Start", "End", "RegionID")

write.table(rslt, file=paste(Work.Dir, "/BedData/", trait.type, "/Region-Info.bed", sep=""), sep="\t", quote=F, col.names=F, row.names=F, append=F)