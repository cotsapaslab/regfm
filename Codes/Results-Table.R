###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())

args <- commandArgs(TRUE)
Work.Dir <- args[1]
trait.type <- args[2]

load(paste0(Work.Dir, "/Rdata/DHS-Data.Rdata"))

All.Cells <- colnames(DHS.Data)

library("limma")

fdr.thresh <- 0.1

DF <- c()
###############################################################################
##################              Load Required Data             ################
###############################################################################
load(paste0(Work.Dir, "/Rdata/", trait.type, "/PPD.Rdata"))
load(paste0(Work.Dir, "/Rdata/", trait.type, "/perCell-rho-Pvalue-v3.Rdata"))
load(paste0(Work.Dir, "/Rdata/", trait.type, "/perCell-rho-Pvalue-v3-Adj.Rdata"))
load(paste0(Work.Dir, "/Rdata/", trait.type, "/Gamma-P-Adj-Final.Rdata"))
load(paste0(Work.Dir, "/Rdata/", trait.type, "/perCell-obs-rho-v3.Rdata"))
load(paste0(Work.Dir, "/Rdata/", trait.type, "/total-rho-v3.Rdata"))

rho.adj.P <- perCell.rho.Pvalue.adj
rho.P <- perCell.rho.Pvalue

region.info <- read.table(paste0(Work.Dir, "/BedData/", trait.type, "/Region-Info-Sorted.bed"), sep="\t", stringsAsFactors=F, header=F)
rownames(region.info) <- region.info[,4]
colnames(region.info) <- c("Chr", "Start", "End", "Region")

ci.dhs <- read.table(paste0(Work.Dir, "/BedData/", trait.type, "/credSNP-v2-DHS-Ovrlp-Sorted.bed"), sep="\t", stringsAsFactors=F, header=F)
colnames(ci.dhs) <- c("Chr", "Start", "Pos", "SNP", "leadSNP", "Region", "R2", "P", "PPS", "DHS.Chr", "DHS.Start", "DHS.End", "DHS.ID", "Overlap")

# Define regions that are significant for rho and gamma
all.regions <- names(PPD)
Rho.Sig.Regions <- rownames(rho.adj.P)[which(apply(rho.adj.P, 1, min) <= fdr.thresh)] 
Gamma.Sig.Regions <- intersect(Rho.Sig.Regions, names(Gamma.P.Adj)[which(unlist(lapply(Gamma.P.Adj, min)) <= fdr.thresh)])

# chr <- start <- end <- leadSNP <- c()
# N.DHS <- N.Gene <- N.CI <- N.Burd.DHS <- my.rho <- c()
for (region in all.regions) {
  ###############################################################################
  ###################             Locus Information              ################
  ###############################################################################
  # Define region information
  chr <- region.info[region, "Chr"]
  start <- region.info[region, "Start"]
  end <- region.info[region, "End"]
  leadSNP <- paste0("rs", unlist(strsplit(region, "rs"))[2])
  
  # Count number of CI, DHS, Genes, burdened DHS and total observed Rho
  load(paste0(Work.Dir, "/Rdata/", trait.type, "/Crr-Pval-Mat/Crr-Pval-Mat-", region, ".Rdata"))
  N.DHS <- nrow(crr.pval.mat)
  N.Gene <- ncol(crr.pval.mat)
  N.CI <- length(unique(ci.dhs[which(ci.dhs[,"Region"] == region), "SNP"]))
  N.Burd.DHS <- length(PPD[[region]])
  my.rho <- round(total.rho[region],3)
  
  ###############################################################################
  ###########              Significant Rho Information               ############
  ###############################################################################
  # Significant rho information
  if (length(intersect(region, Rho.Sig.Regions)) > 0) {
    sig.tissues.rho <- colnames(rho.adj.P)[which(rho.adj.P[region, ] <= fdr.thresh)]
    # sig.tissues.gamma <- colnames(Gamma.P.Adj[[region]])[which(apply(Gamma.P.Adj[[region]], 2, min) <= fdr.thresh)]
    sig.tissues <- sig.tissues.rho # union(sig.tissues.rho, sig.tissues.gamma)
    
    for (tissue in sig.tissues) {
      N.Active.DHS <- sum(DHS.Data[rownames(crr.pval.mat), tissue])
      N.Active.Burd.DHS <- sum(DHS.Data[names(PPD[[region]]), tissue])
      rho <- round(obs.rho[region, tissue],3)
      # rho.P <- round(perCell.rho.Pvalue[region, tissue],5)
      rho.Padj <- round(perCell.rho.Pvalue.adj[region, tissue],4)
      
      ###############################################################################
      ###########              Significant Gamma Information               ##########
      ###############################################################################
      # Significant gamma information
      indx <- which(Gamma.P.Adj[[region]][, tissue] <= fdr.thresh)
      if (length(indx) > 0) {
        sig.genes <- rownames(Gamma.P.Adj[[region]])[indx]
        for (gene in sig.genes) {
          x <- paste(unlist(strsplit(gene, "-"))[-c(1,2)], collapse="-")
          y <- round(Gamma.P.Adj[[region]][gene, tissue],4)
          
          out <- c(trait.type, chr, start, end, leadSNP, N.CI, N.DHS, N.Gene, N.Burd.DHS, my.rho, tissue, N.Active.DHS, N.Active.Burd.DHS, rho, rho.Padj, x, y)
          if (length(out) != 17) {print(trait.type); print(region)}
          DF <- rbind(DF, out)
        }
        
      } else {
        out <- c(trait.type, chr, start, end, leadSNP, N.CI, N.DHS, N.Gene, N.Burd.DHS, my.rho, tissue, N.Active.DHS, N.Active.Burd.DHS, rho, rho.Padj, "NA", "NA")
        if (length(out) != 17) {print("2222")}
        DF <- rbind(DF, out)
      }        
    }      
  } else {
    out <- c(trait.type, chr, start, end, leadSNP, N.CI, N.DHS, N.Gene, N.Burd.DHS, my.rho, "NA", "NA", "NA", "NA", "NA", "NA", "NA")
    if (length(out) != 17) {print("3333")}
    DF <- rbind(DF, out)
  } 
}

colnames(DF) <- c("Disease", "Chr", "Start", "End", "Lead.SNP", "N.CI", "N.DHS", "N.Gene", "N.Pr.DHS", "Total.Rho", "Cell", "N.DHS.Cell", "N.Pr.DHS.Cell", "Rho.perCell", "Rho.FDR", "Gene", "Gamma.FDR")

write.table(DF, file=paste0(Work.Dir, "/Tables/", trait.type, "/Final-Results.xls"), sep="\t", col.names=T, row.names=F, quote=F, append=F)
write.table(DF, file=paste0(Work.Dir, "/Tables/", trait.type, "/Final-Results.txt"), sep="\t", col.names=T, row.names=F, quote=F, append=F)


# indx <- which(DF[,"Gene"] != "NA")
# a <- paste(DF[indx, "Disease"], DF[indx, "Lead.SNP"], sep="-")
# b <- unique(a)
# d <- mapply(function(x){unlist(strsplit(x, "-"))[1]}, b)
# print(table(d))

# Z <- c()
# for (trait in all.traits) {
#   trait.type <- paste0(trait, "-Lead-Extended"); 
#   load(paste0(Work.Dir, "/Rdata/", trait.type, "/Gamma-P-Adj-Final.Rdata")); 
#   for (i in 1:length(Gamma.P.Adj)) {
#       Z <- c(Z, paste0(trait, "-", names(Gamma.P.Adj)[i]))
#   }
# }
