#!/usr/bin/env bash
#SBATCH --time=2:00:00
#SBATCH --mem=20g
#SBATCH --cpus-per-task=3
#SBATCH --job-name=fastp
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/02_fastp_%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/02_fastp_%J.err
#SBATCH --partition=pibu_el8

#Variables
WORKDIR="/data/users/${USER}/annotation_course/"
OUTDIR="$WORKDIR/Fastp"
LOGDIR="$WORKDIR/log"

#Path to reads
PACBIO_DIR="$WORKDIR/Ice-1"
RNASEQ_DIR="$WORKDIR/RNAseq_Sha"

#Create the directory output 
mkdir -p $OUTDIR
cd $OUTDIR

#run fastp on pacbio reads WITHOUT FILTERING to get the total number of bases
apptainer exec --bind /data /containers/apptainer/fastp_0.24.1.sif fastp -i ${PACBIO_DIR}/*.fastq.gz \
            -o ${OUTDIR}/pacbio_ERR11437339.fastq.gz \
            --disable_quality_filtering --disable_length_filtering \
            --json ${OUTDIR}/pacbio_ERR11437339.json \
            --html ${OUTDIR}/pacbio_ERR11437339.html

#run fastp for rnasef reads to trim bad quality reads 
apptainer exec --bind /data /containers/apptainer/fastp_0.24.1.sif fastp -i ${RNASEQ_DIR}/*_1.fastq.gz \
        -I ${RNASEQ_DIR}/*_2.fastq.gz \
        -o ${OUTDIR}/rnaseq_ERR754081_1.fastq.gz \
        -O ${OUTDIR}/rnaseq_ERR754081_2.fastq.gz \
        --json ${OUTDIR}/rnaseq_ERR754081.json \
        --html ${OUTDIR}/rnaseq_ERR754081.html 