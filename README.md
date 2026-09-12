# GDP Analysis (R) — Nominal vs. Real GDP During High-Inflation Periods

**Case study:** *Nominal vs. Real GDP During High-Inflation Periods:
The Post-Pandemic Global Inflation Surge (2021–2023)*
**Countries covered:** United States, Germany, Japan, India

This folder contains all data, R scripts, and output graphs for the
Data Collection & Graphs sections of the group case study.

## Folder structure

```
GDP_Analysis_R/
├── data/                              # Source data (CSV), one file per graph/dataset
│   ├── gdp_growth.csv                 # Nominal & real GDP growth (Graphs 1 & 2)
│   ├── deflator_cpi.csv               # GDP deflator vs CPI inflation (Graph 3)
│   ├── real_gdp_index.csv             # Real GDP index, 2019=100 (Graph 4)
│   ├── deflator_vs_realgrowth.csv     # Deflator vs real growth, scatter (Graph 5)
│   ├── expenditure_components_growth.csv  # Expenditure component growth rates (Graph 6)
│   ├── contribution_to_growth.csv     # PP contributions to real growth (Graph 7)
│   ├── employment_vs_growth.csv       # Employment vs real growth, scatter (Graph 8)
│   ├── unemployment_vs_growth.csv     # Unemployment vs real growth, scatter (Graph 9)
│   ├── gdp_per_capita_growth.csv      # Real GDP per capita growth (Graph 10)
│   └── cumulative_summary.csv         # 2021-2023 cumulative summary table (reference)
│
├── scripts/
│   ├── 00_theme.R                     # Shared academic ggplot2 theme + color palette + save helper
│   └── 01_generate_graphs.R           # Generates all 10 graphs, saves to output/graphs/
│
├── output/
│   └── graphs/                        # ONLY the final graphs land here (PNG + PDF), nothing else
│       ├── graph1_nominal_vs_real_gdp_growth.png / .pdf
│       ├── graph2_nominal_real_gap.png / .pdf
│       ├── graph3_deflator_vs_cpi.png / .pdf
│       ├── graph4_real_gdp_recovery_index.png / .pdf
│       ├── graph5_realgrowth_vs_deflator_scatter.png / .pdf
│       ├── graph6_expenditure_components_growth.png / .pdf
│       ├── graph7_contribution_to_growth_stacked.png / .pdf
│       ├── graph8_realgrowth_vs_employment_scatter.png / .pdf
│       ├── graph9_realgrowth_vs_unemployment_scatter.png / .pdf
│       └── graph10_real_gdp_per_capita_growth.png / .pdf
│
├── run_all.R                          # One-command entry point (installs packages if missing, then runs everything)
└── README.md                          # This file
```

## How to run

1. Open R / RStudio with the project **root folder** (`GDP_Analysis_R/`) as your working directory.
2. Run:
   ```r
   source("run_all.R")
   ```
   or from a terminal:
   ```bash
   Rscript run_all.R
   ```
3. All 10 graphs are (re)generated in `output/graphs/` as both `.png` (300+ dpi, for
   Word/PowerPoint/Google Docs) and `.pdf` (vector, for LaTeX or print-quality inclusion).

## Packages used

`ggplot2`, `dplyr`, `tidyr`, `readr`, `scales`, `forcats`, `ggrepel`, `viridis`
— all CRAN packages, auto-installed by `run_all.R` if missing.

## Design notes

- **Theme:** `theme_academic()` in `scripts/00_theme.R` — serif (Times-like) font,
  minimal gridlines, bold titles, italic-grey subtitles, and a source caption on
  every plot, styled to fit a formal case-study report (APA-consistent visuals).
- **Color palette:** a fixed, colorblind-safe country palette (navy = US, brick red =
  Germany, forest green = Japan, amber = India) used consistently across every graph
  so a reader can identify a country at a glance without re-reading the legend.
- **Every graph cites its data source** in a caption — carry these captions/notes
  over into your report's figure captions for the Bibliography & Data Referencing
  criterion.

## Editing / extending

- To swap in a different country or updated figures, edit the relevant CSV in `data/`
  — no code changes needed, the scripts read directly from these files.
- To restyle all graphs at once (e.g. change the font or palette), edit `scripts/00_theme.R`
  only; every graph inherits from `theme_academic()` and `country_colors`.
