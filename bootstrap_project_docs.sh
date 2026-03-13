#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="${1:-.}"
cd "$ROOT_DIR"

echo "[1/7] Creating PROJECT_BRIEF.md"
cat > PROJECT_BRIEF.md <<'MD'
# Project Brief

## Goal
Build a clean documentation-style website that archives my AlphaGenome presentation and follow-up study notes.

## Audience
- Myself for future reference
- Researchers who want a figure-by-figure walkthrough
- Readers with basic genomics / machine learning background

## Desired style
- Documentation-first, not promotional
- Blue-accent visual design
- Clean scientific reading experience
- Pages should mainly follow:
  1. image
  2. explanation
  3. image
  4. explanation

## Must preserve
- Scientific accuracy
- Figure-by-figure logic from the original presentation
- Korean-first explanatory prose for main reading pages
- Consistent terminology across Introduction / Figures / Concepts

## Priorities
1. Clear reading flow
2. Stable image paths
3. Reusable page template
4. Figure-by-figure completeness
5. Easy maintainability in MkDocs

## Non-goals
- Portfolio-style self-promotion
- Overly flashy landing-page design
- Marketing copy or hype-heavy language
MD

echo "[2/7] Creating SITE_MAP.md"
cat > SITE_MAP.md <<'MD'
# Site Map

## Top-level structure
- Home
- Introduction
  - Overview
  - Regulatory variants
  - Context–resolution trade-off
  - Multi-task trade-off
  - Introduction summary
- Paper Overview
  - Paper overview
  - Model overview
- Figures
  - Figure 1
  - Figure 2
  - Figure 3
  - Figure 4
  - Figure 5
  - Figure 6
  - Figure 7
- Concepts
  - ISM
  - eQTL / sQTL / GWAS / PIP / credible set
  - enhancer–gene linking
- References

## Preferred navigation logic
1. Introduction
2. Paper overview
3. Figures
4. Concepts
5. References
MD

echo "[3/7] Creating STYLE_GUIDE.md"
cat > STYLE_GUIDE.md <<'MD'
# Style Guide

## Visual style
- Primary color family: blue / indigo
- Clean scientific documentation style
- Avoid promotional hero-heavy layout except possibly a minimal home header
- Favor whitespace and readable line length
- Keep page width comfortable for long reading

## Logo / icon
- Prefer DNA-like icon in the top-left navigation area

## Page structure
For Introduction and Figure pages, prefer this order:

1. Page title
2. Short one-line summary
3. Main image
4. Explanation paragraph(s)
5. Secondary image
6. Explanation paragraph(s)
7. Short takeaway
8. Optional speaker-note section

## Writing style
- Main prose: Korean
- Short technical labels may remain English when standard in the paper
- Avoid hype words such as:
  - revolutionary
  - groundbreaking
  - game-changing
- Explain abbreviations at first use
- Prefer direct academic prose over casual blog tone

## Image usage
- Keep original paper figure crops readable
- Avoid placing too many images side-by-side if text becomes cramped
- Prefer sequential image + explanation blocks
- Use consistent captions or section labels

## Scientific content rules
- Do not change interpretation without explicit instruction
- Preserve the presenter's intended logic flow
- Do not simplify away important caveats
- Keep distinctions clear:
  - prediction target vs benchmark
  - sign vs effect size
  - zero-shot vs supervised
  - splice site vs splice usage vs splice junction
MD

echo "[4/7] Creating CONTENT_PLAN.md"
cat > CONTENT_PLAN.md <<'MD'
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
MD

echo "[5/7] Creating TASKS.md"
cat > TASKS.md <<'MD'
# Tasks

## Current high-priority tasks
- Keep the site documentation-style rather than promotional
- Use a DNA-style icon for top-left branding
- Convert Introduction pages into image -> explanation flow
- Build Figure 1–7 pages in the same reading format
- Preserve Korean explanatory prose
- Keep navigation simple and predictable
- Keep blue-accent styling, but reduce visual noise

## Content tasks
- Integrate presenter notes into figure pages
- Separate main explanation from optional speaker notes
- Standardize one-line takeaway sections
- Keep terminology consistent across pages

## Technical tasks
- Maintain stable asset paths under docs/assets/
- Avoid broken relative links
- Keep mkdocs navigation synchronized with page files
- Keep custom CSS minimal and readable

## Constraints
- Do not rewrite scientific claims aggressively
- Do not invent benchmark interpretations
- Do not rename asset files without updating links
- Do not turn reading pages into landing pages
MD

echo "[6/7] Creating ASSET_MANIFEST.md header"
cat > ASSET_MANIFEST.md <<'MD'
# Asset Manifest

This file lists image assets currently found under `docs/assets`.

## Notes
- Keep file paths stable whenever possible.
- When moving or renaming assets, update page links immediately.
- Prefer grouping by section (introduction / figures / concepts).

MD

echo "[7/7] Scanning docs/assets for image files"
if [ -d "docs/assets" ]; then
  {
    echo "## Detected asset files"
    echo
    find docs/assets -type f \( \
      -iname "*.png" -o \
      -iname "*.jpg" -o \
      -iname "*.jpeg" -o \
      -iname "*.webp" -o \
      -iname "*.svg" \
    \) | sort | sed 's|^|- |'
    echo
  } >> ASSET_MANIFEST.md
else
  {
    echo "## Detected asset files"
    echo
    echo "_No docs/assets directory found yet._"
    echo
  } >> ASSET_MANIFEST.md
fi

echo
echo "Done."
echo "Created:"
echo "  - PROJECT_BRIEF.md"
echo "  - SITE_MAP.md"
echo "  - STYLE_GUIDE.md"
echo "  - CONTENT_PLAN.md"
echo "  - ASSET_MANIFEST.md"
echo "  - TASKS.md"
