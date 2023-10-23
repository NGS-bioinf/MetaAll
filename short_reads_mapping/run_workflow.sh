#!/bin/bash

# A script that controls the flow and order of short PE reads mapping analysis.

# Prerequisites:
# 1. Data should be stored in current working directory as "data"!
# 3. There also has to be a reference sequence of the target virus present(e.g. mpxv.fasta)!

# The script takes target virus as pos arg 1 (this arg is linked to refseq name) and thread number as pos arg 2

# Command example: bash run_workflow.sh
#################################################################################################

singularity run /singularity_images/bioinformatics.sif bash workhorse.sh mpxv 32
