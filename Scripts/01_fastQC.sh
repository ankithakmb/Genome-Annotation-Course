#!/usr/bin/env bash
#SBATCH --time=2:00:00
#SBATCH --mem=1g
#SBATCH --cpus-per-task=2
#SBATCH --job-name=fastQC
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/01_fastQC_%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/01_fastQC_%J.err
#SBATCH --partition=pibu_el8

#Variables
WORKDIR="/data/users/${USER}/annotation_course/"
OUTDIR="$WORKDIR/QC_results/"
LOGDIR="$WORKDIR/log/"

#Create the directory for the error and output file if not already created
mkdir -p $LOGDIR

#Path to reads, pre trimming 
PACBIO="$WORKDIR/Ice-1/*.fastq.gz"
RNASEQ="$WORKDIR/RNAseq_Sha/*.fastq.gz"

#Create the directory output 
mkdir -p $OUTDIR
cd $OUTDIR

#run fastqc for both reads and put the result in outfile
apptainer exec --bind /data /containers/apptainer/fastqc-0.12.1.sif fastqc -t 2 $PACBIO $RNASEQ -o $OUTDIR

# #Path to reads post trimming
# RNASEQ="$WORKDIR/Fastp/rnaseq*.fastq.gz"

# #Create the directory output 
# mkdir -p $OUTDIR
# cd $OUTDIR

# #run fastqc for both rnaseq reads after trimming and put the result in outfile
# apptainer exec --bind /data /containers/apptainer/fastqc-0.12.1.sif fastqc -t 2 $RNASEQ -o $OUTDIR