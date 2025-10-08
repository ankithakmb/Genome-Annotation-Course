#!/usr/bin/env bash
#SBATCH --time=2:00:00
#SBATCH --mem=1g
#SBATCH --cpus-per-task=1
#SBATCH --job-name=download_reads
#SBATCH --output=/data/users/rkumble/annotation_course/log/00_download_reads%J.out
#SBATCH --error=/data/users/rkumble/annotation_course/log/00_download_reads%J.err
#SBATCH --partition=pibu_el8

ln -s /data/courses/assembly-annotation-course/raw_data/Ice-1 ./
ln -s /data/courses/assembly-annotation-course/raw_data/RNAseq_Sha ./