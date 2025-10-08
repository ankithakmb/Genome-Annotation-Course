#!/usr/bin/env bash
#SBATCH --time=2:00:00
#SBATCH --mem=40g
#SBATCH --cpus-per-task=4
#SBATCH --job-name=KmerCount
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/03_KmerCount%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/03_KmerCount%J.err
#SBATCH --partition=pibu_el8

#Variables
WORKDIR="/data/users/${USER}/annotation_course"
OUTDIR="$WORKDIR/QC_results"
LOGDIR="$WORKDIR/log/"

#Path to reads, post trimming 
PACBIO="$WORKDIR/Fastp/pacbio*.fastq.gz"

#Create the directory output 
mkdir -p $OUTDIR
cd $OUTDIR

#run jellyfish only for pacbio --> need unbiased WGS data
apptainer exec --bind /data /containers/apptainer/jellyfish:2.2.6--0 jellyfish count \
        -m 21 \
        -s 5G \
        -t 4 \
        -C \
        -o ${OUTDIR}/pacbio_kmers.jf \
        <(zcat $PACBIO)

apptainer exec --bind /data /containers/apptainer/jellyfish:2.2.6--0 jellyfish histo \
    -t 4 \
    ${OUTDIR}/pacbio_kmers.jf > ${OUTDIR}/pacbio_kmers.histo