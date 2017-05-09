###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)

Work.Dir <- args[1]
trait.type <- args[2]
region <- args[3]

load(paste0(Work.Dir, "/Rdata/DHS-Data.Rdata"))
All.Cells <- colnames(DHS.Data)

ci.dhs.path <- paste0(Work.Dir, "/BedData/", trait.type, "/credSNP-v2-DHS-Ovrlp-Sorted.bed")
dhs.ci.ovrlp.dir <- paste0(Work.Dir, "/BedData/", trait.type, "/perLocus-CI-DHS-Overlap")

dir.create(paste0(Work.Dir, "/Rdata/", trait.type, "/rand-perCell-rho-v3"), showWarnings=F, recursive=T)

###############################################################################
#######################               Step 1              #####################
###############################################################################
ci.dhs <- read.table(ci.dhs.path, sep="\t", stringsAsFactors=F, header=F)
colnames(ci.dhs) <- c("Chr", "Start", "Pos", "SNP", "leadSNP", "Region", "R2", "P", "PPS", "DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID", "Overlap")

print(region)

dhs.ids <- read.table(paste0(Work.Dir, "/BedData/", trait.type, "/perLocus-DHS/", region), sep="\t", stringsAsFactors=F, header=F)[,4]
DHS.Data.Subset <- DHS.Data[dhs.ids, ]

###############################################################################
ref <- ci.dhs[which(ci.dhs[,"Region"] == region),]

burdened.dhs <- unique(ref[, "DHS.ID"])
D <- DHS.Data.Subset[burdened.dhs, ]

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

dir.path <- paste(dhs.ci.ovrlp.dir, region, sep="/")
cal.rho <- function(file) {
  # print(file)
  path <- paste0(dir.path, "/", file)
  
  tmp <- try(read.table(path, sep="\t", stringsAsFactors=F, header=F),  silent = TRUE)
  if (!inherits(tmp, 'try-error')) {
    data <- tmp
    colnames(data) <- c("Chr", "Start", "Pos", "SNP", "leadSNP", "Region", "R2", "P", "PPS", "DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID", "Ovrlp")
    
    
    
    ###############################################################################
    burdened.dhs <- unique(data[, "DHS.ID"])
    D <- DHS.Data.Subset[burdened.dhs, ]
    if (length(burdened.dhs) == 1) {
      D <- matrix(D, nrow=1, ncol=ncol(DHS.Data.Subset), dimnames=list(burdened.dhs, colnames(DHS.Data.Subset)))
    }
    
    SNPs <- unique(data[, "SNP"])
    weight.mat <- matrix(0, nrow=length(burdened.dhs), ncol=length(SNPs), dimnames=list(burdened.dhs, SNPs))
    pps <- c()
    for (snp in SNPs) {
      pps[snp] <- data[which(data[,"SNP"] == snp)[1], "PPS"]
      d <- unique(data[which(data[,"SNP"] == snp), "DHS.ID"])
      weight.mat[d,snp] <- 1/length(d)
    }
    
    rho <- unlist(lapply(as.list(burdened.dhs), function(dhs) {
      s <- pps[SNPs] * weight.mat[dhs, SNPs]
      return(sum(s[which(!is.na(s))]))
    }))
    out <- colSums(rho * D)
    
    return(out)
  } else {return(rep(0,22))}
}

rslt <- lapply(as.list(dir(dir.path)), cal.rho)
rand.perCell.rho <- do.call(rbind, rslt)
colnames(rand.perCell.rho) <- All.Cells

save(rand.perCell.rho, file=paste0(Work.Dir, "/Rdata/", trait.type, "/rand-perCell-rho-v3/", region, ".Rdata"))