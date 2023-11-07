#!/bin/bash

# A script that controls the flow and order of long reads classification analysis. 

#Authors: asuljic, mbosilj

# Prerequisites:
# - Have snakemake installed and placed all singularity images.
# - Edit parameters in config.yml file. Here define number of threads (max 128) and RAM max limit (double check). 
# - Check input path (the defined path must end above the folder containing reads). Rename folder if necessary (e.g. rename "barcode01" to "clinical_sample").

# Suggestion: befor run use "-n" flag to perform dry-run
# Command example: bash run_workflow.sh
#################################################################################################

time snakemake -c32 --resources mem_mb=100000 --rerun-incomplete -k --printshellcmds --use-singularity