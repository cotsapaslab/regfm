#!/bin/bash

maindir=$1
software=$2

mkdir $maindir/Rdata
mkdir $maindir/Data
mkdir $maindir/BedData
mkdir $maindir/BigData
mkdir $maindir/BigData/Crr-Pval-Mat-PerChr
mkdir $maindir/BigData/Full-State
mkdir $maindir/BigData/1000Genome
mkdir $maindir/BigData/1000Genome/European

cd $maindir

if [ $software == 'wget' ]
then
   echo wget is running
   wget --max-redirect=20 -O $maindir/Rdata/Download.zip https://www.dropbox.com/sh/eun66ffs2uczbu2/AABDm0mY48dp6spAMWZYxgLya?dl=1
   wget --max-redirect=20 -O $maindir/Data/Download.zip https://www.dropbox.com/sh/x1c0yndjrz261w7/AABaBYjDv_HowIv2zh0LoAaya?dl=1
   wget --max-redirect=20 -O $maindir/BedData/Download.zip https://www.dropbox.com/sh/lvnbn98m0b58ro0/AAC3_a3AkwF6a85O0spTbfvqa?dl=1
   
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr1.Rdata https://www.dropbox.com/s/qva5y5htribtwfu/Crr-pval-mat-chr1.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr2.Rdata https://www.dropbox.com/s/504u077j31v7psn/Crr-pval-mat-chr2.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr3.Rdata https://www.dropbox.com/s/huz1qm24b9xbgbw/Crr-pval-mat-chr3.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr4.Rdata https://www.dropbox.com/s/0xw0d69ro9nqnag/Crr-pval-mat-chr4.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr5.Rdata https://www.dropbox.com/s/2n12g38rw1okkid/Crr-pval-mat-chr5.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr6.Rdata https://www.dropbox.com/s/w8zap2qo31vb92k/Crr-pval-mat-chr6.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr7.Rdata https://www.dropbox.com/s/ak4qjzb55cjgz31/Crr-pval-mat-chr7.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr8.Rdata https://www.dropbox.com/s/7m09mp8pspklf8f/Crr-pval-mat-chr8.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr9.Rdata https://www.dropbox.com/s/9qogupgst8sg96e/Crr-pval-mat-chr9.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr10.Rdata https://www.dropbox.com/s/iv0kw1ix58q947r/Crr-pval-mat-chr10.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr11.Rdata https://www.dropbox.com/s/9yfgf752lh95jxa/Crr-pval-mat-chr11.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr12.Rdata https://www.dropbox.com/s/obpd32ob8ykq3xk/Crr-pval-mat-chr12.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr13.Rdata https://www.dropbox.com/s/gak6e9tmj9l7py2/Crr-pval-mat-chr13.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr14.Rdata https://www.dropbox.com/s/0xp9xg1uh5uawsr/Crr-pval-mat-chr14.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr15.Rdata https://www.dropbox.com/s/zdaeyeagxu9dmls/Crr-pval-mat-chr15.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr16.Rdata https://www.dropbox.com/s/bdtzcbyj9d43cj5/Crr-pval-mat-chr16.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr17.Rdata https://www.dropbox.com/s/awwznb4807habhw/Crr-pval-mat-chr17.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr18.Rdata https://www.dropbox.com/s/8mh2hl6tpiihmd3/Crr-pval-mat-chr18.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr19.Rdata https://www.dropbox.com/s/w9jopjc3tihaey5/Crr-pval-mat-chr19.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr20.Rdata https://www.dropbox.com/s/a2dgkz44elf1gmk/Crr-pval-mat-chr20.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr21.Rdata https://www.dropbox.com/s/btou00c04brza0w/Crr-pval-mat-chr21.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr22.Rdata https://www.dropbox.com/s/edow76gv1uxo1vz/Crr-pval-mat-chr22.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chrX.Rdata https://www.dropbox.com/s/yp7c9osoeiiqtab/Crr-pval-mat-chrX.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chrY.Rdata https://www.dropbox.com/s/72yjqzzijzxmfcu/Crr-pval-mat-chrY.Rdata?dl=1

   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-1-1000.Rdata https://www.dropbox.com/s/o3taaovfvx4z3k3/Crr-Pval-Mat-1-1000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-1001-2000.Rdata https://www.dropbox.com/s/2335yne7lx2nl6g/Crr-Pval-Mat-1001-2000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-2001-3000.Rdata https://www.dropbox.com/s/om4fanhd1z8boca/Crr-Pval-Mat-2001-3000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-3001-4000.Rdata https://www.dropbox.com/s/wfxp30hztjdyajv/Crr-Pval-Mat-3001-4000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-4001-5000.Rdata https://www.dropbox.com/s/s2eaticmdxzd45s/Crr-Pval-Mat-4001-5000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-5001-6000.Rdata https://www.dropbox.com/s/56kgbxim1fkg34f/Crr-Pval-Mat-5001-6000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-6001-7000.Rdata https://www.dropbox.com/s/gv2fd8nk11d2had/Crr-Pval-Mat-6001-7000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-7001-8000.Rdata https://www.dropbox.com/s/vk5f8dgrvz0zwy7/Crr-Pval-Mat-7001-8000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-8001-9000.Rdata https://www.dropbox.com/s/ogh04vdjflq4qmg/Crr-Pval-Mat-8001-9000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-9001-10000.Rdata https://www.dropbox.com/s/dvr6s0v5y8exq2r/Crr-Pval-Mat-9001-10000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-10001-11000.Rdata https://www.dropbox.com/s/zcmxgiwkgrkunef/Crr-Pval-Mat-10001-11000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-11001-12000.Rdata https://www.dropbox.com/s/n59eidw62w99iog/Crr-Pval-Mat-11001-12000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-12001-13000.Rdata https://www.dropbox.com/s/04rsbc7kjxr7wsh/Crr-Pval-Mat-12001-13000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-13001-14000.Rdata https://www.dropbox.com/s/zwgx62zqtn0h7ar/Crr-Pval-Mat-13001-14000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-14001-15000.Rdata https://www.dropbox.com/s/d2s382gowe3m4rn/Crr-Pval-Mat-14001-15000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-15001-16000.Rdata https://www.dropbox.com/s/r3pl4u2s389t482/Crr-Pval-Mat-15001-16000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-16001-17000.Rdata https://www.dropbox.com/s/a7z5lg9586un6ub/Crr-Pval-Mat-16001-17000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-17001-18000.Rdata https://www.dropbox.com/s/7u8cpkz9gxrkzga/Crr-Pval-Mat-17001-18000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-18001-19000.Rdata https://www.dropbox.com/s/yfiil8qrtas4szf/Crr-Pval-Mat-18001-19000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-19001-20000.Rdata https://www.dropbox.com/s/ciby2q9lak77fau/Crr-Pval-Mat-19001-20000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-20001-21000.Rdata https://www.dropbox.com/s/buis98sxkbgaz3t/Crr-Pval-Mat-20001-21000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-21001-22000.Rdata https://www.dropbox.com/s/z90lxtxz2y5l34e/Crr-Pval-Mat-21001-22000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-22001-23000.Rdata https://www.dropbox.com/s/gsduhhsf0j83c6w/Crr-Pval-Mat-22001-23000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-23001-24000.Rdata https://www.dropbox.com/s/3tigw8jxxeh0gf5/Crr-Pval-Mat-23001-24000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-24001-25000.Rdata https://www.dropbox.com/s/7ausrqgn7c1h1z7/Crr-Pval-Mat-24001-25000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-25001-26000.Rdata https://www.dropbox.com/s/77yr8y0smzpwnof/Crr-Pval-Mat-25001-26000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-26001-27000.Rdata https://www.dropbox.com/s/kj88u1btp5zsbtr/Crr-Pval-Mat-26001-27000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-27001-28000.Rdata https://www.dropbox.com/s/np34tnf4vlcjjq9/Crr-Pval-Mat-27001-28000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-28001-29000.Rdata https://www.dropbox.com/s/udf7kkdj1xa6lsk/Crr-Pval-Mat-28001-29000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-29001-30000.Rdata https://www.dropbox.com/s/z1hmw2mjlwmn3jq/Crr-Pval-Mat-29001-30000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-30001-31000.Rdata https://www.dropbox.com/s/rjb9o1stkgg85t1/Crr-Pval-Mat-30001-31000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-31001-32000.Rdata https://www.dropbox.com/s/5vp71otkmfn3jna/Crr-Pval-Mat-31001-32000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-32001-33000.Rdata https://www.dropbox.com/s/oxyeywuatle6hq6/Crr-Pval-Mat-32001-33000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-33001-34000.Rdata https://www.dropbox.com/s/wekw89nfswbxvv1/Crr-Pval-Mat-33001-34000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-34001-35000.Rdata https://www.dropbox.com/s/zv01k5vp3ju07nq/Crr-Pval-Mat-34001-35000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-35001-36000.Rdata https://www.dropbox.com/s/jeh769xkopimfv4/Crr-Pval-Mat-35001-36000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-36001-37000.Rdata https://www.dropbox.com/s/zejwtvo9ip0nnz6/Crr-Pval-Mat-36001-37000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-37001-38000.Rdata https://www.dropbox.com/s/9gt6fv4yeg594cy/Crr-Pval-Mat-37001-38000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-38001-39000.Rdata https://www.dropbox.com/s/dnbxevow4njb3tj/Crr-Pval-Mat-38001-39000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-39001-40000.Rdata https://www.dropbox.com/s/kuipocbfntxg5pz/Crr-Pval-Mat-39001-40000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-40001-41000.Rdata https://www.dropbox.com/s/7pic3kwk42i08iq/Crr-Pval-Mat-40001-41000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-41001-42000.Rdata https://www.dropbox.com/s/n8j1g4m63xd7auk/Crr-Pval-Mat-41001-42000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-42001-43000.Rdata https://www.dropbox.com/s/gqhsk9bjw6htdka/Crr-Pval-Mat-42001-43000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-43001-44000.Rdata https://www.dropbox.com/s/k117ob2dff1pqq8/Crr-Pval-Mat-43001-44000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-44001-45000.Rdata https://www.dropbox.com/s/js35ywmfc6y6wu0/Crr-Pval-Mat-44001-45000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-45001-46000.Rdata https://www.dropbox.com/s/cddwkjkjopm1pbn/Crr-Pval-Mat-45001-46000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-46001-47000.Rdata https://www.dropbox.com/s/oosf5x2862ew3eu/Crr-Pval-Mat-46001-47000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-47001-48000.Rdata https://www.dropbox.com/s/2qs34fuphovddza/Crr-Pval-Mat-47001-48000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-48001-49000.Rdata https://www.dropbox.com/s/y7pnzpmeld3cmqo/Crr-Pval-Mat-48001-49000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-49001-50000.Rdata https://www.dropbox.com/s/47tvcp8vzdehbdr/Crr-Pval-Mat-49001-50000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-50001-51000.Rdata https://www.dropbox.com/s/nghkffl405kiea8/Crr-Pval-Mat-50001-51000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-51001-52000.Rdata https://www.dropbox.com/s/ou3rniwfutfr7hw/Crr-Pval-Mat-51001-52000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-52001-53000.Rdata https://www.dropbox.com/s/2c1x5micsguq1db/Crr-Pval-Mat-52001-53000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-53001-54000.Rdata https://www.dropbox.com/s/o1ksv7xihkeeusv/Crr-Pval-Mat-53001-54000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-54001-55000.Rdata https://www.dropbox.com/s/g6vqrwtofvnzfrb/Crr-Pval-Mat-54001-55000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-55001-56000.Rdata https://www.dropbox.com/s/iw21q78lu2ygl2i/Crr-Pval-Mat-55001-56000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-56001-57000.Rdata https://www.dropbox.com/s/xjq3y841q97mg1d/Crr-Pval-Mat-56001-57000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-57001-58000.Rdata https://www.dropbox.com/s/rttmoaiixb7dq4r/Crr-Pval-Mat-57001-58000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-58001-59000.Rdata https://www.dropbox.com/s/1q9s6akz074ith1/Crr-Pval-Mat-58001-59000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-59001-60000.Rdata https://www.dropbox.com/s/rn1vq63rdrhpogh/Crr-Pval-Mat-59001-60000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-60001-61000.Rdata https://www.dropbox.com/s/9e3hnc1na36glnn/Crr-Pval-Mat-60001-61000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-61001-62000.Rdata https://www.dropbox.com/s/xxeq8toeyb7bpop/Crr-Pval-Mat-61001-62000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-62001-63000.Rdata https://www.dropbox.com/s/yd3otmlqmaeyf0o/Crr-Pval-Mat-62001-63000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-63001-64000.Rdata https://www.dropbox.com/s/e2nadyx2xn60ynb/Crr-Pval-Mat-63001-64000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-64001-65000.Rdata https://www.dropbox.com/s/d3mpihxmgkuerji/Crr-Pval-Mat-64001-65000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-65001-66000.Rdata https://www.dropbox.com/s/ic17nzx2yy1rlt3/Crr-Pval-Mat-65001-66000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-66001-67000.Rdata https://www.dropbox.com/s/0c0ti1d1c2xmzcw/Crr-Pval-Mat-66001-67000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-67001-68000.Rdata https://www.dropbox.com/s/8xfugejda97g908/Crr-Pval-Mat-67001-68000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-68001-69000.Rdata https://www.dropbox.com/s/cxd8fk68p7w5uh2/Crr-Pval-Mat-68001-69000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-69001-70000.Rdata https://www.dropbox.com/s/1uugwrlm7poc569/Crr-Pval-Mat-69001-70000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-70001-71000.Rdata https://www.dropbox.com/s/mx3n42e4al6d360/Crr-Pval-Mat-70001-71000.Rdata?dl=1
   wget --max-redirect=20 -O $maindir/BigData/Full-State/Crr-Pval-Mat-71001-71912.Rdata https://www.dropbox.com/s/m384txtpqy769fu/Crr-Pval-Mat-71001-71912.Rdata?dl=1

   wget --max-redirect=20 -O $maindir/BigData/1000Genome/European/ALL_chr6.bed https://www.dropbox.com/s/i1ev4g73fpeerjs/ALL_chr6.bed?dl=1
   wget --max-redirect=20 -O $maindir/BigData/1000Genome/European/ALL_chr6.bim https://www.dropbox.com/s/f5e49m9a6h82g6p/ALL_chr6.bim?dl=1
   wget --max-redirect=20 -O $maindir/BigData/1000Genome/European/ALL_chr6.fam https://www.dropbox.com/s/2h3uyfp8qidhgps/ALL_chr6.fam?dl=1
   wget --max-redirect=20 -O $maindir/BigData/1000Genome/European/ALL_chr6.log https://www.dropbox.com/s/xkvjmtj8ndszkg5/ALL_chr6.log?dl=1

else
   echo curl is running
   curl -L https://www.dropbox.com/sh/eun66ffs2uczbu2/AABDm0mY48dp6spAMWZYxgLya?dl=1 > $maindir/Rdata/Download.zip  
   curl -L https://www.dropbox.com/sh/x1c0yndjrz261w7/AABaBYjDv_HowIv2zh0LoAaya?dl=1 > $maindir/Data/Download.zip
   curl -L https://www.dropbox.com/sh/lvnbn98m0b58ro0/AAC3_a3AkwF6a85O0spTbfvqa?dl=1 > $maindir/BedData/Download.zip


   curl -L https://www.dropbox.com/s/qva5y5htribtwfu/Crr-pval-mat-chr1.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr1.Rdata 
   curl -L https://www.dropbox.com/s/504u077j31v7psn/Crr-pval-mat-chr2.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr2.Rdata 
   curl -L https://www.dropbox.com/s/huz1qm24b9xbgbw/Crr-pval-mat-chr3.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr3.Rdata 
   curl -L https://www.dropbox.com/s/0xw0d69ro9nqnag/Crr-pval-mat-chr4.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr4.Rdata 
   curl -L https://www.dropbox.com/s/2n12g38rw1okkid/Crr-pval-mat-chr5.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr5.Rdata 
   curl -L https://www.dropbox.com/s/w8zap2qo31vb92k/Crr-pval-mat-chr6.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr6.Rdata 
   curl -L https://www.dropbox.com/s/ak4qjzb55cjgz31/Crr-pval-mat-chr7.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr7.Rdata 
   curl -L https://www.dropbox.com/s/7m09mp8pspklf8f/Crr-pval-mat-chr8.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr8.Rdata 
   curl -L https://www.dropbox.com/s/9qogupgst8sg96e/Crr-pval-mat-chr9.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr9.Rdata 
   curl -L https://www.dropbox.com/s/iv0kw1ix58q947r/Crr-pval-mat-chr10.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr10.Rdata 
   curl -L https://www.dropbox.com/s/9yfgf752lh95jxa/Crr-pval-mat-chr11.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr11.Rdata 
   curl -L https://www.dropbox.com/s/obpd32ob8ykq3xk/Crr-pval-mat-chr12.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr12.Rdata 
   curl -L https://www.dropbox.com/s/gak6e9tmj9l7py2/Crr-pval-mat-chr13.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr13.Rdata 
   curl -L https://www.dropbox.com/s/0xp9xg1uh5uawsr/Crr-pval-mat-chr14.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr14.Rdata 
   curl -L https://www.dropbox.com/s/zdaeyeagxu9dmls/Crr-pval-mat-chr15.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr15.Rdata 
   curl -L https://www.dropbox.com/s/bdtzcbyj9d43cj5/Crr-pval-mat-chr16.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr16.Rdata 
   curl -L https://www.dropbox.com/s/awwznb4807habhw/Crr-pval-mat-chr17.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr17.Rdata 
   curl -L https://www.dropbox.com/s/8mh2hl6tpiihmd3/Crr-pval-mat-chr18.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr18.Rdata 
   curl -L https://www.dropbox.com/s/w9jopjc3tihaey5/Crr-pval-mat-chr19.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr19.Rdata 
   curl -L https://www.dropbox.com/s/a2dgkz44elf1gmk/Crr-pval-mat-chr20.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr20.Rdata 
   curl -L https://www.dropbox.com/s/btou00c04brza0w/Crr-pval-mat-chr21.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr21.Rdata 
   curl -L https://www.dropbox.com/s/edow76gv1uxo1vz/Crr-pval-mat-chr22.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chr22.Rdata
   curl -L https://www.dropbox.com/s/yp7c9osoeiiqtab/Crr-pval-mat-chrX.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chrX.Rdata 
   curl -L https://www.dropbox.com/s/72yjqzzijzxmfcu/Crr-pval-mat-chrY.Rdata?dl=1 > $maindir/BigData/Crr-Pval-Mat-PerChr/Crr-pval-mat-chrY.Rdata 


   curl -L https://www.dropbox.com/s/o3taaovfvx4z3k3/Crr-Pval-Mat-1-1000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-1-1000.Rdata 
   curl -L https://www.dropbox.com/s/2335yne7lx2nl6g/Crr-Pval-Mat-1001-2000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-1001-2000.Rdata 
   curl -L https://www.dropbox.com/s/om4fanhd1z8boca/Crr-Pval-Mat-2001-3000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-2001-3000.Rdata 
   curl -L https://www.dropbox.com/s/wfxp30hztjdyajv/Crr-Pval-Mat-3001-4000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-3001-4000.Rdata 
   curl -L https://www.dropbox.com/s/s2eaticmdxzd45s/Crr-Pval-Mat-4001-5000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-4001-5000.Rdata 
   curl -L https://www.dropbox.com/s/56kgbxim1fkg34f/Crr-Pval-Mat-5001-6000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-5001-6000.Rdata 
   curl -L https://www.dropbox.com/s/gv2fd8nk11d2had/Crr-Pval-Mat-6001-7000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-6001-7000.Rdata 
   curl -L https://www.dropbox.com/s/vk5f8dgrvz0zwy7/Crr-Pval-Mat-7001-8000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-7001-8000.Rdata 
   curl -L https://www.dropbox.com/s/ogh04vdjflq4qmg/Crr-Pval-Mat-8001-9000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-8001-9000.Rdata 
   curl -L https://www.dropbox.com/s/dvr6s0v5y8exq2r/Crr-Pval-Mat-9001-10000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-9001-10000.Rdata 
   curl -L https://www.dropbox.com/s/zcmxgiwkgrkunef/Crr-Pval-Mat-10001-11000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-10001-11000.Rdata 
   curl -L https://www.dropbox.com/s/n59eidw62w99iog/Crr-Pval-Mat-11001-12000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-11001-12000.Rdata 
   curl -L https://www.dropbox.com/s/04rsbc7kjxr7wsh/Crr-Pval-Mat-12001-13000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-12001-13000.Rdata 
   curl -L https://www.dropbox.com/s/zwgx62zqtn0h7ar/Crr-Pval-Mat-13001-14000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-13001-14000.Rdata 
   curl -L https://www.dropbox.com/s/d2s382gowe3m4rn/Crr-Pval-Mat-14001-15000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-14001-15000.Rdata 
   curl -L https://www.dropbox.com/s/r3pl4u2s389t482/Crr-Pval-Mat-15001-16000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-15001-16000.Rdata 
   curl -L https://www.dropbox.com/s/a7z5lg9586un6ub/Crr-Pval-Mat-16001-17000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-16001-17000.Rdata 
   curl -L https://www.dropbox.com/s/7u8cpkz9gxrkzga/Crr-Pval-Mat-17001-18000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-17001-18000.Rdata 
   curl -L https://www.dropbox.com/s/yfiil8qrtas4szf/Crr-Pval-Mat-18001-19000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-18001-19000.Rdata 
   curl -L https://www.dropbox.com/s/ciby2q9lak77fau/Crr-Pval-Mat-19001-20000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-19001-20000.Rdata 
   curl -L https://www.dropbox.com/s/buis98sxkbgaz3t/Crr-Pval-Mat-20001-21000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-20001-21000.Rdata 
   curl -L https://www.dropbox.com/s/z90lxtxz2y5l34e/Crr-Pval-Mat-21001-22000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-21001-22000.Rdata 
   curl -L https://www.dropbox.com/s/gsduhhsf0j83c6w/Crr-Pval-Mat-22001-23000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-22001-23000.Rdata 
   curl -L https://www.dropbox.com/s/3tigw8jxxeh0gf5/Crr-Pval-Mat-23001-24000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-23001-24000.Rdata 
   curl -L https://www.dropbox.com/s/7ausrqgn7c1h1z7/Crr-Pval-Mat-24001-25000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-24001-25000.Rdata 
   curl -L https://www.dropbox.com/s/77yr8y0smzpwnof/Crr-Pval-Mat-25001-26000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-25001-26000.Rdata 
   curl -L https://www.dropbox.com/s/kj88u1btp5zsbtr/Crr-Pval-Mat-26001-27000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-26001-27000.Rdata 
   curl -L https://www.dropbox.com/s/np34tnf4vlcjjq9/Crr-Pval-Mat-27001-28000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-27001-28000.Rdata 
   curl -L https://www.dropbox.com/s/udf7kkdj1xa6lsk/Crr-Pval-Mat-28001-29000.Rdata?dl=1 > $maindir/BigData/Full-State/Crr-Pval-Mat-28001-29000.Rdata 
   curl -L https://www.dropbox.com/s/z1hmw2mjlwmn3jq/Crr-Pval-Mat-29001-30000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-29001-30000.Rdata 
   curl -L https://www.dropbox.com/s/rjb9o1stkgg85t1/Crr-Pval-Mat-30001-31000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-30001-31000.Rdata 
   curl -L https://www.dropbox.com/s/5vp71otkmfn3jna/Crr-Pval-Mat-31001-32000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-31001-32000.Rdata 
   curl -L https://www.dropbox.com/s/oxyeywuatle6hq6/Crr-Pval-Mat-32001-33000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-32001-33000.Rdata 
   curl -L https://www.dropbox.com/s/wekw89nfswbxvv1/Crr-Pval-Mat-33001-34000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-33001-34000.Rdata 
   curl -L https://www.dropbox.com/s/zv01k5vp3ju07nq/Crr-Pval-Mat-34001-35000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-34001-35000.Rdata 
   curl -L https://www.dropbox.com/s/jeh769xkopimfv4/Crr-Pval-Mat-35001-36000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-35001-36000.Rdata 
   curl -L https://www.dropbox.com/s/zejwtvo9ip0nnz6/Crr-Pval-Mat-36001-37000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-36001-37000.Rdata 
   curl -L https://www.dropbox.com/s/9gt6fv4yeg594cy/Crr-Pval-Mat-37001-38000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-37001-38000.Rdata 
   curl -L https://www.dropbox.com/s/dnbxevow4njb3tj/Crr-Pval-Mat-38001-39000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-38001-39000.Rdata 
   curl -L https://www.dropbox.com/s/kuipocbfntxg5pz/Crr-Pval-Mat-39001-40000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-39001-40000.Rdata 
   curl -L https://www.dropbox.com/s/7pic3kwk42i08iq/Crr-Pval-Mat-40001-41000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-40001-41000.Rdata 
   curl -L https://www.dropbox.com/s/n8j1g4m63xd7auk/Crr-Pval-Mat-41001-42000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-41001-42000.Rdata 
   curl -L https://www.dropbox.com/s/gqhsk9bjw6htdka/Crr-Pval-Mat-42001-43000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-42001-43000.Rdata 
   curl -L https://www.dropbox.com/s/k117ob2dff1pqq8/Crr-Pval-Mat-43001-44000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-43001-44000.Rdata 
   curl -L https://www.dropbox.com/s/js35ywmfc6y6wu0/Crr-Pval-Mat-44001-45000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-44001-45000.Rdata 
   curl -L https://www.dropbox.com/s/cddwkjkjopm1pbn/Crr-Pval-Mat-45001-46000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-45001-46000.Rdata 
   curl -L https://www.dropbox.com/s/oosf5x2862ew3eu/Crr-Pval-Mat-46001-47000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-46001-47000.Rdata 
   curl -L https://www.dropbox.com/s/2qs34fuphovddza/Crr-Pval-Mat-47001-48000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-47001-48000.Rdata 
   curl -L https://www.dropbox.com/s/y7pnzpmeld3cmqo/Crr-Pval-Mat-48001-49000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-48001-49000.Rdata 
   curl -L https://www.dropbox.com/s/47tvcp8vzdehbdr/Crr-Pval-Mat-49001-50000.Rdata?dl=1 > $maindir/BigData/Full-State/Crr-Pval-Mat-49001-50000.Rdata 
   curl -L https://www.dropbox.com/s/nghkffl405kiea8/Crr-Pval-Mat-50001-51000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-50001-51000.Rdata 
   curl -L https://www.dropbox.com/s/ou3rniwfutfr7hw/Crr-Pval-Mat-51001-52000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-51001-52000.Rdata 
   curl -L https://www.dropbox.com/s/2c1x5micsguq1db/Crr-Pval-Mat-52001-53000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-52001-53000.Rdata 
   curl -L https://www.dropbox.com/s/o1ksv7xihkeeusv/Crr-Pval-Mat-53001-54000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-53001-54000.Rdata 
   curl -L https://www.dropbox.com/s/g6vqrwtofvnzfrb/Crr-Pval-Mat-54001-55000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-54001-55000.Rdata 
   curl -L https://www.dropbox.com/s/iw21q78lu2ygl2i/Crr-Pval-Mat-55001-56000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-55001-56000.Rdata 
   curl -L https://www.dropbox.com/s/xjq3y841q97mg1d/Crr-Pval-Mat-56001-57000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-56001-57000.Rdata 
   curl -L https://www.dropbox.com/s/rttmoaiixb7dq4r/Crr-Pval-Mat-57001-58000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-57001-58000.Rdata 
   curl -L https://www.dropbox.com/s/1q9s6akz074ith1/Crr-Pval-Mat-58001-59000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-58001-59000.Rdata 
   curl -L https://www.dropbox.com/s/rn1vq63rdrhpogh/Crr-Pval-Mat-59001-60000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-59001-60000.Rdata 
   curl -L https://www.dropbox.com/s/9e3hnc1na36glnn/Crr-Pval-Mat-60001-61000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-60001-61000.Rdata 
   curl -L https://www.dropbox.com/s/xxeq8toeyb7bpop/Crr-Pval-Mat-61001-62000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-61001-62000.Rdata 
   curl -L https://www.dropbox.com/s/yd3otmlqmaeyf0o/Crr-Pval-Mat-62001-63000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-62001-63000.Rdata 
   curl -L https://www.dropbox.com/s/e2nadyx2xn60ynb/Crr-Pval-Mat-63001-64000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-63001-64000.Rdata 
   curl -L https://www.dropbox.com/s/d3mpihxmgkuerji/Crr-Pval-Mat-64001-65000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-64001-65000.Rdata 
   curl -L https://www.dropbox.com/s/ic17nzx2yy1rlt3/Crr-Pval-Mat-65001-66000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-65001-66000.Rdata 
   curl -L https://www.dropbox.com/s/0c0ti1d1c2xmzcw/Crr-Pval-Mat-66001-67000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-66001-67000.Rdata 
   curl -L https://www.dropbox.com/s/8xfugejda97g908/Crr-Pval-Mat-67001-68000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-67001-68000.Rdata 
   curl -L https://www.dropbox.com/s/cxd8fk68p7w5uh2/Crr-Pval-Mat-68001-69000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-68001-69000.Rdata 
   curl -L https://www.dropbox.com/s/1uugwrlm7poc569/Crr-Pval-Mat-69001-70000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-69001-70000.Rdata 
   curl -L https://www.dropbox.com/s/mx3n42e4al6d360/Crr-Pval-Mat-70001-71000.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-70001-71000.Rdata 
   curl -L https://www.dropbox.com/s/m384txtpqy769fu/Crr-Pval-Mat-71001-71912.Rdata?dl=1  > $maindir/BigData/Full-State/Crr-Pval-Mat-71001-71912.Rdata 

   curl -L https://www.dropbox.com/s/i1ev4g73fpeerjs/ALL_chr6.bed?dl=1  > $maindir/BigData/1000Genome/European/ALL_chr6.bed 
   curl -L https://www.dropbox.com/s/f5e49m9a6h82g6p/ALL_chr6.bim?dl=1  > $maindir/BigData/1000Genome/European/ALL_chr6.bim 
   curl -L https://www.dropbox.com/s/2h3uyfp8qidhgps/ALL_chr6.fam?dl=1  > $maindir/BigData/1000Genome/European/ALL_chr6.fam 
   curl -L https://www.dropbox.com/s/xkvjmtj8ndszkg5/ALL_chr6.log?dl=1  > $maindir/BigData/1000Genome/European/ALL_chr6.log 


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