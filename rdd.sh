#! /usr/bin/bash
#$ -cwd
#$ -N rbp_rdd 
#$ -o ./log/job.$JOB_NAME.$JOB_ID.out
#$ -e ./log/job.$JOB_NAME.$JOB_ID.err
#$ -l h_data=6G,h_rt=04:30:00,highp
#$ -pe shared 4 
#$ -t 1-1:1

idx=$SGE_TASK_ID
source $HOME/.bashrc

module load /u/local/Modules/default/init/modules.sh
module load samtools
module load anaconda3
conda activate /u/project/gxxiao2/apps/tmp/asarp
set -e -u -o pipefail

DIR_BASE=/u/project/gxxiao2/alisonki/ASARP
DIR_RDD_PIPELN=/u/project/gxxiao2/apps/tmp/RDD_pipeline
DIR_RYAN=/u/project/gxxiao5/rymbarne/analysisS22
DIR_RDD=/u/project/gxxiao5/alisonki/ASARP/RDD
genome_fa=/u/project/gxxiao5/rymbarne/rbp185/genome/hg19.fa

bamfile=./ctrl.sorted.bam
echo bamfile: $bamfile

chroms=(chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12
        chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY)

for chrom in "${chroms[@]}"
do
        # obtain coordinates of RDDs
        python ${DIR_RDD_PIPELN}/step1_get_rdd_coordinates.py \
                -b $bamfile \
                --user_coordinates /u/project/gxxiao4/kofiamoa/anno/hg19/dbsnp.141.bed \
                -c $chrom \
                -o /u/project/gxxiao2/alisonki/rbp/ctrl \
                -f ${genome_fa} \

        # obtain RDDs reads and training data
        python ${DIR_RDD_PIPELN}/step2.get.mm_pileup_reads.py \
               -b $bamfile \
               -c $chrom \
               -o /u/project/gxxiao2/alisonki/rbp/ctrl \
               -i ctrl \
               --bedgraph_dir /u/project/gxxiao2/alisonki/rbp/ctrl \
               --strandedness fr-unstrand 
done

echo $(date) step 3: merge reads, calculate LLR
# obtain SNV read counts
python ${DIR_RDD_PIPELN}/step3.merge_reads_and_llr_cal.py \
       -o /u/project/gxxiao2/alisonki/rbp/ctrl \
       -i ctrl \

echo $(date) remove temporary files
rm /u/project/gxxiao2/alisonki/rbp.tmp*




