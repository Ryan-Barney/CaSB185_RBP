#! /usr/bin/bash
#$ -cwd
#$ -N RNAeditPipe
#$ -o /u/home/m/melluo/project-gxxiao2/logs/job.$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e /u/home/m/melluo/project-gxxiao2/logs/job.$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -l h_rt=2:00:00,highp
#$ -pe shared 2

source $HOME/.bashrc
set -e -o pipefail
. /u/local/Modules/default/init/modules.sh

module load R
pip install rpy2 --user 

home=/u/project/gxxiao2/melluo/casb185
scripts=${home}/RNA_editing-master/RBP_regulation/demo
outputs=${home}/outputs

control=${home}/ctrl.editing_sites.tab,${home}/ctrl.editing_sites.tab
KD=${home}/kd.editing_sites.tab,${home}/kd.editing_sites.tab

echo $(date) "step 1: obtain data matrices"
python ${scripts}/pipeline.make_matrix_1.py ${control} 5 ${outputs}/trainMat.tab
python ${scripts}/pipeline.make_matrix_2.py ${KD} 5 ${outputs}/KD.testMat.tab
python ${scripts}/pipeline.make_matrix_2.py ${control} 5 ${outputs}/CTRL.testMat.tab

echo $(date) "step 2: obtain batch means"
batch_files=`ls ${outputs}/*.testMat.no_batch_mean.both_rep_cov.tab | tr '\n' ','`
python ${scripts}/pipeline.get_batch_means.py ${batch_files} ${outputs}/batch_means.txt

echo $(date) "step 3: obtain final matrices"
python ${scripts}/pipeline.make_matrix_3.py ${outputs}/KD.testMat.no_batch_mean.both_rep_cov.tab ${outputs}/batch_means.txt ${outputs}/KDfinalMatwMeans.tab
python ${scripts}/pipeline.make_matrix_3.py ${outputs}/CTRL.testMat.no_batch_mean.both_rep_cov.tab ${outputs}/batch_means.txt ${outputs}/CTRLfinalMatwMeans.tab
