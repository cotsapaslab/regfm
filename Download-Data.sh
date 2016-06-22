#!/bin/bash

########################################################################################################################
################ 		    Input Variables - Edit This Section Before Running		        ################
########################################################################################################################

maindir=$1


########################################################################################################################
################ 				DO NOT EDIT BELOW THIS POINT 				################
########################################################################################################################
mkdir $maindir/BedData
mkdir $maindir/BedData/example



wget -O $maindir/BedData/DHS-Data-Extn-Sorted.bed "https://www.dropbox.com/s/yueyoifiy98oeqr/DHS-Data-Extn-Sorted.bed?dl=0"
wget -O $maindir/BedData/example/allSNPs.bed  "https://www.dropbox.com/s/nxr61rcimdfd60o/allSNPs.bed?dl=0"
wget -O $maindir/BedData/example/LeadSNPs.txt  "https://www.dropbox.com/s/hqvyxstenow0mfx/LeadSNPs.txt?dl=0"
wget -O $maindir/BedData/example/Genecode-Sorted.bed  "https://www.dropbox.com/s/uj7hfjrvaw70ukj/Genecode-Sorted.bed?dl=0"

