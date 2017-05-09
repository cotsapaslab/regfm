###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)

Work.Dir <- args[1] # "/Volumes/MP/regfm-v2.0" 
trait.type <- args[2] # "example" # 

load(paste0(Work.Dir, "/Rdata/DHS-Data.Rdata"))
load(paste0(Work.Dir, "/Rdata/", trait.type, "/perCell-rho-Pvalue-v3.Rdata"))
ci.dhs.path <- paste0(Work.Dir, "/BedData/", trait.type, "/credSNP-v2-DHS-Ovrlp-Sorted.bed")

Gamma.P.Dir <- paste0(Work.Dir, "/Rdata/", trait.type, "/Gamma.P.Dir")
PP.Mat.Dir <- paste0(Work.Dir, "/Rdata/", trait.type, "/PP.Mat.Dir")
PPC.Dir <- paste0(Work.Dir, "/Rdata/", trait.type, "/PPC.Dir")

rand.rho.dir <- paste0(Work.Dir, "/Rdata/", trait.type, "/rand-perCell-rho-v3") 
All.Cells <- colnames(DHS.Data)

###############################################################################
#######################               Step 1              #####################
###############################################################################
all.regions <- dir(rand.rho.dir)
all.regions <- unlist(lapply(as.list(all.regions), function(x) {
  return(unlist(strsplit(x, ".Rdata")))
}))

ci.dhs <- read.table(ci.dhs.path, sep="\t", stringsAsFactors=F, header=F)
colnames(ci.dhs) <- c("Chr", "Start", "Pos", "SNP", "leadSNP", "Region", "R2", "P", "PPS", "DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID", "Overlap")


PP.mat <- PPC <- list()
for (region in all.regions) {
  load(paste0(PP.Mat.Dir, "/PP-Mat-", region, ".Rdata"))
  load(paste0(PPC.Dir, "/PPC-", region, ".Rdata"))
  
  PPC[[region]] <- ppc
  PP.mat[[region]] <- pp.mat
}

save(PPC, file=paste0(Work.Dir, "/Rdata/", trait.type, "/PPC.Rdata"))
save(PP.mat, file=paste0(Work.Dir, "/Rdata/", trait.type, "/PP-Mat.Rdata"))


###############################################################################
#######################               Step 1              #####################
###############################################################################
# perCell.rho.Pvalue.adj <- list()
# for (region in all.regions) {
  A <- apply(perCell.rho.Pvalue, 2, p.adjust)
  if (is.null(dim(A))) {
    perCell.rho.Pvalue.adj <- matrix(A, nrow=1, ncol=length(A))
  } else {
    perCell.rho.Pvalue.adj <- A
  }
  rownames(perCell.rho.Pvalue.adj) <- rownames(perCell.rho.Pvalue)
  colnames(perCell.rho.Pvalue.adj) <- colnames(perCell.rho.Pvalue)
# }

save(perCell.rho.Pvalue.adj, file=paste0(Work.Dir, "/Rdata/", trait.type, "/perCell-rho-Pvalue-v3-Adj.Rdata"))

###############################################################################
#######################               Step 3              #####################
###############################################################################
Gamma.P.Adj <- list()
for (region in all.regions) {
  print(region)  
  path <- paste0(Gamma.P.Dir, "/Gamma-Pvalue-", region, ".Rdata")
  
  if (file.exists(path) == TRUE) {
    load(path)  
    B <- apply(Gamma.Pvalue, 1, p.adjust) 
    if (is.null(dim(B))) {
      Gamma.P.Adj[[region]] <- matrix(B, nrow=1, ncol=length(B))
    } else {
      Gamma.P.Adj[[region]] <- B
    }
    
    rownames(Gamma.P.Adj[[region]]) <- colnames(Gamma.Pvalue)
    colnames(Gamma.P.Adj[[region]]) <- rownames(Gamma.Pvalue)
  }
}

save(Gamma.P.Adj, file=paste0(Work.Dir, "/Rdata/", trait.type, "/Gamma-P-Adj-Final.Rdata"))