#!/bin/bash
#PBS -k o
#PBS -l nodes=2:ppn=6,walltime=5:00:00
#PBS -M parkanha@iupui.edu
#PBS -m abe
#PBS -N hg19ref
#PBS -j oe
  
module load bwa/0.7.12
module load samtools/1.9
#reference, databases and softwares
REF="/N/u/parkanha/Carbonate/Database/GATK/gatk-boundle/hg19/ucsc.hg19.fasta"
PICARD="/N/u/parkanha/Carbonate/picard_2.21.1/picard.jar"
GATK="/N/u/parkanha/Carbonate/gatk-4.1.4.0/gatk"
# https://console.cloud.google.com/storage/browser/gatk-software/package-archive/gatk
GATK3="/N/u/parkanha/Carbonate/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar"
#change following based on genome version, download from ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/
GATK_BUNDLE_DIR="/N/u/parkanha/Carbonate/Database/GATK/gatk-boundle/hg19/"
MILLS=${GATK_BUNDLE_DIR}/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf
PHASE1INDELS=${GATK_BUNDLE_DIR}/1000G_phase1.indels.hg19.sites.vcf
DBSNP=${GATK_BUNDLE_DIR}/dbsnp_138.hg19.vcf

#index reference
#1) for bwa mem
if ! ls ${REF}".bwt" 1> /dev/null 2>&1; then
	${BWA} index -a bwtsw ${REF}
fi
#2) for GATK
REF_BASE="${REF%.*}"
REF_DICT=${REF_BASE}".dict"
if ! ls ${REF_DICT} 1> /dev/null 2>&1; then
	java -jar ${PICARD} CreateSequenceDictionary \
		REFERENCE=${REF} \
		OUTPUT=${REF_DICT}
fi
#3) for GATK
if ! ls ${REF}".fai" 1> /dev/null 2>&1; then
	samtools faidx ${REF}
fi