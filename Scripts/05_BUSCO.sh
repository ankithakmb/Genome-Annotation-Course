#!/usr/bin/env bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=120g
#SBATCH --cpus-per-task=16
#SBATCH --job-name=BUSCO
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/05_busco_%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/05_busco_%J.err
#SBATCH --partition=pibu_el8

#Variables
WORKDIR="/data/users/${USER}/annotation_course"
OUTDIR="$WORKDIR/Assemblies/Quality"
LOGDIR="$WORKDIR/log"
APPTAINERPATH="/containers/apptainer/busco_5.7.1.sif"

#assembly paths
assemblies=(
    "$WORKDIR/Assemblies/Flye/*.fasta:busco_flye:genome"
    "$WORKDIR/Assemblies/Hifi/*_primary.fa:busco_hifiasm:genome"
    "$WORKDIR/Assemblies/LJA/*.fasta:busco_lja:genome"
    "$WORKDIR/Assemblies/Trinity/*.fasta:busco_trinity:transcriptome"
)

# BUSCO parameters
LINEAGE="brassicales_odb10"  # or use "--auto-lineage" for automatic selection

#Create directories if not already created
mkdir -p $LOGDIR
mkdir -p $OUTDIR
cd $OUTDIR

# Function to run BUSCO
run_busco() {
    local assembly=$1
    local name=$2
    local mode=$3
    
    apptainer exec \
        --bind $WORKDIR:$WORKDIR \
        $APPTAINERPATH \
        busco -i $assembly -o $name -m $mode -l $LINEAGE --cpu $SLURM_CPUS_PER_TASK -f
}

# Loop through assemblies
for assembly_info in "${assemblies[@]}"; do
    IFS=':' read -r path name mode <<< "$assembly_info"
    run_busco "$path" "$name" "$mode"
done

