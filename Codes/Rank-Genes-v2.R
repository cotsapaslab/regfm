###############################################################################
##################             Code Description             ###################
###############################################################################
# This code computes posterior probability of association per CI SNPs (PPS),
# posterior probability per DHS cluster (\rho shown by PPA or PPD in the code), 
# and posterior probability per-gene (\gamma shown by PPG in the code).
# It also ranks genes based on their posterior probability of associations.

print("Running Rank-Genes-v2.R  .............................................")

###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]

annot.table.path <- paste(Work.Dir, "/Tables/", trait.type, "/credSNP-DHS-Gene-Annot.txt", sep="")
cred.folder <- paste(Work.Dir, "/credible_analysis/", trait.type, "/credible_output", sep="")
region.info.path <- paste(Work.Dir, "/BedData/", trait.type, "/Region-Info.bed", sep="")
load(paste(Work.Dir, "/Rdata/", trait.type, "/RTC-Pvalue.Rdata", sep=""))

filter.thresh <- 0.25
All.Chromosomes <- paste("chr", 1:22, sep="")

# This function computes posterior probability of correlation (normalized correlation coefficient or Beta) between a DHS and a gene by using P values of gene-DHS correlation
Compute.PPC <- function(p) {
  Z <- qchisq(p, 1, low = FALSE)/2
  prob <- exp(Z)
  prob[p > filter.thresh] <- 0
  prob_normed <- prob/sum(prob)  
  return(prob_normed)
}

library("gap")
library("ggplot2")

###############################################################################
#####################              Analysis               #####################
###############################################################################
# Identify all 2Mbp loci
annot <- read.table(annot.table.path, stringsAsFactors=F, header=T, sep="\t")
all.regions <- unique(annot[,"Region"])

Result <- c()
PPA <- PPC <- PP <- PP.mat <- list()
all.snps <- PPS <- c()
for (region in all.regions) {
   # print(region)
  
  # Load P value of correlation
  load(paste(Work.Dir, "/Rdata/", trait.type, "/Crr-Pval-Mat/Crr-Pval-Mat-", region, ".Rdata", sep=""))
  
  # Load credible interval SNPs, and remove duplicated CI SNPs
  path.to.cred.data <- paste0(cred.folder, "/credible_output_", region, ".txt")
  cred.data <- read.table(path.to.cred.data, header=T, stringsAsFactor=F)
  dupl.indx <- which(duplicated(cred.data[,"SNP"]) == TRUE)
  if (length(dupl.indx) > 0) {cred.data <- cred.data[-dupl.indx,]}
  rownames(cred.data) <- cred.data[,"SNP"]
  
  ############################################################################### 
  if (ncol(crr.pval.mat) == 0) {print(paste0(region, " is PROBLEMATIC!!!!!!!!!!!!!!!!!"))}
  if (ncol(crr.pval.mat) > 0) {
    
    # Remove DHS clusters that their P value of correlation is NA.
    # These are the DHS clusters that overlapping TSS regions and are ON for all 22 cell types.
    rm.indx <- which(is.na(crr.pval.mat[,1]))
    if (length(rm.indx) > 0) {
      rm.dhs <- rownames(crr.pval.mat)[rm.indx]
      if (ncol(crr.pval.mat) == 1) {
        mygenes <- colnames(crr.pval.mat)
        mydhs <- rownames(crr.pval.mat)[-rm.indx]
        crr.pval.mat <- matrix(crr.pval.mat[-rm.indx,], ncol=1, nrow=length(mydhs), dimnames=list(mydhs, mygenes))
      } else {
        crr.pval.mat <- crr.pval.mat[-rm.indx,] 
      }     
    } else {rm.dhs <- NULL}
    
    # Extract IDs of DHS clusters and genes overlapping each locus
    region.genes <- colnames(crr.pval.mat)
    burdened.dhs <- setdiff(unique(annot[which(annot[,"Region"] == region), "DHS.ID"]), rm.dhs)
    
    # Remove those burdened DHSs that are not correlated to any genes.
    for (dhs in burdened.dhs) {
      p <- RTC.Pvalue[[region]][dhs, ] # p <- crr.pval.mat[dhs, ]
      if (min(p) > filter.thresh) {burdened.dhs <- setdiff(burdened.dhs, dhs)}
    }    
    
    a <- match(annot[, "DHS.ID"], burdened.dhs)
    b <- match(annot[, "Region"], region)
    indx <- intersect(which(!is.na(a)), which(!is.na(b))) 
    my.annot <- annot[indx, ]
    
    ###############################################################################
    # Equally weights for SNPs overlapping multiple DHS clusters or their 100 bp flanking regions
    if (length(burdened.dhs) > 0) {
      SNPs <- unique(my.annot[, "SNP"])
      weight.mat <- matrix(0, nrow=length(burdened.dhs), ncol=length(SNPs), dimnames=list(burdened.dhs, SNPs))
      for (snp in SNPs) {
        d <- unique(my.annot[which(my.annot[,"SNP"] == snp), "DHS.ID"])
        weight.mat[d,snp] <- 1/length(d)
      }
      
      ###############################################################################     
      # Compute per-DHS posterior probability of association (\rho shown by PPA variable) 
      # and normalized correlation coefficient (or \beta shown by PPC variable)
      PPC[[region]] <- matrix(nrow=length(burdened.dhs), ncol=length(region.genes), dimnames=list(burdened.dhs, region.genes))
      PPA[[region]] <- c()
      for (dhs in burdened.dhs) {
        s <- cred.data[SNPs, "probNorm"] * weight.mat[dhs, SNPs]
        PPA[[region]][dhs] <- sum(s[which(!is.na(s))])
        PPC[[region]][dhs, ] <- Compute.PPC(RTC.Pvalue[[region]][dhs, region.genes])        
      }
      
      rm.indx <- which(is.na(PPC[[region]][,1]))
      if (length(rm.indx) > 0) {
        PPA[[region]] <- PPA[[region]][-rm.indx]
        PPC[[region]] <- PPC[[region]][-rm.indx,]
      }
      
      ###############################################################################
      # Compute per-gene posterior probability of association (\gamma shown by PP variable)
      X <- apply(PPC[[region]], 2, function(x) {x*PPA[[region]]})  
      srt.indx <- c()
      if (is.null(dim(X))) {
        srt.indx <- sort(X, decreasing=T, index.return=T)$ix
        PP[[region]] <- X[srt.indx]
        PP.mat[[region]] <- X[srt.indx]
      } else {
        srt.indx <- sort(apply(X, 2, sum), decreasing=T, index.return=T)$ix
        PP[[region]] <- apply(X, 2, sum)[srt.indx]
        PP.mat[[region]] <- X[,srt.indx]
      }
      
      ###############################################################################
      # Make a table of final results. This includes per-gene posterior probability of association,
      # and sum of per-DHS posterior probability of association (i.e. locus regulatory potential).
      all.genes <- unlist(lapply(as.list(region.genes[srt.indx]), function(x){unlist(strsplit(x,"-"))[3]}))
      out <- cbind(Region=rep(region, times=length(region.genes)),
                   Gene = all.genes,
                   posterior.prob=round(PP[[region]],3),
                   PPA=rep(round(sum(PPA[[region]]),3), times=length(region.genes)),
                   gene.full.name=region.genes[srt.indx])
      Result <- rbind(Result, out)
    }
  }
  
  ###############################################################################
  # Extract per-SNP posterior probability of association (shown by PPS variable) for Credibel Interval SNP
  SNPs <- unique(annot[annot[,"Region"] == region, "SNP"])
  
  z <- match(SNPs, all.snps)
  indx <- which(!is.na(z))
  if (length(indx) > 0) {
    # print(region)
    PPS[SNPs[indx]] <- apply(cbind(PPS[SNPs[indx]], cred.data[SNPs[indx], "probNorm"]), 1, max)
    if (length(indx) < length(SNPs)) {
      PPS[SNPs[-indx]] <- cred.data[SNPs[-indx], "probNorm"]
    }
  } else {
    PPS[SNPs] <- cred.data[SNPs, "probNorm"]
  }  
  
  all.snps <- unique(c(all.snps, SNPs))
}


###############################################################################
# Save final results in excel files.
indx <- sort(as.numeric(Result[,"posterior.prob"]), decreasing=T, index.return=T)$ix
write.table(Result[indx,], file=paste0(Work.Dir, "/Tables/", trait.type, "/Posterior-Probability-", trait.type, ".xls"), sep="\t", quote=F, col.names=T, row.names=F)
write.table(Result[indx,], file=paste0(Work.Dir, "/Tables/", trait.type, "/Posterior-Probability-", trait.type, ".txt"), sep="\t", quote=F, col.names=T, row.names=F)

###############################################################################
# Save results in .Rdata format
save(PPA, file=paste0(Work.Dir, "/Rdata/", trait.type, "/PPA.Rdata")) # per-DHS posterior (\rho)
save(PPC, file=paste0(Work.Dir, "/Rdata/", trait.type, "/PPC.Rdata")) # normalized gene-dhs correlation (\beta)
save(PP.mat, file=paste0(Work.Dir, "/Rdata/", trait.type, "/PP-Mat.Rdata")) # proporton of posterior transmitted to each gene from a DHS cluster
save(PPS, file=paste0(Work.Dir, "/Rdata/", trait.type, "/PPS.Rdata")) # per-SNP posterior (PPS)

# Calculating per-gene posterior probability of association (\gamma shown by PPG variable)
PPD <- PPA
PPG <- list()
for (region in all.regions) {
  # print(region)
  if (length(intersect(names(PPD), region))  > 0) {
    ppd <- PPD[[region]]
    if(!is.matrix(PP.mat[[region]])) {
      if (length(ppd) == 1) {
        PP.mat[[region]] <- matrix(PP.mat[[region]], nrow=1, ncol=length(PP.mat[[region]]), dimnames=list(names(ppd), names(PP.mat[[region]])))
      } else {
        PP.mat[[region]] <- matrix(PP.mat[[region]], nrow=length(ppd), ncol=1, dimnames=list(names(ppd), colnames(PPC[[region]])))
      }
    }
    
    PPG[[region]] <- apply(PP.mat[[region]],2,sum)
  }
}

# Save results in .Rdata format
save(PP.mat, file=paste0(Work.Dir, "/Rdata/", trait.type, "/PP-Mat.Rdata")) # proporton of posterior transmitted to each gene from a DHS cluster
save(PPG, file=paste0(Work.Dir, "/Rdata/", trait.type, "/PPG.Rdata")) # per-gene posterior (\gamma)
save(PPD, file=paste0(Work.Dir, "/Rdata/", trait.type, "/PPD.Rdata")) # per-DHS posterior (\rho)

###############################################################################
# Reporting the gene with the highest posterior probability of association for each locus
DIGs <- c()
for (region in all.regions) {
  #print(region)
  indx <- which(Result[, "Region"] == region)
  if (length(indx) > 0) { 
    if (length(indx) == 1) {
      DIGs[region] <- Result[indx, "gene.full.name"]
    } else {
      A <- Result[indx,]
      ind <- which.max(as.numeric(A[, "posterior.prob"]))
      DIGs[region] <- A[ind, "gene.full.name"]
    }
    
  } else {
    DIGs[region] <- NA
  }
}
save(DIGs, file=paste0(Work.Dir, "/Tables/", trait.type, "/DIGs-genes.Rdata"))