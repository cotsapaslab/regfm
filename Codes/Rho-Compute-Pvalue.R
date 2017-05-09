###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)

Work.Dir <- args[1]
trait.type <- args[2]

load(paste0(Work.Dir, "/Rdata/DHS-Data.Rdata"))
ci.dhs.path <- paste0(Work.Dir, "/BedData/", trait.type, "/credSNP-v2-DHS-Ovrlp-Sorted.bed")

rand.rho.dir <- paste0(Work.Dir, "/Rdata/", trait.type, "/rand-perCell-rho-v3") 
All.Cells <- colnames(DHS.Data)

###############################################################################
#######################               Step 1              #####################
###############################################################################
all.regions <- dir(rand.rho.dir)
all.regions <- unlist(lapply(as.list(all.regions), function(x) {
  return(unlist(strsplit(x, ".Rdata")))
}))

perCell.rho.Pvalue <- obs.rho <- matrix(nrow=length(all.regions), ncol=ncol(DHS.Data), dimnames=list(all.regions, All.Cells))

ci.dhs <- read.table(ci.dhs.path, sep="\t", stringsAsFactors=F, header=F)
colnames(ci.dhs) <- c("Chr", "Start", "Pos", "SNP", "leadSNP", "Region", "R2", "P", "PPS", "DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID", "Overlap")

total.rho <- c()
PPD <- list()
for (region in all.regions) {
  print(region)
  
  dhs.ids <- read.table(paste0(Work.Dir, "/BedData/", trait.type, "/perLocus-DHS/", region), sep="\t", stringsAsFactors=F, header=F)[,4]
  DHS.Data.Subset <- DHS.Data[dhs.ids, ]
  
  ###############################################################################
  ref <- ci.dhs[which(ci.dhs[,"Region"] == region),]
  
  burdened.dhs <- unique(ref[, "DHS.ID"])
  D <- DHS.Data.Subset[burdened.dhs, ]
  if (length(burdened.dhs) == 1) {
    D <- matrix(D, nrow=1, ncol=ncol(DHS.Data.Subset), dimnames=list(burdened.dhs, colnames(DHS.Data.Subset)))
  }
  
  SNPs <- unique(ref[, "SNP"])
  weight.mat <- matrix(0, nrow=length(burdened.dhs), ncol=length(SNPs), dimnames=list(burdened.dhs, SNPs))
  pps <- c()
  for (snp in SNPs) {
    pps[snp] <- ref[which(ref[,"SNP"] == snp)[1], "PPS"]
    d <- unique(ref[which(ref[,"SNP"] == snp), "DHS.ID"])
    weight.mat[d,snp] <- 1/length(d)
  }
  
  rho <- unlist(lapply(as.list(burdened.dhs), function(dhs) {
    s <- pps[SNPs] * weight.mat[dhs, SNPs]
    return(sum(s[which(!is.na(s))]))
  }))
  obs.rho[region, ] <- colSums(rho * D)
  total.rho[region] <- sum(rho)
  
  PPD[[region]] <- rho
  names(PPD[[region]]) <- burdened.dhs
  
  load(paste0(Work.Dir, "/Rdata/", trait.type, "/rand-perCell-rho-v3/", region, ".Rdata"))
  Pvalue <- unlist(lapply(as.list(All.Cells), function(cell) {
    return((1+length(which(rand.perCell.rho[, cell] >= obs.rho[region, cell]))))
  }))/(1+nrow(rand.perCell.rho))
  
  print(nrow(rand.perCell.rho))
  
  names(Pvalue) <- All.Cells
  perCell.rho.Pvalue[region, All.Cells] <- Pvalue[All.Cells]
  
  save(perCell.rho.Pvalue, file=paste0(Work.Dir, "/Rdata/", trait.type, "/perCell-rho-Pvalue-v3.Rdata"))
  save(obs.rho, file=paste0(Work.Dir, "/Rdata/", trait.type, "/perCell-obs-rho-v3.Rdata"))
  save(total.rho, file=paste0(Work.Dir, "/Rdata/", trait.type, "/total-rho-v3.Rdata"))
  save(PPD, file=paste0(Work.Dir, "/Rdata/", trait.type, "/PPD.Rdata"))
}