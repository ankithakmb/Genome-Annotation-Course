#!/usr/bin/env bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=64g
#SBATCH --cpus-per-task=16
#SBATCH --job-name=flye
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/04_flye_%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/04_flye_%J.err
#SBATCH --partition=pibu_el8

#Variables
WORKDIR="/data/users/${USER}/annotation_course"
OUTDIR="$WORKDIR/Assemblies/Flye"
LOGDIR="$WORKDIR/log/"
READDIR="$WORKDIR/Fastp/pacbio_ERR11437339.fastq.gz"
APPTAINERPATH="/containers/apptainer/flye_2.9.5.sif"

#Create the directory for the error and output file if not already created
mkdir -p $LOGDIR

#Create the directory output 
mkdir -p $OUTDIR
cd $OUTDIR

#run flye assembly for Pacbio reads
apptainer exec --bind /data "$APPTAINERPATH" flye --pacbio-hifi "$READDIR" \
                --out-dir "$OUTDIR" \
                --threads 16