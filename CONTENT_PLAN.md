# Content Plan

## Introduction
### Overview
- Why AlphaGenome is needed
- Non-coding variant interpretation bottleneck
- Sequence-to-function trade-offs
- Motivation for a unified model

### Regulatory variants
- Definition of regulatory variant
- Non-coding regulation
- Cell-type specificity
- eQTL example

### Context–resolution trade-off
- DeepSEA example
- Enformer example
- Short context vs long context
- Resolution loss with long-range models

### Multi-task trade-off
- Pangolin as specialist
- Borzoi as multitask/generalist
- Breadth vs best-in-class task performance

### Introduction summary
- Main bottleneck
- Two trade-offs
- Research aim of AlphaGenome

## Figure 1
- Panel A: overall architecture and modalities
- Example explanation of track-specific outputs
- Panel B: training with augmentation and fold split
- Panel C: distillation into student model
- Panels D/E: benchmark summary
- Final takeaway

## Figure 2
- Qualitative track prediction example
- Zoomed RNA/splicing example
- Quantitative modality performance
- Raw vs normalized RNA-seq interpretation
- Splice junction prediction performance
- Final takeaway

## Figure 3
- Comparison models and prediction targets
- Splice site / splice usage / splice junction
- Example exon-skipping / donor-site cases
- ISM interpretation
- Variant effect score definition
- Benchmarks F–I
- Strengths and remaining limitations

## Figure 4
- Expression effect score definition
- APOL4 eQTL example
- ISM interpretation
- Effect size vs sign prediction
- GWAS / COLOC / RF-supervised sections
- Enhancer–gene linking panel
- Final takeaway

## Figure 5
- Accessibility / TF binding variant effect score
- caQTL / bQTL performance
- Example local signal difference
- ISM motif interpretation
- MPRA benchmark
- Final takeaway

## Figure 6
- TAL1 hotspot mutations
- Multi-modality effect of a single non-coding variant
- Activation vs repression-related tracks
- MYB motif creation mechanism
- Final takeaway

## Figure 7
- Training refinement / distillation / resolution design choice
- Why different resolutions were used
- Student vs teacher logic
- Final takeaway

## Concepts
- ISM
- eQTL / sQTL
- GWAS / credible set / PIP
- COLOC
- enhancer–gene linking
- rE2G
- zero-shot vs supervised
