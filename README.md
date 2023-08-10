# MetaDone
MetaDone is a collection of different workflows that enable integrated metagenomic analysis of short PE (e.g. Illumina) and long (e.g. Oxford Nanopore Technologies) reads. Three approaches are used for pathogen detection: taxonomic classification of reads, taxonomic classification of contigs and mapping to reference genomes.
## Installation & Dependencies
To obtain the scripts, download the depository with `git clone` or `wget`. Also, install Snakemake workflow management system (https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) and Singularity (https://singularity-tutorial.github.io/01-installation/).
### Obtain the required databases
Download required databases:
- KrakenUniq Standard collection (https://benlangmead.github.io/aws-indexes/k2)
- Krona taxonomy (https://genomics.sschmeier.com/ngs-taxonomic-investigation/index.html#build-the-taxonomy)
- virus/chromosome-specific HMMs  (https://figshare.com/ndownloader/files/17904323?private_link=f897d463b31a35ad7bf0)
- NCBI nr (https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz)
- NCBI prot.accession2taxid (https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.FULL.gz)
- NCBI names/nodes (https://ftp.ncbi.nih.gov/pub/taxonomy/taxdmp.zip)
- Megan (https://software-ab.cs.uni-tuebingen.de/download/megan6/megan-map-Feb2022.db.zip)
- Host reference genome (e.g. hg38)
- Pathogen reference genome (e.g. enterovirus)
  
Make sure you have enough disk space.
### Build Singularity images
Build images in `singularity_images/` folder and use same name as the definition files. For example:
```
sudo singularity build kraken.sif kraken.def
```
## Example of use
All workflows are started with `bash` command. Before every run double check workflow parameters and path to samples and databases.

Suggestion: befor run use "-n" flag in shell scripts, to perform dry-run.
### Short PE read/contig classification
In terminal, navigate to the `short_PE_classification/` folder, which contains  `config.yml`,`run_classification.sh` and `Snakefile`.
Workflow performs quality check, trimming, host removal, assembly, read/contig classification and visualization preparation of results.
Before run, set the parameters in `config.yml` file and `run_classification.sh` script. Check PE reads name (must end with "_R1.fastq.gz" and "_R2.fastq.gz")

Once set, simply run the workflow with `bash run_classification.sh`.
### Short PE reads reference genome alignment
In terminal, navigate to the `short_PE_mapping/` folder, which contains  `config.yml`,`run_mapping.sh` and `Snakefile`.
Workflow performs performs mapping on the provided reference genome and calculation of the mapping statistics.
Before run, set the parameters in `config.yml` file and `run_mapping.sh` script. Check PE reads name (must end with "_R1.fastq.gz" and "_R2.fastq.gz").

Once set, simply run the workflow with `bash run_mapping.sh`.
### Long read/contig classification
In terminal, navigate to the `long_classification/` folder, which contains  `config.yml`,`run_classification.sh` and `Snakefile`.
Workflow performs quality check, trimming, host removal, assembly, polishing, read/contig classification and visualization preparation of results.
Before run, set the parameters in `config.yml` file and `run_classification.sh` script. 

**IMPORTANT:** Check input path (the defined path must end above the folder containing reads).
For example:
if raw reads are located in `../path_to_sequence_run/fastq_pass/barcode01`, the defined path in `config.yml` must be:
```
../path_to_sequence_run/fastq_pass
```
Rename folder if you wish (e.g. rename "barcode01" to "clinical_sample")

Once set, simply run the workflow with `bash run_classification.sh`.
### Long reads reference genome alignment
In terminal, navigate to the `long_mapping/` folder, which contains  `config.yml`,`run_mapping.sh` and `Snakefile`.
Workflow performs performs mapping on the provided reference genome and calculation of the mapping statistics.
Before run, set the parameters in `config.yml` file and `run_mapping.sh` script. Check long reads extension (must end with ".fastq.gz").

Once set, simply run the workflow with `bash run_mapping.sh`.

## List of tools used to build workflows
Preprocess

[FastQC](https://github.com/s-andrews/FastQC) 

Taxonomic classification of reads

Taxonomic classification of contigs

## Citation
If you have used these workflows in your research, please cite:
