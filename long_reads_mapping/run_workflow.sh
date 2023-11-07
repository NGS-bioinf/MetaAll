#!/bin/bash

# A script that controls the flow and order of long reads mapping analysis.

# Authors: asuljic, mbosilj

# Prerequisites:
# - Have snakemake installed and placed all singularity images.
# - Edit parameters in config.yml file. Here define number of threads (max 128) and RAM max limit (double check). 

# Suggestion: befor run use "-n" flag to perform dry-run
# Command example: bash run_workflow.sh
#################################################################################################

time snakemake -c32 --resources mem_mb=100000 --rerun-incomplete -k --printshellcmds --use-singularity
