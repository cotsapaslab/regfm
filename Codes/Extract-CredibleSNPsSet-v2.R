###############################################################################
##################             Code Description             ###################
###############################################################################
# This code gets the results of credible interval analysis as input, and outputs 
# a data file in .Bed format that contains positions of credible interval SNPs, 
# their P values, and their R2 with the lead SNP.

print("Running Extract-CredibleSNPsSet-v2.R ....................................")


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

getCredible <- function(file) {
  print(file)
  x <- unlist(strsplit(file, ".txt"))[1]
  region <- unlist(strsplit(x, "_output_"))[2]
  leadSNP <- paste("rs", unlist(strsplit(region, "rs"))[2], sep="")
  if (leadSNP == "rsNA") {
    x1 <- unlist(strsplit(region,":"))
    chr <- paste("chr", unlist(strsplit(x1[1], "chr"))[3], sep="")
    leadSNP <- paste(chr, ":", x1[2], sep="")
  } else {chr <- unlist(strsplit(region, "rs"))[1] }
  
  
  A <- read.table(paste(cred.folder, file, sep="/"), header=T, stringsAsFactor=F)
  
  indx <- which(A[,"inCredible"] == 1)
  
  # If lead SNPs is not included in the credible set SNPs, add it to the list
  if (is.na(match(leadSNP, A[indx,"SNP"]))) {
    print(region)
    ind <- which(A[,"SNP"] == leadSNP)
    indx <- c(indx, ind)
  }
  
  D <- cbind(rep(chr, length(indx)), A[indx, c("SNP", "R2", "P", "probNorm")], rep(leadSNP, length(indx)), rep(region, length(indx)))
  colnames(D) <- c("Chr", "SNP", "R2", "P", "PPS", "leadSNP", "Region")
  
  # Identify positions of SNPs
  bim <- read.table(paste(bim.folder, "/", chr, leadSNP, ".bim", sep=""), stringsAsFactors=F)
  colnames(bim) <- c("chr", "SNP", "V3", "Pos", "A1", "A2")
  pos <- bim[match(D[,"SNP"], bim[,"SNP"]), "Pos"]
  
  D <- cbind(D[,"Chr"], pos-1, pos, D[,c("SNP", "R2", "P", "PPS", "leadSNP", "Region")])
  
  return(D)
}


###############################################################################
############        Output list of CI SNPs in Bed Format        ###############
###############################################################################
out <- lapply(as.list(files), getCredible)
rslt <- do.call(rbind, out)
colnames(rslt) <- c("Chr", "Start", "Pos", "SNP", "R2", "P", "PPS", "leadSNP", "Region")

rslt.bed <- rslt[, c("Chr", "Start", "Pos", "SNP", "leadSNP", "Region", "R2", "P", "PPS")]

write.table(rslt.bed, file=paste(Work.Dir, "/BedData/", trait.type, "/credSNPs-v2.bed", sep=""), sep="\t", quote=F, col.names=F, row.names=F, append=F)