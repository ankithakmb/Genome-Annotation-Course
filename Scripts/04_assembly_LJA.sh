#!/usr/bin/env bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=64g
#SBATCH --cpus-per-task=16
#SBATCH --job-name=LJA
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/04_LJA_%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/04_LJA_%J.err
#SBATCH --partition=pibu_el8

#Variables
WORKDIR="/data/users/${USER}/annotation_course"
OUTDIR="$WORKDIR/Assemblies/LJA"
LOGDIR="$WORKDIR/log/"
READDIR="$WORKDIR/Fastp/pacbio_ERR11437339.fastq.gz"
APPTAINERPATH="/containers/apptainer/lja-0.2.sif"

#Create the directory for the error and output file if not already created
mkdir -p $LOGDIR

#Create the directory output 
mkdir -p $OUTDIR
cd $OUTDIR

#Run hifi assembly
apptainer exec --bind /data "$APPTAINERPATH" lja -o "$OUTDIR" \
                --reads "$READDIR" \
                --threads 16 
