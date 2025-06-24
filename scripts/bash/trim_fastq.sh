#!/bin/bash
#$ -l h_vmem=50G
#$ -l h_rt=72:00:00
#$ -N fastp_bulk_RNA
#$ -o "/xchip/beroukhimlab/srangasw/POMT/scripts/logs/fastp.out"
#$ -e "/xchip/beroukhimlab/srangasw/POMT/scripts/logs/fastp.err"
source /broad/software/scripts/useuse
use .fastp-0.20.0

INPUT_DIR="/xchip/beroukhimlab/srangasw/POMT/data/bulk/241230_JR12700_fastq"
OUTPUT_DIR="/xchip/beroukhimlab/srangasw/POMT/data/bulk/trimmed_fastqs"


for R1_FILE in "$INPUT_DIR"/*_R1_001.fastq.gz; do 
	BASENAME=$(basename "$R1_FILE" _R1_001.fastq.gz)
	R2_FILE="$INPUT_DIR/${BASENAME}_R2_001.fastq.gz"
        echo "Processing $BASENAME"
	OUT_R1="$OUTPUT_DIR/${BASENAME}_R1_001_trimmed.fastq.gz"
    	OUT_R2="$OUTPUT_DIR/${BASENAME}_R2_001_trimmed.fastq.gz"
    	REPORT_HTML="$OUTPUT_DIR/${BASENAME}_fastp_report.html"
    	REPORT_JSON="$OUTPUT_DIR/${BASENAME}_fastp_report.json"
	fastp -i "$R1_FILE" -I "$R2_FILE" -o "$OUT_R1" -O "$OUT_R2" --detect_adapter_for_pe -l 20 -h "$REPORT_HTML" -j "$REPORT_JSON"
done
