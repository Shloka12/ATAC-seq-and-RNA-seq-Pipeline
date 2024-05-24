#!/bin/bash 


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     Slurm Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# job name
#SBATCH --job-name=atac_HOMER
# partition (queue) declaration
# Department choices: dept_cpu, dept_gpu, any_cpu, any_gpu, big_memory
# Group choices: bahar_gpu, benos, benos_gpu, camacho_gpu, chakra_24, chakra_gpu
# #SBATCH --partition=big_memory
#SBATCH --cpus-per-task=20
#SBATCH --gres=gpu:1  # Requesting one GPU per task
#SBATCH --mem=100G     # Requesting 32 GB memory per task, adjust as needed
#SBATCH --partition=any_cpu,dept_gpu,any_gpu


# standard output & error
#SBATCH --output=homer.out

#SBATCH --array=0-11

# send email about job start and end
#SBATCH --mail-user=shloka@pitt.edu
#SBATCH --mail-type=ALL

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     User Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


eval "$(conda shell.bash hook)"
conda activate bioinfo


# Define a bash array with paths to your narrowPeak files
declare -a PeakFiles=(
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650729_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650730_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650742_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650743_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650771_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650772_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650784_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650785_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650812_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650813_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650824_peaks.narrowPeak"
  "/net/dali/home/uttam/shloka/atac/peaks/SRR7650825_peaks.narrowPeak"
)

peakFile=${PeakFiles[$SLURM_ARRAY_TASK_ID]}
baseName=$(basename "$peakFile" .narrowPeak)

GENOME="hg38"

# Annotate peaks
annotatePeaks.pl "$peakFile" "$GENOME" > "${baseName}_homer_annotated.txt"

# Motif discovery
findMotifsGenome.pl "$peakFile" "$GENOME" "${baseName}_motifs/" -size given -mask
