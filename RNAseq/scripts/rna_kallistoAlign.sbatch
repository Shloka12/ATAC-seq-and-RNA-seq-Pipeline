#!/bin/bash 


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     Slurm Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# job name
#SBATCH --job-name=kallisto_align
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
# #SBATCH --constraint="A100" #"|Turing|gtx1080"

# standard output & error
# #SBATCH --error=std.err
#SBATCH --output=kallisto-%A_%a.out

#SBATCH --array=0-11

# send email about job start and end
#SBATCH --mail-user=shloka@pitt.edu
#SBATCH --mail-type=ALL

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     User Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

eval "$(conda shell.bash hook)"
conda activate bioinfo

sample_ids=("SRR7647654" "SRR7647655" "SRR7647696" "SRR7647697" "SRR7647731" "SRR7647732" "SRR11007067" "SRR11007068" "SRR11007102" "SRR11007103" "SRR11007133" "SRR11007134")

sample_id=${sample_ids[${SLURM_ARRAY_TASK_ID}]}

mkdir -p /net/dali/home/uttam/shloka/rnaseq/kallisto_out

kallisto quant --threads 4 -i /net/dali/home/uttam/shloka/rnaseq/kallisto/grch38_index -o /net/dali/home/uttam/shloka/rnaseq/kallisto_out/${sample_id} /net/dali/home/uttam/shloka/rnaseq/trimmed/${sample_id}_trimmed_1.fastq.gz /net/dali/home/uttam/shloka/rnaseq/trimmed/${sample_id}_trimmed_2.fastq.gz

echo "Kallisto quantification completed for: ${sample_id}"
