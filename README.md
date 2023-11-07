# MetaAll
MetaAll is a collection of different workflows that enable integrated metagenomic analysis of Illumina short PE and Oxford Nanopore Technologies (ONT) long reads. Three approaches are used for pathogen detection: taxonomic classification of reads, taxonomic classification of contigs and mapping to reference genomes.
## Installation & Dependencies
To obtain the scripts, download the depository with `git clone` or `wget` and install:
- Snakemake workflow management system (https://snakemake.readthedocs.io/en/stable/getting_started/installation.html)
- Singularity (https://singularity-tutorial.github.io/01-installation/)
- MEGAN (https://software-ab.cs.uni-tuebingen.de/download/megan6/welcome.html)
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

## Example of use
All workflows are started with `bash` command. Before every run double check workflow parameters and path to samples and databases.
Once set, simply run the selected workflow with `bash run_workflow.sh`
### Short PE reads/contigs classification
In terminal, navigate to the `ill_classification/` folder, which contains  `config.yml`,`run_workflow.sh` and `Snakefile`.
Workflow performs quality check, trimming, host removal, assembly, read/contig classification and visualization preparation of results.
Before run, set the parameters in `config.yml` file and `run_workflow.sh` script. Check PE reads name (must end with "_R1.fastq.gz" and "_R2.fastq.gz").
Host reference genome must be indexed (use `bowtie2-build` command). 

**Suggestion:** Before run use "-n" flag in shell scripts, to perform dry-run.
### Short PE reads reference genome alignment
From `ill_read_mapping/` folder, simply copy `workhorse.sh` and `run_workflow.sh` scripts, next to folder containing short PE reads. Name of the folder containing sequence data, must be `data`. There also has to be a reference sequence of the target pathogen present `e.g. enterovirus_refseq.fasta`.
The script takes target virus as pos arg 1 (this arg is linked to refseq name, excluding ".fasta" extension) and thread number as pos arg 2. For example: `bash workhorse.sh enterovirus_refseq 32`. Before run, set the parameters in `workhorse.sh` and `run_workflow.sh` scripts. 

### Long reads/contigs classification
In terminal, navigate to the `ont_classification/` folder, which contains  `config.yml`,`run_workflow.sh` and `Snakefile`.
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
In terminal, navigate to the `ont_read_mapping/` folder, which contains  `config.yml`,`run_workflow.sh` and `Snakefile`.
Workflow performs performs mapping on the provided reference genome and calculation of the mapping statistics.
Before run, set the parameters in `config.yml` file and `run_workflow.sh` script. Check long reads extension (must end with ".fastq.gz").

**Suggestion:** Before run use "-n" flag in shell scripts, to perform dry-run.
## Note
For easier and faster analysis, we recommend detection by classification first, followed by mapping. If you would like to use detection by mapping only, please note that workflows where mapping to reference genomes is performed, do not undertake preprocessing steps.
## Output
```
Short PE reads workflow output structure:
Short PE reads/contigs classification:
           # raw fastqc
           "<output_path>/preprocess/QC/reports_raw/<sample_name>_R1.html"
           "<output_path>/preprocess/QC/reports_raw/<sample_name>_R1_fastqc.zip"
           "<output_path>/preprocess/QC/reports_raw/<sample_name>_R2.html"
           "<output_path>/preprocess/QC/reports_raw/<sample_name>_R2_fastqc.zip"
           # raw multiqc
           "<output_path>/preprocess/QC/combined_raw/multiqc.html",        
           # bbduk
           "<output_path>/preprocess/trimmed/<sample_name>_trim_R1.fastq.gz"
           "<output_path>/preprocess/trimmed/<sample_name>_trim_R2.fastq.gz"
           "<output_path>/preprocess/trimmed/<sample_name>_trim_S.fastq.gz"
           # trim fastqc
           "<output_path>/preprocess/QC/reports_trim/<sample_name>_R1.html"
           "<output_path>/preprocess/QC/reports_trim/<sample_name>_R1_fastqc.zip"
           "<output_path>/preprocess/QC/reports_trim/<sample_name>_R2.html"
           "<output_path>/preprocess/QC/reports_trim/<sample_name>_R2_fastqc.zip"
           # trim multiqc
           "<output_path>/preprocess/QC/combined_trim/multiqc.html"
           # bowtie2
           "<output_path>/preprocess/host_depl/<sample_name>_clean_R1.fastq.gz"
           "<output_path>/preprocess/host_depl/<sample_name>_clean_R2.fastq.gz"
           "<output_path>/preprocess/host_depl/<sample_name>_clean_S.fastq.gz"
           "<output_path>/preprocess/host_depl/<sample_name>.bam"
           "<output_path>/preprocess/host_depl/tmp/<sample_name>_clean_R%.fastq.gz"
           # krakenuniq
           "<output_path>/read_classification_results/krakenuniq_taxonomic/<sample_name>.krakenuniq"
           "<output_path>/read_classification_results/pavian_reports/<sample_name>_krakenuniq.report"
           # edit
           "<output_path>/read_classification_results/krona_visualization/<sample_name>.krakenuniq.krona"
           # krona reads
           "<output_path>/read_classification_results/krona_visualization/<sample_name>.krona.html"
           # metaspades
           "<output_path>/contig_classification_results/assembly/tmp/denovo_assembly/<sample_name>"
           "<output_path>/contig_classification_results/assembly/tmp/draft_assembly_fasta/<sample_name>.fasta"
           # seqtk
           "<output_path>/contig_classification_results/assembly/final_assembly/<sample_name>.fasta"
           # viralverify
           "<output_path>/contig_classification_results/viralverify_classification/<sample_name>"
           # diamond blastx
           "<output_path>/contig_classification_results/diamond_blast/<sample_name>_diamond_blast_contigs.daa"
           # daa-meganizer
           "<output_path>/contig_classification_results/tmp/<sample_name>.log"
           # diamond view
           "<output_path>/contig_classification_results/diamond_view/<sample_name>_diamond_blast_contigs.tab"
           # krona contigs
           "<output_path>/contig_classification_results/krona_visualization/<sample_name>_krona_plot.html"
Short PE reads reference genome alignment:
           "<output_path>/ref_mapping/<sample_name>_nodup.bam"
           "<output_path>/ref_mapping/<sample_name>_nodup.bam.bai"
           "<output_path>/ref_mapping/<sample_name>_nodup.baq.bam"
           "<output_path>/ref_mapping/<sample_name>_nodup.baq.bam.bai"
           "<output_path>/ref_mapping/<sample_name>_PE_nodup.bam"
           "<output_path>/ref_mapping/<sample_name>_PE_nodup.bam.bai"
           "<output_path>/ref_mapping/<sample_name>_SE_nodup.bam"
           "<output_path>/ref_mapping/<sample_name>_SE_nodup.bam.bai"
           "<output_path>/ref_mapping/<sample_name>_srmdup.bam"
           "<output_path>/mapping_stats/<sample_name>_mapping_stats.log"

Long reads workflow output structure:
Long reads/contigs classification:
           # cat raw fastq 
           "<output_path>/preprocess/catfastq/<sample_name>.fastq.gz"
           # nanoplot raw
           "<output_path>/preprocess/QC/reports_raw/<sample_name>"
           # nanocomp raw
           "<output_path>/preprocess/QC/combined_raw"
           # porechop_abi
           "<output_path>/preprocess/adapter_trim/<sample_name>.fastq.gz"
           # nanofilt
           "<output_path>/preprocess/quality_trim/<sample_name>_trim.fastq.gz"
           # nanoplot filtered
           "<output_path>/preprocess/QC/reports_trim/<sample_name>"
           # nanocomp filtered
           "<output_path>/preprocess/QC/combined_trim"
           # minimap2 + samtools
           "<output_path>/preprocess/host_depl/bam_files/<sample_name>_unal_sort.bam"
           "<output_path>/preprocess/host_depl/<sample_name>_clean.fastq.gz"
           # krakenuniq
           "<output_path>/read_classification_results/krakenuniq_taxonomic/<sample_name>.krakenuniq"
           "<output_path>/read_classification_results/pavian_reports/<sample_name>_krakenuniq.report"
           # edit krona
           "<output_path>/read_classification_results/krona_visualization/<sample_name>.krakenuniq.krona"
           # krona reads
           "<output_path>/read_classification_results/krona_visualization/<sample_name>.krona.html"
           # metaflye
           "<output_path>/contig_classification_results/assembly/tmp/denovo_assembly/<sample_name>"
           "<output_path>/contig_classification_results/assembly/tmp/draft_assembly/<sample_name>.fasta"
           "<output_path>/contig_classification_results/assembly/tmp/draft_assembly/<sample_name>.gfa"
           # medaka 
           "<output_path>/contig_classification_results/assembly/tmp/polishing/<sample_name>"
           "<output_path>/contig_classification_results/assembly/tmp/polished_assembly/<sample_name>.fasta"
           "<output_path>/contig_classification_results/assembly/final_assembly/<sample_name>.fasta"
           # viralverify
           "<output_path>/contig_classification_results/viralverify_classification/<sample_name>"
           # diamond blastx
           "<output_path>/contig_classification_results/diamond_blast/<sample_name>_diamond_blast_contigs.daa"
           # daa-meganizer
           "<output_path>/contig_classification_results/meganizer_logs/<sample_name>.log"
           # diamond view
           "<output_path>/contig_classification_results/diamond_view/<sample_name>_diamond_blast_contigs.tab"
           # krona contigs
           "<output_path>/contig_classification_results/krona_visualization/<sample_name>_krona_plot.html"
Long reads reference genome alignment:
           # minimap2 + samtools
           "<output_path>/ref_mapping/bam_files/<sample_name>_sort.bam"
           "<output_path>/ref_mapping/bam_files/<sample_name>_sort.bam.bai"
           "<output_path>/ref_mapping/coverage_reports/<sample_name>_coverage.txt"
           "<output_path>/ref_mapping/mapping_statistics/<sample_name>_allstats.txt"
```
## List of tools used
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
[KrakenUniq](https://github.com/fbreitwieser/krakenuniq)
[Krona](https://github.com/marbl/Krona)
[Pavian](https://github.com/fbreitwieser/pavian)
[viralVerify](https://github.com/ablab/viralVerify)
[DIAMOND](https://github.com/bbuchfink/diamond)
[MEGAN](https://github.com/husonlab/megan-ce)
## Citation
If you have used these workflows in your research, please cite:
