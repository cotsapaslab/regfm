#!/bin/bash

## Get inputs
maindir=$1
TraitType=$2
chunk=$3
iter2=$4

########################################################################################################################
echo $chunk

########################################################################################################################
## Initialization
codesdir=$maindir/Codes
beddir=$maindir/BedData/$TraitType

cd $maindir

echo $TraitType

########################################################################################################################
for file in $beddir/perLocus-DHS/*
do
  region=${file##*/}
  echo $region
  
  mkdir -p $beddir/perLocus-Shuffled-Extended-DHS/$region
  mkdir -p $beddir/perLocus-CI-DHS-Overlap/$region
  mkdir -p $maindir/Rdata/$TraitType/PPD/$region
  mkdir -p $maindir/Rdata/$TraitType/PPG/$region
  
  sort -k1,1 -k2,2n $beddir/perLocus-credSNPs/$region > $beddir/perLocus-credSNPs/$region-Sorted
  
  for i in `seq 1 $iter2`; do
    bedtools shuffle -i $beddir/perLocus-DHS/$region -g $maindir/BedData/hg19.genome -incl $beddir/perLocus-Regions/$region -noOverlapping | bedtools slop -g $maindir/BedData/hg19.genome -b 100 > $beddir/perLocus-Shuffled-Extended-DHS/$region/$region-$chunk-$i
    sort -k1,1 -k2,2n $beddir/perLocus-Shuffled-Extended-DHS/$region/$region-$chunk-$i > $beddir/perLocus-Shuffled-Extended-DHS/$region/$region-$chunk-$i-Sorted 
    bedtools intersect -a $beddir/perLocus-credSNPs/$region-Sorted -b $beddir/perLocus-Shuffled-Extended-DHS/$region/$region-$chunk-$i-Sorted -wo > ./BedData/$TraitType/perLocus-CI-DHS-Overlap/$region/$region-$chunk-$i.bed
    
    rm $beddir/perLocus-Shuffled-Extended-DHS/$region/$region-$chunk-$i
    rm $beddir/perLocus-Shuffled-Extended-DHS/$region/$region-$chunk-$i-Sorted
  done
done