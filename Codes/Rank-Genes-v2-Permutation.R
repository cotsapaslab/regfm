###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())

args <- commandArgs(TRUE)
Work.Dir <- args[1]
trait.type <- args[2]
region <- args[3]
gamma.perm.num <- args[4] # 50000

Out.Dir <- paste0(Work.Dir, "/Data/perRegion-DHS-Gene-Corr/", trait.type)
annot.table.path <- paste(Work.Dir, "/Tables/", trait.type, "/credSNP-DHS-Gene-Annot.txt", sep="")
cred.folder <- paste(Work.Dir, "/credible_analysis/", trait.type, "/credible_output", sep="")
region.info.path <- paste(Work.Dir, "/BedData/", trait.type, "/Region-Info.bed", sep="")

Gamma.P.Dir <- paste0(Work.Dir, "/Rdata/", trait.type, "/Gamma.P.Dir")
Gamma.Dir <- paste0(Work.Dir, "/Rdata/", trait.type, "/Gamma.Dir")
PP.Mat.Dir <- paste0(Work.Dir, "/Rdata/", trait.type, "/PP.Mat.Dir")
PPC.Dir <- paste0(Work.Dir, "/Rdata/", trait.type, "/PPC.Dir")

dir.create(Gamma.P.Dir, showWarnings=F, recursive=T)
dir.create(Gamma.Dir, showWarnings=F, recursive=T)
dir.create(PP.Mat.Dir, showWarnings=F, recursive=T)
dir.create(PPC.Dir, showWarnings=F, recursive=T)

load(paste(Work.Dir, "/Rdata/DHS-Data.Rdata", sep=""))

Compute.PPC <- function(p) {
  return(exp(qchisq(p, 1, low = FALSE)/2))
}

All.Cells <- colnames(DHS.Data)

All.Chromosomes <- paste("chr", 1:22, sep="")

###############################################################################
######################              Step 1               ######################
###############################################################################
annot <- read.table(annot.table.path, stringsAsFactors=F, header=T, sep="\t")
all.regions <- unique(annot[,"Region"])

Result <- c()
PPA <- PPC <- PP <- PP.mat <- list()
all.snps <- PPS <- c()

print(region)
load(paste(Work.Dir, "/Rdata/", trait.type, "/Crr-Pval-Mat/Crr-Pval-Mat-", region, ".Rdata", sep=""))
load(paste(Out.Dir, "/Crr-pval-mat-", region, ".Rdata", sep=""))
path.to.cred.data <- paste0(cred.folder, "/credible_output_", region, ".txt")
cred.data <- read.table(path.to.cred.data, header=T, stringsAsFactor=F)
dupl.indx <- which(duplicated(cred.data[,"SNP"]) == TRUE)
if (length(dupl.indx) > 0) {cred.data <- cred.data[-dupl.indx,]}
rownames(cred.data) <- cred.data[,"SNP"]

max.ppc <- Compute.PPC(apply(region.crr.pval.mat, 1, min))

############################################################################### 
if (ncol(crr.pval.mat) == 0) {print(paste0(region, " is PROBLEMATIC!!!!!!!!!!!!!!!!!"))}
if (ncol(crr.pval.mat) > 0) {
  # Remove TSS DHSs
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
  
  region.genes <- colnames(crr.pval.mat)
  burdened.dhs <- setdiff(unique(annot[which(annot[,"Region"] == region), "DHS.ID"]), rm.dhs)
  region.dhs <- unique(c(burdened.dhs, setdiff(rownames(crr.pval.mat), rm.dhs)))  
  
  a <- match(annot[, "DHS.ID"], burdened.dhs)
  b <- match(annot[, "Region"], region)
  indx <- intersect(which(!is.na(a)), which(!is.na(b))) 
  my.annot <- annot[indx, ]
  
  ###############################################################################
  if (length(burdened.dhs) > 0) {
    SNPs <- unique(my.annot[, "SNP"])
    weight.mat <- matrix(0, nrow=length(burdened.dhs), ncol=length(SNPs), dimnames=list(burdened.dhs, SNPs))
    for (snp in SNPs) {
      d <- unique(my.annot[which(my.annot[,"SNP"] == snp), "DHS.ID"])
      weight.mat[d,snp] <- 1/length(d)
    }
    
    ###############################################################################     
    # Compute PPC between each DHS-gene pair
    PPC[[region]] <- matrix(nrow=length(burdened.dhs), ncol=length(region.genes), dimnames=list(burdened.dhs, region.genes))
    PPA[[region]] <- c()
    for (dhs in burdened.dhs) {
      s <- cred.data[SNPs, "probNorm"] * weight.mat[dhs, SNPs]
      PPA[[region]][dhs] <- sum(s[which(!is.na(s))])
      
      p1 <- region.crr.pval.mat[dhs, region.genes]
      
      PPC[[region]][dhs, ] <- Compute.PPC(p1)
    }    
    
    rm.indx <- which(is.na(PPC[[region]][,1]))
    if (length(rm.indx) > 0) {
      PPA[[region]] <- PPA[[region]][-rm.indx]
      PPC[[region]] <- PPC[[region]][-rm.indx,]
    }
    
    Sub.DHS.Data <- DHS.Data[region.dhs,]
    gamma.P <- gamma <- list()
    for (cell in All.Cells) {
      print(cell)
      OUT <- lapply(as.list(1:gamma.perm.num), function(x) {
        rand.dhs.set <- sample(region.dhs, length(PPA[[region]]))
        p1 <- region.crr.pval.mat[rand.dhs.set, region.genes]
        PPC.Rand <- Compute.PPC(p1)#/max.ppc[rand.dhs.set]
        
        if (length(PPA[[region]]) == 1) {
          PPC.Rand <- matrix(PPC.Rand, nrow=1, ncol=length(PPC.Rand))
        }
        
        if (ncol(PPC[[region]]) == 1) {
          PPC.Rand <- matrix(PPC.Rand, nrow=length(PPC.Rand), ncol=1)
        }
        
        X <- apply(PPC.Rand, 2, function(x) {x*PPA[[region]]*Sub.DHS.Data[rand.dhs.set, cell]})
        if (is.null(dim(X))) {
          return(X)
        } else {
          return(apply(X, 2, sum))
        }
      })
      rslt <- do.call(rbind, OUT)
      
      ###############################################################################
      # Compute PP of genes being causal
      X <- apply(PPC[[region]], 2, function(x) {x*PPA[[region]]*Sub.DHS.Data[names(PPA[[region]]), cell]})  
      srt.indx <- c()
      if (is.null(dim(X))) {
        srt.indx <- 1:length(X)
        PP[[region]] <- X[srt.indx]
        PP.mat[[region]] <- X[srt.indx]
      } else {
        srt.indx <- 1:ncol(X)
        PP[[region]] <- apply(X, 2, sum)[srt.indx]
        PP.mat[[region]] <- X[,srt.indx]
      }
      
      gamma.P[[cell]] <- c()
      for (i in 1:length(PP[[region]])) {
        gene <- names(PP[[region]])[i]
        gamma.P[[cell]][gene] <- (1+length(which(rslt[,i] >= PP[[region]][gene])))/(1+nrow(rslt))
      }
      
      gamma[[cell]] <- PP[[region]]        
    }
    
    Gamma <- do.call(rbind, gamma)
    Gamma.Pvalue <- do.call(rbind, gamma.P)  
    
    save(Gamma, file=paste0(Gamma.Dir, "/Gamma-", region, ".Rdata"))
    save(Gamma.Pvalue, file=paste0(Gamma.P.Dir, "/Gamma-Pvalue-", region, ".Rdata"))
    
    pp.mat <- PP.mat[[region]]
    ppc <- PPC[[region]]
    
    save(pp.mat, file=paste0(PP.Mat.Dir, "/PP-Mat-", region, ".Rdata"))
    save(ppc, file=paste0(PPC.Dir, "/PPC-", region, ".Rdata"))
  }
}