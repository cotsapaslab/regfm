args <- commandArgs(TRUE)

trait=args[1]
path.to.data <- args[2]
path.to.cred.input <- args[3]
chr.snpid <- args[4]
Work.Dir <- args[5]

data <- read.table(paste(Work.Dir, "/ld_results/", trait, "/ld_with_", chr.snpid, ".ld", sep=""), header = T, stringsAsFactors=F)
more <- read.table(path.to.data, header = F, stringsAsFactors= F, sep="\t")
colnames(more) <- c("Chr", "V2", "Pos", "SNP", "P")
names(data)[c(6:7)] <- c("SNP", "R2")
# names(more)[c(5,10)] <- c("SNP", "P")

# tog <- merge(data[c(6:7)], more[c(5,10)], all.x = T, all.y = F)
tog <- merge(data[c("SNP", "R2")], more[c("SNP", "P")], all.x = T, all.y = F)

out <- as.data.frame(cbind(tog$SNP, tog$P, tog$R2))
names(out) <- c("SNP", "P", "R2")
write.table(out, paste(path.to.cred.input, "/credible_input_", chr.snpid, ".txt", sep=""), quote = F, row.names = F, col.names = T)

noNa.out <- out
rm.indx <- which(is.na(out[,"P"]))
if (length(rm.indx) > 0) { noNa.out <- out[-rm.indx,]}
write.table(noNa.out, paste(path.to.cred.input, "/credible_input_noNA_", chr.snpid, ".txt", sep=""), quote = F, row.names = F, col.names = T)