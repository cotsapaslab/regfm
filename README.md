#regfm (Regulatory Fine Mapping) `v1.0.0`

`regfm` is a command line tool for identifying individual regulatory
regions mediating disease risk and the genes controlled by these
regulators. It uses summary statistics from genome-wide 
association studies and a list of lead SNPs as the input, and outputs
posterior probabilities for each association being mediated by a
regulatory effect, for each regulator being the causal risk factor,
and for each gene in the locus being pathogenic.

To demonstrate the code and ensure it runs on your machine, we provide
data for the BACH2 locus on chromosome 6 from the IMSGC study of
multiple sclerosis risk (IMSGC, Nature Genetics 2013), available on
[`immunobase.org`](https://www.immunobase.org). This is the locus
included in Figure 3 of our
[upcoming paper](http://biorxiv.org/content/early/2016/05/19/054361).

`regfm` is a series of R scripts controlled by a shell script wrapper,
which takes a set of input and runs the analysis. Within this flow we
calculate LD from the 1000 Genomes project, which is quite large.

## Contents
1. [Dependencies](#depend)
2. [Preparing your data](#data)
3. [Running `regfm`](#run)
4. [Description of output](#output)
5. [Details of package contents](#contents)
6. [Troubleshooting](#trouble)
7. [Citation](#cite)
8. [Contact information](#contact)

<a name="depend"></a>
## Dependencies and installation 

`regfm` depends on previous software and requires some additional,
pre-computed files that are too large to distribute via this
repository. For linkage disequilibrium calculations, it relies on an
external reference panel, which you will have to access from the
appropriate project page. 

### Other software
`regfm` depends on:

R (version >= 3.1.0), including several non-base packages

[bedtools](https://github.com/arq5x/bedtools2) (version >= 2-2.19.1)

[plink](https://www.cog-genomics.org/plink2) (version >= 1.9)

Please note that plink v1.07 is likely to run out of memory with the 1000 Genomes reference sets, so we strongly recommend you use v1.9. 

To check which R packages are available on your system, copy the following code into an R console

```
## utility function checks if packages are installed
check.libs.fn <- function(X = c("e1071","grid","SDMTools","gplots","graphics","gap", "gtable"), ret=F) { 
  tmp <- installed.packages()
  not.installed <- setdiff(X, tmp[,1])
  if(!ret) print(paste(length(not.installed), "packages not installed"))
  if(ret) return(not.installed)
}
## will print out number of libs not installed
check.list.fn(ret=F)
## if some are missing, install en masse with
install.packages(check.libs.fn(ret=T))
```

You can download `regfm` from github via your browser or with the command
```  
git clone https://github.com/cotsapaslab/regfm.git
```

### Pre-computed data
We provide correlation matrices between all DNase I hypersensitivity
clusters and expression levels for all genes, as described in our
paper. These data are available via DropBox, as GitHub does not host
large files. In the main directory you will find the script
`Download-Data.sh`, which will download these data for you into a
specified directory. You must specify if the script should use the
`wget` or the `curl` utility to do so, depending on what is installed
on your system.

```
## Is curl installed?
curl --help

## is wget installed?
wget --help

## if you get a help message for at least one of these, you are good
## to go

./Download-Data.sh . curl
## or
./Download-Data.sh . wget
```

You can also obtain the data via the DropBox website, though you will
have to sync your account to that directory.

### LD reference data
Finally, `regfm` requires an LD reference panel in plink formate
(bed/bim/fam). In our paper we used the 1000 Genomes Europeans
(excluding Finnish samples), but you should choose the most
appropriate panel for the study you are analyzing. Due to the size of
these data we cannot make them available directly. The plink
documentation has a
[helpful list of sources](https://www.cog-genomics.org/plink2/resources). In
our distribution, we include data for chromosome 6 to allow the
example to run.

<a name="data"></a>
## Preparing Your Data 

For each trait you wish to analyze, you will need two input files:

### Association summary statistics in BED format. 

This is one SNP per line, tab-delimited plain text with five columns: chromosome number, basepair position - 1 (in hg19 coordinates), basepair position (hg19), SNP ID, and association p value. The file should have no header line. Create a directory under regfm/BedData/ for each trait you wish to analyze, copy your bed file into that directory, and rename it `allSNPs.bed`. 

### Lead SNPs to fine-map.
You will also have to tell `regfm` which associations to fine-map, by providing a list of lead SNPs. Create a tab-delimited text file with column headers `SNP, Chr, Position, P` and corresponding entries SNP ID, chromosome number, basepair position (hg19), and association p value. Copy this to your input directory under regfm/BedData/ and rename it `leadsnps.txt`. 

### Example files 
As an example, we have included input files for MS association in the BACH2 locus in `regfm/BedData/example`.

<a name="run"></a>
## Running regfm 

`regfm` assumes you will run the wrapper from the top-level directory where it lives. You will need to edit the first section of `regfm.sh`:

```
maindir=<PATH TO THE REGFM DIRECTORY>
```
You will also have to specify where the LD reference panel files are, by editing the next line:

```
KGEurDir=$bigdatadir/1000Genome/European
```

Additionally, if either or both of the plink or bedtools binaries are not in directories in your default path, you can uncomment and edit the commands in the next few lines of the script:

```
export PATH=$PATH:<PLINKDIR>
export PATH=$PATH:<BEDTOOLSDIR>  
```

You can test if your binaries are in the default path by typing the following commands into your terminal:

```
plink --version
bedtools --version
```
If either produces an error, that binary is not in your default path and you should edit the PATH variable line.

Finally, to run `regfm` on data in your new directory <TRAIT>, simply run the wrapper script as:

```
./regfm.sh <TRAIT>
```

The example data can be run as:

```
./regfm.sh example
```
<a name="output"></a>
## Output Results 

### Per-locus summaries
Results for each trait can be found in the tab-delimited file `./Tables/<TRAIT>/Summary-Table-<TRAIT>.txt`, which contains an entry for each lead SNP association a tab-delimited file with columns:

* CHR - chromosome identifier
* SNP - the ID of the input lead SNP
* BP - basepair coordinate for the lead SNP
* RHO - (\rho), regulatory potential of the locus. This is the proportion of posterior probability of disease association localizing to regulatory features.
* CLGENE - closest gene to the lead SNP (either gene boundary)
* DIST - distance between the closest gene and the lead SNP
* PRIGENES - prioritized genes, with normalized per-gene posteriors in parentheses. This value is the posterior attributable to a gene, \gamma, divided by \rho.  

### Per-locus figures
A figure for each locus can be found in `./Figures/<TRAIT>/`. These show the association signal in the 2Mbp region centered on the lead SNP (the top panel), the regulatory elements with significant \rho values and their correlation to genes in the region (middle panel), and how gene expression varies by regulatory element accessibility (bottom panel). These figures are described in more detail in our paper (see Citations section, below).
<a name="contents"></a> 
## Detailed description of package contents 

Under `BedData` folder
`DHS-Data-Extn-Sorted.bed`: This file includes boundaries of each DHS cluster extended by 100 bp each side in the BED format.
`Genecode-Sorted.bed`: This file includes boundaries of genes (from transcription start site to transcript end site) in the BED Format. Genes boundaries are obtained from Genecode v12.

Under `Data` folder
`Allele-Specific-Data/Allele-Specific-UW-MAF.bed`: This file contains information about SNPs tested for allelic-imbalanced in DNA accessibility. This data is originally obtained from [`Maurano, et.al. Large-scale identification of sequence variants influencing human transcription factor occupancy in vivo`]((http://www.nature.com/ng/journal/v47/n12/extref/ng.3432-S5.txt) ). We then obtained MAF of the SNPs using 1000 Genome data, and added MAF column to the original file.

Under `Rdata` folder
`Best-genomeFunc.Rdata`: Genomic function of each DHS cluster obtained by using ChromHMM data.
`DHS-Data-Extn.Rdata`: Presense/absence of DHS clusters over 22 cell types after excluding DHS clusters overlapping MHC region (chr6:28x10^6 - 34x10^6 on hg19).
`DHS-Data-Sorted.bed`: Boundaries of each DHS cluster in the BED format.
`DHS-Data.Rdata`: Presense/absence of DHS clusters over 22 cell types.
`Norm-Trans-Exp.Rdata`: A matrix of gene expression data obtained by processing Roadmap Epigenome Project exon array data.
`Unique-DHS-Data.Rdata`: All 796,747 DHS cluster can be categorized to 71,912 unique clusters based on their patterns of presence/absence over 22 cell types. This file contains these unique clusters.

Under `BigData` folder
`Crr-Pval-Mat-PerChr/Crr-pval-mat-chrN.Rdata`: Correlation P values between DHS clusters and genes overlapping chromosome N. Here P values for chromosome 6 is provided as an example. For access to the correlation P values of all chromosomes, look at `BigData` folder.
<a name="trouble"></a>
## Troubleshooting 
If you get a `permission denied` error when running a script, enter
`chmod u+x <file>` for that file and try again. That should give you
permission to execute the file.
<a name="cite"></a> 
## Citation 

`regfm` was written by Parisa Shooshtari (Yale University and the Broad Institute of MIT and Harvard). 

You can cite `regfm` as:

Shooshtari, et al. Integrative genetic and epigenetic analysis uncovers regulatory mechanisms of autoimmune disease. [BioRxiv, 2016.](http://biorxiv.org/content/early/2016/05/19/054361)
<a name="contact"></a>
## Contact # Citation 
Please address comments and questions to Parisa Shooshtari (pshoosh@broadinstitute.org) or Chris Cotsapas (cotsapas@broadinstitute.org)
