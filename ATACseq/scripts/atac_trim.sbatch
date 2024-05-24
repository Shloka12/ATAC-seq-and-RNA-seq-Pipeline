#!/bin/bash 


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     Slurm Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# job name
#SBATCH --job-name=ATACseq_trim
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
#SBATCH --output=trim-%A_%a.out

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

OUT_DIR="/net/dali/home/uttam/shloka/atac/trimmed"
mkdir -p ${OUT_DIR}

sample_ids=("SRR7650742" "SRR7650743" "SRR7650784" "SRR7650785" "SRR7650824" "SRR7650825" "SRR7650729" "SRR7650730" "SRR7650771" "SRR7650772" "SRR7650812" "SRR7650813")


sample_id=${sample_ids[${SLURM_ARRAY_TASK_ID}]}

cutadapt -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -m 20 -O 5 -o ${OUT_DIR}/${sample_id}_trimmed_1.fastq.gz -p ${OUT_DIR}/${sample_id}_trimmed_2.fastq.gz ${FASTQ_DIR}/${sample_id}_pass_1.fastq.gz ${FASTQ_DIR}/${sample_id}_pass_2.fastq.gz


echo "Trimming completed for: ${sample_id}"
