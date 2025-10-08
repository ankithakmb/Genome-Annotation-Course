#!/usr/bin/env bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=120g
#SBATCH --cpus-per-task=16
#SBATCH --job-name=Merqury
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/07_Merqury_%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/07_Merqury_%J.err
#SBATCH --partition=pibu_el8

#Paths
WORKDIR="/data/users/${USER}/annotation_course"
READDIR="$WORKDIR/Ice-1" #path to PacBio HiFi reads
OUTDIR="$WORKDIR/Assemblies/Quality/03_Merqury"
LOGDIR="$WORKDIR/log"

#Create directories if not already created
mkdir -p $LOGDIR
mkdir -p $OUTDIR
cd $OUTDIR


#Path inside container
export MERQURY="/usr/local/share/merqury"


#apptainer path
APPTAINERPATH="/containers/apptainer/merqury_1.3.sif"


# Build meryl database if it doesn't exist
if [ ! -d "$OUTDIR/hifi_asm.meryl" ]; then
    echo "Building Meryl database..."
    
    apptainer exec --bind /data $APPTAINERPATH \
    meryl k=21 count output "$OUTDIR/hifi_asm.meryl" $READDIR/*.fastq.gz
else
    echo "Using existing Meryl database at: $OUTDIR/hifi_asm.meryl"
fi


# Run Merqury for each assembly using a for loop
declare -A ASSEMBLIES
ASSEMBLIES[flye]="$WORKDIR/Assemblies/Flye/assembly.fasta"
ASSEMBLIES[hifiasm]="$WORKDIR/Assemblies/Hifi/HiFiasm_Ice1_primary.fa"
ASSEMBLIES[lja]="$WORKDIR/Assemblies/LJA/assembly.fasta"


for ASSEMBLY_NAME in "${!ASSEMBLIES[@]}"; do
    echo "Running Merqury for ${ASSEMBLY_NAME} assembly..."
    mkdir -p $OUTDIR/${ASSEMBLY_NAME}
    cd $OUTDIR/${ASSEMBLY_NAME}
    
    apptainer exec --bind /data $APPTAINERPATH \
    $MERQURY/merqury.sh "$OUTDIR/hifi_asm.meryl" ${ASSEMBLIES[$ASSEMBLY_NAME]} ${ASSEMBLY_NAME}
done

cd $OUTDIR

echo "Merqury analysis complete for all assemblies!"