#! /usr/bin/bash
#$ -cwd
#$ -N annot_snv
#$ -o ./log/job.$JOB_NAME.$JOB_ID.$TASK_ID.out
#$ -e ./log/job.$JOB_NAME.$JOB_ID.$TASK_ID.err
#$ -l h_data=6G,h_rt=04:30:00,highp
#$ -pe shared 1
#$ -t 1-1:1

idx=$SGE_TASK_ID
source $HOME/.bashrc

module load /u/local/Modules/default/init/modules.sh
module load samtools
module load anaconda3
conda activate /u/project/gxxiao2/apps/tmp/asarp
set -e -u -o pipefail

DIR_BASE=/u/project/gxxiao2/alisonki/ASARP
DIR_ASARP=${DIR_BASE}/ASARP-bam-friendly-/asarp_vPSI
DIR_OUT=/u/project/gxxiao5/alisonki/ASARP/asarp
DIR_RYAN=/u/project/gxxiao5/rymbarne/analysisS22
metadata=/u/project/gxxiao4/giovas/projects/asarp_msbb/metadata.msbb_rnaseq_brain.filter_cols.tsv
genotype_metadata=/u/project/gxxiao4/giovas/projects/asarp_msbb/metadata.msbb_rnaseq_brain.genotype.biospecimen.tab

# get rnaseq id from bam file
#arr=(${DIR_RYAN}/BAM/*.rmdup.bam)
#rnaseqid=$(echo ${arr[$idx-1]} | cut -d "/" -f 8 | cut -d "." -f 1)
#bamfile=${arr[$idx-1]}
#echo rnaseqid: $rnaseqid
#echo bamfile: $bamfile

# get individual id from metadata, using rnaseq id
#indv_id=$(awk -v rnaseq="$rnaseqid" -F "\t" '$3==(rnaseq) {print $8}' ${metadata})
#echo individual id: $indv_id

#vcf_sample_id=$(less ${genotype_metadata} | grep $indv_id | awk '{print $2}')
#echo vcf sample id: $vcf_sample_id

#config=${DIR_BASE}/config/${rnaseqid}.asarp_config_file
#perl -I ${DIR_ASARP} ${DIR_ASARP}/asarp.pl \
#    ${DIR_OUT}/${rnaseqid} \
#   $config \
#   ${DIR_ASARP}/default.param \
#    ${rnaseqid}
annot_file=/u/project/gxxiao4/giovas/projects/asarp_msbb/annot/gencode.v41.GRCh38.annotation_gene_summary.tsv
#./ASARP/data/hg19.merged.to.ensg.all.tx.03.18.2011.txt.gz
perl -I ${DIR_ASARP} -I ./ASARP ./ASARP/annotSnvGene.pl rbp.final.7filtered_formatted.tab $annot_file >> rbp.kd.labeled_kd.rdd 
	
	
