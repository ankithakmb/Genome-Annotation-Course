#!/usr/bin/env bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=120g
#SBATCH --cpus-per-task=16
#SBATCH --job-name=QUAST
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/06_quast_%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/06_quast_%J.err
#SBATCH --partition=pibu_el8

#Variables
WORKDIR="/data/users/${USER}/annotation_course"
OUTDIR="$WORKDIR/Assemblies/Quality/02_Quast"
LOGDIR="$WORKDIR/log"
REFDIR="/data/courses/assembly-annotation-course/references"
REFERENCE="$REFDIR/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
ANNOTATION="$REFDIR/TAIR10_GFF3_genes.gff"
APPTAINERPATH="/containers/apptainer/quast_5.2.0.sif"

#assembly paths
FLYEPATH="$WORKDIR/Assemblies/Flye/assembly.fasta"
HIFIPATH="$WORKDIR/Assemblies/Hifi/HiFiasm_Ice1_primary.fa"
LJAPATH="$WORKDIR/Assemblies/LJA/assembly.fasta"

#Create directories if not already created
mkdir -p $LOGDIR
mkdir -p $OUTDIR
cd $OUTDIR

apptainer exec \
        --bind $WORKDIR \
        --bind $REFDIR \
        $APPTAINERPATH quast.py \
        --eukaryote --est-ref-size 135000000 \
        -o $OUTDIR/wo_ref --threads $SLURM_CPUS_PER_TASK \
        --labels flye,hifiasm,lja $FLYEPATH $HIFIPATH $LJAPATH

apptainer exec \
        --bind $WORKDIR \
        --bind $REFDIR \
        $APPTAINERPATH quast.py \
        --eukaryote -r $REFERENCE -g $ANNOTATION \
        -o $OUTDIR/with_ref --threads $SLURM_CPUS_PER_TASK \
        --labels flye,hifiasm,lja $FLYEPATH $HIFIPATH $LJAPATH 