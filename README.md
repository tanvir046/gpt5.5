# EMT Basics LaTeX Project

This repository contains a LaTeX learning guide for power-system fundamentals, protection, EMT, power electronics, controls, renewable integration, PSCAD skills, validation, HVDC/FACTS, standards, mathematical foundations, and advanced EMT study topics.

## Files

- `main.tex` - main LaTeX source file.
- `references.bib` - bibliography database.
- `figures/` - TikZ figure source files included by `main.tex`.
- `EMT_Basics.pdf` - generated PDF output.

## Build

Run the standard LaTeX/BibTeX sequence from the repository root:

```sh
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
mv main.pdf EMT_Basics.pdf
```
