###############################################################################
##################             Code Description             ###################
###############################################################################
# This code prepares an annotation file that contains per-locus summary of the
# results. This includes regulatory potential of the locus (total \rho),
# prioritized genes, and the closest gene to the lead SNP.

print("Running Extract-Candidate-Genes.R  ...................................")

###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]

path.to.table <- paste0(Work.Dir, "/Tables/", trait.type, "/Posterior-Probability-", trait.type, ".txt")
snps.path <- paste0(Work.Dir, "/BedData/", trait.type, "/LeadSNPs.txt")

Result <- read.table(path.to.table, sep="\t", stringsAsFactors=F, header=T)
load(paste(Work.Dir, "/Rdata/Norm-Trans-Exp.Rdata", sep=""))
load(paste(Work.Dir, "/Tables/", trait.type, "/DIGs-genes.Rdata", sep=""))

###############################################################################
##################                   Step 1                  ##################
###############################################################################
ratio <- round(Result[,"posterior.prob"]/Result[,"PPA"], 3)
Result <- cbind(Result, ratio=ratio)

total.PPA <- c()
for (region in unique(Result[,"Region"])) {
  indx <- which(Result[,"Region"] == region)
  if (length(unique(Result[indx, "PPA"])) != 1) {
    stop(paste0("Error: More than one PPA for region ", region ))
  }
  
  total.PPA[region] <- Result[indx[1], "PPA"]
}

srt.indx <- sort(total.PPA, index.return=T, decreasing=T)$ix
srt.regions <- names(total.PPA)[srt.indx]

comp.mat <- c()
for (region in srt.regions) { 
  indx <- which(Result[, "Region"] == region)
  A <- Result[indx, ]
  # Keep the genes that receive 10% or more of the total posterior attributable to all DHSs in the locus
  A <- A[A[,"ratio"] > 0.1,]
  
  # Sort the genes based on their posterior probabilities
  r <- A[, "ratio"]
  ind <- sort(r, decreasing=T, index.return=T)$ix
  B <- A[ind, c("Gene", "ratio")]
  
  out <- paste(apply(B, 1, function(x) {return(paste(x[1], " (", round(as.numeric(x[2]), 3), ")", sep=""))}), collapse=", ")
  
  comp.mat <- rbind(comp.mat, c(region, total.PPA[region], out))
}
colnames(comp.mat) <- c("Region", "Total.PPA", "TopGenes.Ratio")

snps.data <- read.table(snps.path, sep="\t", stringsAsFactors=F, header=T)
colseset.gene <- colseset.gene.fullname <- c()
dist.clst <- leadSNP.bp.hg19 <- leadSNP <- chr <- c()
for (region in srt.regions) {
  # Extract position of lead SNPs
  # print(region)
  leadSNP[region] <- paste0("rs", unlist(strsplit(region, "rs"))[2])
  lead.pos <- snps.data[which(snps.data[,"SNP"] == leadSNP[region]), "Position"]
  chr[region] <- unlist(strsplit(region, "rs"))[1]
  
  load(paste(Work.Dir, "/Rdata/", trait.type, "/Crr-Pval-Mat/Crr-Pval-Mat-", region, ".Rdata", sep=""))
  region.genes <- colnames(crr.pval.mat) 

  # Identify the closest gene to the lead SNPs
  rownames(norm.trans.exp) <- paste(norm.trans.exp[, "chrom"], norm.trans.exp[,"ensTrans.hugoGene"], sep="-")
  
  exp.data <-  norm.trans.exp[region.genes, c("txStart", "txEnd")]
  dist.data <- abs(exp.data - lead.pos)
  min.dist <- apply(dist.data,1,min)
  
  gene <- names(which(min.dist == min(min.dist)))
  colseset.gene[region] <- unlist(strsplit(gene, "-"))[3]
  colseset.gene.fullname[region] <- gene
  
  leadSNP.bp.hg19[region] <- lead.pos
  dist.clst[region] <- min(min.dist)
}

# Make a final annotation table and save it as excel file.
if (nrow(comp.mat) != 1) {
  Final.Table <- cbind(comp.mat[, c("Region", "Total.PPA")], colseset.gene[comp.mat[, "Region"]], comp.mat[, "TopGenes.Ratio"], colseset.gene.fullname[comp.mat[, "Region"]], DIGs[comp.mat[, "Region"]], leadSNP.bp.hg19[comp.mat[, "Region"]], dist.clst[comp.mat[, "Region"]], leadSNP[comp.mat[, "Region"]], chr[comp.mat[, "Region"]])  
  Summary.Table <- Final.Table[,c("Chr", "leadSNP", "leadSNP.Pos", "Total PPA", "Closest Gene", "Distance", "TopGenes (PP/Total PPA)")] 
} else {
  Final.Table <- c(comp.mat[, c("Region", "Total.PPA")], colseset.gene[comp.mat[, "Region"]], comp.mat[, "TopGenes.Ratio"], colseset.gene.fullname[comp.mat[, "Region"]], DIGs[comp.mat[, "Region"]], leadSNP.bp.hg19[comp.mat[, "Region"]], dist.clst[comp.mat[, "Region"]], leadSNP[comp.mat[, "Region"]], chr[comp.mat[, "Region"]])
  Final.Table <- matrix(Final.Table, ncol=10, nrow=nrow(comp.mat))
  colnames(Final.Table) <- c("Region", "Total PPA", "Closest Gene", "TopGenes (PP/Total PPA)", "CLGs.fullname", "DIGs.fullname", "leadSNP.Pos", "Distance", "leadSNP", "Chr")
  
  Summary.Table <- Final.Table[,c("Chr", "leadSNP", "leadSNP.Pos", "Total PPA", "Closest Gene", "Distance", "TopGenes (PP/Total PPA)")]
  
  Summary.Table <- matrix(Summary.Table, ncol=7, nrow=nrow(comp.mat))
}
colnames(Final.Table) <- c("Region", "Total PPA", "Closest Gene", "TopGenes (PP/Total PPA)", "CLGs.fullname", "DIGs.fullname", "leadSNP.Pos", "Distance", "leadSNP", "Chr")
colnames(Summary.Table) <- c("CHR", "SNP", "BP", "RHO", "CLGENE", "DIST", "PRIGENES")

write.table(Final.Table, file=paste0(Work.Dir, "/Tables/", trait.type, "/PP-ClosestVsDIGs-", trait.type, ".xls"), sep="\t", quote=F, col.names=T, row.names=F)
write.table(Final.Table, file=paste0(Work.Dir, "/Tables/", trait.type, "/PP-ClosestVsDIGs-", trait.type, ".txt"), sep="\t", quote=F, col.names=T, row.names=F)
write.table(colseset.gene, file=paste0(Work.Dir, "/Tables/", trait.type, "/genes-closest.txt"), quote=F, row.names=F, col.names=F, append=F)
write.table(Summary.Table, file=paste0(Work.Dir, "/Tables/", trait.type, "/Summary-Table-", trait.type, ".txt"), sep="\t", quote=F, col.names=T, row.names=F)