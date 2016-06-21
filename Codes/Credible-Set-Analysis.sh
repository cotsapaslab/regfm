#!/bin/bash

TraitType=$1
chr=$2
pos=$3
snpid=$4
maindir=$5
bigdatadir=$6
KGEurDir=$7


codesdir=$maindir/Codes
perRegionKG=$maindir/Data/perRegion-1000Genome/$TraitType
mkdir $perRegionKG


regionStart=$[$pos-1000000]
regionEnd=$[$pos+1000000]
regionChr=$chr

awk -v regionStart=$regionStart -v regionEnd=$regionEnd '{if($4 > regionStart && $4 < regionEnd) print $2}' $KGEurDir/ALL_$chr.bim > $perRegionKG/$chr$snpid.extract.bim
plink --bfile $KGEurDir/ALL_$chr --extract $perRegionKG/$chr$snpid.extract.bim --make-bed --out $perRegionKG/$chr$snpid
plink --bfile $perRegionKG/$chr$snpid --r2 --ld-snp $snpid --ld-window-kb 2000 --ld-window-r2 0 --ld-window 99999 --out $maindir/ld_results/$TraitType/ld_with_$chr$snpid

awk -v regionStart=$regionStart -v regionEnd=$regionEnd -v regionChr=$regionChr '{if ($3 >= regionStart && $3 <= regionEnd && $1 == regionChr) print $1 "	" $2 "	" $3 "	" $4 "	" $5 }' $maindir/BedData/$TraitType/allSNPs-Sorted.bed > $maindir/BedData/$TraitType/allSNPs-perRegion/$chr$snpid.bed

Rscript $codesdir/merge.R $TraitType $maindir/BedData/$TraitType/allSNPs-perRegion/$chr$snpid.bed  $maindir/credible_analysis/$TraitType/credible_input $chr$snpid $maindir

Rscript $codesdir/getCredible.R $maindir/credible_analysis/$TraitType/credible_input/credible_input_noNA_$chr$snpid.txt $maindir/credible_analysis/$TraitType/credible_output/credible_output_$chr$snpid.txt

# Plot region with SNPs in credible interval color coded
Rscript $codesdir/plot_credible.R $maindir/credible_analysis/$TraitType/credible_output/credible_output_$chr$snpid.txt $maindir/credible_analysis/$TraitType/credible_plot/credible_interval_plot_$chr$snpid.pdf $maindir/BedData/$TraitType/allSNPs-perRegion/$chr$snpid.bed