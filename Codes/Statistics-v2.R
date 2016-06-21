###############################################################################
##################             Code Description             ###################
###############################################################################
# This code reports statistics for CI SNPs, DHS clusters and genes.

print("Running Statistics-v2.R  .............................................")

###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]

path.to.table <- paste0(Work.Dir, "/Tables/", trait.type, "/Posterior-Probability-", trait.type, ".txt")
snps.path <- paste0(Work.Dir, "/BedData/", trait.type, "/allSNPs.bed")
region.info.path <- paste0(Work.Dir, "/BedData/", trait.type, "/Region-Info.bed")
cred.dhs.ovrlp.path <- paste0(Work.Dir, "/BedData/", trait.type, "/credSNP-DHS-Ovrlp.bed")
allSNPs.dhs.ovrlp.path <- paste0(Work.Dir, "/BedData/", trait.type, "/allSNP-DHS-Ovrlp.bed")
genecode.bed.path <- paste0(Work.Dir, "/BedData/Genecode-Sorted.bed")
final.table.path <- paste0(Work.Dir, "/Tables/", trait.type, "/PP-ClosestVsDIGs-", trait.type, ".txt")
credSNP.path <- paste(Work.Dir, "/BedData/", trait.type, "/credSNPs-Sorted.bed", sep="")

cred.dir <- paste0(Work.Dir, "/credible_analysis/", trait.type, "/credible_output")
Result <- read.table(path.to.table, sep="\t", stringsAsFactors=F, header=T)
load(paste(Work.Dir, "/Rdata/Norm-Trans-Exp.Rdata", sep=""))

crr.pval.dir <- paste0(Work.Dir, "/Rdata/", trait.type, "/Crr-Pval-Mat")

Final.Table <- read.table(final.table.path, sep="\t", stringsAsFactors=F, header=T)
all.regions <- Final.Table[,"Region"]

###############################################################################
##################              SNPs Statistics             ###################
###############################################################################
region.info <- read.table(region.info.path, sep="\t", stringsAsFactors=F, header=F)
colnames(region.info) <- c("Chr", "Start", "End", "Region")
rownames(region.info) <- region.info[,"Region"]

cred.dhs.ovrlp <- read.table(cred.dhs.ovrlp.path, sep="\t", stringsAsFactors=F, header=F)
colnames(cred.dhs.ovrlp) <- c("Chr", "V2", "Pos", "SNP", "leadSNP", "Region", "V7", "V8", "DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID", "Overlap")

allSNP.dhs.ovrlp <- read.table(allSNPs.dhs.ovrlp.path, sep="\t", stringsAsFactors=F, header=F)
colnames(allSNP.dhs.ovrlp) <- c("Chr", "V2", "Pos", "SNP", "P", "DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID", "Overlap")
indx <- which(duplicated(allSNP.dhs.ovrlp[,"DHS.ID"])==F)
My.DHSs <- allSNP.dhs.ovrlp[indx, c("DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID")]

all.snps <- read.table(snps.path, stringsAsFactors=F, sep="\t")
colnames(all.snps) <- c("Chr", "V2", "Pos", "SNP", "P")

# Read genecode annotation data
# genecode.table <- read.table(genecode.comp.path, sep="\t", stringsAsFactors=FALSE)
# dim(genecode.table) # 167536     15
# colnames(genecode.table) <- c("transcript_id", "chrom", "strand", "txStart",
#                               "txEnd", "cdsStart", "cdsEnd", "exonCount",
#                               "exonStarts", "exonEnds", "id", "gene_id",
#                               "cdsStartStat", "cdsEndStat", "exonFrames")
# 
# ensTrans <- unlist(lapply(as.list(genecode.table[, "transcript_id"]), function(x) {
#   return(unlist(strsplit(x, "\\."))[1])} ))
# ensTrans.hugoGene <- paste(ensTrans, genecode.table[, "gene_id"], sep="-")
# # genecode.data <- cbind(genecode.table[,c("chrom", "txStart", "txEnd")], ensTrans.hugoGene)
# genecode.data <- genecode.table[,c("chrom", "txStart", "txEnd", "gene_id")]
# colnames(genecode.data) <- c("Chr", "Start", "End", "Gene.ID")

genecode.table <- read.table(genecode.bed.path, sep="\t", stringsAsFactors=F, header=F)
colnames(genecode.table) <- c("Chr", "Start", "End", "gene_id", "V5")
gene.id <- mapply(function(x) {paste(unlist(strsplit(x,"-"))[-c(1,2)], collapse="-")}, genecode.table[,"gene_id"])
genecode.data <- cbind(genecode.table[,1:3], gene.id)

num.snps <- num.CI.snps <- num.cred.onDHS <- Num.DHS <- Num.Gene <- num.burdened.dhs <- Num.DHS.withSNP <- prop.withSNP.DHSs <- Num.genecode.genes <- ratio.genecode.tested <- c()
for (region in all.regions) {
  # print(region)
  
  ###############################################################################
  # Number of SNPs
  start <- region.info[region, "Start"]
  end <- region.info[region, "End"]  
  num.snps[region] <- length(which(all.snps[,"Pos"] >= start & all.snps[,"Pos"] <= end))
  
  ###############################################################################
  # Number of credible SNPs
  cred.path <- paste0(cred.dir, "/credible_output_", region, ".txt")
  cred.data <- read.table(cred.path, sep="\t", header=T, stringsAsFactors=F)
  num.CI.snps[region] <- length(which(cred.data[,"inCredible"] == 1))
  
  ###############################################################################
  # Number of Burdened DHSs
  indx <- which(cred.dhs.ovrlp[,"Region"] == region)
  num.cred.onDHS[region] <- length(unique(cred.dhs.ovrlp[indx, "SNP"]))
  num.burdened.dhs[region] <- length(unique(cred.dhs.ovrlp[indx, "DHS.ID"]))
  
  ###############################################################################
  # Number of DHSs and Genes Per Locus  
  load(paste(crr.pval.dir, "/Crr-Pval-Mat-", region, ".Rdata", sep=""))
  if (is.null(dim(crr.pval.mat))) {
    Num.DHS[region] <- length(crr.pval.mat)
    Num.Gene[region] <- 1
  } else {
    Num.DHS[region] <- nrow(crr.pval.mat)
    Num.Gene[region] <- ncol(crr.pval.mat)
  }
  
  ###############################################################################
  # Number of DHSs with at least one SNP on them
  region.start <- region.info[region, "Start"]
  region.end <- region.info[region, "End"]
  region.chr <- region.info[region, "Chr"]
  Num.DHS.withSNP[region] <- length(which(My.DHSs[,"DHS.Chr"] == region.chr & My.DHSs[,"DHS.Start"] <= region.end & My.DHSs[,"DHS.End"] >= region.start))
  
  indx <- which(genecode.data[,"Chr"] == region.chr & genecode.data[,"Start"] <= region.end & genecode.data[,"End"] >= region.start)  
  Num.genecode.genes[region] <- length(unique(genecode.data[indx,"Gene.ID"]))
  
  ratio.genecode.tested[region] <- round(Num.genecode.genes[region]/Num.Gene[region],2)
  
  ###############################################################################
  # Proportion of DHSs with at least one SNP
  prop.withSNP.DHSs[region] <- round(Num.DHS.withSNP[region]/Num.DHS[region],2)
  
}

Output <- cbind(Num.SNPs=num.snps, CI.Size=num.CI.snps, Num.Cred.onDHS=num.cred.onDHS, Num.DHS=Num.DHS, Num.Burdened.DHSs=num.burdened.dhs, Num.DHS.withSNP=Num.DHS.withSNP, prop.withSNP.DHSs=prop.withSNP.DHSs, Num.Tested.Gene=Num.Gene, Num.Genecode.Genes=Num.genecode.genes, Genecode.Tested.Ratio=ratio.genecode.tested)

Out.Table <- cbind(Final.Table, Output)

write.table(Out.Table, file=paste0(Work.Dir, "/Tables/", trait.type, "/PP-FullTable-", trait.type, ".xls"), sep="\t", quote=F, col.names=T, row.names=F)
write.table(Out.Table, file=paste0(Work.Dir, "/Tables/", trait.type, "/PP-FullTable-", trait.type, ".txt"), sep="\t", quote=F, col.names=T, row.names=F)




###############################################################################
####################         Statistics for SNPs         ######################
###############################################################################
# print(".......................   Statistics for SNPs   .........................")
# Number of Disease Loci and Lead SNPs
region.info <- read.table(region.info.path, stringsAsFactors=F, header=F, sep="\t")
colnames(region.info) <- c("Chr", "Start", "End", "Region")
print(paste("Number of disease loci is", length(unique(region.info[,"Region"]))))
print(paste("Number of lead SNPs is", length(unique(region.info[,"Region"]))))

# Number of MS Credible SNPs
credSNP.data <- read.table(credSNP.path, stringsAsFactors=F, header=F, sep="\t")
colnames(credSNP.data) <- c("Chr", "Start", "Pos", "SNP", "leadSNP", "Region", "R2", "P")
print(paste("Number of credible SNPs is", length(unique(credSNP.data[,"SNP"]))))
print("Summary of number of credible SNPs per locus is")
print(summary(as.numeric(table(credSNP.data[,"leadSNP"]))))

"Number of credible SNPs located on DHSs"
ovrlp.data <- read.table(cred.dhs.ovrlp.path, sep="\t", header=F, stringsAsFactors=F)
colnames(ovrlp.data) <- c("Chr", "Start", "Pos", "SNP", "leadSNP", "Region", "R2", "P", "DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID", "Overlap")

print(paste("Number of credible SNPs located on DHSs is", length(unique(ovrlp.data[,"SNP"]))))
indx <- which(apply(ovrlp.data, 1, function(x) {x["SNP"] == x["leadSNP"]})==TRUE)
print(paste("Number of lead SNPs located on DHSs", length(unique(ovrlp.data[indx, "SNP"]))))

cat("\n\n")


###############################################################################
####################         Statistics for DHSs         ######################
###############################################################################
print(".......................   Statistics for DHSs   .........................")
# Number of DHSs and Genes Per Locus
Num.Gene <- Num.DHS <- c()
for (region in region.info[, "Region"]) {
  load(paste(crr.pval.dir, "/Crr-Pval-Mat-", region, ".Rdata", sep=""))
  if (is.null(dim(crr.pval.mat))) {
    Num.DHS[region] <- length(crr.pval.mat)
    Num.Gene[region] <- 1
  } else {
    Num.DHS[region] <- nrow(crr.pval.mat)
    Num.Gene[region] <- ncol(crr.pval.mat)
  }
}

print(paste("Total number of DHSs overlapping risk loci is", sum(Num.DHS)))
print("Summary of number of DHSs overlapping risk loci per locus is")
print(summary(Num.DHS))

# Number of Burdened DHSs (Total and Per Locus)
print(paste("Total number of burdened DHSs is", length(unique(ovrlp.data[,"DHS.ID"]))))
num.burd.dhs.per.locus <- c()
for (region in region.info[, "Region"]) {
  indx <- which(ovrlp.data[,"Region"] == region)
  if (length(indx) == 0) {
    num.burd.dhs.per.locus[region] <- 0
  } else {
    num.burd.dhs.per.locus[region] <- length(unique(ovrlp.data[indx, "DHS.ID"]))
  }
}

indx.burdened <- which(num.burd.dhs.per.locus > 0)
burdened.loci <- names(num.burd.dhs.per.locus)[indx.burdened]
print(paste("Number of loci with at least one burdened DHS is", length(burdened.loci)))
print("Summary of number of burdened DHSs per locus (for those with at least one burdened DHS) is")
print(summary(num.burd.dhs.per.locus[burdened.loci]))

cat("\n\n")


###############################################################################
####################         Statistics for Genes         #####################
###############################################################################
print(".......................   Statistics for Genes   .........................")
# Number of Genes Overlapping Disease Loci
print(paste("Total number of Genes overlapping risk loci is", sum(Num.Gene)))
print("Summary of number of genes overlapping risk loci per locus is")
print(summary(Num.Gene))

print(paste("Total number of Genes overlapping risk loci with at least one burdened DHSs is", sum(Num.Gene[burdened.loci])))
print("Summary of number of genes overlapping risk loci per locus is")
print(summary(Num.Gene[burdened.loci]))