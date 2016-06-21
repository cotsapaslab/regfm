###############################################################################
##################             Code Description             ###################
###############################################################################
# This code generates a multi-panel figure for each lead SNP.

print("Running Plots-Multi-Panel.R  .........................................")

###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]

status <- "TopGenesOnly"
ai.status <- "YES"

library("e1071")
library("gplots")
library("graphics")
# library("ggplot2")
library("grid")
library("SDMTools")
library("gtable")

source(paste0(Work.Dir, "/Codes/Plots-Panel1-geneLabels.R"))
source(paste0(Work.Dir, "/Codes/Plots-Panel1.R"))
source(paste0(Work.Dir, "/Codes/Plots-Panel2.R"))

path.to.data <- paste0(Work.Dir, "/BedData/", trait.type, "/allSNPs-Sorted.bed")
ai.cred.path <- paste0(Work.Dir, "/Data/Allele-Specific-Data/credSNP-AlleleSpecific-Overlap-", trait.type, ".bed")
out.dir <- paste0(Work.Dir, "/Figures/", trait.type)
path.to.region.info <- paste0(Work.Dir, "/BedData/", trait.type, "/Region-Info.bed")
dir.create(out.dir, showWarnings=F, recursive=T)

load(paste0(Work.Dir, "/Rdata/", trait.type, "/PPA.Rdata"))
load(paste0(Work.Dir, "/Rdata/", trait.type, "/PPC.Rdata"))
load(paste0(Work.Dir, "/Rdata/", trait.type, "/PP-Mat.Rdata"))
load(paste0(Work.Dir, "/Rdata/", trait.type, "/RTC-Pvalue.Rdata"))
load(paste0(Work.Dir, "/Rdata/Best-genomeFunc.Rdata"))
load(paste0(Work.Dir, "/Rdata/Norm-Trans-Exp.Rdata"))
load(paste0(Work.Dir, "/Rdata/DHS-Data.Rdata"))

rownames(norm.trans.exp) <- paste(norm.trans.exp[,"chrom"], norm.trans.exp[, "ensTrans.hugoGene"], sep="-")
all.regions <- names(PPA)
region.info <- read.table(path.to.region.info, sep="\t", stringsAsFactors=F, header=F)
colnames(region.info) <- c("Chr", "regionStart", "regionEnd", "Region")

###############################################################################
################               Allelic Imbalance              #################
###############################################################################
if (ai.status == "YES") {
  ai.cred <- as.matrix(read.table(ai.cred.path, sep="\t", stringsAsFactors=F, header=F))
  ai.cred <- ai.cred[,c(6, 12, 26)]
  keep.indx <- which(ai.cred[,3] != "not_imbalanced")
  if (length(keep.indx) > 0) {
    AI.Data <- unique(ai.cred[keep.indx, 1:2])
    if (length(keep.indx) == 1) {
      AI.Data <- matrix(AI.Data, nrow=1, ncol=2)
    }
    colnames(AI.Data) <- c("Region", "DHS.ID")
    rownames(AI.Data) <- AI.Data[,"DHS.ID"]
  }
}

###############################################################################
##################                Plot Figures              ###################
###############################################################################
for (region in all.regions) {
  # print(region)
  
  indx <- which(region.info[,"Region"] == region)
  region.start <- region.info[indx, "regionStart"]
  region.end <- region.info[indx, "regionEnd"]
  
  pl <- list()
  num.dhs <- length(PPA[[region]])
  n.boxplt <- min(3, num.dhs)
  
  ppa <- PPA[[region]]
  ppc <- PPC[[region]]
  pp.mat <- PP.mat[[region]]  
  num.dhs <- length(ppa)
  
  input.path <- paste0(Work.Dir, "/credible_analysis/", trait.type, "/credible_output/credible_output_", region, ".txt")  
  load(paste0(Work.Dir, "/Rdata/", trait.type, "/Crr-Pval-Mat/Crr-Pval-Mat-", region, ".Rdata"))
  region.genes <- colnames(crr.pval.mat)
  X <- norm.trans.exp[region.genes, 1:11]
  
  pdf(paste0(out.dir, "/", region, ".pdf"), width=11, height=8)
    par(mfrow=c(5,1))
    layout(matrix(c(rep(1,4), rep(2,1), rep(3,3), rep(4,4), rep(5,1)), nrow=13, ncol=1))
    plot.panel1(norm.trans.exp[region.genes, 1:11], region, input.path, path.to.data, region.start, region.end, trait.type)
    plot.panel1.geneLabels(X, region.start, region.end, out.path)
    plot.panel2(region, ppa, ppc, pp.mat, status)
    rtc.pval <- RTC.Pvalue[[region]]
    source(paste0(Work.Dir, "/Codes/Plots-Panel3.R"))
  dev.off()
}