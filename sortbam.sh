#! /usr/bin/bash
#$ -cwd
#$ -N sortbam 
#$ -o ./log/job.$JOB_NAME.$JOB_ID.out
#$ -e ./log/job.$JOB_NAME.$JOB_ID.err
#$ -l h_data=6G,h_rt=04:30:00,highp
#$ -pe shared 4 
#$ -t 1-1:1

idx=$SGE_TASK_ID
source $HOME/.bashrc

module load /u/local/Modules/default/init/modules.sh
module load samtools
set -e -u -o pipefail


samtools sort ./ctrl.fixed.bam > ./ctrl.sorted.bam
samtools index ./ctrl.sorted.bam





