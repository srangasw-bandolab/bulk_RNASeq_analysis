
#!/bin/bash
#$ -l h_vmem=50G
#$ -l h_rt=72:00:00
#$ -N fastqc_bulk_RNA
#$ -o "/xchip/beroukhimlab/srangasw/POMT/scripts/logs/fastqc_trimmed.out"
#$ -e "/xchip/beroukhimlab/srangasw/POMT/scripts/logs/fastqc_trimmed.err"
source /broad/software/scripts/useuse
use .fastqc-0.11.9

cd /xchip/beroukhimlab/srangasw/POMT/data/bulk/trimmed_fastqs
fastqc -f fastq -o /xchip/beroukhimlab/srangasw/POMT/scripts/logs/fastqc_outs 20241230_pomt1_neg_1_JR12700_S145_L008*


