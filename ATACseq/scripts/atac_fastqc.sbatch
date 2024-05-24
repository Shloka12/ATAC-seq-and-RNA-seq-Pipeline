#!/bin/bash 


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     Slurm Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# job name
#SBATCH --job-name=ATACseq_fastqc
# partition (queue) declaration
# Department choices: dept_cpu, dept_gpu, any_cpu, any_gpu, big_memory
# Group choices: bahar_gpu, benos, benos_gpu, camacho_gpu, chakra_24, chakra_gpu
#SBATCH --partition=dept_gpu

# number of requested nodes
#SBATCH --nodes=1

# number of tasks
#SBATCH --ntasks=1

# number of requested cores
#SBATCH --ntasks-per-node=1

# request a GPU
#SBATCH --gres=gpu:1

# request a specific node
# #SBATCH --nodelist=g101

# call a Slurm Feature
# #SBATCH --constraint=4C
# #SBATCH --constraint="L40|A100|Turing|gtx1080"

# standard output & error
# #SBATCH --error=std.err
#SBATCH --output=fastqc-%A_%a.out

#SBATCH --array=0-11

# send email about job start and end
#SBATCH --mail-user=shloka@pitt.edu
#SBATCH --mail-type=ALL

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     User Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

eval "$(conda shell.bash hook)"
conda activate bioinfo

FASTQ_DIR="/net/dali/home/uttam/shloka/atac/fastq"

sra_numbers=("SRR7650742" "SRR7650743" "SRR7650784" "SRR7650785" "SRR7650824" "SRR7650825" "SRR7650729" "SRR7650730" "SRR7650771" "SRR7650772" "SRR7650812" "SRR7650813")


sra_id=${sra_numbers[${SLURM_ARRAY_TASK_ID}]}

mkdir -p ${FASTQ_DIR}/../fastqc_initial
# Run FastQC on the pass_1 and pass_2 fastq files for the specified SRA ID

fastqc -o ${FASTQ_DIR}/../fastqc_initial ${FASTQ_DIR}/${sra_id}_pass_1.fastq.gz ${FASTQ_DIR}/${sra_id}_pass_2.fastq.gz

echo "FastQC analysis completed for: ${sra_id}"
