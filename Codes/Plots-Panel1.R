plot.panel1 <- function(X, region, input.path, path.to.data, region.start, region.end, trait) {  
  ###############################################################################
  ##################               Initialization             ###################
  ###############################################################################
  # Set parameters for DHSs and genes boxes
  K <- 33
  rg <- colorpanel(K, "grey", "red")
  
  data <- read.table(input.path, header = T)
  table(data$inCredible)
  
  more <- read.table(path.to.data, header = F, stringsAsFactors= F, sep="\t")
  more <- as.data.frame(more)
  colnames(more) <- c("Chr", "V2", "Pos", "SNP", "P")
  more$Pos <- as.numeric(more$Pos)
  chr <- unlist(strsplit(unlist(strsplit(region, "rs"))[1], "chr"))[2]  
  tog <- merge(data, more[,c("Pos","SNP")], all.x = T, all.y = F)
  
  tog$logP <- -log10(tog$P)
  tog[is.na(tog$probNorm),"probNorm"] <- 0
  tog$CI <- "No"
  tog$CI[tog$probNorm > 0] <- "Yes"
  
  a <- region.start/1000000
  b <- region.end/1000000
  x1 <- a + 0.94*(b-a)
  x2 <- a + 0.97*(b-a)
  y1 <- 0.10*(max(-log10(tog$P)))
  y2 <- 0.80*(max(-log10(tog$P)))
  x0 <- a - 0.04*(b-a)
  
  min.expr <- round(-0.05*max(tog$logP))
  max.expr <- round(1.05*max(tog$logP))+10
  
  f <- max(tog$logP)
  if(f <= 5) {steps <- 1} else {if(f <= 10) {steps<-2} else {if(f <= 15) {steps<-20} else {if(f <= 25) {steps<-5} else {if(f <= 30) {steps<-6} else {steps<-10}}}} }
  
  y.lbl <- round(seq(0, max(tog$logP), by=steps)) # seq(0, max.expr, by=10)
  x.lbl <- seq(round(a,2), round(b,2), by=0.5)
  # print(x.lbl)
  
  # print(y.lbl)
  par(mar=c(0,5,5,0)+0.1)
  cols <- rg[round((K-1)*tog$probNorm+1)]
  plot(tog$Pos/1000000, -log10(tog$P), axes=FALSE, ann=FALSE,
       pch=18, col=cols, cex=1*(1+tog$probNorm),
       xlim=c(region.start/1000000, region.end/1000000),
       ylim=c(-0.05*max(tog$logP), 1.05*max(tog$logP))) 
  axis(side=3, at=x.lbl, labels = FALSE, tick=T, col="darkgrey")
  axis(side=2, at=y.lbl, labels = FALSE, tick=T, col="darkgrey")
  text(y = y.lbl, par("usr")[1], labels = y.lbl, srt = 0, pos = 2, xpd = TRUE, col="darkgrey")
  text(x = x.lbl, y=1.15*max(tog$logP), labels = x.lbl, srt = 0, pos = 3, xpd = TRUE, col="darkgrey")
  mtext(paste("Position on Chromosome", chr, "(Mbp)"), side=3, line=3, col="darkgrey")  
  mtext(paste0(trait, " GWAS", "\n", "-log10(P)"), side=2, line=2, col="darkgrey")
  
  pnts <- cbind(c(x1,x2,x2,x1),
                c(y1,y2,y2,y1))
  legend.gradient(pnts, cols = rg, c(0,round(max(tog$probNorm),2)), title="Posterior")  
}