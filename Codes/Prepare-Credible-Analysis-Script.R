###############################################################################
##################             Code Description             ###################
###############################################################################
# This code gets a list of independent lead SNPs (i.e. most significant SNPs) 
# as inputs, and returns a .sh script which is used to run credible interval 
# analysis for each lead SNP seperately.

###############################################################################
##################               Initialization             ###################
###############################################################################
rm(list=ls())
args <- commandArgs(TRUE)
trait.type <- args[1]
Work.Dir <- args[2]
Big.Data.Dir <- args[3]
KGEurDir <-  args[4]

lead.path <- paste0(Work.Dir, "/BedData/", trait.type, "/LeadSNPs.txt")

###############################################################################
###############               Preparing .sh Script             ################
###############################################################################
leadSNPs <- read.table(lead.path, sep="\t", stringsAsFactors=F, header=T)

A <- cbind(rep("./Credible-Set-Analysis.sh", times=nrow(leadSNPs)),
           rep(trait.type, times=nrow(leadSNPs)),
           paste0("chr", leadSNPs[, "Chr"]),
           leadSNPs[, "Position"],
           leadSNPs[, "SNP"],
           rep(Work.Dir, times=nrow(leadSNPs)),
           rep(Big.Data.Dir, times=nrow(leadSNPs)),
           rep(KGEurDir, times=nrow(leadSNPs)))

write.table("#!/bin/bash", file=paste0(Work.Dir, "/Codes/run-all-credible-", trait.type, ".sh"), quote=F, row.names=F, col.names=F, append=F, sep="\t")
write.table(paste0("cd ", Work.Dir, "/Codes"), file=paste0(Work.Dir, "/Codes/run-all-credible-", trait.type, ".sh"), quote=F, row.names=F, col.names=F, append=T, sep="\t")
write.table(A, file=paste0(Work.Dir, "/Codes/run-all-credible-", trait.type, ".sh"), quote=F, row.names=F, col.names=F, append=T, sep="\t")