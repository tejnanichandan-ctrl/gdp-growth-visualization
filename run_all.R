# ============================================================
# run_all.R
# Master script: run this single file to regenerate every
# graph for the case study from scratch.
#
# Usage (from the project root folder):
#   Rscript run_all.R
# ============================================================

required_packages <- c("ggplot2", "dplyr", "tidyr", "readr",
                        "scales", "forcats", "ggrepel", "viridis")

missing <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]
if (length(missing) > 0) {
  message("Installing missing packages: ", paste(missing, collapse = ", "))
  install.packages(missing, repos = "https://cloud.r-project.org")
}

source("scripts/01_generate_graphs.R")

# 02_fix_graphs_8_9.R regenerates Graphs 8 & 9 with cleaner, decluttered
# labels (short "Country 'YY" tags via ggrepel) — these are the versions
# actually checked into output/graphs/, so this must run after 01 to
# reproduce the current graphs exactly.
source("scripts/02_fix_graphs_8_9.R")
