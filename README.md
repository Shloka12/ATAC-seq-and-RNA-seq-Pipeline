# Regulatory and Transcriptional Dynamics in B and T Cells: An ATAC/RNA-seq Study

## Introduction

Welcome to this comprehensive repository, dedicated to analyzing ATAC-seq and RNA-seq data. Here, you will find specialized pipelines developed to explore the regulatory and transcriptional dynamics in T cells and B cells. This collection of workflows is designed to provide clear, reproducible results.

## Project Contents

This repository contains two primary pipelines:
- **RNA-seq Pipeline**: Analyzes transcriptomic data to identify differential gene expression.
- **ATAC-seq Pipeline**: Processes genomic accessibility data to identify differential peak regions.

Each pipeline is thoroughly documented to ensure reproducibility and robustness.

## RNA-seq Pipeline Overview

### Workflow Steps

1. **Data Retrieval** (`rna_fastq.sbatch.sh`)
   - **Input**: SRA accession numbers.
   - **Output**: Downloaded FASTQ files.
2. **Quality Control** (`rna_fastqc.sbatch`, `rna_multiqc.sbatch`)
   - **Input**: Raw FASTQ files.
   - **Output**: HTML reports on sequencing quality.
3. **Data Trimming** (`rna_trim.sbatch`)
   - **Input**: Raw FASTQ files.
   - **Output**: Trimmed FASTQ files.
4. **Alignment** (`rna_kallistoAlign.sbatch`)
   - **Input**: Trimmed FASTQ files.
   - **Output**: Kallisto output files, including abundance estimations.
5. **Differential Expression Analysis** (`RNAseq_analysis.Rmd`)
   - **Input**: Kallisto output files.
   - **Output**: Statistical comparisons, plots, and final reports.

### Scripts and Documentation

Detailed descriptions and instructions for each script are available within the subdirectories.

## ATAC-seq Pipeline Overview

### Workflow Steps

1. **Data Retrieval** (`atac_alldonors_fastq.sbatch`)
   - **Input**: SRA accession numbers.
   - **Output**: Downloaded FASTQ files.
2. **Preprocessing** (`atac_trim.sbatch`, `atac_align.sbatch`, `atac_filter_rev.sbatch`)
   - **Input**: Raw FASTQ files.
   - **Output**: BAM files of aligned sequences.
3. **Peak Calling** (`atac_peakCalling.sbatch`)
   - **Input**: Filtered BAM files.
   - **Output**: BED files with detected peaks.
4. **Annotation and Differential Analysis** (`atac_homer.sbatch`, `atac_diffPeakAnalys_tcell_bcell.Rmd`)
   - **Input**: BED files, count matrices.
   - **Output**: Annotated peak lists, differential analysis reports.

### Scripts and Documentation

Each script's role is well-documented, with a focus on ease of use and reproducibility.

## License

This project is licensed under the MIT License.

