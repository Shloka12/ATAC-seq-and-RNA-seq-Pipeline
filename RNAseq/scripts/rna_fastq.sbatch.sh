#!/bin/bash 

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     Slurm Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# job name
#SBATCH --job-name=RNAseq_fastq_dump
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
# #SBATCH --constraint="A100|L40|Turing|gtx1080"

# standard output & error
# #SBATCH --error=std.err
#SBATCH --output=fastq_dump-%A_%a.out

#SBATCH --array=0-11

# send email about job start and end
#SBATCH --mail-user=shloka@pitt.edu
#SBATCH --mail-type=ALL

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     User Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

eval "$(conda shell.bash hook)"
conda activate bioinfo

sra_numbers=("SRR7647654" "SRR7647655" "SRR7647696" "SRR7647697" "SRR7647731" "SRR7647732" "SRR11007067" "SRR11007068" "SRR11007102" "SRR11007103" "SRR11007133" "SRR11007134")

sra_directory="/net/dali/home/uttam/shloka/rnaseq"

sra_id=${sra_numbers[${SLURM_ARRAY_TASK_ID}]}

echo "Prefetching SRA file for: ${sra_id}"

prefetch_cmd="prefetch --output-directory ${sra_directory} ${sra_id}"
eval ${prefetch_cmd}

echo "Generating fastq for: ${sra_id}"

fastq_dump="fastq-dump --outdir ${sra_directory}/fastq --gzip --skip-technical --readids --read-filter pass --dumpbase --split-e --clip --origfmt ${sra_directory}/${sra_id}/${sra_id}.sra"



eval ${fastq_dump}
