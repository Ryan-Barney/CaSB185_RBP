#! /usr/bin/bash
#$ -cwd
#$ -N r_gem
#$ -o log/job.$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e log/job.$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -V
#$ -l h_rt=10:00:00,h_data=16G
#$ -pe shared 2
#$ -t 1-1:1

THREAD=2

idx=$SGE_TASK_ID

source $HOME/.bash_profile

set -e -o pipefail
. /u/local/Modules/default/init/modules.sh
module load samtools

####################

DIR_BASE=/u/home/r/rymbarne/project-gxxiao5
DIR_WORK=${DIR_BASE}/rbp185
DIR_FILES=${DIR_WORK}/nsab/bam
DIR_GIREMI=${DIR_WORK}/giremi-master/giremi
genome=/u/project/gxxiao2/apps/genomes/hg19/all.chr.fa

####################

echo "--- $(date) --- merge bam ---"

samtools merge -o ${DIR_FILES}/ctrl.bam ${DIR_FILES}/*.bam 

bam=${DIR_FILES}/kd.fixed.bam
bb2b=${DIR_WORK}/utilities/bigBedToBed
${bb2b} ${DIR_WORK}/dbSnp153.bb stdout > ${DIR_WORK}/dbSnp153.bed

echo "--- $(date) --- run giremi ---"

export LD_LIBRARY_PATH=/u/home/r/rymbarne/project-gxxiao5/rbp185/htslib-1.3.2
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH":/u/home/r/rymbarne/intel/oneapi/mkl/2023.0.0/lib/intel64/
which R
${DIR_GIREMI} -f ${genome} -l ${DIR_WORK}/kd_snvs_final.tab -o ${DIR_WORK}/kd_giremi_output.txt ${bam}

echo "--- $(date) --- done ---"
