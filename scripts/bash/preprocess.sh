#!/bin/bash
#SBATCH --job-name=fastp_POMT
#SBATCH --output="/path/to/logs/fastp.out"
#SBATCH --error="/path/to/logs/fastp.out"
#SBATCH --partition=normal
#SBATCH --mem=60G
#SBATCH --ntasks=1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --time=80:00:00
#SBATCH --mail-user=your_email
source /path/to/miniforge/etc/profile.d/conda.sh
conda activate /path/to/conda_env
module load fastqc
INPUT_DIR="/path/to/raw_data/"
OUTPUT_DIR="/path/to/trimmed_data"
# Do fastQC on raw_data
fastqc -f fastq -o /path/to/fastqc_results/raw ${INPUT_DIR}/*fastq.gz 

# Trim adapters and low quality bases using fastp
mkdir -p "$OUTPUT_DIR"
for R1_FILE in "$INPUT_DIR"/*_R1*.fastq.gz; do 
	BASENAME=$(basename "$R1_FILE" _R1_001.fastq.gz)
    echo "Processing $BASENAME"
	fastp -i "$R1_FILE" -I "$INPUT_DIR/${BASENAME}_R2_001.fastq.gz" -o "$OUTPUT_DIR/${BASENAME}_R1_001_trimmed.fastq.gz" -O "$OUTPUT_DIR/${BASENAME}_R2_001_trimmed.fastq.gz" --detect_adapter_for_pe -l 20 -h "$OUTPUT_DIR/${BASENAME}_report.html" -j REPORT_JSON="$OUTPUT_DIR/${BASENAME}_report.json" --overlap_len_require 15
done

# Do fastQC on trimmed data
fastqc -f fastq -o /path/to/fastqc_results/trim ${OUTPUT_DIR}/*fastq.gz 

ls $OUTPUT_DIR/*.fastq $OUTPUT_DIR/*.fastq.gz 2>/dev/null | \
> sed -E 's/_L[0-9]{3}_R[12]_001_trimmed\.fastq(\.gz)?$//' | \
> sort -u > $OUTPUT_DIR/samples.txt
