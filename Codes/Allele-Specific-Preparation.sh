#!/bin/bash

#######################################################################################################
## Initialization

trait=$1
workdir=$2

alleleDataDir=$workdir/Data/Allele-Specific-Data
TraitType=$trait

#######################################################################################################
sort -k1,1 -k2,2n $workdir/BedData/$TraitType/credSNP-DHS-Ovrlp.bed > $workdir/BedData/$TraitType/credSNP-DHS-Ovrlp-Sorted.bed

bedtools intersect -a $workdir/BedData/$TraitType/credSNP-DHS-Ovrlp-Sorted.bed -b $alleleDataDir/Allele-Specific-UW-MAF.bed -wo > $alleleDataDir/credSNP-AlleleSpecific-Overlap-$TraitType.bed
