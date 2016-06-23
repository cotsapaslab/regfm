#!/bin/bash

maindir=$1
software=$2

mkdir $maindir/Rdata
mkdir $maindir/Data
mkdir $maindir/BedData
mkdir $maindir/BigData

cd $maindir

if [ $software == 'wget' ]
then
   echo wget is running
   wget --max-redirect=20 -O $maindir/Rdata/Download.zip https://www.dropbox.com/sh/eun66ffs2uczbu2/AABDm0mY48dp6spAMWZYxgLya?dl=1
   wget --max-redirect=20 -O $maindir/Data/Download.zip https://www.dropbox.com/sh/x1c0yndjrz261w7/AABaBYjDv_HowIv2zh0LoAaya?dl=1
   wget --max-redirect=20 -O $maindir/BedData/Download.zip https://www.dropbox.com/sh/lvnbn98m0b58ro0/AAC3_a3AkwF6a85O0spTbfvqa?dl=1
   #wget --max-redirect=20 -O $maindir/BigData/Download.zip https://www.dropbox.com/sh/h9v0s004y1nkupm/AAD7HUb6WY3TIJMvtKRuAnaja?dl=1
else
   echo curl is running
   curl -L https://www.dropbox.com/sh/eun66ffs2uczbu2/AABDm0mY48dp6spAMWZYxgLya?dl=1 > $maindir/Rdata/Download.zip  
   curl -L https://www.dropbox.com/sh/x1c0yndjrz261w7/AABaBYjDv_HowIv2zh0LoAaya?dl=1 > $maindir/Data/Download.zip
   curl -L https://www.dropbox.com/sh/lvnbn98m0b58ro0/AAC3_a3AkwF6a85O0spTbfvqa?dl=1 > $maindir/BedData/Download.zip
   # curl -L https://www.dropbox.com/sh/ekrfk1z7bwq7201/AAA6wLBM0tA6AVeAX5deKtija?dl=1 > $maindir/BigData/1000Genome/Download.zip
fi

cd ./Rdata
unzip Download.zip
rm Download.zip
cd ..

cd ./Data
unzip Download.zip
rm Download.zip
cd ..

cd ./BedData
unzip Download.zip
rm Download.zip
cd ..

#cd ./BigData
#unzip Download.zip
#rm Download.zip
#cd ..