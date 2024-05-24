#!/bin/bash 


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     Slurm Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# job name
#SBATCH --job-name=atac_getCountMatrix
# partition (queue) declaration
# Department choices: dept_cpu, dept_gpu, any_cpu, any_gpu, big_memory
# Group choices: bahar_gpu, benos, benos_gpu, camacho_gpu, chakra_24, chakra_gpu
# #SBATCH --partition=big_memory
#SBATCH --cpus-per-task=30
#SBATCH --gres=gpu:1  # Requesting one GPU per task
#SBATCH --mem=500G     # Requesting 32 GB memory per task, adjust as needed
#SBATCH --partition=any_cpu,dept_gpu,any_gpu


# standard output & error
#SBATCH --output=countMat.out

# #SBATCH --array=0-11

# send email about job start and end
#SBATCH --mail-user=shloka@pitt.edu
#SBATCH --mail-type=ALL

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     User Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


eval "$(conda shell.bash hook)"
conda activate bioinfo


# Count reads in merged peaks using bedtools multicov
bedtools multicov -bams SRR7650742_filtered_rmdup.bam SRR7650784_filtered_rmdup.bam SRR7650824_filtered_rmdup.bam \
                        SRR7650743_filtered_rmdup.bam SRR7650785_filtered_rmdup.bam SRR7650825_filtered_rmdup.bam \
                  -bed merged_peaks_tcells.bed > counts_matrix_tcells.txt
