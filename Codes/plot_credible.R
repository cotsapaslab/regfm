args <- commandArgs(TRUE)

input.path <- args[1]
output.path <- args[2]
path.to.data <- args[3]

data<- read.table(input.path, header = T)
# str(data)
table(data$inCredible)

more <- read.table(path.to.data, header = F, stringsAsFactors= F, sep="\t")
more <- as.data.frame(more)
colnames(more) <- c("Chr", "V2", "Pos", "SNP", "P")
more$Pos <- as.numeric(more$Pos)

# str(more)
chr <- head(more$Chr, 1)

tog <- merge(data, more[,c("Pos","SNP")], all.x = T, all.y = F)
# str(tog)

library(ggplot2)

tog$logP <- -log10(tog$P)
a <- ggplot(tog, aes(Pos/1000000, logP, color = factor(inCredible))) + geom_point() + theme_bw()

a <- a + ggtitle("Credible interval plot")

# Set up the axes
a <- a + ylab(expression(paste('-log'[10],italic('(P)')))) + xlab(paste("Chromosome ", chr, " position (Mb)", sep = ""))

a <- a + geom_abline(intercept = -log10(0.05), slope = 0, colour = "blue")

# Draw abline at Bonferroni corrected -logp
# a <- a + geom_abline(intercept = -log10(0.05/length(more$P)), slope = 0, colour = "green")
a <- a + geom_abline(intercept = -log10(5e-8), slope = 0, colour = "green")

# Fix legend
a <- a + scale_color_discrete(name = "In credible interval", labels = c("No", "Yes"))

a <- a + theme(plot.title = element_text(face = "bold", size = 16),
	       legend.position = "top", 
               axis.text.x = element_text(size = 14), 
               axis.text.y = element_text(size = 14),
               axis.title.x = element_text(size = 14),
               axis.title.y = element_text(size = 14))


pdf(output.path)
a
dev.off()
