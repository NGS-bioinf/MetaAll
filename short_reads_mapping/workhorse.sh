#!bin/bash

# This script performs mapping on the provided reference genome and calculation of the mapping statistics.
# Before run, set the parameters in run_workflow.sh script.

#Authors: asuljic

# Samtools coverage is set to "-q 10 -Q 10" (change if necessary).

###################################################################################################################
echo "START ANALYSIS"
date
# Delete existing directories

rm -r ref_mapping mapping_stats

# Create directories
mkdir ref_mapping mapping_stats

# Create sample list
ls data | cut -d "_" -f 1 | sort -n | uniq > samples

# Index reference
echo "Indexing reference sequence"

bwa index "${1}".fasta
samtools faidx "${1}".fasta
samtools dict "${1}".fasta > "${1}".dict

# Alignment
echo "Mapping reads to reference"

for i in $(cat samples); do
	date
	sample=${i}

	echo $i;

	bwa mem -t "${2}" -R '@RG\tID:foo\tSM:bar\tLB:library1-PE' "${1}".fasta data/${sample}_*R1*.fastq.gz data/${sample}_*R2*.fastq.gz | \
		samtools view --threads "${2}" -uhS - | \
		samtools sort --threads "${2}" -n  - | \
		samtools fixmate --threads "${2}" -m - ref_mapping/${sample}_PE_nodup.bam
	samtools sort --threads "${2}" ref_mapping/${sample}_PE_nodup.bam | \
		samtools markdup -r --threads "${2}" - ref_mapping/${sample}_PE_nodup.bam
	samtools index ref_mapping/${sample}_PE_nodup.bam

	bwa mem -t "${2}" -R '@RG\tID:foo\tSM:bar\tLB:library1-S' "${1}".fasta data/${sample}_*S*.fastq.gz | \
		samtools view -uhS --threads "${2}" - | \
		samtools sort --threads "${2}" - |  \
		samtools rmdup -s - ref_mapping/${sample}_srmdup.bam
	samtools sort --threads "${2}" -o ref_mapping/${sample}_SE_nodup.bam ref_mapping/${sample}_srmdup.bam
	samtools index ref_mapping/${sample}_SE_nodup.bam

	samtools merge --threads "${2}" ref_mapping/${sample}_nodup.bam ref_mapping/${sample}_PE_nodup.bam ref_mapping/${sample}_SE_nodup.bam
	samtools index ref_mapping/${sample}_nodup.bam

	samtools calmd -Ar --threads "${2}" ref_mapping/${sample}_nodup.bam "${1}".fasta | \
		samtools sort --threads "${2}" -o ref_mapping/${sample}_nodup.baq.bam - 
	samtools index ref_mapping/${sample}_nodup.baq.bam
	date
done
date

# Mapping statistics

echo "Calculating mapping statistics"

for i in $(cat samples); do
	date
	sample=${i}
	echo $i;

	echo -e "${sample}" > mapping_stats/${sample}_mapmapping_stats_name.log
	samtools flagstat ref_mapping/${sample}_nodup.baq.bam > mapping_stats/${sample}_allmapping_stats.log
	samtools coverage -q 10 -Q 10 ref_mapping/${sample}_nodup.baq.bam > mapping_stats/${sample}_coverage.log
	
	
	cat mapping_stats/${sample}_mapmapping_stats_name.log mapping_stats/${sample}_allmapping_stats.log mapping_stats/${sample}_coverage.log > mapping_stats/${sample}_mapping_stats.log
	rm  mapping_stats/${sample}_allmapping_stats.log mapping_stats/${sample}_mapmapping_stats_name.log mapping_stats/${sample}_coverage.log
	date
done
date

echo "Analysis complete"
date
