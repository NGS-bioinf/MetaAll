#!/bin/bash

# A script that controls the flow and order of short PE reads classification analysis. 

# Prerequisites:
# - Have snakemake installed and placed all singularity images
# - Edit parameters in config.yml file. Here define number of threads (max 128) and RAM max limit (double check). 
# - Check PE reads name (must end with "_R1.fastq.gz" and "_R2.fastq.gz")

# Suggestion: befor run use "-n" flag to perform dry-run
# Command example: bash run_workflow.sh
#################################################################################################

time snakemake -c32 --resources mem_mb=100000 --rerun-incomplete -k --printshellcmds --use-singularity
