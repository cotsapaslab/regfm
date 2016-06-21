###############################################################################
##################               Initialization             ###################
###############################################################################
adj.name.func <- function(x) {
  y <- unlist(strsplit(x,"-"))[-c(1,2)]
  return(paste(y, collapse="-"))
}

Cell.Types <- colnames(norm.trans.exp)[-c(1:11)]

dhs.lbl <- c()
for (i in 1:length(ppa)) {
  dhs.id <- names(ppa)[i]
  x <- as.numeric(unlist(strsplit(dhs.id, "-"))[-1])
  dhs.lbl[dhs.id] <- paste0("DHS", i, "-", x[1], "+", (x[2]-x[1]))
}

###############################################################################
##################                      Plots                ##################
###############################################################################
cmsm <- cumsum(sort(ppa/sum(ppa), decreasing=T))
n.boxplt <- min(4, as.numeric(which(cmsm >= 0.95)[1]))

Top.DHSs <- names(sort(ppa, decreasing=T))[1:n.boxplt]
indx <- match(names(ppa), Top.DHSs)
indx <- indx[!is.na(indx)]
Sorted.DHSs <- Top.DHSs[indx]

final.pl <- list()
all.df <- c()
myobj <- list()
for (burdened.dhs in Sorted.DHSs) {
  region.genes <- colnames(ppc)
  n.dhs <- length(burdened.dhs)
  n.gene <- ncol(ppc)
  
  # Sort genes based on their positions on the genome
  genes <- colnames(ppc)
  srt.indx <- sort(norm.trans.exp[genes, "txStart"], index.return=T)$ix
  srt.genes <- genes[srt.indx]
  
  if (!is.matrix(pp.mat)) {
    if (length(ppa) == 1) {
      pp.mat <- matrix(pp.mat, nrow=1, dimnames=list(names(ppa), names(pp.mat)))
    } else {
      pp.mat <- matrix(pp.mat, ncol=1, dimnames=list(names(ppa), colnames(ppc)))
    }
  }
  ppg <- apply(pp.mat, 2, sum)
  names(ppg) <- colnames(pp.mat)
  
  if (status == "TopGenesOnly") {
    top.genes <- names(sort(ppg, decreasing=T))[1:min(10,length(ppg))]
    srt.genes <- intersect(srt.genes, top.genes)
  }
  
  df <- c()
  for (gene in srt.genes) {
    expr <- norm.trans.exp[gene, Cell.Types]
    dhs.on.off <- DHS.Data[burdened.dhs, Cell.Types]
    if (n.dhs == 1) {dhs.on.off <- matrix(dhs.on.off, nrow=1, dimnames=list(burdened.dhs, Cell.Types))}
    
    comb.func <- function(dhs) {
      dhs.status <- rep("Absent", times=length(Cell.Types))
      dhs.status[which(dhs.on.off[dhs, Cell.Types]==1)] <- "Present"
      return(t(rbind(geneExp=expr[Cell.Types], 
                     dhs.on.off=dhs.on.off[dhs, Cell.Types],
                     DHS.Activity=dhs.status,
                     Tissue=Cell.Types,
                     dhs=rep(dhs, times=length(Cell.Types)),
                     gene=rep(adj.name.func(gene), times=length(Cell.Types))
      )))
    }
    
    out <- lapply(as.list(burdened.dhs), comb.func)
    rslt <- do.call(rbind, out)
    df <- rbind(df, rslt)
  }
  colnames(df)[3] <- "D.Test.Activity"
  rownames(df) <- paste(df[,"gene" ], df[,"Tissue"], sep="-")
  df <- as.data.frame(df)
  
  
  df$geneExp <- as.numeric(as.character(df$geneExp))
  df$gene <- factor(df$gene, levels = unlist(lapply(as.list(srt.genes), adj.name.func)), ordered = TRUE)
  
  all.df <- rbind(all.df, df)   
  
  if (!is.null(rtc.pval)) {
    pvals <- rtc.pval[burdened.dhs, srt.genes]
  } else {
    pvals <- crr.pval.mat[burdened.dhs, srt.genes]
  }
  names(pvals) <- srt.genes
  
  x <- 1:length(srt.genes)
  y <- rep(12, length(srt.genes))
  lbl <- paste0("p=", round(pvals[srt.genes], 2))
  sz <- rep(4, length(srt.genes))
    
}

all.df <- transform(all.df, dhs.id=dhs.lbl[as.character(all.df[, "dhs"])])
all.df$dhs.id <- factor(all.df$dhs.id, levels = as.character(dhs.lbl[Sorted.DHSs]), ordered = TRUE)



P.mat <- rtc.pval
rownames(P.mat) <- dhs.lbl[rownames(rtc.pval)]

obj <- all.df
source(paste0(Work.Dir, "/Codes/paired-boxplot.R"))