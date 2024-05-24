#!/bin/bash 


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     Slurm Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# job name
#SBATCH --job-name=filter_align
# partition (queue) declaration
# Department choices: dept_cpu, dept_gpu, any_cpu, any_gpu, big_memory
# Group choices: bahar_gpu, benos, benos_gpu, camacho_gpu, chakra_24, chakra_gpu
# #SBATCH --partition=big_memory
#SBATCH --cpus-per-task=20
#SBATCH --gres=gpu:1  # Requesting one GPU per task
#SBATCH --mem=100G     # Requesting 32 GB memory per task, adjust as needed
#SBATCH --partition=any_cpu,dept_gpu,any_gpu


# standard output & error
#SBATCH --output=filter-%A_%a.out

#SBATCH --array=0-11

# send email about job start and end
#SBATCH --mail-user=shloka@pitt.edu
#SBATCH --mail-type=ALL

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#                     User Construction Section
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

eval "$(conda shell.bash hook)"
conda activate bioinfo


# Define your directories

OUT_DIR="/net/dali/home/uttam/shloka/atac/alignment"

PICARD_JAR="/net/dali/home/uttam/shloka/picard.jar"  # Make sure to specify the correct path to your Picard jar file



# Array of sample identifiers (from previous steps)

sample_ids=("SRR7650742" "SRR7650743" "SRR7650784" "SRR7650785" "SRR7650824" "SRR7650825" "SRR7650729" "SRR7650730" "SRR7650771" "SRR7650772" "SRR7650812" "SRR7650813")

sample_id=${sample_ids[${SLURM_ARRAY_TASK_ID}]}



# Samtools filter

if [ -f ${OUT_DIR}/${sample_id}_bowtie2_sorted.bam ]; then
    samtools view -h -q 30 -F 1804 -f 2 -b ${OUT_DIR}/${sample_id}_bowtie2_sorted.bam > ${OUT_DIR}/${sample_id}_filtered.bam

    # Check if filtered BAM was created successfully
    if [ -f ${OUT_DIR}/${sample_id}_filtered.bam ]; then
        java -jar $PICARD_JAR MarkDuplicates INPUT=${OUT_DIR}/${sample_id}_filtered.bam OUTPUT=${OUT_DIR}/${sample_id}_filtered_rmdup.bam METRICS_FILE=${OUT_DIR}/${sample_id}_dup_metrics.txt REMOVE_DUPLICATES=true ASSUME_SORTED=true

        # Check if Picard completed successfully and the dedup file exists
        if [ -f ${OUT_DIR}/${sample_id}_filtered_rmdup.bam ]; then
            samtools index ${OUT_DIR}/${sample_id}_filtered_rmdup.bam
            echo "Filtering and deduplication completed for: ${sample_id}"
        else
            echo "Error: Picard did not generate a deduplicated BAM for ${sample_id}."
        fi
    else
        echo "Error: Failed to create filtered BAM for ${sample_id}."
    fi
else
    echo "Error: Sorted BAM does not exist for ${sample_id}."
fi


echo "Filtering and deduplication completed for: ${sample_id}"


