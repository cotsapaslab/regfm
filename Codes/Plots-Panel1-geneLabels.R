plot.panel1.geneLabels <- function(X, region.start, region.end, out.path) {
  xlim=c(region.start, region.end)/1000000
  ylim=c(-4,4)
  
  indx <- sort(X[,"txStart"], decreasing=F, index.return=T)$ix
  X <- X[indx,]
  
  par(mar=c(0,5,0,0)+0.1)
  plot(NA, xlim=xlim, ylim=ylim, xaxt='n', yaxt='n', ann=FALSE, bty ="n")
  
  for (i in 1:nrow(X)) {
    my.x <- (as.numeric(X[i,"txStart"]) + as.numeric(X[i,"txEnd"]))/2000000
    my.y <- (-1)^i
    my.lbl <- X[i, "hugoGene"]
    
    strt <- as.numeric(X[i,"txStart"])/1000000
    end <- as.numeric(X[i,"txEnd"])/1000000
    
    segments(x0=strt, y0=my.y, x1=end, y1=my.y)
    text(x=(strt+end)/2, y = 2.5*my.y, labels=my.lbl, cex=1.3, srt=0)
  }
}