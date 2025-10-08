#!/usr/bin/env bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=120g
#SBATCH --cpus-per-task=16
#SBATCH --job-name=nucmer_mummer
#SBATCH --mail-user=ramakanth.kumble@students.unibe.ch
#SBATCH --mail-type=end
#SBATCH --output=/data/users/rkumble/annotation_course/log/08_nucmer_mummer_%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/08_nucmer_mummer_%J.err
#SBATCH --partition=pibu_el8

# Paths
WORKDIR="/data/users/${USER}/annotation_course"
OUTDIR="$WORKDIR/Assemblies/Comparisons"
LOGDIR="$WORKDIR/log"

#assembly paths
FLYE="$WORKDIR/Assemblies/Flye/assembly.fasta"
HIFIASM="$WORKDIR/Assemblies/Hifi/HiFiasm_Ice1_primary.fa"
LJA="$WORKDIR/Assemblies/LJA/assembly.fasta"

# Reference genome path
REFERENCE="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

# Container path
APPTAINERPATH="/containers/apptainer/mummer4_gnuplot.sif"

# Create directories
mkdir -p $LOGDIR
mkdir -p $OUTDIR
cd $OUTDIR

# Define assemblies in an associative array
declare -A ASSEMBLIES
ASSEMBLIES[flye]="$WORKDIR/Assemblies/Flye/assembly.fasta"
ASSEMBLIES[hifiasm]="$WORKDIR/Assemblies/Hifi/HiFiasm_Ice1_primary.fa"
ASSEMBLIES[lja]="$WORKDIR/Assemblies/LJA/assembly.fasta"

# Part 1: Compare all assemblies vs reference
for ASSEMBLY_NAME in "${!ASSEMBLIES[@]}"; do
    echo "Processing ${ASSEMBLY_NAME} vs reference..."
    
    # Create output directory for this comparison
    mkdir -p "$OUTDIR/${ASSEMBLY_NAME}_vs_ref"
    cd "$OUTDIR/${ASSEMBLY_NAME}_vs_ref"
    
    # Run nucmer
    apptainer exec --bind /data "$APPTAINERPATH" nucmer \
        --prefix=${ASSEMBLY_NAME}_vs_ref \
        --breaklen=1000 \
        --mincluster=1000 \
        "$REFERENCE" \
        "${ASSEMBLIES[$ASSEMBLY_NAME]}"
    
    # Generate mummerplot
    apptainer exec --bind /data "$APPTAINERPATH" mummerplot \
        -R "$REFERENCE" \
        -Q "${ASSEMBLIES[$ASSEMBLY_NAME]}" \
        --filter \
        -t png \
        --large \
        --layout \
        --fat \
        --prefix=${ASSEMBLY_NAME}_vs_ref \
        ${ASSEMBLY_NAME}_vs_ref.delta
    
    echo "Completed ${ASSEMBLY_NAME} vs reference"
done

#Part 2: compare assemblies against each other 

# 1. Flye vs Hifiasm
echo "Processing Flye vs Hifiasm..."
mkdir -p "$OUTDIR/flye_vs_hifiasm"
cd "$OUTDIR/flye_vs_hifiasm"

apptainer exec --bind /data "$APPTAINERPATH" nucmer \
    --prefix=flye_vs_hifiasm \
    --breaklen=1000 \
    --mincluster=1000 \
    "$FLYE" \
    "$HIFIASM"

apptainer exec --bind /data "$APPTAINERPATH" mummerplot \
    -R "$FLYE" \
    -Q "$HIFIASM" \
    --filter \
    -t png \
    --large \
    --layout \
    --fat \
    --prefix=flye_vs_hifiasm \
    flye_vs_hifiasm.delta

echo "Completed Flye vs Hifiasm"

# 2. Flye vs LJA
echo "Processing Flye vs LJA..."
mkdir -p "$OUTDIR/flye_vs_lja"
cd "$OUTDIR/flye_vs_lja"

apptainer exec --bind /data "$APPTAINERPATH" nucmer \
    --prefix=flye_vs_lja \
    --breaklen=1000 \
    --mincluster=1000 \
    "$FLYE" \
    "$LJA"

apptainer exec --bind /data "$APPTAINERPATH" mummerplot \
    -R "$FLYE" \
    -Q "$LJA" \
    --filter \
    -t png \
    --large \
    --layout \
    --fat \
    --prefix=flye_vs_lja \
    flye_vs_lja.delta

echo "Completed Flye vs LJA"

# 3. Hifiasm vs LJA
echo "Processing Hifiasm vs LJA..."
mkdir -p "$OUTDIR/hifiasm_vs_lja"
cd "$OUTDIR/hifiasm_vs_lja"

apptainer exec --bind /data "$APPTAINERPATH" nucmer \
    --prefix=hifiasm_vs_lja \
    --breaklen=1000 \
    --mincluster=1000 \
    "$HIFIASM" \
    "$LJA"

apptainer exec --bind /data "$APPTAINERPATH" mummerplot \
    -R "$HIFIASM" \
    -Q "$LJA" \
    --filter \
    -t png \
    --large \
    --layout \
    --fat \
    --prefix=hifiasm_vs_lja \
    hifiasm_vs_lja.delta

echo "Completed Hifiasm vs LJA"

#Summary
echo "=================================="
echo "ANALYSIS COMPLETED"
echo "Completion time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Output directory: $OUTDIR"
echo ""
echo "--- Assemblies vs Reference ---"
echo "  → flye_vs_ref/"
echo "  → hifiasm_vs_ref/"
echo "  → lja_vs_ref/"
echo "-------------------------------------"
echo "--- Pairwise Assembly Comparisons ---"
echo "  → flye_vs_hifiasm/"
echo "  → flye_vs_lja/"
echo "  → hifiasm_vs_lja/"
echo ""
echo "File descriptions:"
echo "  *.delta  - Binary alignment data"
echo "  *.png    - Dotplot visualization"
echo "=========================================="
