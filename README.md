# MetaDone
MetaDone is a collection of different workflows that enable integrated metagenomic analysis of short PE (e.g. Illumina) and long (e.g. Oxford Nanopore Technologies) reads. Three approaches are used for pathogen detection: taxonomic classification of reads, taxonomic classification of contigs and mapping to reference genomes.
## Installation & Dependencies
To obtain the scripts, download the depository with `git clone` or `wget`.
### Obtain the required databases
Download required databases:
- KrakenUniq Standard collection (https://benlangmead.github.io/aws-indexes/k2)
- Krona taxonomy (https://genomics.sschmeier.com/ngs-taxonomic-investigation/index.html#build-the-taxonomy)
- viralVerify virus/chromosome-specific HMMs  (https://figshare.com/ndownloader/files/17904323?private_link=f897d463b31a35ad7bf0)
- Diamond NCBI nr (https://ftp.ncbi.nlm.nih.gov/blast/db/FASTA/nr.gz)
- NCBI taxonomy (https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.FULL.gz)
- Megan (https://software-ab.cs.uni-tuebingen.de/download/megan6/megan-map-Feb2022.db.zip)
- Host reference genome (e.g. hg38)

Make sure you have enough disk space.
### Build Singularity images
## Example of use
### Short PE read/contig classification
### Short PE read reference genome alignment
### Long read/contig classification
### Long read reference genome alignment
## Citation
If you have used these workflows in your research, please cite:
