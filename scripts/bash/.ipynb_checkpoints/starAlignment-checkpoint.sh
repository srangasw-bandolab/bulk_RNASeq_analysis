#!/bin/bash
#$ -l h_vmem=50G
#$ -l h_rt=120:00:00
#$ -N star_alignment
#$ -t 1-12
#$ -o "/xchip/beroukhimlab/srangasw/POMT/scripts/bash/logs/star_alignment.out"
#$ -e "/xchip/beroukhimlab/srangasw/POMT/scripts/bash/logs/star_alignment.err"
#$ -m beas
#$ -M srangasw@broadinstitute.org
source /broad/software/scripts/useuse

use .star-2.7.10a
GENOMEDIR="/xchip/beroukhimlab/srangasw/POMT/genome/STAR_gfp"
OUTPUT_DIR="/xchip/beroukhimlab/srangasw/POMT/data/bulk/counts"
INPUT_DIR="/xchip/beroukhimlab/srangasw/POMT/data/bulk/trimmed_fastqs"
GTFFILE="/xchip/beroukhimlab/srangasw/POMT/genome/mouse/genes/updated.genes.gtf"
SAMPLES_FILE="/xchip/beroukhimlab/srangasw/POMT/data/bulk/trimmed_fastqs/samples.txt"

cd $OUTPUT_DIR
SAMPLE=$(sed -n "${SGE_TASK_ID}p" $SAMPLES_FILE)

if [ -z "$SAMPLE" ]; then
    echo "Error: No sample found for task ID ${SGE_TASK_ID}"
    exit 1
fi


R1="${INPUT_DIR}/${SAMPLE}_L008_R1_001_trimmed.fastq.gz"
R2="${INPUT_DIR}/${SAMPLE}_L008_R2_001_trimmed.fastq.gz"
OUT_PREFIX="${OUTPUT_DIR}/${SAMPLE}"

echo "Does R1 exist? $(ls -l $R1 2>/dev/null || echo 'NO')"
echo "Does R2 exist? $(ls -l $R2 2>/dev/null || echo 'NO')"

if [ ! -f "$R1" ] || [ ! -f "$R2" ]; then
    echo "Error: Input files not found for sample ${SAMPLE}"
    echo "Expected files:"
    echo "R1: $R1"
    echo "R2: $R2"
    exit 1
fi

mkdir -p "${OUT_PREFIX}"

echo "Processing sample: ${SAMPLE}"
echo "Input R1: $R1"
echo "Input R2: $R2"
echo "Output directory: ${OUT_PREFIX}"

STAR --genomeDir $GENOMEDIR --outSAMattributes All --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --readFilesCommand zcat --outMultimapperOrder Random --outReadsUnmapped Fastx --outWigType wiggle --readFilesIn $R1 $R2 --sjdbGTFfile $GTFFILE --outFileNamePrefix "${OUT_PREFIX}/" 

# Check STAR exit status
if [ $? -ne 0 ]; then
    echo "Error: STAR alignment failed for sample ${SAMPLE}"
    exit 1
fi

echo "Completed processing sample: ${SAMPLE}"



