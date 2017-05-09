#!/bin/bash

## Get inputs
maindir=$1
TraitType=$2

########################################################################################################################
echo $maindir

########################################################################################################################
## Initialization
codesdir=$maindir/Codes
beddir=$maindir/BedData/$TraitType

echo $TraitType

########################################################################################################################
## Make required directories
mkdir -p $maindir/BedData
mkdir -p $maindir/BedData/$TraitType

mkdir -p $maindir/Rdata/$TraitType/PPD
mkdir -p $maindir/Rdata/$TraitType/PPG

mkdir -p $beddir/perLocus-DHS
mkdir -p $beddir/perLocus-Regions
mkdir -p $beddir/perLocus-Shuffled-Extended-DHS
mkdir -p $beddir/perLocus-credSNPs
mkdir -p $beddir/perLocus-CI-DHS-Overlap

########################################################################################################################
## Extract credible set SNPs
RScript $codesdir/Extract-CredibleSNPsSet-v2.R $TraitType $maindir

## Overlap credible set SNPs and DHSs to identify burdened DHSs
sort -k1,1 -k2,2n $maindir/BedData/$TraitType/credSNPs-v2.bed > $maindir/BedData/$TraitType/credSNPs-v2-Sorted.bed
bedtools intersect -a $maindir/BedData/$TraitType/credSNPs-v2-Sorted.bed -b $maindir/BedData/$TraitType/DHS-Data-Extn-Sorted.bed -wo > $maindir/BedData/$TraitType/credSNP-v2-DHS-Ovrlp.bed
sort -k1,1 -k2,2n $maindir/BedData/$TraitType/credSNP-v2-DHS-Ovrlp.bed > $maindir/BedData/$TraitType/credSNP-v2-DHS-Ovrlp-Sorted.bed

########################################################################################################################
## Overlap Region Info and DHS Clusters
sort -k1,1 -k2,2n $maindir/BedData/$TraitType/Region-Info.bed > $maindir/BedData/$TraitType/Region-Info-Sorted.bed
bedtools intersect -a $maindir/BedData/DHS-Data-Sorted.bed -b $maindir/BedData/$TraitType/Region-Info-Sorted.bed -wo > $maindir/BedData/$TraitType/DHS-RegionInfo-Ovrlp.bed

Rscript $codesdir/Rho-perLocus-DHS-Region.R $TraitType $maindir
Rscript $codesdir/Rho-getCredible.R $TraitType $maindir