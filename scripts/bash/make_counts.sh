#!/bin/bash
#$ -l h_vmem=50G
#$ -l h_rt=6:00:00
#$ -o "/xchip/beroukhimlab/srangasw/POMT/scripts/bash/logs/counts.out"
#$ -e "/xchip/beroukhimlab/srangasw/POMT/scripts/bash/logs/counts.err"
#$ -N POMT_counts
source /broad/software/scripts/useuse

cd "/xchip/beroukhimlab/srangasw/POMT/scripts/R_scripts"
/home/unix/srangasw/miniconda3/bin/conda run -p /home/unix/srangasw/miniconda3/envs/single_cell Rscript create_counts.R
