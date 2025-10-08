#!/usr/bin/env bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=80G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=hifi
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/04_hifi_%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/04_hifi_%J.err
#SBATCH --partition=pibu_el8

#Variables
WORKDIR="/data/users/${USER}/annotation_course"
OUTDIR="$WORKDIR/Assemblies/Hifi"
LOGDIR="$WORKDIR/log/"
READDIR="$WORKDIR/Fastp/pacbio_ERR11437339.fastq.gz"
APPTAINERPATH="/containers/apptainer/hifiasm_0.25.0.sif"

#Create the directory for the error and output file if not already created
mkdir -p $LOGDIR

#Create the directory output 
mkdir -p $OUTDIR
cd $OUTDIR

#run assembly for hifi
apptainer exec --bind /data "$APPTAINERPATH" hifiasm -o "$OUTDIR/HiFiasm_Ice1.asm" \
                -t 16 \
                "$READDIR"

# Convert primary assembly (GFA to FASTA)
awk '/^S/{print ">"$2;print $3}' "$OUTDIR/HiFiasm_Ice1.asm.bp.p_ctg.gfa" > "$OUTDIR/HiFiasm_Ice1_primary.fa"

# Convert alternate assembly (GFA to FASTA) 
awk '/^S/{print ">"$2;print $3}' "$OUTDIR/HiFiasm_Ice1.asm.bp.hap1.p_ctg.gfa" > "$OUTDIR/HiFiasm_Ice1_hap1.fa"
awk '/^S/{print ">"$2;print $3}' "$OUTDIR/HiFiasm_Ice1.asm.bp.hap2.p_ctg.gfa" > "$OUTDIR/HiFiasm_Ice1_hap2.fa"