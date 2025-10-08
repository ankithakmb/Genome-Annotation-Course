#!/usr/bin/env bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=120g
#SBATCH --cpus-per-task=16
#SBATCH --job-name=trinity
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/04_trinity_%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/04_trinity_%J.err
#SBATCH --partition=pibu_el8

#Variables
WORKDIR="/data/users/${USER}/annotation_course"
OUTDIR="$WORKDIR/Assemblies/Trinity"
LOGDIR="$WORKDIR/log/"
READDIR="$WORKDIR/Fastp"

#Create the directory for the error and output file if not already created
mkdir -p $LOGDIR

#Create the directory output 
mkdir -p $OUTDIR
cd $OUTDIR

#Run assembly for rnaseq reads, Trinity runs as a module - add module and then run 
module load Trinity
Trinity --seqType fq \
        --left ${READDIR}/rnaseq*_1.fastq.gz \
        --right ${READDIR}/rnaseq*_2.fastq.gz \
        --CPU 16 --max_memory 64G 