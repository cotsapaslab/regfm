# paired.boxplot.v2 <- function(obj, gene = "gene", condition = "dhs.on.off",
#                           value="geneExp",colors=c("#fc8d62","#8da0cb"),
#                           bar = 0.20, ...) {
# create a minimal, *paired boxplot* for comparing observations
# under two conditions for multiple entities. For example, gene
# expression levels across samples modulo condition, for multiple
# genes

options( digits = 6 )
dhs <- "dhs.id"
gene <- "gene"
condition <- "dhs.on.off"
value <- "geneExp"
colors <- c("#8da0cb", "#fc8d62")
bar <- 0.20

gene.names <- unique(obj[,gene])
dhs.names <- unique(obj[,dhs])
conditions <- c(0,1)

min.expr <- round(min(obj[,value]))
max.expr <- round(max(obj[,value]))

y.lbl <- seq(floor(min.expr), floor(max.expr)+1, by=2)

N <- length(dhs.names)
L0 <- 0.8
L <- 5/4*L0
if (N != 1) {
  delta1 <- 2/7*L
} else {
  delta1 <- 0
}
st <- (L-delta1*(N-1))/2

x.space <- c()
for (i in 1:length(gene.names)) {
  x <- seq(st, L-st, by=delta1) + (i-1) * (7/6*L)
  x.space <- c(x.space, x)
}
x.space <- x.space + L0

# print(as.list(as.character(dhs.names)))
x.lbl <- rep(unlist(lapply(as.list(as.character(dhs.names)), function(x) {unlist(strsplit(x,"-"))[1]})), times=length(gene.names))


colnames(P.mat) <- unlist(lapply(as.list(colnames(P.mat)), function(x) {unlist(strsplit(x,"-"))[3]}))

pval.lbl <- round(c(P.mat[as.character(dhs.names),as.character(gene.names)]),2)


par(mar=c(5,5,0,0)+0.1)
plot(1, type="n", axes=F,
     xlim=c(0.5, max(x.space)+0.4/length(dhs.names)),
     ylim= range(y.lbl), # range(obj[,value]),
     xlab="", ylab="")
axis(side=1, at = x.space, labels=FALSE, tick=T,las=2, col="darkgrey")
axis(side=2, at=y.lbl, labels = FALSE, tick=T, col="darkgrey")
mtext(side=2, text="Gene Expression \n by DHS State", line=2, col="darkgrey")
text(y = y.lbl, par("usr")[1], labels = y.lbl, srt = 0, pos = 2, xpd = TRUE, col="darkgrey")
text(x = x.space, y=min(y.lbl)-1.2, labels = x.lbl, srt = 90, pos = 1, xpd = TRUE, cex=1, col="darkgrey")
# box()
text(x=x.space[1]-0.65*L0, y=max(y.lbl), labels="DHS State")
legend(0, max(y.lbl), c("Absent","Present"), lty=c(1,1), lwd=c(2.5,2.5), col=colors, bty="n")

for(i in 1:length(gene.names)) {
  for (j in 1:length(dhs.names)) {
    k <- length(dhs.names) * (i-1) + j
    
    cond1.ix <- which(obj[,gene] == gene.names[i] & obj[,dhs] == dhs.names[j] & obj[,condition] == conditions[1])
    cond2.ix <- which(obj[,gene] == gene.names[i] & obj[,dhs] == dhs.names[j] & obj[,condition] == conditions[2])
    
    ## add vertical lines spanning boxplot whiskers
    lines(x=rep(x.space[k],2),
          y=range(obj[c(cond1.ix, cond2.ix), value]), col="darkgrey")
   
    if (length(cond1.ix) > 0) {
      for (n in 1:length(cond1.ix)) {
        lines(x=c(x.space[k], x.space[k]-(bar/2)),
              y=rep(obj[cond1.ix[n],value],2), col=colors[1], lwd=1)
      }
    }
    
    if (length(cond2.ix) > 0) {
      for (n in 1:length(cond2.ix)) {
        lines(x=c(x.space[k], x.space[k]+(bar/2)),
              y=rep(obj[cond2.ix[n],value],2), col=colors[2], lwd=1)
      }
    }
  }
}

par(mar=c(2,5,0,0)+0.1)
stars <- rep("", times=length(pval.lbl))
stars[which(pval.lbl <= 0.05)] <- "*"
mycol <- rep("black", times=length(pval.lbl))
mycol[which(pval.lbl <= 0.05)] <- "red"
pval.lbl[pval.lbl == 0] <- "< 0.005"
pval.lbl <- paste0(pval.lbl, stars)

plot(1, type="n", axes=F,
     xlim=c(0.5, max(x.space)+0.4/length(dhs.names)),
     ylim= c(-1,1),
     xlab="", ylab="")
axis(side=1, at = x.space, labels=FALSE, tick=F,las=2)
axis(side=2, at=y.lbl, labels = FALSE, tick=F)
mtext(side=2, text="P Value", line=2, col="darkgrey")
text(x = x.space, y=0, labels = pval.lbl, srt = 45, pos = 1, xpd = TRUE, cex=1, col=mycol)