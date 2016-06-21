plot.panel2 <- function(region, ppa, ppc, pp.mat, status) {  
  ###############################################################################
  ##################               Initialization             ###################
  ###############################################################################
  burdDHS.starts <-as.numeric(unlist(lapply(names(ppa), function(x) {unlist(strsplit(x,"-"))[2]})))
  burdDHS.ends <- as.numeric(unlist(lapply(names(ppa), function(x) {unlist(strsplit(x,"-"))[3]})))
  names(burdDHS.starts) <- names(burdDHS.ends) <- names(ppa)
  
  min.dhs.pos <- min(burdDHS.starts) - 100
  max.dhs.pos <- max(burdDHS.ends) + 100
  
  # Adjusted length between DHSs in the genome  
  l1 <- log(burdDHS.ends[-1] - burdDHS.ends[-length(burdDHS.ends)])
  if (length(ppa) > 2) {
    mn <- min(l1); mx <- max(l1)
    a <- (800-100)/(mx-mn)
    b <- (100*mx-800*mn)/(mx-mn)
    dhs.line.width <- a*l1 + b
  } else {
    if (length(ppa) == 2) {
      dhs.line.width <- (800-100)/2
    } else {
      dhs.line.width <- 0
    }
  } 
  
  # Set parameters for DHSs and genes boxes
  gene.line.width <- 200
  dhs.box.width <- 400
  gene.box.width <- 1200
  box.height <- 300
  h <- box.height/2
  H <- -6*h
  
  K <- 33
  rg <- colorpanel(K, "grey", "red")
  
  # This is for plotting legends
  my.palette <- rg
  
  
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
  
  ###############################################################################
  ##################              Define Functions             ##################
  ###############################################################################
  ## Add an alpha value to a colour
  add.alpha <- function(col, alpha=1){
    if(missing(col))
      stop("Please provide a vector of colours.")
    apply(sapply(col, col2rgb)/255, 2, 
          function(x) 
            rgb(x[1], x[2], x[3], alpha=alpha))  
  }
  
  adj.name.func <- function(x) {
    y <- unlist(strsplit(x,"-"))[-c(1,2)]
    return(paste(y, collapse="-"))
  }
  
  ###############################################################################
  ##################                      Plots                ##################
  ###############################################################################  
  # print(region)  
  
  pp.mat <- pp.mat[, srt.genes] 
  ppc <- ppc[, srt.genes]  
  if (!is.matrix(pp.mat)) {
    if (length(ppa) == 1) {
      ppc <- matrix(ppc, nrow=1, dimnames=list(names(ppa), srt.genes))
      pp.mat <- matrix(pp.mat, nrow=1, dimnames=list(names(ppa), srt.genes))
    } else {
      ppc <- matrix(ppc, ncol=1, dimnames=list(names(ppa), srt.genes))
      pp.mat <- matrix(pp.mat, ncol=1, dimnames=list(names(ppa), srt.genes))
    }
  }
  
  
  dhs.ids <- names(ppa)
  ppg <- apply(pp.mat, 2, sum)
  gene.names <- colnames(pp.mat)
  gene.names <- unlist(lapply(as.list(gene.names), adj.name.func))
  
  total.ppa <- sum(ppa)
  norm.ppa <- ppa/total.ppa
  norm.ppg <- ppg/total.ppa  
  num.dhs <- length(ppa)
  num.genes <- length(pp.mat)/num.dhs
  
  c1 <- (num.dhs+2) * dhs.box.width + sum(dhs.line.width)
  c2 <- (num.genes) * gene.box.width + (num.genes+1)*gene.line.width
  
  if (c2 > c1) {
    dhs.shift <- (c2-c1)/2
    gene.shift <- 200
    xlim <- c(0, c2)
  } else {
    gene.shift <- (c1-c2)/2
    dhs.shift <- 200
    xlim <- c(0, c1)
  }
  
  ###############################################################################
  ##############                  Plots for DHSs                  ###############
  ###############################################################################
  # Setting parameters of boxes for DHSs
  box.ends <- c()
  box.ends[1] <- dhs.shift + 2 * dhs.box.width
  if (num.dhs >= 2) {
    for (cnt in 2:num.dhs) {
      box.ends[cnt] <- dhs.shift + dhs.box.width + cnt * dhs.box.width + sum(dhs.line.width[1:(cnt-1)])
    }
  }
  
  box.starts <- box.ends - dhs.box.width
  #box.starts <- mapply(convr, burdDHS.starts)
  box.bottom <- rep(-h, times=num.dhs)
  box.top <- rep(h, times=num.dhs)
  
  # Setting parameters of segments for DHSs
  seg.starts <- c(dhs.shift, box.ends)
  seg.ends <- c(box.starts, c1+dhs.shift)
  
  seg.bottom <- rep(0, times=num.dhs+1)
  seg.top <- rep(0, times=num.dhs+1)
  
  # Setting plot parameters
  ylim <- c(H-2*h, 2*h)
  cols <- rg[round((K-1)*norm.ppa+1)]
  
  par(mar=c(0,5,0,0)+0.1)
  plot(NA, xlim=xlim, ylim=ylim, xaxt='n', yaxt='n', ann=FALSE, bty ="n", yaxs="i")
  
  rect(xleft=box.starts, ybottom=box.bottom, xright=box.ends, ytop=box.top, col=cols)
  segments(x0=seg.starts, y0=seg.bottom, x1=seg.ends, y1=seg.top)
  
  box.cntr.dhs <- (box.starts + box.ends)/2
  names(box.cntr.dhs) <- names(norm.ppa)
  
  ###############################################################################
  #############                  Plots for Genes                  ###############
  ###############################################################################
  # Setting parameters of boxes for genes
  box.ends <- (1:num.genes) * (gene.line.width + gene.box.width) + gene.shift
  box.starts <- box.ends - gene.box.width
  box.cntr.genes <- (box.starts + box.ends)/2
  box.bottom <- rep(-h, times=num.genes) + H
  box.top <- rep(h, times=num.genes) + H
  
  # Setting parameters of segments for genes
  seg.starts <- c(box.starts-gene.line.width, box.ends[num.genes])
  seg.ends <- seg.starts + gene.line.width
  seg.bottom <- rep(0, times=num.genes+1) + H
  seg.top <- rep(0, times=num.genes+1) + H
  
  # Setting plot parameters
  cols <- rg[round((K-1)*norm.ppg+1)]
  
  rect(xleft=box.starts, ybottom=box.bottom, xright=box.ends, ytop=box.top, col=cols)
  segments(x0=seg.starts, y0=seg.bottom, x1=seg.ends, y1=seg.top)
  
  box.cntr.genes <- (box.starts + box.ends)/2
  names(box.cntr.genes) <- names(norm.ppg)
  
  ###############################################################################
  #############             Plots for DHS-Gene Link               ###############
  ###############################################################################
  my.col <- ppc
  my.col[ppc==0] <- NA
  for (dhs in names(norm.ppa)) {
    x1 <- rep(box.cntr.dhs[dhs], times=length(box.cntr.genes))
    x0 <- box.cntr.genes
    y0 <- rep(H+h, times=length(box.cntr.genes)) 
    y1 <- rep(-h, times=length(box.cntr.genes))
    lwds <- (2-1)*ppc[dhs, names(box.cntr.genes)] + 1
    segments(x0, y0, x1, y1, col=add.alpha("lightgrey", alpha=as.numeric(ppc[dhs,names(box.cntr.genes)])>0), lw=lwds)
  }
  
  dhs.labels <- 1:length(dhs.ids)

  gene.labels <- unlist(lapply(as.list(1:length(gene.names)), function(i) {
    gene <- gene.names[i]
  }))
  
  # print(sum(ppa))
  # print(sum(pp.mat))
  
  text(x=box.cntr.genes, y = rep(H, times=length(gene.names)), labels=gene.labels, cex=1.3)
  text(x=box.cntr.dhs, y = rep(0, times=length(dhs.ids)), labels=dhs.labels, cex=1.3)
  text(x=-200, y = 0, labels="DHS", cex=1.5)
  text(x=-200, y = H, labels="Gene", cex=1.5)
}