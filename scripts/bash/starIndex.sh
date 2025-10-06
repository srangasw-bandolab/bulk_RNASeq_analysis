#!/bin/bash
#SBATCH --job-name=genome_index_POMT
#SBATCH --output="/path/to/logs/starIndex.out"
#SBATCH --error="/path/to/logs/starIndex.out"
#SBATCH --partition=normal
#SBATCH --mem=60G
#SBATCH --ntasks=1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --time=80:00:00
#SBATCH --mail-user=your_email

module load STAR/2.7.10a
GENOMEDIR="/path/to/genome/dir"

mkdir -p $GENOMEDIR/STAR_gfp
cd /working/directory/

STAR --runMode genomeGenerate --genomeDir $GENOMEDIR/STAR_gfp --genomeFastaFiles "/path/to/updated.genome.fa" --sjdbGTFfile "/path/to/updated.genes.gtf" --sjdbOverhang 150


