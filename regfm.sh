#!/bin/bash

########################################################################################################################
################ 		    Input Variables - Edit This Section Before Running		        ################
########################################################################################################################

maindir=<WORKINGDIR>

## LD reference panel
KGEurDir=$maindir/BigData/1000Genome/European

## uncomment and edit these variables if plink and bedtools are not in your default path
## Otherwise keep them commented

## plink path
#export PATH=$PATH:<PLINKDIR>

## bedtools path
#export PATH=$PATH:<BEDTOOLSDIR>

########################################################################################################################
################ 				DO NOT EDIT BELOW THIS POINT 				################
########################################################################################################################
## log all bash script actions
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1
## Everything below will be directed to the file 'log.out'


trait=$1
TraitType=$trait
bigdatadir=$maindir/BigData
codesdir=$maindir/Codes
datadir=$maindir/Data
creddir=$maindir/credible_analysis/$TraitType
rdatadir=$maindir/Rdata/$TraitType
figdir=$maindir/Figures/$TraitType
tabledir=$maindir/Tables/$TraitType
beddir=$maindir/BedData/$TraitType

cd $maindir

########################################################################################################################
## Make required directories
mkdir $maindir/ld_results
mkdir $maindir/ld_results/$TraitType

mkdir $maindir/Data/perRegion-1000Genome
mkdir $maindir/Data/perRegion-DHS-Gene-Corr

mkdir $maindir/credible_analysis
mkdir $maindir/credible_analysis/$TraitType
mkdir $maindir/credible_analysis/$TraitType/credible_input
mkdir $maindir/credible_analysis/$TraitType/credible_output
mkdir $maindir/credible_analysis/$TraitType/credible_plot

mkdir $maindir/Rdata
mkdir $maindir/Rdata/$TraitType
mkdir $maindir/Rdata/$TraitType/Crr-Pval-Mat

mkdir $maindir/Figures
mkdir $maindir/Figures/$TraitType

mkdir $maindir/Tables
mkdir $maindir/Tables/$TraitType

mkdir $maindir/BedData
mkdir $maindir/BedData/$TraitType
mkdir $maindir/BedData/$TraitType/allSNPs-perRegion

mkdir $maindir/Data/perRegion-DHS-Gene-Corr
mkdir $maindir/Data/perRegion-DHS-Gene-Corr/$TraitType

mkdir $maindir/Figures/$TraitType

cp $maindir/BedData/DHS-Data-Extn-Sorted.bed  $maindir/BedData/$TraitType/DHS-Data-Extn-Sorted.bed

########################################################################################################################
## Split all SNPs association data based on chromosome number
for num in {1..22}; do
   awk -v regionChr=chr$num '$1 == regionChr' $beddir/allSNPs.bed > $beddir$temp.bed
   awk '{ print $4 "	" $3 "	" $5}' $beddir$temp.bed >  $datadir/perChr-$TraitType/allSNPs-chr-without-header-chr$num.txt
   awk 'BEGIN {print "SNP\tPos\tP"} {print}' $datadir/perChr-$TraitType/allSNPs-chr-without-header-chr$num.txt > $datadir/perChr-$TraitType/allSNPs-chr$num.txt
   
   rm $beddir$temp.bed
   rm $datadir/perChr-$TraitType/allSNPs-chr-without-header-chr$num.txt
done

########################################################################################################################
## Sort bed files and find which SNPs overlap each region
sort -k1,1 -k2,2n ./BedData/$TraitType/allSNPs.bed > ./BedData/$TraitType/allSNPs-Sorted.bed

########################################################################################################################
## Identify credible interval SNPs
RScript $codesdir/Prepare-Credible-Analysis-Script.R $TraitType $maindir $bigdatadir $KGEurDir

chmod +x $codesdir/run-all-credible-$TraitType.sh
chmod +x $codesdir/Credible-Set-Analysis.sh

$codesdir/run-all-credible-$TraitType.sh

## Get the results of credible interval analysis as input, and output a data file in .Bed format that contains positions of credible interval SNPs, their P values, and their R2 with the lead SNP.
RScript $codesdir/Extract-CredibleSNPsSet.R $TraitType $maindir

########################################################################################################################
## Extract boundaries of 2Mbp regions centered on lead SNPs.
RScript $codesdir/Prepare-Regions-Information.R $TraitType $maindir

## Get the per-chromosome DHS-gene correlation matrix, and output a subset of this matrix that includes DHS and genes overlapping each 2Mbp region only.
Rscript $codesdir/Extract-Crr-Pval.R $TraitType $maindir

########################################################################################################################
## Overlap credible set SNPs and DHS clusters to identify candidate DHS clusters
sort -k1,1 -k2,2n ./BedData/$TraitType/credSNPs.bed > ./BedData/$TraitType/credSNPs-Sorted.bed
bedtools intersect -a ./BedData/$TraitType/credSNPs-Sorted.bed -b ./BedData/$TraitType/DHS-Data-Extn-Sorted.bed -wo > ./BedData/$TraitType/credSNP-DHS-Ovrlp.bed

## Overlap all GWAS SNPs and DHS clusters
sort -k1,1 -k2,2n ./BedData/$TraitType/allSNPs.bed > ./BedData/$TraitType/allSNPs-Sorted.bed
bedtools intersect -a ./BedData/$TraitType/allSNPs-Sorted.bed -b ./BedData/$TraitType/DHS-Data-Extn-Sorted.bed -wo > ./BedData/$TraitType/allSNP-DHS-Ovrlp.bed

########################################################################################################################
## Identify candidate DHS clusters that overlap CI SNPs, and the genes correlated to them.
Rscript $codesdir/credSNPs-DHS-Extn-CrrGene-Annot.R $TraitType $maindir

## Generate a matrix of correlation P values between DHS clusters overlapping the locus and all genes in the genome.
Rscript $codesdir/Prepare-Crr-Pval.R $TraitType $maindir $bigdatadir

## Compute permutation-based P value between each candidate DHS and the genes overlapping 2Mbp region 
## to completely remove inflation in the P values test statistics.
Rscript $codesdir/Compute-RTC-Pvalue.R $TraitType $maindir $bigdatadir

## Compute posterior probability of association per CI SNPs, per DHS cluster, and per genes; and
## Rank genes based on their posterior probability of associations.
Rscript $codesdir/Rank-Genes-v2.R $TraitType $maindir
Rscript $codesdir/Extract-Candidate-Genes.R $TraitType $maindir

########################################################################################################################
## Report statistics for credible interval SNPs, DHS clusters and genes.
Rscript $codesdir/Statistics-v2.R $TraitType $maindir

## Plot multi-panel graphs
$codesdir/Allele-Specific-Preparation.sh $trait $maindir
Rscript $codesdir/Plots-Multi-Panel.R $TraitType $maindir

## Remove unnecessary tables
cd $maindir/Tables/$TraitType
ls | grep -v Summary-Table-$TraitType.txt | xargs rm