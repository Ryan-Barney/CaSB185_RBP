#! /usr/bin/bash
#$ -cwd
#$ -N r_sam2bam
#$ -o log/job.$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e log/job.$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -V
#$ -l h_rt=5:00:00,highp
#$ -pe shared 1
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
DIR_FILES=${DIR_WORK}/siab/sam
DIR_OUT=${DIR_WORK}/siab/bam

####################

for i in {1..22} {X..Y}; do
    samtools view -S -b ${DIR_FILES}/chr${i}.one.sam.true > ${DIR_OUT}/chr${i}.bam
done
