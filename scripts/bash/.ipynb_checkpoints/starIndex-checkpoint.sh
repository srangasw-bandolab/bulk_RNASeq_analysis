#!/bin/bash
#$ -l h_vmem=200G
#$ -l h_rt=72:00:00
#$ -N star_index
#$ -o "/xchip/beroukhimlab/srangasw/POMT/scripts/logs/star_index.out"
#$ -e "/xchip/beroukhimlab/srangasw/POMT/scripts/logs/star_index.err"
source /broad/software/scripts/useuse

use .star-2.7.10a
GENOMEDIR="/xchip/beroukhimlab/srangasw/POMT/genome"
STAR_EXEC="/broad/software/free/Linux/redhat_7_x86_64/pkgs/star_2.7.10a/bin/STAR"

mkdir -p $GENOMEDIR/STAR_gfp
cd /xchip/beroukhimlab/srangasw/POMT/

STAR --runMode genomeGenerate --genomeDir $GENOMEDIR/STAR_gfp --genomeFastaFiles "/xchip/beroukhimlab/srangasw/POMT/genome/mouse/fasta/updated.genome.fa" --sjdbGTFfile "/xchip/beroukhimlab/srangasw/POMT/genome/mouse/genes/updated.genes.gtf" --sjdbOverhang 150


