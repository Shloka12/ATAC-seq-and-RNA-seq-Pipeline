#!/bin/bash 


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     Slurm Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# job name
#SBATCH --job-name=peak__align
# partition (queue) declaration
# Department choices: dept_cpu, dept_gpu, any_cpu, any_gpu, big_memory
# Group choices: bahar_gpu, benos, benos_gpu, camacho_gpu, chakra_24, chakra_gpu
# #SBATCH --partition=big_memory
#SBATCH --cpus-per-task=20
#SBATCH --gres=gpu:1  # Requesting one GPU per task
#SBATCH --mem=100G     # Requesting 32 GB memory per task, adjust as needed
#SBATCH --partition=any_cpu,dept_gpu,any_gpu


# standard output & error
#SBATCH --output=peak-%A_%a.out

#SBATCH --array=0-11

# send email about job start and end
#SBATCH --mail-user=shloka@pitt.edu
#SBATCH --mail-type=ALL

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     User Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

eval "$(conda shell.bash hook)"
conda activate bioinfo

OUT_DIR="/net/dali/home/uttam/shloka/atac/alignment"
PEAKS_DIR="/net/dali/home/uttam/shloka/atac/peaks"
mkdir -p $PEAKS_DIR

sample_ids=("SRR7650742" "SRR7650743" "SRR7650784" "SRR7650785" "SRR7650824" "SRR7650825" "SRR7650729" "SRR7650730" "SRR7650771" "SRR7650772" "SRR7650812" "SRR7650813")
sample_id=${sample_ids[${SLURM_ARRAY_TASK_ID}]}

macs2 callpeak -t ${OUT_DIR}/${sample_id}_filtered_rmdup.bam -f BAMPE -n ${sample_id} --outdir ${PEAKS_DIR} --nomodel --shift -100 --extsize 200 -g hs --keep-dup all --call-summits; echo "Peak calling completed for: ${sample_id}"
echo "Peak calling completed for: ${sample_id}"
