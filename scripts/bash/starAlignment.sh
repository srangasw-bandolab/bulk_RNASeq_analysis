#!/bin/bash
#SBATCH --job-name=STAR_POMT
#SBATCH --output="/path/to/logs/starAlign.out"
#SBATCH --error="/path/to/logs/starAlign.out"
#SBATCH --partition=normal
#SBATCH --mem=60G
#SBATCH --ntasks=1
#SBATCH --array=0-11
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --time=48:00:00
#SBATCH --mail-user=your_email

module load STAR/2.7.10a
GENOMEINDEX="/path/to/STAR/genome"
OUTPUT_DIR="/path/to/output_dir"
INPUT_DIR="/path/to/trimmed_fastqs"
GTFFILE="/path/to/updated.genes.gtf"
SAMPLES_FILE="/path/to/samples.txt"

cd $OUTPUT_DIR
SAMPLE=$(sed -n "${SLURM_TASK_ID + 1}p" $SAMPLES_FILE)

if [ -z "$SAMPLE" ]; then
    echo "Error: No sample found for task ID ${SLURM_TASK_ID}"
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

STAR --genomeDir $GENOMEINDEX --outSAMattributes All --outSAMtype BAM SortedByCoordinate --quantMode GeneCounts --readFilesCommand zcat --outMultimapperOrder Random --outReadsUnmapped Fastx --outWigType wiggle --readFilesIn $R1 $R2 --sjdbGTFfile $GTFFILE --outFileNamePrefix "${OUT_PREFIX}/" 

# Check STAR exit status
if [ $? -ne 0 ]; then
    echo "Error: STAR alignment failed for sample ${SAMPLE}"
    exit 1
fi

echo "Completed processing sample: ${SAMPLE}"



