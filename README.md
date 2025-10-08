# Genome Annotation Course

Welcome to the **Genome Annotation Course** repository!  
This repository contains resources, code, and materials for the genome annotation module.

## Overview

This repository contains all files, scripts, and documentation associated with the Genome Annotation Course. The primary objective of this course is to perform genome and transcriptome analysis, from raw sequencing reads to assembly evaluation and comparative genomics.

---

## Sample Description

For this module, the **Ice-1 Arabidopsis thaliana accession** was used as the sample for analysis.

**References:**

- Qichao Lian et al. "A pan-genome of 69 Arabidopsis thaliana accessions reveals a conserved genome structure throughout the global species range." Nature Genetics. 2024;56:982-991. [Available online](https://www.nature.com/articles/s41588-024-01715-9)
- Jiao WB, Schneeberger K. "Chromosome-level assemblies of multiple Arabidopsis genomes reveal hotspots of rearrangements with altered evolutionary dynamics." Nature Communications. 2020;11:1–10. [Available online](http://dx.doi.org/10.1038/s41467-020-14779-y)

---

## Bioinformatics Workflow

The following pipeline was used for genome and transcriptome analysis:

1. **Quality Control**
    - FastQC (raw reads)
    - Fastp (trimming/filtering)
    - FastQC (post-trimming)

2. **K-mer Counting**
    - Jellyfish

3. **Genome Assembly**
    - HiFiasm
    - Flye
    - LJA

4. **Transcriptome Assembly**
    - Trinity

5. **Assembly Quality Assessment**
    - BUSCO (genome & transcriptome)
    - QUAST (genome)
    - Merqury (genome)

6. **Comparative Genomics**
    - Nucmer & MUMmer (genome comparisons against reference and between assembly types)

---

## Tool Versions

| Tool      | Version   |
|-----------|-----------|
| FastQC    | 0.12.1    |
| fastp     | 0.24.1    |
| Jellyfish | 2.2.6     |
| Flye      | 2.9.5     |
| Hifiasm   | 0.25.0    |
| LJA       | 0.2       |
| Trinity   | 2.15.1    |
| BUSCO     | 5.4.2     |
| QUAST     | 5.2.0     |
| Merqury   | 1.3       |
| MUMmer    | 4         |

---

## Repository Structure

```
Genome-Annotation-Course/
├── scripts/            # Annotation scripts and pipelines
├── results/            # Example output files
└── README.md           # This file
```

---

## License

This repository is licensed under the [MIT License](LICENSE).

---

## Contact

For any questions or feedback, please open an issue or contact the maintainer.

---

Happy annotating!
