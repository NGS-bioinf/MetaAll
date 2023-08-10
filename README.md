# MetaDone
MetaDone is a collection of different workflows that enable integrated metagenomic analysis of short PE (e.g. Illumina) and long (e.g. Oxford Nanopore Technologies) reads. Three approaches are used for pathogen detection: taxonomic classification of reads, taxonomic classification of contigs and mapping to reference genomes.
## Installation & Dependencies
To obtain the scripts, download the depository with `git clone` or `wget` and install:
- Snakemake workflow management system (https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)
- Singularity (https://singularity-tutorial.github.io/01-installation/)
- MEGAN (https://software-ab.cs.uni-tuebingen.de/download/megan6/welcome.html)
- Tablet (https://ics.hutton.ac.uk/tablet/)
### Obtain the required databases
Download required databases:
- KrakenUniq Standard collection (https://benlangmead.github.io/aws-indexes/k2)
- Krona taxonomy (https://genomics.sschmeier.com/ngs-taxonomic-investigation/index.html#build-the-taxonomy)
- virus/chromosome-specific HMMs  (https://figshare.com/ndownloader/files/17904323?private_link=f897d463b31a35ad7bf0)
- NCBI nr (https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz)
- NCBI prot.accession2taxid (https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.FULL.gz)
- NCBI names/nodes (https://ftp.ncbi.nih.gov/pub/taxonomy/taxdmp.zip)
- MEGAN (https://software-ab.cs.uni-tuebingen.de/download/megan6/megan-map-Feb2022.db.zip)
- Host reference genome (e.g. hg38)
- Pathogen reference genome (e.g. enterovirus)
  
**NOTE:** Make sure you have enough disk space.
### Build Singularity images
Build images in `singularity_images/` folder and use same name as the definition files. For example:
```
sudo singularity build kraken.sif kraken.def
```
## Example of use
All workflows are started with `bash` command. Before every run double check workflow parameters and path to samples and databases.
Once set, simply run the selected workflow with `bash run_workflow.sh`
### Short PE read/contig classification
In terminal, navigate to the `short_PE_classification/` folder, which contains  `config.yml`,`run_workflow.sh` and `Snakefile`.
Workflow performs quality check, trimming, host removal, assembly, read/contig classification and visualization preparation of results.
Before run, set the parameters in `config.yml` file and `run_workflow.sh` script. Check PE reads name (must end with "_R1.fastq.gz" and "_R2.fastq.gz").
Host reference genome must be indexed (use `bowtie2-build` command). 

**Suggestion:** Before run use "-n" flag in shell scripts, to perform dry-run.
### Short PE reads reference genome alignment
From `short_mapping/` folder, simply copy `workhorse.sh` and `run_workflow.sh` scripts, next to folder containing short PE reads. Name of the folder containing sequence data, must be `data`. There also has to be a reference sequence of the target pathogen present `e.g. enterovirus_refseq.fasta`.
The script takes target virus as pos arg 1 (this arg is linked to refseq name, excluding ".fasta" extension) and thread number as pos arg 2. For example: `bash workhorse.sh enterovirus_refseq 32`. Before run, set the parameters in `workhorse.sh` and `run_workflow.sh` scripts. 

### Long read/contig classification
In terminal, navigate to the `long_classification/` folder, which contains  `config.yml`,`run_workflow.sh` and `Snakefile`.
Workflow performs quality check, trimming, host removal, assembly, polishing, read/contig classification and visualization preparation of results.
Before run, set the parameters in `config.yml` file and `run_workflow.sh` script. 

**IMPORTANT:** Check input path (the defined path must end above the folder containing reads).
For example:
if raw reads are located in `../path_to_sequence_run/fastq_pass/barcode01`, the defined path in `config.yml` must be:
```
../path_to_sequence_run/fastq_pass
```
Rename folder if you wish (e.g. rename "barcode01" to "clinical_sample")

**Suggestion:** Before run use "-n" flag in shell scripts, to perform dry-run.
### Long reads reference genome alignment
In terminal, navigate to the `long_mapping/` folder, which contains  `config.yml`,`run_workflow.sh` and `Snakefile`.
Workflow performs performs mapping on the provided reference genome and calculation of the mapping statistics.
Before run, set the parameters in `config.yml` file and `run_workflow.sh` script. Check long reads extension (must end with ".fastq.gz").

**Suggestion:** Before run use "-n" flag in shell scripts, to perform dry-run.
## Note
For easier and faster analysis, we recommend detection by classification first, followed by mapping. If you would like to use detection by mapping only, please note that workflows where mapping to reference genomes is performed, do not undertake preprocessing steps.
## Output

## List of tools used
### Preprocess
[FastQC](https://github.com/s-andrews/FastQC)
[MultiQC](https://github.com/ewels/MultiQC)
[NanoPack](https://github.com/wdecoster/nanopack)
[BBMap](https://github.com/BioInfoTools/BBMap)
[Porechop_ABI](https://github.com/bonsai-team/Porechop_ABI)
[bowtie2](https://github.com/BenLangmead/bowtie2)
[BWA](https://github.com/lh3/bwa)
[minimap2](https://github.com/lh3/minimap2)
[samtools](https://github.com/samtools/samtools)
[SPAdes](https://github.com/ablab/spades)
[Flye](https://github.com/fenderglass/Flye)
[medaka](https://github.com/nanoporetech/medaka)
[seqtk](https://github.com/lh3/seqtk)
### Taxonomic classification of reads
[KrakenUniq](https://github.com/fbreitwieser/krakenuniq)
### Taxonomic classification of contigs
[viralVerify](https://github.com/ablab/viralVerify)
[DIAMOND](https://github.com/bbuchfink/diamond)
## Visual interpretation of results
[Krona](https://github.com/marbl/Krona)
[Pavian](https://github.com/fbreitwieser/pavian)
[MEGAN](https://github.com/husonlab/megan-ce)
[jvarkit](https://github.com/lindenb/jvarkit)
[Tablet](https://github.com/cropgeeks/tablet)
## Citation
If you have used these workflows in your research, please cite:
